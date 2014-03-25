//
//  ZFont.h
//  FontLabel
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZFont : NSObject {
	CGFontRef _cgFont;
	CGFloat _pointSize;
	CGFloat _ratio;
	NSString *_familyName;
	NSString *_fontName;
	NSString *_postScriptName;
}
@property (nonatomic, readonly) CGFontRef cgFont;
@property (nonatomic, readonly) CGFloat pointSize;
@property (nonatomic, readonly) CGFloat ascender;
@property (nonatomic, readonly) CGFloat descender;
@property (nonatomic, readonly) CGFloat leading;
@property (nonatomic, readonly) CGFloat xHeight;
@property (nonatomic, readonly) CGFloat capHeight;
@property (nonatomic, readonly) NSString *familyName;
@property (nonatomic, readonly) NSString *fontName;
@property (nonatomic, readonly) NSString *postScriptName;
+ (ZFont *)fontWithCGFont:(CGFontRef)cgFont size:(CGFloat)fontSize;
+ (ZFont *)fontWithUIFont:(UIFont *)uiFont;
- (id)initWithCGFont:(CGFontRef)cgFont size:(CGFloat)fontSize;
- (ZFont *)fontWithSize:(CGFloat)fontSize;
@end
