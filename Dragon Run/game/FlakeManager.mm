//
//  FlakeManager.mm
//  Game
//
//

#import "FlakeManager.h"
#import "snowflake.h"
#import "CrashDetectUtils.h"


@implementation FlakeManager
@synthesize snowArray=_snowArray;
@synthesize snowCount=_snowCount;
@synthesize SpeedsnowCount=_SpeedsnowCount;
@synthesize BigsnowCount=_BigsnowCount;

static FlakeManager *_sharedFlakeManager = nil;

+ (FlakeManager*) sharedFlakeManager 
{
	if (!_sharedFlakeManager) 
	{
		_sharedFlakeManager = [[FlakeManager alloc] init];
	}
	
	return _sharedFlakeManager;
}

+ (void) releaseFlakeManager 
{
	if (_sharedFlakeManager) 
	{
		[_sharedFlakeManager release];
		_sharedFlakeManager = nil;
	}
}
- (id) init
{
	if ( (self=[super init]) )
	{
		_snowArray = [[NSMutableArray arrayWithCapacity: MAX_snowCOUNT] retain];
		for (int i = 0; i < MAX_snowCOUNT; i ++)
		{
			snowflake* snow = [[snowflake alloc] init];
			[_snowArray addObject: snow];
		}
		
		[self reset];
	}
	
	return self;
}

- (void) reset
{
	_snowCount = 0;
	_SpeedsnowCount = 0;
	_BigsnowCount = 0;
}

- (void) generatesnows
{
	for (int i = 0; i < MAX_snowCOUNT; i ++)
	{
		snowflake *snow = [_snowArray objectAtIndex: i];
		[snow setSnowType: SNOW_GOLD];
	}	
}

- (void) setsnowPosition: (int) index x: (float) x y: (float) y
{
	if (index < 0 || index >= MAX_snowCOUNT)
		return;
	
	snowflake *snow = [_snowArray objectAtIndex: index];
	snow.x = x;
	snow.y = y;
}

- (SNOWTYPE) canGet: (CGPoint) point
{
	for (int i = 0; i < MAX_snowCOUNT; i ++)
	{
		snowflake *snow = [_snowArray objectAtIndex: i];
		if (snow.snowType == SNOW_NONE)
			continue;
		if (CrashDetectUtils::DetectCircleAndCircle(point, 10, CGPointMake(snow.x, snow.y), 10) == CRASH_YES)
		{
			SNOWTYPE snowType = snow.snowType;
			[snow setSnowType: SNOW_NONE];
			if (snowType == SNOW_GOLD)
            {
                _snowCount ++;
                
            }
				
			return snowType;
		}
	}
	
	return SNOW_NONE;
}

-  (void) draw
{
	for (int i = 0; i < MAX_snowCOUNT; i ++)
	{
		snowflake *snow = [_snowArray objectAtIndex: i];
		[snow draw];
	}	
}

- (void) dealloc
{
	self.snowArray = nil;
	[super dealloc];
}

@end
