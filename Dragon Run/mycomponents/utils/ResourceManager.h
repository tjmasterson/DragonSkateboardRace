//
//  ResourceManager.h
//  glideGame
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#ifndef RESOURCEMANAGER_H
#define RESOURCEMANAGER_H

enum TEXTURE_ID
{
	kSclouds,
	TEXTURE_COUNT
};

@interface ResourceManager : NSObject {
	CCSprite* textures[TEXTURE_COUNT];
	
	CCLabelBMFont* shadowFont;
}

@property (nonatomic, retain) CCLabelBMFont* shadowFont;

+ (ResourceManager*) sharedResourceManager;
+ (void) releaseResourceManager;

- (id) init;
- (void) loadLoadingData;
- (void) loadData;

- (CCSprite*) getTextureWithId: (int) textureId;
- (CCSprite*) getTextureWithName: (NSString*) textureName;
- (NSString*) getShadowFontName;
@end

#endif
