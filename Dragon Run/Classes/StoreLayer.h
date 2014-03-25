//
//  StoreLayer.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GrowButton;
@interface StoreLayer : CCLayer {
    GrowButton* _btnSelect;
	GrowButton* _btnUnlock;
	GrowButton* _btnBuy;
	CCSprite* _spriteSelected;	
	CCSprite* _spritePreview;
	CCLabelBMFont* _labelSkipCount;
	CCLabelBMFont* _labelSpeedCount;
	int _selectedTab;
	int _selectedItem[4];
}

@property (nonatomic, retain) GrowButton* btnSelect;
@property (nonatomic, retain) GrowButton* btnUnlock;
@property (nonatomic, retain) GrowButton* btnBuy;
@property (nonatomic, retain) CCSprite* spriteSelected;
@property (nonatomic, retain) CCSprite* spritePreview;
@property (nonatomic, retain) CCLabelBMFont* labelSkipCount;
@property (nonatomic, retain) CCLabelBMFont* labelSpeedCount;

- (void) setPreviewAnimation;
- (void) updateCoinLabel;
@end
