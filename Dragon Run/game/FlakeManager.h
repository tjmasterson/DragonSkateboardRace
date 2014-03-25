//
//  FlakeManager.h
//  Game
//
//

#import "snowflake.h"
#define MAX_snowCOUNT	60

@interface FlakeManager : NSObject {
	NSMutableArray* _snowArray;
	int _snowCount;
	int _SpeedsnowCount;
	int _BigsnowCount;
}

@property (nonatomic, retain) NSMutableArray* snowArray;
@property (nonatomic) int snowCount;
@property (nonatomic) int SpeedsnowCount;
@property (nonatomic) int BigsnowCount;

+ (FlakeManager*) sharedFlakeManager;
+ (void) releaseFlakeManager;

- (id) init;
- (void) reset;
- (void) setsnowPosition: (int) index x: (float) x y: (float) y;
- (void) draw;
- (void) generatesnows;
- (SNOWTYPE) canGet: (CGPoint) point;

@end
