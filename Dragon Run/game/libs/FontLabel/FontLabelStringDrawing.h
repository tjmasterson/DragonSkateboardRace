//
//  FontLabelStringDrawing.h
//  FontLabel
//
//

#import <UIKit/UIKit.h>
#import "ZAttributedString.h"

@class ZFont;

@interface NSString (FontLabelStringDrawing)
// CGFontRef-based methods
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize constrainedToSize:(CGSize)size __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize constrainedToSize:(CGSize)size
		   lineBreakMode:(UILineBreakMode)lineBreakMode __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawAtPoint:(CGPoint)point withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawInRect:(CGRect)rect withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawInRect:(CGRect)rect withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize
	   lineBreakMode:(UILineBreakMode)lineBreakMode __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawInRect:(CGRect)rect withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize
	   lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment __AVAILABILITY_INTERNAL_DEPRECATED;

// ZFont-based methods
- (CGSize)sizeWithZFont:(ZFont *)font;
- (CGSize)sizeWithZFont:(ZFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithZFont:(ZFont *)font constrainedToSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)sizeWithZFont:(ZFont *)font constrainedToSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode
		  numberOfLines:(NSUInteger)numberOfLines;
- (CGSize)drawAtPoint:(CGPoint)point withZFont:(ZFont *)font;
- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withZFont:(ZFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)drawInRect:(CGRect)rect withZFont:(ZFont *)font;
- (CGSize)drawInRect:(CGRect)rect withZFont:(ZFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)drawInRect:(CGRect)rect withZFont:(ZFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode
		   alignment:(UITextAlignment)alignment;
- (CGSize)drawInRect:(CGRect)rect withZFont:(ZFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode
		   alignment:(UITextAlignment)alignment numberOfLines:(NSUInteger)numberOfLines;
@end

@interface ZAttributedString (ZAttributedStringDrawing)
- (CGSize)size;
- (CGSize)sizeConstrainedToSize:(CGSize)size;
- (CGSize)sizeConstrainedToSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)sizeConstrainedToSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode
				  numberOfLines:(NSUInteger)numberOfLines;
- (CGSize)drawAtPoint:(CGPoint)point;
- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width lineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)drawInRect:(CGRect)rect;
- (CGSize)drawInRect:(CGRect)rect withLineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)drawInRect:(CGRect)rect withLineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment;
- (CGSize)drawInRect:(CGRect)rect withLineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment
	   numberOfLines:(NSUInteger)numberOfLines;
@end
