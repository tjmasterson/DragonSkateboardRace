//
//  CCNodeClipping.h
//  CCSlider
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCNodeClipping : CCNode {
	
	CGRect clippingRegionInNodeCoordinates;
	CGRect clippingRegion;
}

@property (nonatomic) CGRect clippingRegion;

@end