//
//  BackgroundManager.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResourceManager.h"

enum BACKGROUND_TYPE
{
	kBackground_Menu = 0, 
};

@class BackgroundManager;
@interface BackgroundManager : NSObject {
	ResourceManager* resManager;
}

+ (BackgroundManager*) sharedBackgroundManager;
+ (void) releaseBackgroundManager;

- (id) init;
- (void) draw;
@end
