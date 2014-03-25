
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "SoundManager.h"

#define MAX_HISTORY 3
#define MAX_HISTORY_POS	100
#define kPerfectTakeOffVelocityY 2.0f
enum ACTION {
	START = 0,
	PLAY,
	ACTION_COUNT
};

@class GameLayer;
class HeroContactListener;

@interface Hero : CCNode {
	GameLayer *_game;
    BOOL _isDoingYahoo;
    CCSprite *_sprite;
    b2Body *_body;
    float radius;
	BOOL awake;
	BOOL tricks;
	BOOL feverMode;
	BOOL tapDown;
	
	float mfAngleHistory[MAX_HISTORY];
	int mHistoryPointer;

	int mZzzCounter;
	int eatedTimeCoinCount;
	
	BOOL eating;
	int eatingFrame;
	BOOL eatingSpeedCoin;
	BOOL forceSleep;
	BOOL _usePowerItemFly;
	BOOL speedFever;
	BOOL biged;
	BOOL eatedScore2x;
	int _currentPlayer;
	
	HeroContactListener *_contactListener;
	BOOL _flying;
	BOOL _diving;
	int _nPerfectSlides;
	int playerPosition;
	int rightLand;
}

@property (nonatomic, assign) GameLayer *game;
@property (nonatomic, retain) CCSprite *sprite;
@property (readonly) BOOL awake;
@property (readonly) BOOL _flying;
@property (readonly) BOOL tricks;
@property (readonly) int rightLand;
@property (nonatomic) BOOL feverMode;
@property (nonatomic) BOOL tapDown;
@property (nonatomic) BOOL forceSleep;
@property (nonatomic) int eatedTimeCoinCount;
@property (nonatomic) BOOL	usePowerItemFly;
@property (nonatomic) BOOL speedFever;
@property (nonatomic) BOOL eatingSpeedCoin;
@property (nonatomic) BOOL eatedScore2x;
@property (nonatomic) BOOL diving;

+ (id) heroWithGame:(GameLayer*)game;
- (id) initWithGame:(GameLayer*)game;
- (void) setHeroAnimation: (ACTION) action;
- (void) unsleep;
- (void) sleep;
- (void) wake;
- (void) dive;
- (void) forcedive;
- (void) limitVelocity;
- (void) updateNodePosition;
- (void) useDiveByPowerupItem;
- (void) reset;
- (void) resetHero;
-(void)rotationOfChar;
- (void) landed;
- (void) tookOff;
- (void) hit;
-(void)buttonEffect2;
-(void)buttonEffect3;
-(void)buttonEffect4;
-(void)buttonEffect5;
-(void)rotationOfChar;
-(void)obsEffect1;
-(void)heroPositionCheck;

@end
