//
//  snowflake.h
//  Game
//
//

#import "cocos2d.h"

enum SNOWTYPE
{
	SNOW_NONE = 0,
	SNOW_GOLD,
	SNOW_COUNT
};

@interface snowflake : NSObject {
	SNOWTYPE _snowType;
	float _x;
	float _y;
}

@property (nonatomic) SNOWTYPE snowType;
@property (nonatomic) float x;
@property (nonatomic) float y;

- (id) init;
- (void) draw;
- (void) setY:(float) y;
@end
