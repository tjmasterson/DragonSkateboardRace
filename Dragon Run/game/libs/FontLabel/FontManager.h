//
//  FontManager.h
//  FontLabel
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class ZFont;

@interface FontManager : NSObject {
	CFMutableDictionaryRef fonts;
	NSMutableDictionary *urls;
}
+ (FontManager *)sharedManager;
/*!
    @method     
    @abstract   Loads a TTF font from the main bundle
	@param filename The name of the font file to load (with or without extension).
	@return YES if the font was loaded, NO if an error occurred
    @discussion If the font has already been loaded, this method does nothing and returns YES.
				This method first attempts to load the font by appending .ttf to the filename.
				If that file does not exist, it tries the filename exactly as given.
*/
- (BOOL)loadFont:(NSString *)filename;
/*!
	@method
	@abstract	Loads a font from the given file URL
	@param url A file URL that points to a font file
	@return YES if the font was loaded, NO if an error occurred
	@discussion If the font has already been loaded, this method does nothing and returns YES.
*/
- (BOOL)loadFontURL:(NSURL *)url;
/*!
    @method     
    @abstract   Returns the loaded font with the given filename
	@param filename The name of the font file that was given to -loadFont:
	@return A CGFontRef, or NULL if the specified font cannot be found
    @discussion If the font has not been loaded yet, -loadFont: will be
                called with the given name first.
*/
- (CGFontRef)fontWithName:(NSString *)filename __AVAILABILITY_INTERNAL_DEPRECATED;
/*!
	@method
	@abstract	Returns a ZFont object corresponding to the loaded font with the given filename and point size
	@param filename The name of the font file that was given to -loadFont:
	@param pointSize The point size of the font
	@return A ZFont, or NULL if the specified font cannot be found
	@discussion If the font has not been loaded yet, -loadFont: will be
				called with the given name first.
*/
- (ZFont *)zFontWithName:(NSString *)filename pointSize:(CGFloat)pointSize;
/*!
	@method
	@abstract	Returns a ZFont object corresponding to the loaded font with the given file URL and point size
	@param url A file URL that points to a font file
	@param pointSize The point size of the font
	@return A ZFont, or NULL if the specified font cannot be loaded
	@discussion If the font has not been loaded yet, -loadFontURL: will be called with the given URL first.
*/
- (ZFont *)zFontWithURL:(NSURL *)url pointSize:(CGFloat)pointSize;
/*!
	@method
	@abstract   Returns a CFArrayRef of all loaded CGFont objects
	@return A CFArrayRef of all loaded CGFont objects
	@description You are responsible for releasing the CFArrayRef
*/
- (CFArrayRef)copyAllFonts;
@end
