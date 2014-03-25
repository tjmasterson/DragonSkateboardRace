//
//  HelpLayer.m
//  AvalancheMountain
//
//

#import "AppDelegate.h"
#import "HelpLayer.h"
#import "GrowButton.h"
#import "StageLayer.h"

@implementation HelpLayer

+ (CCScene*) scene {
    CCScene *scene = [CCScene node];
    [scene addChild:[HelpLayer node]];
    return scene;
}

-(void)dealloc
{
    [super dealloc];
}

- (id) init {
    
	if ((self = [super init])) 
	{
	}
	return self;
}



- (void) onEnter
{
	[super onEnter];
	
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite* sprite;
    if( screenSize.width == 568 || screenSize.height == 568 )
        sprite = [CCSprite spriteWithFile: @"instructions-586h.png"];
    else
      sprite = [CCSprite spriteWithFile: @"instructions.png"];
	[sprite setPosition: ccp(screenSize.width/2, screenSize.height/2)];
	[self addChild: sprite];
	

    CCSprite* spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_back.png"];
	GrowButton *btnBack = [GrowButton buttonWithSpriteFrame:@"btn_back.png" 
											selectframeName: @"btn_back.png" 
													 target:self 
												   selector:@selector(actionBack:)];
	btnBack.position =  ccp(spriteTemp.contentSize.width/2,spriteTemp.contentSize.height/2);
	[sprite addChild:btnBack];
    
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] flgADdisplay])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeGoogleAd];
    }
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] flgRMdisplay])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeRevMobAd];
    }
}

- (void) actionBack: (id) sender
{	
	CCScene* layer = [StageLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInL transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];	
}

@end
