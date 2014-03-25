//
//  CJSONSerializer.h
//

#import <Foundation/Foundation.h>

@interface CJSONSerializer : NSObject {
}

+ (id)serializer;

- (BOOL)isValidJSONObject:(id)inObject;

/// Take any JSON compatible object (generally NSNull, NSNumber, NSString, NSArray and NSDictionary) and produce an NSData containing the serialized JSON.
- (NSData *)serializeObject:(id)inObject error:(NSError **)outError;

- (NSData *)serializeNull:(NSNull *)inNull error:(NSError **)outError;
- (NSData *)serializeNumber:(NSNumber *)inNumber error:(NSError **)outError;
- (NSData *)serializeString:(NSString *)inString error:(NSError **)outError;
- (NSData *)serializeArray:(NSArray *)inArray error:(NSError **)outError;
- (NSData *)serializeDictionary:(NSDictionary *)inDictionary error:(NSError **)outError;

@end

typedef enum {
    CJSONSerializerErrorCouldNotSerializeDataType = -1,
    CJSONSerializerErrorCouldNotSerializeObject = -1
} CJSONSerializerError;
