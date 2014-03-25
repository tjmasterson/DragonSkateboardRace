//
//  CreditLayer.m
//  AvalancheMountain
//
//

#import "CreditLayer.h"
#import "GrowButton.h"
#import "TitleLayer.h"
#import "RoundedRectNode.h"

@implementation CreditLayer

+ (CCScene*) scene {
    CCScene *scene = [CCScene node];
    [scene addChild:[CreditLayer node]];
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

//Copyright @ 2012 Brian Appell

//Music License courtesy of Ghosts of August "Disease"
//(c) 2012 Core Revolt Publishing / Dirtbag Records

- (void) onEnter
{
	[super onEnter];
	
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite* sprite;
    if( size.width == 568 || size.height == 568 )
        sprite = [CCSprite spriteWithFile: @"stage_back-5x.png"];
    else
      sprite = [CCSprite spriteWithFile: @"stage_back.png"];
	[sprite setPosition: ccp(size.width/2, size.height/2)];
	[self addChild: sprite];
	
	RoundedRectNode* roundNode = [[[RoundedRectNode alloc] initWithRectSize: CGSizeMake(size.width*0.75, size.height/2)] autorelease];
	roundNode.position = ccp(size.width/8, size.height/2.5);
    
	[self addChild: roundNode];
	
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	CCLabelBMFont *labelTitle = [CCLabelBMFont labelWithString:@"Copyright @ 2013 Brian Appell" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	labelTitle.position = ccp(screenSize.width/2, 250);
	[self addChild:labelTitle];

	CCLabelBMFont *labelTitle1 = [CCLabelBMFont labelWithString:@"Music License courtesy of Ghosts \n     of August \"Disease\"" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	labelTitle1.position = ccp(screenSize.width/2, 170);
	[self addChild:labelTitle1];

	CCLabelBMFont *labelTitle2 = [CCLabelBMFont labelWithString:@"(c) 2012 Core Revolt Publishing /\n     Dirtbag Records" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	labelTitle2.position = ccp(screenSize.width/2, 100);
	[self addChild:labelTitle2];
	
	GrowButton *btnBack = [GrowButton buttonWithSpriteFrame:@"btn_back.png" 
											selectframeName: @"btn_back.png" 
													 target:self 
												   selector:@selector(actionBack:)];
	btnBack.position =  ccp(80/2,58/2);
	[sprite addChild:btnBack];	
}

- (void) actionBack: (id) sender
{	
	CCScene* layer = [TitleLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInL transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];	
}

@end
