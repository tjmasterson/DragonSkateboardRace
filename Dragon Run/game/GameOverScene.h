//
//  PauseScene.h
//  Game
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define kTagTryButton	12313
#define kTagContinueButton	12314

@interface GameOverScene : CCLayerColor {
	BOOL _successed;
    CCLabelBMFont* _labelCaption;
	int _score;
	CCLabelBMFont* _labelSecond;
	float _fRemainTime;
	CCLabelBMFont* _labelPoint;
	BOOL _bUnLockNextLevel;
	CCLabelBMFont* _labelCompleted;
    
	NSInvocation *invocation;
#if NS_BLOCKS_AVAILABLE
	// used for menu items using a block
	void (^block_)(id sender);
#endif

}

@property (nonatomic, retain) CCLabelBMFont* labelCaption;
@property (nonatomic) BOOL successed;
@property (nonatomic, retain) CCLabelBMFont* labelSecond;
@property (nonatomic) int score;
@property (nonatomic) BOOL bAllowPlay;
@property (nonatomic, retain) CCLabelBMFont* labelPoint;
@property (nonatomic, retain) CCLabelBMFont* labelCompleted;

- (id) initWithNextUnLock: (BOOL) bUnLockNextLevel fTime: (float) fTime;
- (void) setTarget:(id) rec selector:(SEL) cb;
- (void) setTitle:(NSString*) title;
- (void) actionMainMenu: (id) sender;
@end
