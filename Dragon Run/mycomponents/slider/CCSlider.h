//
//  Slider.h
//  Trundle
//
//

#import "cocos2d.h"

@interface CCSliderThumb : CCMenuItemImage
{
	
}
@property (readwrite, assign) float value;

-(id) initWithTarget:(id)t selector:(SEL)sel;

@end

/* Internal class only */
@class CCSliderTouchLogic;

@interface CCSlider : CCLayer
{
	CCSliderTouchLogic* _touchLogic;
	CCSprite *barImage_;
}

@property (readonly) CCSliderThumb* thumb;
@property (nonatomic,retain) CCSprite *barImage;
@property (readwrite) float value;
@property (readwrite) BOOL liveDragging;

- (id) initWithTarget:(id)t selector:(SEL)sel;
+ (id) sliderWithTarget:(id)t selector:(SEL)sel;
- (void) clippingBar : (CGSize)size;
- (void) setTouchEndSelector : (SEL)sel;

- (void) setTouchEnabled : (BOOL)enable;

@end


