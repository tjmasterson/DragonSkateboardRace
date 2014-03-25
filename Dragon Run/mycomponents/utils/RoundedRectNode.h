/*
 *  RoundedRectNode.h
 *
 *
 */


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RoundedRectNode : CCNode {
    CGSize size;
    float radius;
    
    ccColor4B borderColor;
    ccColor4B fillColor;
    float lineWidth;
    
    NSUInteger cornerSegments;
}

-(id) initWithRectSize:(CGSize)sz;

@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) float radius;
@property (nonatomic,assign) ccColor4B borderColor;
@property (nonatomic,assign) ccColor4B fillColor;
@property (nonatomic,assign) float borderWidth;
@property (nonatomic,assign) NSUInteger cornerSegments;

@end