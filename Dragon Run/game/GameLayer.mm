/*
 */

#import "GameLayer.h"
#import "PauseScene.h"
#import "GameOverScene.h"
#import "Sky.h"
#import "Terrain.h"
#import "Hero.h"
#import "FlakeManager.h"
#import "ResourceManager.h"
#import "ScoreManager.h"
#import "AppSettings.h"
#import "AppDelegate.h"
#import "SoundManager.h"
#import "GrowTextButton.h"
#import "NPCocosNotifications.h"

#define MAX_DISTANCE	9000.0f
#define MAX_TIME		90.0f
#define INIT_CHASER_POSX	-1800
#define CHASER_SPEEDX		300
#define BAR_DISTANCE_LENGTH 1000.0
#define MAX_CHASER_DISTANCE 2000

@interface GameLayer (Private) <UIAlertViewDelegate>
- (void) createBox2DWorld;
@end

@implementation GameLayer 
@synthesize mScore;
@synthesize world = _world;
@synthesize sky = _sky;
@synthesize terrain = _terrain;
@synthesize hero = _hero;
@synthesize sprTouchMe=_sprTouchMe;
@synthesize resetButton = _resetButton;
@synthesize scoreFont = _scoreFont;
@synthesize touchFont = _touchFont;
@synthesize mGameType;
@synthesize helpTouch=_helpTouch;
@synthesize sprPrgChar=_sprPrgChar;
@synthesize powerButton=_powerButton;
@synthesize oppsitionplayer=_oppsitionplayer;
+ (CCScene*) scene {
    CCScene *scene = [CCScene node];
    [scene addChild:[GameLayer node]];
    return scene;
}

-(void)tournamentEnded:(id)sender
{
    if ([Nextpeer isCurrentlyInTournament]) {
        
        [Nextpeer reportForfeitForCurrentTournament];
    }

    //Reutn to main menu
    [[SoundManager sharedSoundManager] stopBackgroundMusic];
	CCScene* layer = [TitleLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionFade transitionWithDuration:1.0f scene:layer withColor:color];
	[[CCDirector sharedDirector] replaceScene:ts];
    
}

- (id) init {
    
	if ((self = [super init])) {
        /* Game Recive Other Palyer Data Notification message */
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(gotBlindingStar:) name: NOTIFICATION_GOT_BLIND_ATTACK object: nil];
        nextPeerFramerateJump = 0.0;
        totalTime = 0.0;
    /*
     if ([Nextpeer isCurrentlyInTournament])
     {
     }
    else
    {
        [Nextpeer launchDashboard];
    }
     
     */
//        [Nextpeer isCurrentlyInTournament];
//        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
//        [dict setObject:@"NPA23903563215244302" forKey:@"tournamentUuid"];
//        [NPTournamentStartDataContainer containerWithDictionary:dict];
//        [dict release];
        currentLevel=0;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        screenW = screenSize.width;
        screenH = screenSize.height;
		
        [self createBox2DWorld];
#ifndef DRAW_BOX2D_WORLD

        self.sky = [Sky skyWithTextureSize:512];
        [self addChild:_sky];
        
#endif

        self.terrain = [Terrain terrainWithWorld:_world];
        [self addChild:_terrain];
		
		ResourceManager* resManager = [ResourceManager sharedResourceManager];

        self.hero = [Hero heroWithGame:self];
        [_terrain addChild:_hero];

		self.sprTouchMe = [CCSprite spriteWithFile: @"help_touchme.png"];
		[_sprTouchMe setPosition: ccp(350, 170)];
		_sprTouchMe.visible = NO;
		[self addChild:_sprTouchMe];		
		
		self.resetButton = [CCSprite spriteWithFile:@"pause.png"];
        [self addChild:_resetButton];
        CGSize size = _resetButton.contentSize;
        float padding = 8;
        _resetButton.position = ccp(screenW-size.width/2-padding, screenH-size.height/2-padding);

		self.scoreFont = [CCLabelBMFont labelWithString:@"SCORE 0" fntFile: [resManager getShadowFontName]];
		_scoreFont.anchorPoint = ccp(0,0);
        [self addChild:_scoreFont];
        _scoreFont.position = ccp(250, 15);

		self.touchFont = [CCLabelBMFont labelWithString:@"PRESS SCREEN TO BEGIN!" fntFile:[resManager getShadowFontName]];
		[_touchFont setPosition: ccp(240, 160)];
        [self addChild:_touchFont];

        self.isTouchEnabled = YES;
        tapDown = NO;
        m_bPaused = NO;
		mScore = 0;
		m_bNewGame = NO;
		_isUsePowerup = false;
		_timeUsePowerup = 0;
		_helpTouch = NO;
		m_bHaveEnterGame = [AppSettings isEnterGame];
		_fChaserPosX = INIT_CHASER_POSX;
        [self scheduleUpdate];

		[[SoundManager sharedSoundManager] playBackgroundMusic: kBRock];
		heroCheck=0;
		//60-244
		CCSprite* spriteChar = [CCSprite spriteWithFile: @"prog_char.png"];
		[spriteChar setPosition: ccp(320, 15)];
        [spriteChar setFlipX:YES];
		[self addChild: spriteChar];		
		self.sprPrgChar = spriteChar;

		CCSprite* spriteProgress = [CCSprite spriteWithFile: @"bg_progress.png"];
		[spriteProgress setPosition: ccp(480/2, 24)];
		[self addChild: spriteProgress];				

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidEnterBackground:)
													 name:UIApplicationDidEnterBackgroundNotification object:nil];
	
		
		self.powerButton = [GrowTextButton buttonWithSpriteFrame: @"10"
												 normalframeName:@"btn_power.png"
												 selectframeName: @"btn_power.png"
														  target:self
														selector:@selector(actionPower:)
													  centerText: YES];
		_powerButton.position =  ccp(40,300);
		if ([AppSettings boostCoinCount] != UNLIMIT)
			[_powerButton setString: [NSString stringWithFormat: @"%d", [AppSettings boostCoinCount]]];
		else 
			[_powerButton setString: @"*"];
		[self addChild:_powerButton];
		
		
		
		touchArray=[[NSMutableArray alloc] init];
		
		//all buttons from my side
		
		CCSprite* trickButt1 = [CCSprite spriteWithFile: @"flip.png"];
		[trickButt1 setPosition: ccp(368, 68)];
		trickButt1.tag=1;
		[self addChild: trickButt1];		
		[touchArray addObject:trickButt1];
		
		CCSprite* trickButt2 = [CCSprite spriteWithFile: @"leftboardgrab.png"];
		[trickButt2 setPosition: ccp(428, 68)];
		trickButt2.tag=2;
		[self addChild: trickButt2];
		[touchArray addObject:trickButt2];
		
		CCSprite* trickButt3 = [CCSprite spriteWithFile: @"nose grab.png"];
		[trickButt3 setPosition: ccp(344, 28)];
		trickButt3.tag=3;
		[self addChild: trickButt3];
         [touchArray addObject:trickButt3];
		
		CCSprite* trickButt4 = [CCSprite spriteWithFile: @"rightboardgrab.png"];
		[trickButt4 setPosition: ccp(400, 28)];
		trickButt4.tag=4;
		[self addChild: trickButt4];
        [touchArray addObject:trickButt4];
		
		CCSprite* trickButt5 = [CCSprite spriteWithFile: @"tail grab.png"];
		[trickButt5 setPosition: ccp(455, 28)];
		trickButt5.tag=5;
		[self addChild: trickButt5];
		[touchArray addObject:trickButt5];
		
		
		/*CCMenuItem *trickButt2 = [CCMenuItemImage 
								  itemFromNormalImage:@"leftboardgrab.png" selectedImage:@"leftboardgrab.png" 
								  target:self selector:@selector(buttonEffectCase2)];
		trickButt2.position = ccp(428, 68);
		
		CCMenu *trickButt12 = [CCMenu menuWithItems:trickButt2, nil];
		trickButt12.position = CGPointZero;
		[self addChild:trickButt12 z:44];
		
		

		CCMenuItem *trickButt3 = [CCMenuItemImage 
								  itemFromNormalImage:@"nose grab.png" selectedImage:@"nose grab.png" 
								  target:self selector:@selector(buttonEffectCase3)];
		trickButt3.position = ccp(344, 28);
		
		CCMenu *trickButt13 = [CCMenu menuWithItems:trickButt3, nil];
		trickButt13.position = CGPointZero;
		[self addChild:trickButt13 z:44];

		CCMenuItem *trickButt4 = [CCMenuItemImage 
								  itemFromNormalImage:@"rightboardgrab.png" selectedImage:@"rightboardgrab.png" 
								  target:self selector:@selector(buttonEffectCase4)];
		trickButt4.position = ccp(400, 28);
		
		CCMenu *trickButt14 = [CCMenu menuWithItems:trickButt4, nil];
		trickButt14.position = CGPointZero;
		[self addChild:trickButt14 z:44];
		
		CCMenuItem *trickButt5 = [CCMenuItemImage 
								  itemFromNormalImage:@"tail grab.png" selectedImage:@"tail grab.png" 
								  target:self selector:@selector(buttonEffectCase5)];
		trickButt5.position = ccp(455, 28);
		
		CCMenu *trickButt15 = [CCMenu menuWithItems:trickButt5, nil];
		trickButt15.position = CGPointZero;
		[self addChild:trickButt15 z:44];*/
		
		
		//End case		
		
    }
    return self;
}



- (void) actionPower: (id) sender
{	
	if (!_isUsePowerup && ([AppSettings boostCoinCount] > 0 || [AppSettings boostCoinCount] == UNLIMIT) && _hero.awake)
	{
		_isUsePowerup = true;
		[_hero setUsePowerItemFly:YES];
		_timeUsePowerup = [self getCurrentTime];
		[AppSettings subBoostCoin: 1];
		if ( [AppSettings boostCoinCount] == UNLIMIT )
			[_powerButton setString: @"*"];
		else 
			[_powerButton setString: [NSString stringWithFormat: @"%d", [AppSettings boostCoinCount]]];
	}
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
	if (m_bPaused)
		return;
	[self actionPause];
	
}

-(void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) onExit
{
    
    
    if ([Nextpeer isCurrentlyInTournament]) {
        
        [Nextpeer reportForfeitForCurrentTournament];
       [[NPCocosNotifications sharedManager] clearAndDismiss];
         //[[NSNotificationCenter defaultCenter] removeObserver: self];
    }

	[self unscheduleUpdate];
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (void) setHelpTouch: (BOOL) touched
{
	if (m_bHaveEnterGame)
		return;
	
	_helpTouch = touched;
	self.sprTouchMe.visible = touched;
}

- (void) setMGameType: (GAMETYPE) gameType
{
	mGameType = gameType;
}

- (void) changePlayerDone: (int) plusCoin 
{
	[((AppDelegate*)([UIApplication sharedApplication].delegate)) submitScore: [self getRealScore]+plusCoin];
	[[ScoreManager sharedScoreManager] submitQuickScore: @"test" score: [self getRealScore]+plusCoin];
	int currentStage = [AppSettings currentStage];
	[AppSettings setScore:currentStage nScore:[self getRealScore]+plusCoin];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    self.sprPrgChar = nil;
	self.sky = nil;
	self.terrain = nil;
    self.hero = nil;
    self.resetButton = nil;
	self.scoreFont = nil;
	self.touchFont = nil;
	
#ifdef DRAW_BOX2D_WORLD

    delete render;
    render = NULL;
    
#endif
    
	delete _world;
	_world = NULL;
	[super dealloc];
}

- (void) actionPause
{
    if (m_bPaused)
        return;
    m_bPaused = YES;
	_pauseTime = [self getCurrentTime];
    PauseScene* dialog = [[[PauseScene alloc]  init] autorelease];
    [dialog setTarget: self selector: @selector(actionResume:)];
    [self addChild: dialog];
}

- (void) actionGameOver
{
    m_bPaused = YES;
	float fTime = [self getRemainTime];
	BOOL bUnLockNextStage = (fTime > 0)?YES:NO;
    GameOverScene* dialog = [[[GameOverScene alloc]  initWithNextUnLock: bUnLockNextStage fTime:fTime] autorelease];
	[dialog setSuccessed: YES];
    [dialog setTarget: self selector: @selector(actionResumeForOverDialog:)];	
	[self changePlayerDone: fTime*100];
	int nScore = [self getRealScore];
	[dialog setScore: nScore];
    [self addChild: dialog];
    [[SoundManager sharedSoundManager] playEffect:kContratulations bForce:NO];
}

- (void) actionGameFail 
{	
    m_bPaused = YES;
    GameOverScene* dialog = [[[GameOverScene alloc]  initWithNextUnLock: NO fTime:0] autorelease];
	[dialog setSuccessed: NO];
    [dialog setTarget: self selector: @selector(actionResumeForOverDialog:)];
	[dialog setScore: [self getRealScore]];
    [self addChild: dialog];
}

- (void) actionResumeForOverDialog: (id) sender
{
	m_bNewGame = YES;
    m_bPaused = NO;	
}

- (void) actionResume: (id) sender
{
    PauseScene* dialog = (PauseScene*)sender;
    if (dialog.isResetGame)
    {
        currentLevel=0;
		m_bNewGame = YES;
    }
    else {
		_startTime += ([self getCurrentTime] - _pauseTime);
	}
    m_bPaused = NO;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint pos = _resetButton.position;
    CGSize size = _resetButton.contentSize;
    float padding = 8;
    float w = size.width+padding*2;
    float h = size.height+padding*2;
    CGRect rect = CGRectMake(pos.x-w/2, pos.y-h/2, w, h);
    if (CGRectContainsPoint(rect, location)) {
        [self actionPause];
    } else {
		if (![_hero feverMode])			
			tapDown = YES;
		[_hero setTapDown: YES];
    }
	
	
	
	//UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
	
	CGPoint point1 =  [[CCDirector sharedDirector] convertToGL: point];
	NSLog(@"ccTouchesMoved x=%f y=%f", point.x, point.y);
	
	CCSprite * player1 = [CCSprite spriteWithFile:@"waleft_board_grab1.png"];
	
	player1.position = ccp(point1.x,point1.y);
	player1.scale=.1;
	//player.anchorPoint = ccp(.5,0);
	[self addChild:player1];
	for (CCSprite *target in touchArray)
	{
		if ((CGRectIntersectsRect([target boundingBox], [player1 boundingBox])) && heroCheck==0) 	
		{
			heroCheck=1;
			if(target.tag==1)
			    [_hero rotationOfChar];
			if(target.tag==2)
				[_hero buttonEffect2];
			if(target.tag==3)
				[_hero buttonEffect3];
			if(target.tag==4)
				[_hero buttonEffect4];		
			if(target.tag==5)
				[_hero buttonEffect5];
			
			break;
		}
		else
		{
			[_hero obsEffect1];
		}
		
		
	}
	
	
	[self removeChild:player1 cleanup:YES];
	player1=nil;
	
   return YES;
	
	
}



- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
	
	CGPoint point1 =  [[CCDirector sharedDirector] convertToGL: point];
	NSLog(@"ccTouchesMoved x=%f y=%f", point.x, point.y);
	
	CCSprite * player1 = [CCSprite spriteWithFile:@"waleft_board_grab1.png"];
	
	player1.position = ccp(point1.x,point1.y);
	player1.scale=.1;
	//player.anchorPoint = ccp(.5,0);
	[self addChild:player1];
	for (CCSprite *target in touchArray)
	{
		if ((CGRectIntersectsRect([target boundingBox], [player1 boundingBox])) && heroCheck==0)	
		{
			heroCheck=1;
			if(target.tag==1)
			    [_hero rotationOfChar];
			if(target.tag==2)
				[_hero buttonEffect2];
			if(target.tag==3)
				[_hero buttonEffect3];
			if(target.tag==4)
				[_hero buttonEffect4];		
			if(target.tag==5)
				[_hero buttonEffect5];			
			break;
		}
		else
		{
			[_hero obsEffect1];
		}
		
		
	}
	
	
	[self removeChild:player1 cleanup:YES];
	player1=nil;
	
	
}


- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    tapDown = NO;
	[_hero setTapDown: NO];
	if(heroCheck==1)
	   {
	    [_hero obsEffect1];
		heroCheck=0;
	   }
}

- (void) fadeOutSunriseLayer
{
	[_hero wake];
	tapDown = NO;	
	m_bPaused = NO;
	[_hero setHeroAnimation: PLAY];
	_startTime = [self getCurrentTime];
}

- (long) getCurrentTime
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	long ms = tv.tv_sec * 1000L + tv.tv_usec / 1000L;
	return ms;
}

- (void) update:(ccTime)dt
{
    totalTime = totalTime + dt;
   // NSLog(@"total time %f", totalTime);
    
	if (m_bPaused) {
		return;
	}
	if (m_bNewGame)
	{
        [_terrain resetTerrain];
        [_hero resetHero];
//		_timeFont.visible = YES;
//		_sprClockBg.visible = YES;
		mScore = 0;
//		[_timeFont setString: @"90.00"];
		_fChaserPosX = INIT_CHASER_POSX;
		[[FlakeManager sharedFlakeManager] reset];
		[_sprPrgChar setPosition: ccp(320, 15)];
		m_bNewGame = NO;	
		return;
	}
    if (tapDown) 
	{
		if (!_hero.awake) 
		{
			m_bPaused = YES;
			_touchFont.visible = NO;
			[AppSettings setEnterGame];
			
			[self fadeOutSunriseLayer];
			return;
		} 
		else 
		{
			[_hero dive];
		}
    }
    [_hero limitVelocity];
	if (_isUsePowerup)
	{
		[_hero useDiveByPowerupItem];
		long remainTime = [self getCurrentTime] - _timeUsePowerup;
		
		if (remainTime > 1000)
		{
			_isUsePowerup = false;
			[_hero setUsePowerItemFly:NO];
		}
	}
    
    int32 velocityIterations = 8;
    int32 positionIterations = 3;
    _world->Step(dt, velocityIterations, positionIterations);
    
    // update hero CCNode position
    [_hero updateNodePosition];	
	
    // terrain scale and offset
    float height = _hero.position.y;
    const float minHeight = screenH*4/5;
	const float lowHeight = screenH*2/5;
    if (height < minHeight) {
        height = minHeight;
    }


	float scale = 1.0f;
	
	if (![_terrain existBetweenValley:kMaxHillKeyPoints-6 endValley:kMaxHillKeyPoints-1 heroPos: _hero.position])
	{
		scale = minHeight / height;		
		_terrain.offsetY = 0;
	}
	else
	{
		if (_hero.position.y > lowHeight)
		{
			scale = minHeight / height;		
			_terrain.offsetY = 0;
		}
		else
		{
			_terrain.offsetY = lowHeight - _hero.position.y;
		}

		if ([_terrain continentFeverDivePos].x < _hero.position.x)
		{
			[_hero setFeverMode: YES];
		}
		if ([_terrain existBetweenValley:kMaxHillKeyPoints-2 endValley:kMaxHillKeyPoints-1 heroPos: _hero.position])
		{
			[_hero forcedive];
			[_hero reset];
			//NSLog(@"force drive");
		}
	}
	
	if ([_terrain existBetweenValley:0 endValley:3 heroPos: _hero.position])
	{
		[_hero setFeverMode: NO];
	}

    _terrain.scale = scale;
    _terrain.offsetX = _hero.position.x;
	CCSprite *shark =  nil;
    
    /* Game Sender Palyer Data   ( Remove Comment from code )*/
    if ([Nextpeer isCurrentlyInTournament])
    {//_hero.position;//
		shark.position = self.hero.position;//CGPointMake(100, 100);
//		if(shark.visible) {
			
        CGPoint shark_pos = self.hero.position;//shark.position;
       // NSLog(@"hero postion %f %f %f",self.hero.position.x , _hero.position.x, shark_pos.x);
            NSData *packet = [NSData dataWithBytes:&shark_pos length:sizeof(CGPoint)];
    // Perform action!
           if (packet) {
////            [Nextpeer pushMessageToOtherPlayers:@"%PLAYER_NAME% Avalanched You !"];
//               nextPeerFramerateJump = nextPeerFramerateJump + 1.0;
//               if(nextPeerFramerateJump  == 3.0) { //send 20 updates to nextPeer per second
//                   nextPeerFramerateJump = 0.0;
//                   //[Nextpeer pushDataToOtherPlayers:packet];
//
//               }else{
//                  // NSLog(@"t");
                   [Nextpeer pushDataToOtherPlayers:packet];

               }
//            }
//        }
    }

#ifndef DRAW_BOX2D_WORLD

    [_sky setOffsetX:_terrain.offsetX*0.2f];
    [_sky setScale:1.0f-(1.0f-scale)*0.75f];
    
#endif
	
	[self drawScore];
	[self updateProgress: dt];
//	NSLog(@"dt = %f", dt);
}

- (float) getRemainTime {
	float fTime =  (MAX_TIME-([self getCurrentTime]-_startTime)/1000.0f);
	if (fTime < 0)
		fTime = 0;
	return fTime;
}

- (void) updateProgress:(ccTime)dt 
{
	if (m_bPaused || !_hero.awake)
		return;

	_fChaserPosX += CHASER_SPEEDX*dt;
	float fDistance=_hero.position.x-_fChaserPosX;
	float fTime = [self getRemainTime];
	float fPercent = fTime/MAX_TIME*100;
    if (fDistance>MAX_CHASER_DISTANCE)
    {
        _fChaserPosX = _hero.position.x-MAX_CHASER_DISTANCE;
    }
	//hb: insert
	if (_terrain.endDistanceX < _hero.position.x) {
  
		[_hero sleep];
		[self actionGameOver];
	} 
	else if (fPercent <= 0) {
		fPercent = 0;
		[_hero sleep];
		[self actionGameFail];
		return;
	}
	
	[_sprPrgChar setPosition: ccp(60+(300-60)/100.0f*fPercent, 17)];
	if (fTime < 0)
		fTime = 0;
}

- (int) getRealScore
{
	return mScore + [FlakeManager sharedFlakeManager].snowCount*100;
}

- (void) drawScore
{
	if (_hero.awake)
	{	
		
		int p=_hero.rightLand;
		
		if(p==1 && !_hero._flying)
		{
			mScore -=10;
						
		}
		else
		{
		 
		if(heroCheck==1 && _hero.tricks)
		  {
			  printf("\nneal");
			mScore +=20;
		  }
		else
			mScore += 1;
		}
		if (fever)
			mScore += 30;
		
		
		
	}
	
	static int s_nScore = 0;
	if (mScore < s_nScore)
		s_nScore = mScore + [FlakeManager sharedFlakeManager].snowCount*100;
	else if (mScore > s_nScore)
	{
		s_nScore = mScore + [FlakeManager sharedFlakeManager].snowCount*100;
	}
	
	[_scoreFont setString: [NSString stringWithFormat: @"%d", s_nScore]];
    if ([Nextpeer isCurrentlyInTournament])
    {
        [Nextpeer reportScoreForCurrentTournament:s_nScore];
    }
}

- (void) createBox2DWorld {
    
    b2Vec2 gravity;
    gravity.Set(0.0f, -9.8f);
    
    _world = new b2World(gravity, false);
	
#ifdef DRAW_BOX2D_WORLD
    
    render = new GLESDebugDraw(PTM_RATIO);
    _world->SetDebugDraw(render);
    
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
//	flags += b2Draw::e_jointBit;
//	flags += b2Draw::e_aabbBit;
//	flags += b2Draw::e_pairBit;
//	flags += b2Draw::e_centerOfMassBit;
	render->SetFlags(flags);
    
#endif
}

- (void) showPerfectSlide {
//	NSString *str = @"perfect slide";
//	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:@"shadowFont.fnt"];
//	label.position = ccp(screenW/2, screenH*15/16);
//	[label runAction:[CCScaleTo actionWithDuration:1.0f scale:1.2f]];
//	[label runAction:[CCSequence actions:
//					  [CCFadeOut actionWithDuration:1.0f],
//					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
//					  nil]];
//	[self addChild:label];
}

- (void) showFrenzy {
	NSString *str = @"FREESTYLE!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*15/16);
	[label runAction:[CCScaleTo actionWithDuration:2.0f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:2.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

- (void) showHit {
	NSString *str = @"";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*15/16);
	[label runAction:[CCScaleTo actionWithDuration:1.0f scale:1.2f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

- (void) showMissionSuccess {
	NSString *str = @"WELL DONE!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*9/16);
	[label runAction:[CCScaleTo actionWithDuration:1.2f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.2f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

-(void)showTookMagnet
{
    NSString *str = @"SUPER MAGNET!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*9/16);
	[label runAction:[CCScaleTo actionWithDuration:1.2f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.2f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}
-(void)showTookEnlarge
{
    NSString *str = @"SUPER SIZE!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*9/16);
	[label runAction:[CCScaleTo actionWithDuration:1.2f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.2f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}
-(void)showTookDoublePoints
{
    NSString *str = @"DOUBLE POINTS!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*9/16);
	[label runAction:[CCScaleTo actionWithDuration:1.2f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.2f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}


-(void)showTookExtraTime
{
    NSString *str = @"EXTRA TIME!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*9/16);
	[label runAction:[CCScaleTo actionWithDuration:1.2f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.2f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}
-(void)showTookSpeed
{
    NSString *str = @"EXTRA SPEED!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
	label.position = ccp(screenW/2, screenH*9/16);
	[label runAction:[CCScaleTo actionWithDuration:1.2f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.2f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

-(void)tookExtraTime
{
}

-(void)tookRegularCoin
{
}


/* Game Recive Other Palyer Data */
- (void)addBlindingStarAtPosition:(CGPoint)starPoint
{
   // NSLog(@"test %f",starPoint.x);
    if([_terrain getChildByTag:100000])
    {
        _oppsitionplayer.position=starPoint;
    }
    else{
       // [_terrain removeChildByTag:100000 cleanup:YES];
        self.oppsitionplayer = [Hero heroWithGame:self];
        self.oppsitionplayer.tag=100000;
        self.oppsitionplayer.scale=2.0;
        [_terrain addChild:_oppsitionplayer];
        _oppsitionplayer.position=starPoint;

    }
}
- (void)gotBlindingStar:(NSNotification *)notification
{
   // NSLog(@"Hi Test");

	NSData *data = [notification object];
	CGPoint starPos;
	if (data == nil) {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		starPos = ccp(winSize.width/2, winSize.height/2);
	}
	else {
        CGPoint* receivedPointPtr = (CGPoint*)[data bytes];
        // NSLog(@"%f",receivedPointPtr);
        starPos = *receivedPointPtr;
         // NSLog(@"%f",starPos.x);
	}
    
	[self addBlindingStarAtPosition:starPos];
}
/*
-(void)nextpeerDidReceiveTournamentCustomMessage:(NPTournamentCustomMessageContainer*)message
{
    NSLog(@"Received game message from %@", message.playerName);
    NSDictionary* gameMessage = [NSKeyedUnarchiver unarchiveObjectWithData:message.message];
    NSUInteger type = [[gameMessage objectForKey:@"type"] unsignedIntValue];
    NSLog(@"%d Type ",type);
   /* switch (type) {
   //     case MESSAGE_TYPE_SLOWDOWN:
            // Slow down the main character
       //     break;
        case MESSAGE_TYPE_FLASH_BOMB:
            // Show flash bomb animation
            break;
    
    }
}
*/
/* Code END */


//#pragma mark - NPTournamentDelegate
//-(void)nextpeerDidReceiveTournamentCustomMessage:(NPTournamentCustomMessageContainer*)message
//{
//	NSData *data = message.message;
//	CGPoint starPos;
//	if (data == nil) {
//		CGSize winSize = [[CCDirector sharedDirector] winSize];
//		starPos = ccp(winSize.width/2, winSize.height/2);
//	}
//	else {
//        CGPoint* receivedPointPtr = (CGPoint*)[data bytes];
//        starPos = *receivedPointPtr;
//	}
//	[self addBlindingStarAtPosition:starPos];
//}

@end
