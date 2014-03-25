
#import "Terrain.h"
#import "ResourceManager.h"
#import "FlakeManager.h"
#import "AppSettings.h"
@interface Terrain()
- (CCTexture2D*) generateStripesTexture;
- (CCSprite*) generateStripesSprite;
- (void) generateHillKeyPoints;
- (void) generateBorderVertices;
- (void) createBox2DBody;
- (void) resetHillVertices;
@end

@implementation Terrain

@synthesize stripes = _stripes;
@synthesize offsetX = _offsetX;
@synthesize offsetY = _offsetY;
@synthesize islandCount = _islandCount;
@synthesize endDistanceX=_endDistanceX;

+ (id) terrainWithWorld:(b2World*)w {
    return [[[self alloc] initWithWorld:w] autorelease];
}

- (id) initWithWorld:(b2World*)w {
    
    if ((self = [super init])) {
        
        world = w;

        CGSize size = [[CCDirector sharedDirector] winSize];
        screenW = size.width;
        screenH = size.height;
        
#ifndef DRAW_BOX2D_WORLD
        textureSize = 512;
        _renderTexture = [[CCRenderTexture renderTextureWithWidth:textureSize height:textureSize] retain];
        self.stripes = [self generateStripesSprite];
        
#endif
        
		[[FlakeManager sharedFlakeManager] reset];
        [self generateHillKeyPoints];
        [self generateBorderVertices];
        
        [self createBox2DBody];
        self.offsetX = 0;
		self.islandCount = 1;
		firstTime = YES;
		
		[self schedule:@selector(emitterSnowSake:) interval:0.5f];
		
		
    }
    return self;
}

- (void) dealloc {

#ifndef DRAW_BOX2D_WORLD
    
	[_renderTexture release];
    self.stripes = nil;
    
#endif

    [super dealloc];
}

- (void) draw {

#ifdef DRAW_BOX2D_WORLD
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
	glPushMatrix();
	glScalef( CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR(), 1.0f);
	world->DrawDebugData();
	glPopMatrix();
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);	

#else
	if (_offsetX  > (_endDistanceX-800)) {
		CCSprite* sprite = [[ResourceManager sharedResourceManager] getTextureWithName:@"skistation"];
		[sprite setPosition: ccp(_endDistanceX+200, 479/4+3*16)];
		[sprite visit];
	}

    //
    glBindTexture(GL_TEXTURE_2D, _stripes.texture.name);

    glDisableClientState(GL_COLOR_ARRAY);

    glColor4f(1, 1, 1, 1);
	glPushMatrix();
	glScalef( CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR(), 1.0f);

    glVertexPointer(2, GL_FLOAT, 0, hillVertices);
    glTexCoordPointer(2, GL_FLOAT, 0, hillTexCoords);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nHillVertices);

	glPopMatrix();
    glEnableClientState(GL_COLOR_ARRAY);
	
	[[FlakeManager sharedFlakeManager] draw]; //Doesn't affect performance
#endif
}

ccColor3B aryColor[] =
{
	ccc3(255, 255, 255),
	ccc3(0xbb, 0xea, 0xed),
	ccc3(0xb5, 0xb2, 0x31),
	ccc3(0xbb, 0x20, 0xa4),
	ccc3(0xb7, 0xb2, 0x21),
	ccc3(0x72, 0xe3, 0xc3),
	ccc3(0xff, 0xb2, 0x84),
	ccc3(0x9c, 0xff, 0xd6),
	ccc3(0xff, 0xa5, 0xcf),
};

static int terrainColorIndex = 0;
+ (void) setTerrainColorIndex: (int) index
{
	terrainColorIndex = index;
}
- (ccColor4F) generateColor {
//    const int minSum = 450;
//    const int minDelta = 150;
//    int r, g, b, min, max;
//    while (true) {
//        r = arc4random()%256;
//        g = arc4random()%256;
//        b = arc4random()%256;
//        min = MIN(MIN(r, g), b);
//        max = MAX(MAX(r, g), b);
//        if (max-min < minDelta) continue;
//        if (r+g+b < minSum) continue;
//        break;
//    }
    return ccc4FFromccc3B(aryColor[terrainColorIndex]);
}

- (CCTexture2D*) generateStripesTexture {

	// random number of stripes (even)
    const int minStripes = 4;
    const int maxStripes = 40; //Doesnt affect performance
    int nStripes = arc4random()%(maxStripes-minStripes)+minStripes;
    if (nStripes%2) {
        nStripes++;
    }
    
    [_renderTexture begin];
//	[_renderTexture beginWithClear:1 g:0 b:0 a:1];
    
    // layer 1: stripes

    CGPoint vertices[maxStripes*6];
    ccColor4F colors[maxStripes*6];
    int nVertices = 0;

    float x1, x2, y1, y2, dx, dy;
    ccColor4F c;
    
    if (arc4random()%2) 
	  {

        // diagonal stripes
        
        dx = (float)textureSize / (float)nStripes;
        dy = 0;

        x1 = -textureSize;
        y1 = 0;
        
        x2 = 0;
        y2 = textureSize;

        for (int i=0; i<nStripes/2; i++) {
            c = [self generateColor];
            for (int j=0; j<2; j++) {
                vertices[nVertices] = ccp(x1+j*textureSize, y1);
                colors[nVertices++] = c;
                vertices[nVertices] = ccp(x1+j*textureSize+dx, y1);
                colors[nVertices++] = c;
                vertices[nVertices] = ccp(x2+j*textureSize, y2);
                colors[nVertices++] = c;
                vertices[nVertices] = vertices[nVertices-2];
                colors[nVertices++] = c;
                vertices[nVertices] = vertices[nVertices-2];
                colors[nVertices++] = c;
                vertices[nVertices] = ccp(x2+j*textureSize+dx, y2);
                colors[nVertices++] = c;
            }
            x1 += dx;
            x2 += dx;
        }
        
    } 
	else 
	{
        
        // horizontal stripes
        
        dx = 0;
        dy = (float)textureSize / (float)nStripes;

        x1 = 0;
        y1 = 0;
        
        x2 = textureSize;
        y2 = 0;
        
        for (int i=0; i<nStripes; i++) {
            c = [self generateColor];
            vertices[nVertices] = ccp(x1, y1);
            colors[nVertices++] = c;
            vertices[nVertices] = ccp(x2, y2);
            colors[nVertices++] = c;
            vertices[nVertices] = ccp(x1, y1+dy);
            colors[nVertices++] = c;
            vertices[nVertices] = vertices[nVertices-2];
            colors[nVertices++] = c;
            vertices[nVertices] = vertices[nVertices-2];
            colors[nVertices++] = c;
            vertices[nVertices] = ccp(x2, y2+dy);
            colors[nVertices++] = c;
            y1 += dy;
            y2 += dy;
        }
        
    }
    
    CCSprite *s = [CCSprite spriteWithFile:@"noise.png"]; //Doesn't affect performance
    s.position = ccp(textureSize/2, textureSize/2);
    s.scale = (float)textureSize/(512.0f)*CC_CONTENT_SCALE_FACTOR();
    glColor4f(1, 1, 1, 1);
    [s visit];

    [_renderTexture end];

    return _renderTexture.sprite.texture;
}

- (CCSprite*) generateStripesSprite {

    CCTexture2D *texture = [self generateStripesTexture];
    CCSprite *sprite = [CCSprite spriteWithTexture:texture];
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
    [sprite.texture setTexParameters:&tp];
	
    return sprite;
}

- (void) generateHillKeyPoints {

    nHillKeyPoints = 0;
    terrainColorIndex = [AppSettings currentStage];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"level-%d.plist", terrainColorIndex]];
	NSDictionary *levelDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSArray* hillPoints = [levelDic objectForKey: @"hill"];
	
	for (int i = 0; i < [hillPoints count]; i ++) {
		NSDictionary* d = [hillPoints objectAtIndex:i];		
		CGPoint* points = (CGPoint*) [[d objectForKey:@"points"] bytes];
		NSLog(@"points = %f, %f", points[0].x, 768-points[0].y);
		hillKeyPoints[nHillKeyPoints++] = ccp(points[0].x*32, (768-points[0].y)*16);
	}
	

	//get end point
//	_endDistanceX = hillKeyPoints[nHillKeyPoints-1].x - 500;
	NSArray* endPoints = [levelDic objectForKey: @"stars"];
	for (int i = 0; i < [endPoints count]; i ++) {
		NSDictionary* d = [endPoints objectAtIndex:i];		
		_endDistanceX = ([[d objectForKey:@"x"] intValue])*32;
	}

    fromKeyPointI = 0;
    toKeyPointI = 0;
}

- (CGPoint) continentStartIslandEndPos
{
	return hillKeyPoints[kMaxHillKeyPoints-6];
}

- (CGPoint) continentFeverDivePos
{
	return hillKeyPoints[kMaxHillKeyPoints-7];
}

- (BOOL) existBetweenValley: (int) startValley endValley: (int) endValley heroPos: (CGPoint) heroPos
{
	float startX = hillKeyPoints[startValley].x;
	float endX = hillKeyPoints[endValley].x;
	
	if (heroPos.x >= startX && heroPos.x <= endX)
		return YES;
	return NO;
}

- (void) generateBorderVertices {

    nBorderVertices = 0;
    CGPoint p0, p1, pt0, pt1;
    p0 = hillKeyPoints[0];
    for (int i=0; i<nHillKeyPoints; i++) {
        p1 = hillKeyPoints[i];
        
        int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
        float dx = (p1.x - p0.x) / hSegments;
        float da = M_PI / hSegments;
        float ymid = (p0.y + p1.y) / 2;
        float ampl = (p0.y - p1.y) / 2;
        pt0 = p0;
        borderVertices[nBorderVertices++] = pt0;
        for (int j=1; j<hSegments+1; j++) {
            pt1.x = p0.x + j*dx;
            pt1.y = ymid + ampl * cosf(da*j);
            borderVertices[nBorderVertices++] = pt1;
            pt0 = pt1;
        }
        
        p0 = p1;
    }
//    NSLog(@"nBorderVertices = %d", nBorderVertices);
}

- (void) createBox2DBody {
    
    b2BodyDef bd;
    bd.position.Set(0, 0);

	if (body != NULL)
		world->DestroyBody(body); 
	
    body = world->CreateBody(&bd);	
    
    b2Vec2 b2vertices[kMaxBorderVertices];
    int nVertices = 0;
    for (int i=0; i<nBorderVertices; i++) {
        b2vertices[nVertices++].Set(borderVertices[i].x/PTM_RATIO,borderVertices[i].y/PTM_RATIO);
    }
    b2vertices[nVertices++].Set(borderVertices[nBorderVertices-1].x/PTM_RATIO,-10);
    b2vertices[nVertices++].Set(-screenW/4,-10);
    
    b2LoopShape shape;
    shape.Create(b2vertices, nVertices);
    body->CreateFixture(&shape, 0);

	[[FlakeManager sharedFlakeManager] generatesnows];
	int offsetNo = 0;
	for (int j = 0; j < MAX_snowCOUNT/10; j ++)
	{
		offsetNo = offsetNo + arc4random() % 100;
		for (int i = 0; i < 10; i ++)
		{
			[[FlakeManager sharedFlakeManager] setsnowPosition:j*10+i x: borderVertices[(offsetNo+20)*3].x y: borderVertices[(offsetNo+20)*3].y+20]; 
			offsetNo ++;
		}
	}
}

- (void) resetHillVertices {

#ifdef DRAW_BOX2D_WORLD
    return;
#endif
    
    prevFromKeyPointI = -1;
    prevToKeyPointI = -1;
    
    // key points interval for drawing
    
    float leftSideX = _offsetX-screenW/8/self.scale;
    float rightSideX = _offsetX+screenW*7/8/self.scale;
    
    while (hillKeyPoints[fromKeyPointI+1].x < leftSideX) {
        fromKeyPointI++;
        if (fromKeyPointI > nHillKeyPoints-1) {
            fromKeyPointI = nHillKeyPoints-1;
            break;
        }
    }
    while (hillKeyPoints[toKeyPointI].x < rightSideX) {
        toKeyPointI++;
        if (toKeyPointI > nHillKeyPoints-1) {
            toKeyPointI = nHillKeyPoints-1;
            break;
        }
    }
    
    if (prevFromKeyPointI != fromKeyPointI || prevToKeyPointI != toKeyPointI) {
        
//        NSLog(@"building hillVertices array for the visible area");

//        NSLog(@"leftSideX = %f", leftSideX);
//        NSLog(@"rightSideX = %f", rightSideX);
        
//        NSLog(@"fromKeyPointI = %d (x = %f)",fromKeyPointI,hillKeyPoints[fromKeyPointI].x);
//        NSLog(@"toKeyPointI = %d (x = %f)",toKeyPointI,hillKeyPoints[toKeyPointI].x);
        
        // vertices for visible area
        nHillVertices = 0;
        CGPoint p0, p1, pt0, pt1;
        p0 = hillKeyPoints[fromKeyPointI];
        for (int i=fromKeyPointI+1; i<toKeyPointI+1; i++) {
            p1 = hillKeyPoints[i];
            
            // triangle strip between p0 and p1
            int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
            int vSegments = 1;
            float dx = (p1.x - p0.x) / hSegments;
            float da = M_PI / hSegments;
            float ymid = (p0.y + p1.y) / 2;
            float ampl = (p0.y - p1.y) / 2;
            pt0 = p0;
            for (int j=1; j<hSegments+1; j++) {
                pt1.x = p0.x + j*dx;
                pt1.y = ymid + ampl * cosf(da*j);
                for (int k=0; k<vSegments+1; k++) {
                    hillVertices[nHillVertices] = ccp(pt0.x, pt0.y-(float)textureSize/vSegments*k);
                    hillTexCoords[nHillVertices] = ccp(pt0.x/(float)textureSize, (float)(k)/vSegments);
					nHillVertices = (nHillVertices + 1);
					if (nHillVertices >= kMaxHillVertices)
						nHillVertices = kMaxHillVertices - 1;

                    hillVertices[nHillVertices] = ccp(pt1.x, pt1.y-(float)textureSize/vSegments*k);
                    hillTexCoords[nHillVertices] = ccp(pt1.x/(float)textureSize, (float)(k)/vSegments);
					nHillVertices = (nHillVertices + 1);
					if (nHillVertices >= kMaxHillVertices)
						nHillVertices = kMaxHillVertices - 1;
                }
                pt0 = pt1;
            }
            
            p0 = p1;
        }
        
//        NSLog(@"nHillVertices = %d", nHillVertices);
        
        prevFromKeyPointI = fromKeyPointI;
        prevToKeyPointI = toKeyPointI;
    }
}

- (void) setOffsetX:(float)offsetX {
    if (_offsetX != offsetX || firstTime) {
        firstTime = NO;
        _offsetX = offsetX;
        self.position = ccp(screenW/8-_offsetX*self.scale, _offsetY);
        
        [self resetHillVertices];
    }
}

- (void) reset {
    self.stripes = [self generateStripesSprite];
    fromKeyPointI = 0;
    toKeyPointI = 0;
}

- (void) resetTerrain
{
	self.offsetX = 0;
	self.islandCount = 1;
	firstTime = YES;	

	world->DestroyBody(body);
	body = NULL;
	[self generateHillKeyPoints];
	[self generateBorderVertices];
//	[self reset];
	[self createBox2DBody];
}

- (void) generateNewIsland
{
	[self generateHillKeyPoints];
	[self generateBorderVertices];
	[self reset];
	[self createBox2DBody];
}

- (CGPoint) getHillKeyPoint: (int) index
{
	return hillKeyPoints[index];
}

- (void) emitterSnowSake: (ccTime) time {
	float fScale = self.scale;
	float fWidth = 480*1.0f/fScale;
	float fHeight = 320*1.0f/fScale;
	float fStartY = rand()%((int)fHeight);
	float fEndY = rand()%((int)fHeight);
	int minTime = 4;
	int animTime = minTime + rand()%minTime;
	
	CCSprite* sprite = [CCSprite spriteWithFile: @"particleMask.png"];
	[sprite setPosition:ccp(_offsetX+fWidth,fStartY)];
//	[sprite setColor: ccc3(rand()%128, rand()%128, rand()%128)];
	[self addChild: sprite];

	ccBezierConfig bezier;
	bezier.controlPoint_1 = ccp(_offsetX+fWidth*2/3, fHeight/3);
	bezier.controlPoint_2 = ccp(_offsetX+fWidth/3, fHeight/3*2);
	bezier.endPosition = ccp(_offsetX-20,fEndY);
	id moveto = [CCBezierTo actionWithDuration:animTime bezier:bezier];
	[sprite runAction:[CCSequence actions:
					 moveto,
					 [CCCallFuncND actionWithTarget:sprite selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					 nil]];	
}

@end
