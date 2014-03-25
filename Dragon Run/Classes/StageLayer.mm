//
//  StoreLayer.m
//
//

#import "StageLayer.h"
#import "TitleLayer.h"
#import "HelpLayer.h"
#import "GameLayer.h"
#import "GrowButton.h"
#import "ImageButton.h"
#import "ResourceManager.h"
#import "AppSettings.h"
#import "AppDelegate.h"
#import "CCScrollLayer.h"
#import "Sky.h"
#import "StagePageLayer.h"
#import "AppSettings.h"
#import "Terrain.h"
#import "StoreLayer.h"
#import "AppDelegate.h"

@interface CCMenu (UnselectSelectedItem)
- (void) unselectSelectedItem;
@end

@implementation CCMenu (UnselectSelectedItem)

- (void) unselectSelectedItem
{
	if(state_ == kCCMenuStateTrackingTouch)
	{
		[selectedItem_ unselected];		
		state_ = kCCMenuStateWaiting;
		selectedItem_ = nil;
	}
}

@end

#pragma mark -

@interface StageLayer (ScrollLayerCreation)

- (NSArray *) scrollLayerPages;
- (CCScrollLayer *) scrollLayer;
- (void) updateFastPageChangeMenu;

@end


@implementation StageLayer
@synthesize labelSkipCount=_labelSkipCount;
BOOL bAllowPlay;
enum nodeTags
{
	kScrollLayer = 256,
	kAdviceLabel = 257,
	kFastPageChangeMenu = 258,
};

- (void) dealloc {
	self.labelSkipCount = nil;
	[super dealloc];
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        app = [[UIApplication sharedApplication] delegate];

		CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite* sprite;
        if( size.width == 568 || size.height == 568 )
            sprite = [CCSprite spriteWithFile: @"stage_back-5x.png"];
        else
            sprite = [CCSprite spriteWithFile: @"stage_back.png"];
		[sprite setPosition: ccp(size.width/2, size.height/2)];
		[self addChild: sprite];
		
        CCSprite* spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_back.png"];
        CGSize BackSize = spriteTemp.contentSize;
        
		GrowButton *btnBack = [GrowButton buttonWithSpriteFrame:@"btn_back.png"
												selectframeName: @"btn_back.png"
														 target:self
													   selector:@selector(actionBack:)];
		btnBack.position =  ccp(BackSize.width,BackSize.height);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            btnBack.position =  ccp(BackSize.width,BackSize.height);
        }
        else
        {
            btnBack.position =  ccp(BackSize.width-25,BackSize.height-25);
        }
		[sprite addChild:btnBack];
        
		CCSprite* spriteRope = [CCSprite spriteWithFile: @"rope.png"];
		[spriteRope setPosition: ccp(size.width/2, size.height*0.75)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [spriteRope setPosition: ccp(size.width/2, size.height*0.75)];
        }
        else
        {
            [spriteRope setPosition: ccp(size.width/2, size.height*0.85)];
            if (size.width == 568 || size.height == 568) {
                spriteRope.scaleX = 1.2f;
            }
        }
		[sprite addChild: spriteRope];
        
		CCSprite* spriteRope2 = [CCSprite spriteWithFile: @"rope2.png"];
		[spriteRope2 setPosition: ccp(size.width/2, size.height*0.70)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [spriteRope2 setPosition: ccp(size.width/2, size.height*0.70)];
        }
        else
        {
            [spriteRope2 setPosition: ccp(size.width/2, size.height*0.75)];
            if (size.width == 568 || size.height == 568) {
                spriteRope2.scaleX = 1.2f;
            }
        }
		[sprite addChild: spriteRope2];
        
		CCSprite* spriteRopeWay1 = [[ResourceManager sharedResourceManager] getTextureWithName: @"ropeway2"];
		[spriteRopeWay1 setPosition: ccp(size.width*0.25, (size.height*0.70)-(spriteRopeWay1.contentSize.height/2.2))];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [spriteRopeWay1 setPosition: ccp(size.width*0.25, (size.height*0.70)-(spriteRopeWay1.contentSize.height/2.2))];
        }
        else
        {
            [spriteRopeWay1 setPosition: ccp(size.width*0.25, (size.height*0.75)-(spriteRopeWay1.contentSize.height/2.2))];
        }
		[sprite addChild: spriteRopeWay1];
        
		CCSprite* spriteRopeWay2 = [[ResourceManager sharedResourceManager] getTextureWithName: @"ropeway2"];
		[spriteRopeWay2 setPosition: ccp(size.width*0.75, (size.height*0.70)-(spriteRopeWay1.contentSize.height/2.2))];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [spriteRopeWay2 setPosition: ccp(size.width*0.75, (size.height*0.70)-(spriteRopeWay1.contentSize.height/2.2))];
        }
        else
        {
            [spriteRopeWay2 setPosition: ccp(size.width*0.75, (size.height*0.75)-(spriteRopeWay1.contentSize.height/2.2))];
        }
		[sprite addChild: spriteRopeWay2];
        
		// Add fast page change menu.
		[self updateFastPageChangeMenu];
		
		// Do initial positioning & create scrollLayer.
		[self updateForScreenReshape];
		
		CCSprite* spriteI = [CCSprite spriteWithSpriteFrameName: @"icon_skip_coin.png"];
        [spriteI setPosition: ccp(size.width * 0.95 - spriteI.contentSize.width, size.height - spriteI.contentSize.height)];
        spriteI.scale = 0.5;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [spriteI setPosition: ccp(size.width * 0.95 - spriteI.contentSize.width, size.height - spriteI.contentSize.height)];
        }
        else
        {
            [spriteI setPosition: ccp(size.width * 0.95 - spriteI.contentSize.width, (size.height - spriteI.contentSize.height)+20)];
        }
		[sprite addChild: spriteI];
		
		CCLabelBMFont* labelSkipCount = [CCLabelBMFont labelWithString:@"" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
		[labelSkipCount setPosition: ccp(size.width * 0.95, size.height - spriteI.contentSize.height)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [labelSkipCount setPosition: ccp(size.width * 0.95, size.height - spriteI.contentSize.height)];
        }
        else
        {
            [labelSkipCount setPosition: ccp(size.width * 0.95, size.height - spriteI.contentSize.height+20)];
        }
		[sprite addChild: labelSkipCount];
		self.labelSkipCount = labelSkipCount;
		[self updateSkipLabel];
        
        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_title_help.png"];
        
		GrowButton *btnHelp = [GrowButton buttonWithSpriteFrame:@"btn_title_help.png"
                                                selectframeName: @"btn_title_help.png"
                                                         target:self
                                                       selector:@selector(actionHelp:)];
        
		btnHelp.position =  ccp((size.width * 0.85) - spriteTemp.contentSize.width/2, (size.height * 0.18) - spriteTemp.contentSize.height/2);
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            btnHelp.position =  ccp((size.width * 0.85) - spriteTemp.contentSize.width/2, (size.height * 0.18) - spriteTemp.contentSize.height/2);
        }
        else
        {
            btnHelp.position =  ccp((size.width * 0.85) - spriteTemp.contentSize.width/2, ((size.height * 0.18) - spriteTemp.contentSize.height/2)+20);
        }
        [sprite addChild:btnHelp];
        
        //if (![AppSettings RemoveAdMob]){
            //[(AppDelegate*)[[UIApplication sharedApplication] delegate] displayRevMobAd:270];
            
            //            }
        //};
        bAllowPlay = TRUE;
	}
	return self;
}

-(void) setRevMobAds{
    bAllowPlay = FALSE;
    [self schedule:@selector(StartAddPage) interval:1];
}

-(void) StartAddPage
{
    [self unschedule:@selector(StartAddPage)];
    NSLog(@"[AM - StageLayer - StartAddPage] RevMob -> showFullscreen");
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showFullscreen];
    [self schedule:@selector(EndAddPage) interval:1];
}

- (void) EndAddPage
{
    BOOL RMAd = [(AppDelegate*)[[UIApplication sharedApplication] delegate] GetRevMobRequestFlag];
    BOOL CBAd = [(AppDelegate*)[[UIApplication sharedApplication] delegate] GetChartBoostRequestFlag];
    [self unschedule:@selector(EndAddPage)];
    //    [(AppDelegate*)[[UIApplication sharedApplication] delegate] releaseFullscreen];
    
    if (RMAd==NO){
        if (CBAd == NO){
            bAllowPlay = TRUE;
        }
    }
    
    if (bAllowPlay==FALSE) {
        [self schedule:@selector(EndAddPage) interval:1];
    }
}

- (void) updateSkipLabel {
	NSString* strSkipCount = ([AppSettings skipCoinCount] == UNLIMIT)?@"*":[NSString stringWithFormat:@"%d", [AppSettings skipCoinCount]];
	[_labelSkipCount setString: strSkipCount];
  
}

- (void) actionBack: (id) sender
{	
	CCScene* layer = [StoreLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInL transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];
    
}

- (void) actionHelp: (id) sender
{
	CCScene* layer = [HelpLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];
}

// Removes old "0 1 2" menu and creates new for actual pages count.
- (void) updateFastPageChangeMenu
{
	// Remove fast page change menu if it exists.
	[self removeChildByTag:kFastPageChangeMenu cleanup:YES];
	
	// Get total current pages count.
	int pagesCount = [[self scrollLayerPages]count];
	CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
	if (scroller)
	{
		pagesCount = [[scroller pages] count];
	}
}

// Positions children of CCScrollLayerTestLayer.
// ScrollLayer is updated via deleting old and creating new one. 
// (Cause it's created with pages - normal CCLayer, which contentSize = winSize)
- (void) updateForScreenReshape
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	CCNode *fastPageChangeMenu = [self getChildByTag:kFastPageChangeMenu];
	CCNode *adviceLabel = [self getChildByTag:kAdviceLabel];
	
	fastPageChangeMenu.position = ccp( 0.5f * screenSize.width, 15.0f); 
	adviceLabel.anchorPoint = ccp(0.5f, 1.0f);
	adviceLabel.position = ccp(0.5f * screenSize.width, screenSize.height*0.75);
	
	// ReCreate Scroll Layer for each Screen Reshape (slow, but easy).
	CCScrollLayer *scrollLayer = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
	if (scrollLayer)
	{
		[self removeChild:scrollLayer cleanup:YES];
	}
	
	scrollLayer = [self scrollLayer];
	[self addChild: scrollLayer z: 0 tag: kScrollLayer];	
	[scrollLayer selectPage: [AppSettings currentStage]];
	scrollLayer.delegate = self;
}

#pragma mark ScrollLayer Creation

// Returns array of CCLayers - pages for ScrollLayer.
- (NSArray *) scrollLayerPages
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	NSMutableArray* array = [NSMutableArray arrayWithCapacity: 15];
	for (int i = 0; i < TOTAL_LEVELS; i ++) {
        BOOL bLocked = [AppSettings getStageFlag: i];
//        //hb: insert
//        if (i < 15 ) {
//            bLocked = false;
//        }
		
		int nScore = [AppSettings getScore: i];
		StagePageLayer* page = [[StagePageLayer alloc] initWithTag:i strTitle:[NSString stringWithFormat:@"STAGE%d", i+1] nScore:nScore bLocked:bLocked];
		[page setTarget:self selector:@selector(actionPlay:)];
		[page setPosition: ccp(screenSize.width/2, screenSize.height/2)];
		[array addObject: page];
	}
	
	return array;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if ([AppSettings skipCoinCount] == UNLIMIT || [AppSettings skipCoinCount] > 0) {
			[AppSettings setStageFlag:_selectedStage flag:NO];
			[AppSettings subSkipCoin:1];
			CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
			StagePageLayer* pageLayer = (StagePageLayer*)[scroller.pages objectAtIndex: _selectedStage];
			[pageLayer setUnLock];
			[self updateSkipLabel];
		}
        else
        {
            [AppSettings setStageFlag:_selectedStage flag:NO];
			[AppSettings subSkipCoin:0];
			CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
			StagePageLayer* pageLayer = (StagePageLayer*)[scroller.pages objectAtIndex: _selectedStage];
			[pageLayer setUnLock];
			[self updateSkipLabel];
        }
	}
}

- (void) actionPlay: (id) sender {

    if (bAllowPlay){
        StagePageLayer* page = (StagePageLayer*)sender;
        int nStageNo = page.nTag;
        _selectedStage = nStageNo;
        //hb :mark
        if ([AppSettings getStageFlag: nStageNo] == YES) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Confirm Stage Unlock"
														message:@"" 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:@"Cancel", nil] autorelease];
            [alert show];
            return;
        }
        [AppSettings setCurrentStage: nStageNo];
        [Sky setBackgroundId: STAGE_1];
        [Terrain setTerrainColorIndex: nStageNo];
       /* CCScene* layer = [GameLayer node];
        ((GameLayer*)layer).mGameType = (GAMETYPE)(GAME_QUICK);
        ccColor3B color;
        color.r = 0x0;
        color.g = 0x0;
        color.b = 0x0;
        
        
       
        CCTransitionScene *ts = [CCTransitionFade transitionWithDuration:1.0f scene:layer withColor:color];
        [[CCDirector sharedDirector] replaceScene:ts];
        */
        
        app.levelNo = nStageNo;
        
        if ([Nextpeer isCurrentlyInTournament])
        {
        }
        else
        {
            [Nextpeer launchDashboard];
        }


    }
}

// Creates new Scroll Layer with pages returned from scrollLayerPages.
- (CCScrollLayer *) scrollLayer
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	// Create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages).
	CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers: [self scrollLayerPages] widthOffset: 0.48f * screenSize.width ];
	scroller.pagesIndicatorPosition = ccp(screenSize.width * 0.5f, 20.0f);
    
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
    scroller.marginOffset = 0.5f * screenSize.width;
	
	return scroller;
}

#pragma mark Callbacks

- (void) changeColorPressed: (CCNode *) sender
{
    CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
    
    GLubyte opacity = arc4random() % 127 + 128;
    GLubyte red = arc4random() % 255;
    GLubyte green = arc4random() % 255;
    GLubyte blue = arc4random() % 255;
    
    GLubyte opacitySelected = arc4random() % 127 + 128;
    GLubyte redSelected = arc4random() % 255;
    GLubyte greenSelected = arc4random() % 255;
    GLubyte blueSelected = arc4random() % 255;
    
    scroller.pagesIndicatorNormalColor = ccc4(red, green, blue, opacity);
    scroller.pagesIndicatorSelectedColor = ccc4(redSelected, greenSelected, blueSelected, opacitySelected);
    
}

// "Add Page" Button Callback - adds new page & updates fast page change menu.
- (void) addPagePressed: (CCNode *) sender
{
	NSLog(@"CCScrollLayerTestLayer#addPagePressed: called!");
	
	// Add page with label with number.
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
	
	int x = [scroller.pages count] + 1;
	CCLayer *pageX = [CCLayer node];
	CCLabelTTF *label = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"Page %d", x] 
										   fontName: @"Arial Rounded MT Bold" 
										   fontSize:44];
	label.position =  ccp( screenSize.width /2 , screenSize.height/2 );
	[pageX addChild:label];
	
	[scroller addPage: pageX];
	
	//Update fast page change menu.
	[self updateFastPageChangeMenu];
}

// "Remove page" menu callback - removes pages through running new action with delay.
- (void) removePagePressed: (CCNode *) sender
{
	// Run action with page removal on cocos2d thread.
	[self runAction:[CCSequence actions:
					 [CCDelayTime actionWithDuration:0.2f],
					 [CCCallFunc actionWithTarget:self selector:@selector(removePage)],
					 nil]
	 ];
}

- (void) removePage
{
	// Actually remove page.
	CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
	[scroller removePageWithNumber: [scroller.pages count] - 1];
	
	// Update fast page change menu.
	[self updateFastPageChangeMenu];
}

#pragma mark Scroll Layer Callbacks

// Unselects all selected menu items in node - used in scroll layer callbacks to 
// cancel menu items when scrolling started.
-(void)unselectAllMenusInNode:(CCNode *)node
{
	for (CCNode *child in node.children) 
	{
		if ([child isKindOfClass:[CCMenu class]]) 
		{
			// Child here is CCMenu subclass - unselect.
			[(CCMenu *)child unselectSelectedItem];
		}
		else
		{
			// Child here is some other CCNode subclass.
			[self unselectAllMenusInNode: child];
		}
	}
}

- (void) scrollLayerScrollingStarted:(CCScrollLayer *) sender
{
	NSLog(@"CCScrollLayerTestLayer#scrollLayerScrollingStarted: %@", sender);	
	// No buttons can be touched after scroll started.
	[self unselectAllMenusInNode: self];
}

- (void) scrollLayer: (CCScrollLayer *) sender scrolledToPageNumber: (int) page
{
	NSLog(@"CCScrollLayerTestLayer#scrollLayer:scrolledToPageNumber: %@ %d", sender, page);
}



@end
