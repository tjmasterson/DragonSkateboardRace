
#import "GameLayer.h"
#import "Hero.h"
#import "Box2D.h"
#import "GameConfig.h"
#import "ResourceManager.h"
#import "FlakeManager.h"
#import "AppSettings.h"
#import "HeroContactListener.h"
#import "SoundManager.h"

@interface Hero()
- (void) createBox2DBody;
@end

@implementation Hero

@synthesize game = _game;
@synthesize sprite = _sprite;
@synthesize awake;
@synthesize tricks;
@synthesize _flying;
@synthesize rightLand;
@synthesize feverMode;
@synthesize tapDown;
@synthesize forceSleep;
@synthesize eatedTimeCoinCount;
@synthesize usePowerItemFly=_usePowerItemFly;
@synthesize speedFever;
@synthesize eatingSpeedCoin;
@synthesize eatedScore2x;
@synthesize diving = _diving;

+ (id) heroWithGame:(GameLayer*)game {
	return [[[self alloc] initWithGame:game] autorelease];
}

- (id) initWithGame:(GameLayer*)game {
    
	if ((self = [super init])) {

		self.game = game;

#ifndef DRAW_BOX2D_WORLD
        self.sprite = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"dragon%d0.png", [AppSettings getCurrentPlayer]]];
		
        [self addChild:_sprite];
		[self setHeroAnimation: START];
#endif
		_body = NULL;
        _currentPlayer = [AppSettings getCurrentPlayer];
		NSLog(@"currentPlayer = %d", _currentPlayer);
		radius = 18.0f;
		awake = NO;
		tapDown = NO;
		eating = NO;
		tricks=NO;
		eatingFrame = 0;
		eatingSpeedCoin= NO;
		_usePowerItemFly= NO;
		forceSleep = NO;
		mHistoryPointer = 0;
		mZzzCounter = 0;
		eatedTimeCoinCount = 0;
		speedFever = NO;
		for (int i = 0; i < MAX_HISTORY; i ++)
			mfAngleHistory[i] = -1000;

		_contactListener = new HeroContactListener(self, game);
		_game.world->SetContactListener(_contactListener);

		[self createBox2DBody];
        [self updateNodePosition];
		[self sleep];

		_flying = NO;
		_diving = NO;
		_nPerfectSlides = 0;
		rightLand=0;
		playerPosition=0;
	}
	return self;
}

- (void) setHeroAnimation: (ACTION) action {
	int _selectedChar = [AppSettings getCurrentPlayer];
	[_sprite stopAllActions];	
	CCSpriteFrame* frame1, *frame2, *frame3, *frame4;	
	if (action == START) {
		frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d0.png", _selectedChar]];
		frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d1.png", _selectedChar]];
		frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d2.png", _selectedChar]];
		frame4 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d3.png", _selectedChar]];
	} else if (action == PLAY) {
		frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d0.png", _selectedChar]];
		frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d1.png", _selectedChar]];
		frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d2.png", _selectedChar]];
		frame4 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"dragon%d3.png", _selectedChar]];		
	}
	
	[_sprite setAnchorPoint:ccp(0.5, 18.0f/	frame1.rect.size.height)];
	CCAnimation *danceAnimation = [CCAnimation animationWithFrames:[NSArray arrayWithObjects:frame1, frame2,frame3, frame4, nil] delay:0.1f];				
	
	CCAnimate *danceAction = [CCAnimate actionWithAnimation:danceAnimation];
	CCRepeatForever *repeat = [CCRepeatForever actionWithAction:danceAction];
	[_sprite runAction:repeat];		
}

- (void) dealloc {

	self.game = nil;

#ifndef DRAW_BOX2D_WORLD
    self.sprite = nil;
#endif
	delete _contactListener;
    [super dealloc];
}

- (void) createBox2DBody {

    CGSize size = [[CCDirector sharedDirector] winSize];
    int screenH = size.height;
    CGPoint startPosition = ccp(0, (screenH*2+radius));
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.position.Set(startPosition.x/PTM_RATIO, startPosition.y/PTM_RATIO);
    _body = _game.world->CreateBody(&bd);
    
    b2CircleShape shape;
    shape.m_radius = radius/PTM_RATIO;
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    fd.restitution = 0; // bounce
    fd.friction = 0;
    
    _body->CreateFixture(&fd);
}

- (void) unsleep
{
	awake = YES;
	_body->SetActive(true);	
}

- (void) sleep {
	awake = NO;
	_body->SetActive(false);
}

- (void) wake {
	awake = YES;
	_body->SetActive(true);
	_body->ApplyLinearImpulse(b2Vec2(1,2), _body->GetPosition());
}

- (void) useDiveByPowerupItem {
    _body->ApplyForce(b2Vec2(20,10),_body->GetPosition());
}

- (void) forcedive {
    _body->ApplyForce(b2Vec2(5,40),_body->GetPosition());
}

- (void) dive {
    _body->ApplyForce(b2Vec2(0,-30),_body->GetPosition());
}

- (void) limitVelocity {
    float minVelocityX = 3;
    float minVelocityY = -40;

    b2Vec2 vel = _body->GetLinearVelocity();

	if (eatingSpeedCoin)
	{
		minVelocityX = 6;
		eatingSpeedCoin = NO;
	}
	if (feverMode) 
	{	
		if (vel.y < 0)
			minVelocityY = -50;	
		else
			minVelocityX = 30;	
	}
	
    if (vel.x < minVelocityX) {
        vel.x = minVelocityX;
    }
    if (vel.y < minVelocityY) {
        vel.y = minVelocityY;
    }
    _body->SetLinearVelocity(vel);
}

- (float) calcAverAngle: (float) angle
{
	float fSum = 0;
	int nCount = 0;
	for (int i = 0; i < MAX_HISTORY; i ++)
	{
		if (mfAngleHistory[i] != -1000)
		{
			fSum += mfAngleHistory[i]; 
			nCount ++;
		}
	}
	
	mfAngleHistory[mHistoryPointer] = angle;
	mHistoryPointer = (mHistoryPointer + 1) % MAX_HISTORY;
	return (fSum+angle)/(nCount+1);
}
- (void) updateNodePosition {

    float x = _body->GetPosition().x*PTM_RATIO;
    float y = _body->GetPosition().y*PTM_RATIO;
	self.position = ccp(x, y);
    b2Vec2 vel = _body->GetLinearVelocity();
    float angle = (atan2f(vel.y, vel.x));
    

#ifdef DRAW_BOX2D_WORLD
    
    _body->SetTransform(_body->GetPosition(), angle);
    
#else
    
	angle = [self calcAverAngle: angle];
    self.rotation = (int)(-1 * CC_RADIANS_TO_DEGREES(angle));
    if (y>950 && !_isDoingYahoo)
    {
        [[SoundManager sharedSoundManager] playEffect: kYahoo bForce: NO];
        _isDoingYahoo=true;
    }
    if (y<500)
    {
        _isDoingYahoo=false;
    }
	FlakeManager *Manager = [FlakeManager sharedFlakeManager];
	
	SNOWTYPE coinType = [Manager canGet: self.position];
	if (coinType != SNOW_NONE)
	{
		eating = YES;
		eatingFrame = 0;
		if (coinType==SNOW_GOLD)
        {
            [_game tookRegularCoin];
            _game.mScore+=20;
        }
	}

	if (eating)
	{
		eatingFrame ++;
		if (eatingFrame > 10)
		{
			eating = NO;
			eating = 0;
		}		
	}	
#endif
	// collision detection
	b2Contact *c = _game.world->GetContactList();
	if (c) {
		if (_flying) {
			[self landed];
		}
	} else {
		if (!_flying) {
			[self tookOff];
		}
	}	
}

- (void) reset {
	biged = NO;
	eatingSpeedCoin = NO;
	eatedScore2x = NO;
}

- (void) resetHero {
	_game.world->DestroyBody(_body);
	[self createBox2DBody];
	[self sleep];
	biged = NO;
	eatingSpeedCoin = NO;
	eatedScore2x = NO;
	eatedTimeCoinCount = 0;
	speedFever = NO;
	forceSleep = NO;

	_flying = NO;
	_diving = NO;
	_nPerfectSlides = 0;
}
//===============================our creation=============================


-(void)rotationOfChar
{
	if(playerPosition==1)
	{
		tricks=YES;
		
	rightLand=1;
	float x12=_sprite.position.x;
	float y12=_sprite.position.y;
		
	[self removeChild:_sprite cleanup:YES];
	_sprite=nil;
		
	_sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"nosegrab%d.png", _currentPlayer]];
	_sprite.position=ccp(x12,y12);
		if(_currentPlayer==6)
			_sprite.scale=.7;
	[self addChild:_sprite];
	[_sprite runAction:[CCRotateTo actionWithDuration:2.2 angle:1440]];
						
	}
}

-(void)obsEffect1
{
	//[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"doing"];
	//[[NSUserDefaults standardUserDefaults] synchronize];
	rightLand=1;
	tricks=NO;
	float x12=_sprite.position.x;
	float y12=_sprite.position.y;
	//float y121=_sprite.scale;
	[self removeChild:_sprite cleanup:YES];
	_sprite=nil;
	self.sprite = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"dragon%d0.png", [AppSettings getCurrentPlayer]]];
	_sprite.position=ccp(x12,y12);
	
    [self addChild:_sprite];
	[self setHeroAnimation: START];
	//playerPosition=0;
	rightLand=0;
	
}


-(void)buttonEffect2
{
	if(playerPosition==1)
	{
	rightLand=1;
	tricks=YES;
	float x12=_sprite.position.x;
	float y12=_sprite.position.y;
	//float y121=_sprite.scale;
	[self removeChild:_sprite cleanup:YES];
	
	_sprite=nil;
	
	_sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"left_board_grab%d.png", _currentPlayer]];
	_sprite.position=ccp(x12,y12);
		if(_currentPlayer==6)
			_sprite.scale=.7;
	[self addChild:_sprite];
	}
	//[_sprite stopAllActions];
	//[_sprite setTexture:[[CCTextureCache sharedTextureCache]addImage:@"left_board_grab6.png"/*[NSString stringWithFormat:@"left_board_grab%d.png", _currentPlayer]]*/]];
}

-(void)buttonEffect3
{
	if(playerPosition==1)
	{
	tricks=YES;
	rightLand=1;
	//[_sprite setTexture:[[CCTextureCache sharedTextureCache]addImage:[NSString stringWithFormat:@"nosegrab%d.png", _currentPlayer]]];
	float x12=_sprite.position.x;
	float y12=_sprite.position.y;
	
	[self removeChild:_sprite cleanup:YES];
	
	_sprite=nil;
	
	_sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"nosegrab%d.png", _currentPlayer]];
	_sprite.position=ccp(x12,y12);
		if(_currentPlayer==6)
			_sprite.scale=.7;
	[self addChild:_sprite];
	}
	
}


-(void)buttonEffect4
{
	if(playerPosition==1)
	{
	tricks=YES;
	rightLand=1;
	//[_sprite setTexture:[[CCTextureCache sharedTextureCache]addImage:[NSString stringWithFormat:@"right_board_grab%d.png", _currentPlayer]]];
	float x12=_sprite.position.x;
	float y12=_sprite.position.y;
	
	[self removeChild:_sprite cleanup:YES];
	
	_sprite=nil;
	
	_sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"right_board_grab%d.png", _currentPlayer]];
	_sprite.position=ccp(x12,y12);
		if(_currentPlayer==6)
			_sprite.scale=.7;
	[self addChild:_sprite];
	}
}


-(void)buttonEffect5
{
	if(playerPosition==1)
	{
	tricks=YES;
	rightLand=1;
	//[_sprite setTexture:[[CCTextureCache sharedTextureCache]addImage:[NSString stringWithFormat:@"tailgrab%d.png", _currentPlayer]]];
	float x12=_sprite.position.x;
	float y12=_sprite.position.y;
	
	[self removeChild:_sprite cleanup:YES];
	
	_sprite=nil;
	
	_sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"tailgrab%d.png", _currentPlayer]];
	_sprite.position=ccp(x12,y12);
		if(_currentPlayer==6)
			_sprite.scale=.7;
	[self addChild:_sprite];
	}
}



//=================================End of our creation=====================

- (void) landed {
	NSLog(@"landed");
	tricks=NO;
	//[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"doing"];
	//[[NSUserDefaults standardUserDefaults] synchronize];
	_flying = NO;
	[self runAction:[CCSequence actions:
								
								[CCDelayTime actionWithDuration:.2],
								
								[CCCallFuncN actionWithTarget:self selector:@selector(heroPositionCheck)],
								nil]];
	playerPosition=0;
}

-(void)heroPositionCheck
{
	if(rightLand==1)
	{
		float x12=_sprite.position.x;
		float y12=_sprite.position.y;
		//float y121=_sprite.scale;
		[self removeChild:_sprite cleanup:YES];
		_sprite=nil;
		self.sprite = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"dragon%d0.png", [AppSettings getCurrentPlayer]]];
		_sprite.position=ccp(x12,y12);
		[self addChild:_sprite];
		[self setHeroAnimation: START];
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"valueCorrect"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		rightLand=0;
	}
	
}


- (void) tookOff {
	//	NSLog(@"tookOff");
	_flying = YES;
	
	b2Vec2 vel = _body->GetLinearVelocity();
	//	NSLog(@"vel.y = %f",vel.y);
	if (vel.y > kPerfectTakeOffVelocityY) {
		//		NSLog(@"perfect slide");
		playerPosition=1;
		_nPerfectSlides++;
		if (_nPerfectSlides > 1) {
			if (_nPerfectSlides == 4) {
				[_game showFrenzy];
			} else {
				[_game showPerfectSlide];
			}
		}
	}
}

- (void) hit {
	//	NSLog(@"hit");
	_nPerfectSlides = 0;
	[_game showHit];
}

- (void) setDiving:(BOOL)diving {
	if (_diving != diving) {
		_diving = diving;
		// TODO: change sprite image here
	}
}


@end
