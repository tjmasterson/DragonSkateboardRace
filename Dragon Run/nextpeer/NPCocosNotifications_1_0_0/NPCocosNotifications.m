/*
 * This file is subject to the terms and conditions defined in
 * file 'NP_LICENSE.txt', which is part of this source code package.
 */


#import "NPCocosNotifications.h"
#import "CCArray.h"
#import "Nextpeer/NPNotificationContainer.h"

// ---------------------NPCocosNotificationDesign--------------------- //
// This will display the notification on the middle of the screen
@implementation NPCocosNotificationDesign

- (id) init
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	self = [self initWithColor:ccc4(0, 0, 0, 0) width:size.width height:10];
	if (self != nil) {
		image_ = [CCSprite node];
		[image_ setPosition:ccp(size.width/2.0, 0)];
		[self addChild:image_];
	}
	return self;
}

// Place the texture on the image and set the sizes to fit
- (void) setTexture:(CCTexture2D*)texture {
	if(texture){
		CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
		
		[self setContentSize:CGSizeMake(self.contentSize.width, rect.size.height)];
		[image_ setTexture:texture];
		[image_ setTextureRect:rect];
	}
}
@end

// ---------------------NPCocosNotifications--------------------- //

@interface NPCocosNotifications (Private)

- (id) initWithTemplate:(CCNode <NPCocosNotificationDesignProtocol> *)templates;
- (void) setAnimationIn:(char)type time:(ccTime)time;
- (void) setAnimationOut:(char)type time:(ccTime)time;
- (void) setAnimation:(char)type time:(ccTime)time;
- (void) updateAnimations;
- (void) _updateAnimationIn;
- (void) _updateAnimationOut;
- (CCActionInterval*) _animation:(char)type time:(ccTime)time;
- (void) _showNotification;
- (void) _addNotificationToArray:(NPNotificationContainer*)data cached:(BOOL)isCached;
- (void) _startScheduler;
- (void) _hideNotification;
- (void) _hideNotificationScheduler;
- (void) registerWithTouchDispatcher;
- (void) _setState:(char)states;

@end

@implementation NPCocosNotifications

@synthesize position				= position_;
@synthesize notificationDesign		= template_;
@synthesize animationIn				= animationIn_;
@synthesize animationOut			= animationOut_;
@synthesize delegate				= delegate_;
@synthesize showingTime				= showingTime_;
@synthesize currentNotification		= currentNotification_;

static NPCocosNotifications *sharedManager;

+ (NPCocosNotifications *)sharedManager
{
	if (!sharedManager)
		sharedManager = [[NPCocosNotifications alloc] init];
	
	return sharedManager;
}

+ (id) alloc
{
	NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (void) purgeSharedManager
{
	[sharedManager release];
}

- (id) init
{
	CCNode <NPCocosNotificationDesignProtocol> *templates = [[[NPCocosNotificationDesign alloc] init] autorelease];
	self = [self initWithTemplate:templates];
	return self;
}

- (id) initWithTemplate:(CCNode <NPCocosNotificationDesignProtocol> *)templates
{
	if( (self = [super init]) ) {
		self.notificationDesign = templates;
		
		delegate_			= nil;
		state_				= kNPCocosNotificationStateHide;
		typeAnimationIn_	= kNPCocosNotificationAnimationMovement;
		typeAnimationOut_	= kNPCocosNotificationAnimationMovement;
		timeAnimationIn_	= 0.5f; // Default sizes
		timeAnimationOut_	= 0.5f;
		
		cachedNotifications_ = [[CCArray alloc] initWithCapacity:4];
		
		showingTime_		= 3.0f;
		position_			= kNPCocosNotificationPositionTop;
	}	
	return self;
}

- (void) _setState:(char)states
{
	if(state_==states) return;
	state_ = states;
	
	if([delegate_ respondsToSelector:@selector(notification:newState:)])
		[delegate_ notification:currentNotification_ newState:state_];
}

- (void) setPosition:(char)positions
{
	position_ = positions;
	[self updateAnimations];
}

- (void) setNotificationDesign:(CCNode <NPCocosNotificationDesignProtocol>*) templates
{
	if(state_!=kNPCocosNotificationStateHide)
		[template_ stopAllActions];
	
	if(state_==kNPCocosNotificationStateShowing)
	{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
#endif
		[[CCScheduler sharedScheduler] unscheduleSelector:@selector(_hideNotificationScheduler) forTarget:self];		
	}
	
	[templates retain];
	[template_ release];
	template_ = templates;
	[template_ setVisible:NO];
	[template_ setIsRelativeAnchorPoint:YES];
	
	[self _setState:kNPCocosNotificationStateHide];
}

- (void) clearAndDismiss {
    
	[self _setState:kNPCocosNotificationStateHide];
	[template_ setVisible:NO];
	[template_ stopAllActions];
	[template_ onExit];
	
	//Release current notification
    [cachedNotifications_ removeAllObjects];
	self.currentNotification = nil;
}

#pragma mark -
#pragma mark Notification Actions
#pragma mark -

- (CCActionInterval*) _animation:(char)type time:(ccTime)time
{
	CCActionInterval *action = nil;
	switch (type){
		case kNPCocosNotificationAnimationMovement:
			if(position_==kNPCocosNotificationPositionBottom)
				action = [CCMoveBy actionWithDuration:time position:ccp(0, template_.contentSize.height)];
			
			else if(position_ == kNPCocosNotificationPositionTop)
				action = [CCMoveBy actionWithDuration:time position:ccp(0, -template_.contentSize.height)];
			
			break;
		case kNPCocosNotificationAnimationScale:
			action = [CCScaleBy actionWithDuration:time scale:(1.0f-KNOTIFICATIONMIN_SCALE)/KNOTIFICATIONMIN_SCALE];
			
			break;
		default: break;
	}
	return action;
}

- (void) _updateAnimationIn
{
	self.animationIn = [CCSequence actionOne:[self _animation:typeAnimationIn_ time:timeAnimationIn_] two:[CCCallFunc actionWithTarget:self selector:@selector(_startScheduler)]];
}

- (void) _updateAnimationOut
{
	CCActionInterval *tempAction = [self _animation:typeAnimationOut_ time:timeAnimationOut_];
	self.animationOut = [CCSequence actionOne:[tempAction reverse] two:[CCCallFunc actionWithTarget:self selector:@selector(_hideNotification)]];
}

- (void) updateAnimations
{
	[self _updateAnimationIn];
	[self _updateAnimationOut];
}

- (void) setAnimationIn:(char)type time:(ccTime)time
{
	typeAnimationIn_ = type;
	timeAnimationIn_ = time;
	[self _updateAnimationIn];
}

- (void) setAnimationOut:(char)type time:(ccTime)time
{
	typeAnimationOut_ = type;
	timeAnimationOut_ = time;
	[self _updateAnimationOut];
}

- (void) setAnimation:(char)type time:(ccTime)time
{
	typeAnimationIn_ = typeAnimationOut_ = type;
	timeAnimationIn_ = timeAnimationOut_ = time;
	[self updateAnimations];
}

#pragma mark -
#pragma mark Notification Steps
#pragma mark -

- (void) _startScheduler
{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	[self registerWithTouchDispatcher];
#endif
	[self _setState:kNPCocosNotificationStateShowing];
	[template_ stopAllActions];
	[[CCScheduler sharedScheduler] scheduleSelector:@selector(_hideNotificationScheduler) forTarget:self interval:showingTime_ paused:NO];
}

- (void) _hideNotification
{
	[self _setState:kNPCocosNotificationStateHide];
	[template_ setVisible:NO];
	[template_ stopAllActions];
	[template_ onExit];
	
	//Release current notification
	[cachedNotifications_ removeObject:currentNotification_];
	self.currentNotification = nil;
	
	//Check next notification
	[self _showNotification];
}

- (void) _hideNotificationScheduler
{	
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
#endif
	[[CCScheduler sharedScheduler] unscheduleSelector:@selector(_hideNotificationScheduler) forTarget:self];
	
	[self _setState:kNPCocosNotificationStateAnimationOut];
	[template_ runAction:animationOut_];
}

#pragma mark -
#pragma mark Manager Notifications
#pragma mark -

- (void) _addNotificationToArray:(NPNotificationContainer*)data cached:(BOOL)isCached
{
	if(isCached)
	{
		[cachedNotifications_ addObject:data];
		if([cachedNotifications_ count]==1)
			[self _showNotification];
	}else{
		if(currentNotification_)
		{
			[cachedNotifications_ removeObject:currentNotification_];
		}
		[cachedNotifications_ insertObject:data atIndex:0];
		[self _showNotification];
	}
}

#pragma mark -
#pragma mark NPTournamentDelegate methods
#pragma mark -

// Disallow Nextpeer to present platform notification, we will handle them internal
-(BOOL)nextpeerIsNotificationAllowed:(NPNotificationContainer *)notice
{
    return NO; 
}

-(void)nextpeerHandleDisallowedNotification:(NPNotificationContainer *)notice
{
    // Add notification to the cache only if the director is still active
    if (![[CCDirector sharedDirector] isPaused]) {
        [self _addNotificationToArray:notice cached:TRUE];
    }
}

#pragma mark -
#pragma mark Show Notification methods
#pragma mark -

// Show the current notification
- (void) _showNotification
{
	if([cachedNotifications_ count]==0) return;
	
	//Get notification data
	self.currentNotification = [cachedNotifications_ objectAtIndex:0];
	
	//Stop system
	if(state_==kNPCocosNotificationStateShowing)
	{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
#else
		[[CCEventDispatcher sharedDispatcher] removeMouseDelegate:self];
#endif
	}
	
	if(state_!=kNPCocosNotificationStateHide)
	{
		[self _setState:kNPCocosNotificationStateHide];
		
		[template_ setVisible:NO];
		[template_ stopAllActions];
		[template_ onExit];
		[[CCScheduler sharedScheduler] unscheduleSelector:@selector(_hideNotificationScheduler) forTarget:self];
	}
	
	//Prepare template
	[template_ setVisible:NO];
	[template_ stopAllActions];
	[template_ onExit];
	
	//Prepare animation in background thread
	[self performSelectorInBackground:@selector(_presentNotification:) withObject:currentNotification_];
}

// The rendered image property is lazy & heavy, so we will do that in background thread.
// Once we winished we call _showNotificationWithImage with the image to be displayed
-(void)_presentNotification:(NPNotificationContainer *)notice {
	UIImage *imgToDisplay =  notice.renderedImage;
	[imgToDisplay retain]; // retain the image (so it will not release during selector)
	[self performSelectorOnMainThread:@selector(_showNotificationWithImage:) withObject:imgToDisplay waitUntilDone:NO];
}

// Show the notification on the screen
-(void)_showNotificationWithImage:(UIImage *)imgToDisplay {
	
	// Transform the image to CCTexture2D
	CCTexture2D *texture = [[CCTexture2D alloc] initWithImage:imgToDisplay];
	[imgToDisplay release];
	
	// Apply the texture on the template (the old texture will be override)
	[template_ setTexture:texture];
	
    // Updating the animations based on the new texture (so the animation will be calculated by new texture size)
	[self updateAnimations];
    
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// Perform animation (move or scale) based on selected paramaters.
	if(position_==kNPCocosNotificationPositionBottom){
		switch (typeAnimationIn_) {
			case kNPCocosNotificationAnimationMovement:
				[template_ setScale:1.0f];
				[template_ setPosition:ccp(winSize.width/2.0f, 0)];
				
				break;
			case kNPCocosNotificationAnimationScale:
				[template_ setScale:KNOTIFICATIONMIN_SCALE];
				[template_ setPosition:ccp(winSize.width/2.0f, template_.contentSize.height)];
				
				
				break;
			default: 
                [texture release];
                return;
		}
		
	}else if(position_==kNPCocosNotificationPositionTop)
	{
        CGFloat statusBarOffsetHeight = 0.0f;
        
        if (![UIApplication sharedApplication].statusBarHidden) {
            
            CGSize statusBarOffsetSize = [UIApplication sharedApplication].statusBarFrame.size;
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                statusBarOffsetHeight = statusBarOffsetSize.width;
            }
            else {
                statusBarOffsetHeight = statusBarOffsetSize.height;
            }
        }
        
		switch (typeAnimationIn_){
			case kNPCocosNotificationAnimationMovement:
				[template_ setScale:1.0f];
				[template_ setPosition:ccp(winSize.width/2.0f, winSize.height+template_.contentSize.height - statusBarOffsetHeight)];
				
				break;
			case kNPCocosNotificationAnimationScale:
				[template_ setScale:KNOTIFICATIONMIN_SCALE];
				[template_ setPosition:ccp(winSize.width/2.0f, winSize.height - statusBarOffsetHeight)];
				
				break;
			default: 
                [texture release];
                return;
		}
	}
	[self _setState:kNPCocosNotificationStateAnimationIn];
	[template_ onEnter];
	[template_ runAction:animationIn_];
	
	//Update template
	[template_ setVisible:YES];
	
	[texture release];
}

#pragma mark -
#pragma mark Touch Events
#pragma mark -

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:INT_MAX];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	CGRect rect = [template_ boundingBox];
	if(CGRectContainsPoint(rect, point))
		[self _hideNotificationScheduler];
}
#endif

#pragma mark -
#pragma mark Other methods
#pragma mark -

- (void) visit
{	
	[template_ visit];
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X>", [self class], self];
}

-(void) dealloc
{
	CCLOG(@"cocos2d: deallocing %@", self);
	
	sharedManager = nil;
	[cachedNotifications_ release];
	[self setCurrentNotification:nil];
	[self setNotificationDesign:nil];
	[self setDelegate:nil];
	[self setAnimationIn:nil];
	[self setAnimationOut:nil];
	[super dealloc];
}
@end