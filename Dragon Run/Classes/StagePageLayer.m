//
//  StagePageLayer.m
//

#import "StagePageLayer.h"
#import "ImageButton.h"
#import "ResourceManager.h"
#import "AppSettings.h"
#import "AppDelegate.h"

#define LOCK_SPRITE_TAG 1000
@implementation StagePageLayer
@synthesize nTag=_nTag;
@synthesize bLocked=_bLocked;

- (id) initWithTag: (int) nTag strTitle: (NSString*) strTitle nScore: (int) nScore bLocked: (BOOL) bLocked {
	if ( (self=[super init]) ) {
		CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite* spriteTemp = [CCSprite spriteWithSpriteFrameName:@"ropeway1.png"];
        CGSize RopeSize = spriteTemp.contentSize;
		ImageButton* btnSnowBoarder1 = [ImageButton buttonWithSpriteFrame:@"ropeway1.png"
														  selectframeName:@"ropeway1.png"
																   target:self
																 selector:@selector(actionPlay:)
																	  tag: nTag];
		btnSnowBoarder1.position = ccp(screenSize.width/2, (screenSize.height*0.75)-RopeSize.height/2.2);
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            btnSnowBoarder1.position = ccp(screenSize.width/2, (screenSize.height*0.75)-RopeSize.height/2.2);
        }
        else
        {
            btnSnowBoarder1.position = ccp(screenSize.width/2, (screenSize.height*0.85)-RopeSize.height/2.2);
        }
        [self addChild:btnSnowBoarder1];
        
        
		CCLabelBMFont *labelTitle = [CCLabelBMFont labelWithString:strTitle fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
		labelTitle.position = ccp(screenSize.width/2, (screenSize.height*0.75)-(RopeSize.height*0.6));
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            labelTitle.position = ccp(screenSize.width/2, (screenSize.height*0.75)-(RopeSize.height*0.6));
        }
        else
        {
            labelTitle.position = ccp(screenSize.width/2, (screenSize.height*0.75)-(RopeSize.height*0.6)+30);
        }
		[self addChild:labelTitle];
        
		CCLabelBMFont *labelScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", nScore] fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
		labelScore.position = ccp(screenSize.width/2, (screenSize.height*0.75)-(RopeSize.height*0.85));
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            labelScore.position = ccp(screenSize.width/2, (screenSize.height*0.75)-(RopeSize.height*0.85));
        }
        else
        {
            labelScore.position = ccp(screenSize.width/2, (screenSize.height*0.75)-(RopeSize.height*0.85)+40);
        }
		[self addChild:labelScore];
        
		if (bLocked) {
			CCSprite* sprLock = [[ResourceManager sharedResourceManager] getTextureWithName: @"lock"];
			[sprLock setPosition: ccp(screenSize.width/2, (screenSize.height*0.75)-(RopeSize.height*0.85))];
			[self addChild: sprLock];
			[sprLock setTag:LOCK_SPRITE_TAG];
		}
		
		self.nTag = nTag;
		self.bLocked = bLocked;
        
        //hb:insert
        //      [AppSettings setPurchasedAllOpenCoin: YES];
	}
	
	return self;
}

- (void) setTarget:(id) rec selector:(SEL) cb
{
	NSMethodSignature * sig = nil;
	
	if( rec && cb ) {
		sig = [[rec class] instanceMethodSignatureForSelector:cb];
		
		invocation = nil;
		invocation = [NSInvocation invocationWithMethodSignature:sig];
		[invocation setTarget:rec];
		[invocation setSelector:cb];
#if NS_BLOCKS_AVAILABLE
		if ([sig numberOfArguments] == 3) 
#endif
			[invocation setArgument:&self atIndex:2];
		
		[invocation retain];
	}
}

- (void) setUnLock {
	CCNode* sprite = [self getChildByTag:LOCK_SPRITE_TAG];
	[sprite removeFromParentAndCleanup: YES];
}

- (void) actionPlay: (id) sender {
    
 if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] flgRMdisplay])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeRevMobAd];
    }

	[invocation invoke];
}

- (void) dealloc {
	[invocation release];
	[super dealloc];
}
@end
