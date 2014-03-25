//
//  StagePageLayer.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StagePageLayer : CCLayer {
	NSInvocation *invocation;
#if NS_BLOCKS_AVAILABLE
	// used for menu items using a block
	void (^block_)(id sender);
#endif

    int _nTag;
	BOOL _bLocked;
}

@property (nonatomic) int nTag;
@property (nonatomic) BOOL bLocked;

- (id) initWithTag: (int) nTag strTitle: (NSString*) strTitle nScore: (int) nScore bLocked: (BOOL) bLocked;
- (void) setTarget:(id) rec selector:(SEL) cb;
- (void) setUnLock;
@end
