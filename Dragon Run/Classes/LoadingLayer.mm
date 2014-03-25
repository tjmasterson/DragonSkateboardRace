//
//  LoadingLayer.mm
//  Game
//
//

#import "LoadingLayer.h"
#import "TitleLayer.h"
#import "GameLayer.h"
#import "ResourceManager.h"
#import "SoundManager.h"
#import "AppSettings.h"
#import "Sky.h"
#import "Terrain.h"
#import "SVGKit.h"

@implementation LoadingLayer

+ (CCScene*) scene {
    CCScene *scene = [CCScene node];
    [scene addChild:[LoadingLayer node]];
    return scene;
}

-(void)dealloc
{
    [super dealloc];
}
- (id) init {
    
	if ((self = [super init])) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite* sprite;
        if( size.width == 568 || size.height == 568 )
            sprite = [CCSprite spriteWithFile: @"title_back-5x.png"];
        else
            sprite = [CCSprite spriteWithFile: @"title_back.png"];
		[sprite setPosition: ccp(size.width/2, size.height/2)];
		[self addChild: sprite];
        
		[self scheduleUpdate];
	}
	
	return self;
}

- (void) onExit
{
	[super onExit];
	//[self unscheduleUpdate];
}

static void saveApplier(void* info, const CGPathElement* element)
{
	NSMutableArray* a = (NSMutableArray*) info;
	
	int nPoints;
	switch (element->type)
	{
		case kCGPathElementMoveToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddLineToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddQuadCurveToPoint:
			nPoints = 2;
			break;
		case kCGPathElementAddCurveToPoint:
			nPoints = 3;
			break;
		case kCGPathElementCloseSubpath:
			nPoints = 0;
			break;
		default:
			return;
	}
	
	NSNumber* type = [NSNumber numberWithInt:element->type];
	NSData* points = [NSData dataWithBytes:element->points length:nPoints*sizeof(CGPoint)];
	[a addObject:[NSDictionary dictionaryWithObjectsAndKeys:type,@"type",points,@"points",nil]];
}

- (void) loadSVGLevel: (int) level {	
	SVGDocument *document = [SVGDocument documentNamed: [NSString stringWithFormat: @"level-%d.svg", level]];

	NSMutableArray* hillVertexArray = [NSMutableArray arrayWithCapacity:20];
	NSMutableArray* starVertexArray = [NSMutableArray arrayWithCapacity: 10];
	
	for (SVGElement *element in document.children) {
		if ([element isKindOfClass:[SVGElement class]]) {
			if ([element.identifier isEqualToString: @"layer1"] == YES) {
				for (SVGElement *element1 in element.children) {
					if ([element1 isKindOfClass:[SVGRectElement class]]) {
						SVGRectElement *starElement = (SVGRectElement*)element1;
						NSNumber* posX = [NSNumber numberWithInt:starElement.x];
						NSNumber* posY = [NSNumber numberWithInt:starElement.y];
						[starVertexArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:posX,@"x",posY,@"y",nil]];
					} else if ([element1 isKindOfClass:[SVGPathElement class]]) {
						NSLog(@"SVGPathElement %@", element1.identifier);
						SVGPathElement *hilElement = (SVGPathElement*)element1;
						// Convert path to an array
						CGPathApply(hilElement.path, hillVertexArray, saveApplier);
					}
				}				
			}
		}
	}	
	
	NSDictionary *levelDic = [NSDictionary dictionaryWithObjectsAndKeys:hillVertexArray, @"hill",starVertexArray, @"stars", nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"level-%d.plist", level]];
	
	[levelDic writeToFile:plistPath atomically: YES];
	
}
- (void) update:(ccTime)dt
{
	static long tick = 0;
	tick ++;
	
	if (tick == 1)
	{
		[AppSettings defineUserDefaults];
		[[SoundManager sharedSoundManager] setBackgroundMusicMute: [AppSettings backgroundMute]];
		[[SoundManager sharedSoundManager] setEffectMute: [AppSettings effectMute]];

		[[ResourceManager sharedResourceManager] loadLoadingData]; 
		[[ResourceManager sharedResourceManager] loadData];
        for (int i = 0; i < TOTAL_LEVELS; i ++) {
			[self loadSVGLevel: i];
		}
	}		

	if (tick == 3)
	{
		[[CCDirector sharedDirector] replaceScene:[TitleLayer node]];	
		
	}
}
@end
