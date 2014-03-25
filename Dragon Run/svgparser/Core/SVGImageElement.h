//
//  SVGImageElement.h
//

#import <Foundation/Foundation.h>

#import "SVGElement.h"

@interface SVGImageElement : SVGElement <SVGLayeredElement>

@property (nonatomic, readonly) CGFloat x;
@property (nonatomic, readonly) CGFloat y;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

@property (nonatomic, readonly) NSString *href;

@end
