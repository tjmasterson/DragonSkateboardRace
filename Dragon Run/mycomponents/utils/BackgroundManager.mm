//
//  BackgroundManager.m
//

#import "BackgroundManager.h"
#import "DeviceSettings.h"

@implementation BackgroundManager

static BackgroundManager *_sharedBackground = nil;

+ (BackgroundManager*) sharedBackgroundManager 
{
	if (!_sharedBackground) 
	{
		_sharedBackground = [[BackgroundManager alloc] init];
	}
	
	return _sharedBackground;
}

+ (void) releaseBackgroundManager 
{
	if (_sharedBackground) 
	{
		[_sharedBackground release];
		_sharedBackground = nil;
	}
}

- (id) init
{
	if( (self=[super init] )) 
	{
		resManager = [ResourceManager sharedResourceManager];
	}
	
	return self;
}

- (void) drawMaskColor
{
    float gradientAlpha = 0.5f;
    
    glEnable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    CGPoint vertices[4];
    ccColor4F colors[4];
    int nVertices = 0;
    float textureSize = 512.0f;
    vertices[nVertices] = ccp(0, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0.5f, gradientAlpha};
    vertices[nVertices] = ccp(textureSize, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0.5f, gradientAlpha};
    
    vertices[nVertices] = ccp(0, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0.5f, gradientAlpha};
    vertices[nVertices] = ccp(textureSize, textureSize);
    colors[nVertices++] = (ccColor4F){0, 0, 0.5f, gradientAlpha};
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);	
}
- (void) draw
{	
	static long tick = 0;
	CCSprite* sprite = [resManager getTextureWithName: @"title"];
	[sprite setPosition: ccp(240, 160)];
	[sprite visit];
	
	sprite = [resManager getTextureWithId: kSclouds];
	
//	for (int i = 0; i < 4; i ++)
//	{
//		[sprite setPosition: ccp(i*256-(tick%256), 320)];
//		[sprite visit];
//	}	
//	
    [self drawMaskColor];
	tick ++;
}


- (void) dealloc
{
	[super dealloc];
}

@end

