//
//  PauseScene.m
//  Game
//
//

#import "PauseScene.h"
#import "StageLayer.h"
#import "GrowButton.h"
#import "BackgroundManager.h"
#import "SoundManager.h"
#import "AppDelegate.h"
#import "GrowIconButton.h"
#import "AppSettings.h"

@implementation PauseScene
@synthesize isResetGame;
@synthesize btnSound=_btnSound;
@synthesize btnEffect=_btnEffect;

- (id) init
{
	if( (self=[super initWithColor: ccc4(255,255,255,0)] )) {
		self.isResetGame = NO;
	}
	
	return self;
}

- (void) dealloc
{
	self.btnEffect = nil;
	self.btnSound = nil;
	[invocation release];
	[super dealloc];
}

- (void) onEnter {
	[super onEnter];

	GrowIconButton *btnMainMenu = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png" 
													 selectframeName: @"btn_blank.png" 
													   iconframeName: @"btn_list.png" 
															 posIcon: ccp(56/2, 56/2)
															  target:self 
															selector:@selector(actionMainMenu:)];	
	btnMainMenu.position =  ccp(160,100);
	[self addChild:btnMainMenu];
	
	GrowIconButton *btnNewGame = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png" 
														selectframeName: @"btn_blank.png" 
														  iconframeName: @"btn_replay.png" 
																posIcon: ccp(56/2, 56/2)
																 target:self 
															   selector:@selector(actionNewGame:)];
	btnNewGame.position =  ccp(240,100);
	[self addChild:btnNewGame];

	GrowIconButton *btnResume = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png" 
													   selectframeName: @"btn_blank.png" 
														 iconframeName: @"btn_continue.png" 
															   posIcon: ccp(56/2, 56/2)
																target:self 
															  selector:@selector(actionResume:)];
	btnResume.position =  ccp(320,100);
	[self addChild:btnResume];
	
	GrowIconButton *btnSound = [GrowIconButton buttonWithSpriteFrame:@"btn_music.png" 
													 selectframeName: @"btn_music.png" 
													   iconframeName: @"stop_icon.png" 
															 posIcon: ccp(42/2, 42/2)
															  target:self 
															selector:@selector(actionSound:)];
	btnSound.position =  ccp(370,35);
	[self addChild:btnSound];

	GrowIconButton *btnEffect = [GrowIconButton buttonWithSpriteFrame:@"btn_sound.png" 
													 selectframeName: @"btn_sound.png" 
													   iconframeName: @"stop_icon.png" 
															 posIcon: ccp(42/2, 42/2)
															  target:self 
															selector:@selector(actionEffect:)];
	btnEffect.position =  ccp(420,35);
	[self addChild:btnEffect];

	self.btnSound = btnSound;
	self.btnEffect = btnEffect;
	[_btnSound setIconVisible: [AppSettings backgroundMute]];
	[_btnEffect setIconVisible: [AppSettings effectMute]];
	
	CCLabelBMFont* font = [CCLabelBMFont labelWithString:@"GAME PAUSED" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	font.position = ccp(240, 200);
	[self addChild:font];
	
	id fade = [CCFadeTo actionWithDuration:0.4f opacity: 128];
	[self runAction: fade];
	
}

- (void) actionSound: (id) sender {
	BOOL bMute = ![AppSettings backgroundMute];
	[AppSettings setBackgroundMute: bMute];
	[_btnSound setIconVisible: bMute];
	[[SoundManager sharedSoundManager] setBackgroundMusicMute: bMute];

	if (bMute)
		[[SoundManager sharedSoundManager] stopBackgroundMusic];
	else 
		[[SoundManager sharedSoundManager] playBackgroundMusic: kBRock];
}

- (void) actionEffect: (id) sender {
	BOOL bMute = ![AppSettings effectMute];
	[AppSettings setEffectMute: bMute];
	[_btnEffect setIconVisible: bMute];	
	[[SoundManager sharedSoundManager] setEffectMute: bMute];
}

- (void) onExit {
	[super onExit];
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

- (void) actionEndAnimation: (id) sender {
	[invocation invoke];
	[self removeFromParentAndCleanup: YES];	
}

- (void) actionResume: (id) sender
{
    self.isResetGame = NO;
	id fade = [CCFadeTo actionWithDuration:0.4f opacity: 0];
	id aniFunc = [CCCallFunc actionWithTarget:self selector:@selector(actionEndAnimation:)];
	id sequence = [CCSequence actions: fade, aniFunc, nil];
	[self runAction:sequence];	
}

- (void) actionNewGame: (id) sender
{
    self.isResetGame = YES;
	id fade = [CCFadeTo actionWithDuration:0.4f opacity: 0];
	id aniFunc = [CCCallFunc actionWithTarget:self selector:@selector(actionEndAnimation:)];
	id sequence = [CCSequence actions: fade, aniFunc, nil];
	[self runAction:sequence];	
}

- (void) actionMainMenu: (id) sender
{
	[[SoundManager sharedSoundManager] stopBackgroundMusic];
	CCScene* layer = [StageLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionFade transitionWithDuration:1.0f scene:layer withColor:color];
	[[CCDirector sharedDirector] replaceScene:ts];
	[self removeFromParentAndCleanup: YES];
}

@end
