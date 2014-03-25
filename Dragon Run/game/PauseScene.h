//
//  PauseScene.h
//  Game
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GrowIconButton;
@interface PauseScene : CCLayerColor {
	NSInvocation *invocation;
    
    BOOL    isResetGame;
	GrowIconButton *_btnSound;
	GrowIconButton *_btnEffect;
}

@property (nonatomic) BOOL isResetGame;
@property (nonatomic, retain) GrowIconButton *btnSound;
@property (nonatomic, retain) GrowIconButton *btnEffect;

- (id) init;
- (void) setTarget:(id) rec selector:(SEL) cb;
@end
