//
//  ZAttributedStringPrivate.h
//  FontLabel
//
//

#import <Foundation/Foundation.h>
#import "ZAttributedString.h"

@interface ZAttributeRun : NSObject <NSCopying, NSCoding> {
	NSUInteger _index;
	NSMutableDictionary *_attributes;
}
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) NSMutableDictionary *attributes;
+ (id)attributeRunWithIndex:(NSUInteger)idx attributes:(NSDictionary *)attrs;
- (id)initWithIndex:(NSUInteger)idx attributes:(NSDictionary *)attrs;
@end

@interface ZAttributedString (ZAttributedStringPrivate)
@property (nonatomic, readonly) NSArray *attributes;
@end
