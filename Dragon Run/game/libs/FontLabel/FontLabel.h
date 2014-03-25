//
//  FontLabel.h
//  FontLabel
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZFont;
@class ZAttributedString;

@interface FontLabel : UILabel {
	void *reserved; // works around a bug in UILabel
	ZFont *zFont;
	ZAttributedString *zAttributedText;
}
@property (nonatomic, setter=setCGFont:) CGFontRef cgFont __AVAILABILITY_INTERNAL_DEPRECATED;
@property (nonatomic, assign) CGFloat pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
@property (nonatomic, retain, setter=setZFont:) ZFont *zFont;
// if attributedText is nil, fall back on using the inherited UILabel properties
// if attributedText is non-nil, the font/text/textColor
// in addition, adjustsFontSizeToFitWidth does not work with attributed text
@property (nonatomic, copy) ZAttributedString *zAttributedText;
// -initWithFrame:fontName:pointSize: uses FontManager to look up the font name
- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize;
- (id)initWithFrame:(CGRect)frame zFont:(ZFont *)font;
- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
@end
