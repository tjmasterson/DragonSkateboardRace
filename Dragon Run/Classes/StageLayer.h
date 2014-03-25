//
//  StoreLayer.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"

@class RoundedRectNode;
@class AppDelegate;
@interface StageLayer : CCLayer <CCScrollLayerDelegate, UIAlertViewDelegate>{
	CCLabelBMFont* _labelSkipCount;
	int _selectedStage;
    AppDelegate *app;
}
@property (nonatomic, retain) CCLabelBMFont* labelSkipCount;
@property (nonatomic, retain) NSString* calledBy;
- (void) updateForScreenReshape;
- (void) updateSkipLabel;
- (void) setRevMobAds;
@end
