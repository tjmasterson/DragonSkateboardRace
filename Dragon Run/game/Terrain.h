
#import "cocos2d.h"
#import "Box2D.h"

//#define kMaxHillKeyPoints 101
//#define kMaxHillVertices 1000
//#define kMaxBorderVertices 5000
//#define kHillSegmentWidth 15

#define kMaxHillKeyPoints 151
#define kMaxHillVertices 1500
#define kMaxBorderVertices 6000
#define kHillSegmentWidth 15
#define kMaxCliffPoints	 5

@interface Terrain : CCNode {
    CGPoint hillKeyPoints[kMaxHillKeyPoints];
    int nHillKeyPoints;
    int fromKeyPointI;
    int toKeyPointI;
    CGPoint hillVertices[kMaxHillVertices];
    CGPoint hillTexCoords[kMaxHillVertices];
    int nHillVertices;
    CGPoint borderVertices[kMaxBorderVertices];
    int nBorderVertices;
    CCSprite *_stripes;
    float _offsetX;
    float _offsetY;
    b2World *world;
    b2Body *body;
    int screenW;
    int screenH;
    int textureSize;
	int _islandCount;
	BOOL firstTime;
	int prevFromKeyPointI;
    int prevToKeyPointI;
	CCRenderTexture* _renderTexture;
	int _endDistanceX;
}
@property (nonatomic, retain) CCSprite *stripes;
@property (nonatomic, assign) float offsetX;
@property (nonatomic, assign) float offsetY;
@property (nonatomic, assign) int islandCount;
@property (nonatomic) int endDistanceX;

+ (void) setTerrainColorIndex: (int) index;
+ (id) terrainWithWorld:(b2World*)w;
- (id) initWithWorld:(b2World*)w;
- (void) generateNewIsland;
- (void) reset;
- (void) resetTerrain;

- (CGPoint) continentStartIslandEndPos;
- (CGPoint) continentFeverDivePos;
- (BOOL) existBetweenValley: (int) startValley endValley: (int) endValley heroPos: (CGPoint) heroPos;
- (CGPoint) getHillKeyPoint: (int) index;

@end
