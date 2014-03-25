/*
 */

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "TitleLayer.h"
#import "Hero.h"
#import "Nextpeer/NextpeerDelegate.h"
#import "Nextpeer/NPTournamentDelegate.h"

@class Sky;
@class Terrain;
@class Hero;
@class GrowTextButton;
@class AppDelegate;

enum GAMETYPE
{
	GAME_QUICK = 0,
	STAGE_1,
	STAGE_2,
	STAGE_3,
	STAGE_4,
	STAGE_5,
	STAGE_6,
	MAX_GAMETYPE
};

@interface GameLayer : CCLayer<UITextFieldDelegate> {
    int currentLevel;
    int screenW;
    int screenH;
    b2World *_world;
    Sky *_sky;
    Terrain *_terrain;
    Hero *_hero;
    Hero *oppsitionplayer;
    BOOL tapDown;
    GLESDebugDraw *render;
    CCSprite *_resetButton;
	CCSprite *_sprTouchMe;
    CCLabelBMFont* _scoreFont;
	CCLabelBMFont* _touchFont;
    BOOL m_bPaused;
	GAMETYPE mGameType;
	int mScore;
	CCSprite *_sprPrgChar;
	BOOL	_helpTouch;
	BOOL	perfectSlideStart;
	int		perfectSlideHillNumber;
	BOOL	fever;
	BOOL	feverCount;
	BOOL	m_bNewGame;
	BOOL	m_bHaveEnterGame;
	bool	_isUsePowerup;
	long	_timeUsePowerup;
	float	_fChaserPosX;
	
	long _goldForComplete;
	unsigned long _startTime;
	unsigned long _pauseTime;
	
	UIAlertView *changePlayerAlert;
	UITextField *changePlayerTextField;		
	GrowTextButton* _powerButton;
	
	NSMutableArray  * touchArray;
	int heroCheck;
    
    AppDelegate *app;
    
    float nextPeerFramerateJump; // nextPeer allows 20 messages per second, but game current rate is 25 frames per second;
     float totalTime;
}

@property (nonatomic, readonly) b2World *world;
@property (nonatomic, retain) Sky *sky;
@property (nonatomic, retain) Terrain *terrain;
@property (nonatomic, retain) Hero *hero;
@property (nonatomic, retain) Hero *oppsitionplayer;

@property (nonatomic, retain) CCSprite *resetButton;
@property (nonatomic, retain) CCSprite *sprTouchMe;
@property (nonatomic, retain) CCLabelBMFont* scoreFont;
@property (nonatomic, retain) CCLabelBMFont* touchFont;
@property (nonatomic, readwrite) int mScore;
@property (nonatomic) GAMETYPE mGameType;
@property (nonatomic) BOOL helpTouch;
@property (nonatomic, retain) CCSprite *sprPrgChar;
@property (nonatomic, retain) GrowTextButton* powerButton;

+ (CCScene*) scene;
- (id) init;
- (void) actionGameOver;
- (long) getCurrentTime;
- (int) getRealScore;
- (void) setMGameType: (GAMETYPE) gameType;
-(void)tookExtraTime;
- (void) showPerfectSlide;
- (void) showFrenzy;
- (void) showHit;
- (void) showMissionSuccess;
-(void)showTookMagnet;
-(void)showTookEnlarge;
-(void)showTookDoublePoints;
-(void)showTookExtraTime;
-(void)showTookSpeed;
-(void)tookRegularCoin;
- (void)drawScore;
- (void) updateProgress:(ccTime)dt;
- (float) getRemainTime;
- (void) actionPause;


@end
