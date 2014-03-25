//
//  PauseScene.m
//  Game
//
//

#import "GameOverScene.h"
#import "TitleLayer.h"
#import "StageLayer.h"
#import "StoreLayer.h"
#import "AppDelegate.h"
#import "ScoreManager.h"
#import "GrowButton.h"
#import "SoundManager.h"
#import "BackgroundManager.h"
#import "GrowIconButton.h"
#import "AppSettings.h"


@implementation GameOverScene
@synthesize labelSecond=_labelSecond;
@synthesize labelCompleted=_labelCompleted;
@synthesize score=_score;
@synthesize labelPoint=_labelPoint;
@synthesize successed=_successed;
@synthesize labelCaption=_labelCaption;

- (void) dealloc
{
	self.labelCompleted = nil;
	self.labelCaption = nil;
	self.labelSecond = nil;
	self.labelPoint = nil;
	[invocation release];
	[super dealloc];
}

- (id) initWithNextUnLock: (BOOL) bUnLockNextLevel fTime: (float) fTime
{
	if( (self=[super initWithColor: ccc4(255,255,255,0)] )) {
        
//        [ AppDelegate get ].m_nPrevPage =   PAGE_GAMEOVER;

        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite* spriteTemp = [CCSprite spriteWithSpriteFrameName: @"btn_blank.png"];
        CGSize ListSize = spriteTemp.contentSize;
        
		_bUnLockNextLevel = bUnLockNextLevel;
		_fRemainTime = fTime;
		GrowIconButton *btnMainMenu = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png"
															selectframeName: @"btn_blank.png"
															  iconframeName: @"btn_list.png"
																	posIcon: ccp(ListSize.width/2, ListSize.height/2)
																	 target:self
																   selector:@selector(actionMainMenu:)];
        btnMainMenu.position =  ccp(screenSize.width/2 - ListSize.width,screenSize.height*0.70);
		[self addChild:btnMainMenu];
        
        CGSize ReplaySize = spriteTemp.contentSize;
		GrowIconButton *btnTryAgain = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png"
															selectframeName: @"btn_blank.png"
															  iconframeName: @"btn_replay.png"
																	posIcon: ccp(ReplaySize.width/2, ReplaySize.height/2)
																	 target:self
																   selector:@selector(actionTryAgain:)];
        btnTryAgain.position =  ccp(screenSize.width/2,screenSize.height*0.70);
		btnTryAgain.tag = kTagTryButton;
		[self addChild:btnTryAgain];
        
        if (([AppSettings currentStage] + 1) < TOTAL_LEVELS){
            CGSize ContinueSize = spriteTemp.contentSize;
            GrowIconButton *btnContinue = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png"
                                                                selectframeName: @"btn_blank.png"
                                                                  iconframeName: @"btn_nextstage.png"
                                                                        posIcon: ccp(ContinueSize.width/2, ContinueSize.height/2)
                                                                         target:self
                                                                       selector:@selector(actionContinue:)];
            btnContinue.position =  ccp(screenSize.width/2 + ContinueSize.width,screenSize.height*0.70);
            btnContinue.tag = kTagContinueButton;
            [self addChild:btnContinue];
		}
        
        spriteTemp = [CCSprite spriteWithSpriteFrameName: @"btn_email.png"];
        CGSize EmailSize = spriteTemp.contentSize;
        
		GrowButton *btnEmail = [GrowButton buttonWithSpriteFrame:@"btn_email.png"
                                                 selectframeName: @"btn_email.png"
                                                          target:self
                                                        selector:@selector(actionEmail:)];
		btnEmail.position =  ccp(screenSize.width/2 - EmailSize.width*1.5,EmailSize.height*1.25);
		[self addChild:btnEmail];
        
        spriteTemp = [CCSprite spriteWithSpriteFrameName: @"btn_facebook.png"];
        CGSize FBSize = spriteTemp.contentSize;
		GrowButton *btnFacebook = [GrowButton buttonWithSpriteFrame:@"btn_facebook.png"
													selectframeName: @"btn_facebook.png"
															 target:self
														   selector:@selector(actionFacebook:)];
		btnFacebook.position =  ccp(screenSize.width/2,FBSize.height*1.25);
		[self addChild:btnFacebook];
        
        spriteTemp = [CCSprite spriteWithSpriteFrameName: @"btn_gamecenter.png"];
        CGSize GCSize = spriteTemp.contentSize;
		GrowButton *btnGameCenter = [GrowButton buttonWithSpriteFrame:@"btn_gamecenter.png"
                                                      selectframeName: @"btn_gamecenter.png"
                                                               target:self
                                                             selector:@selector(actionGameCenter:)];
		btnGameCenter.position =  ccp(screenSize.width/2 + GCSize.width*1.5,GCSize.height*1.25);
		[self addChild:btnGameCenter];
        
		self.labelCaption = [CCLabelBMFont labelWithString:@"STAGE COMPLETED!" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
        _labelCaption.position = ccp(screenSize.width/2,screenSize.height*0.55);
        [self addChild:_labelCaption];
        
        self.labelPoint = [CCLabelBMFont labelWithString:@"BASE SCORE: 0" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
        _labelPoint.position = ccp(screenSize.width/2,screenSize.height*0.50);
        [self addChild:_labelPoint];
		
		self.labelSecond = [CCLabelBMFont labelWithString:@"TIME BONUS: 0" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
        _labelSecond.position = ccp(screenSize.width/2,screenSize.height*0.45);
        [self addChild:_labelSecond];
		
		self.labelCompleted = [CCLabelBMFont labelWithString:@"FINAL SCORE: 0" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
        _labelCompleted.position = ccp(screenSize.width/2,screenSize.height*0.40);
        [self addChild:_labelCompleted];
		
        [_labelPoint setString: [NSString stringWithFormat: @"SCORE : %d", _score]];
		_successed = NO;
		
		if (bUnLockNextLevel) {
			int currentStage = [AppSettings currentStage]+1;
            
            //hb:insert
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //            BOOL bFlag = [userDefaults boolForKey:@"com.mobware.avalanchemountainhd.allopencoin"];
            
            [AppSettings setStageFlag: currentStage flag: NO];
			
		}
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

- (void) onEnter
{
	[super onEnter];
    _bAllowPlay = FALSE;
	int currentStage = [AppSettings currentStage] + 1;
    
	if (!_successed)
	{
		_bAllowPlay = TRUE;
        GrowButton* btnContinue = (GrowButton*)[self getChildByTag: kTagContinueButton];
		[btnContinue setVisible: NO];
		[_labelCaption setString: [NSString stringWithFormat:@"STAGE %d FAILED!", currentStage]];
		_labelSecond.visible = NO;
		_labelPoint.visible = NO;
		_labelCompleted.visible = NO;
	}
	else
	{
		if (_bUnLockNextLevel) {
			[_labelCaption setString: [NSString stringWithFormat:@"STAGE %d COMPLETED!", currentStage]];
		}
		else{
			[_labelCaption setString: @"TIME IS OVER!"];
        }
        _bAllowPlay = FALSE;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showChartBoostAd];
        [self schedule:@selector(CheckChartBoostAd) interval:1];
	}
    
	[_labelPoint setString: [NSString stringWithFormat: @"BASE SCORE : %d", _score]];
	float fTime = _fRemainTime;
	[_labelSecond setString: [NSString stringWithFormat:@"TIME BONUS: %d*100=%d", (int)fTime, (int)(fTime*100)]];
	[_labelCompleted setString: [NSString stringWithFormat: @"FINAL SCORE : %d", (int)(_score+fTime*100)]];
    if ([Nextpeer isCurrentlyInTournament]) {
        [Nextpeer reportControlledTournamentOverWithScore:(int)(_score+fTime*100)];
    }

}

- (void) CheckChartBoostAd
{
    BOOL RMAd = [(AppDelegate*)[[UIApplication sharedApplication] delegate] GetRevMobRequestFlag];
    BOOL CBAd = [(AppDelegate*)[[UIApplication sharedApplication] delegate] GetChartBoostRequestFlag];
    [self unschedule:@selector(EndAddPage)];
    //    [(AppDelegate*)[[UIApplication sharedApplication] delegate] releaseFullscreen];
    
    if (RMAd==NO){
        if (CBAd == NO){
            _bAllowPlay = TRUE;
        }
    }
    
    if (_bAllowPlay==FALSE) {
        [self schedule:@selector(CheckChartBoostAd) interval:1];
    }
}

- (void) setTitle:(NSString*) title
{
	[_labelCaption setString: title];
}

- (void) actionTryAgain: (id) sender
{
    if (_bAllowPlay) {

	[invocation invoke];
	[self removeFromParentAndCleanup: YES];

    }
}

- (void) actionFacebook: (id) sender
{
	AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	[delegate submitScoreToFacebook: [[ScoreManager sharedScoreManager] topScoreValue]];
}

- (void) actionContinue: (id) sender
{
    if (_bAllowPlay) {
    
	int currentStage = [AppSettings currentStage];
	if (_bUnLockNextLevel)
		currentStage ++;
       // AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
      //  delegate.levelNo = currentStage;
	[AppSettings setCurrentStage: currentStage];
	[AppSettings setStageFlag: currentStage flag: NO];
	[invocation invoke];
	[self removeFromParentAndCleanup: YES];
        
    }
}

- (void) actionMainMenu: (id) sender
{
    if (_bAllowPlay) {
    
	[[SoundManager sharedSoundManager] stopBackgroundMusic];
	CCScene* layer = [StageLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] flgRMdisplay])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeRevMobAd];
    }
	CCTransitionScene *transitionScene = [CCTransitionFade transitionWithDuration:1.0f scene:layer withColor:color];
	[[CCDirector sharedDirector] replaceScene:transitionScene];
        
    }
}

- (void) actionEmail: (id) sender
{
	AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	[delegate showEmail: _score];
}

- (void) actionGameCenter: (id) sender
{
	AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	[appDelegate showLeaderboard];		
}

@end
