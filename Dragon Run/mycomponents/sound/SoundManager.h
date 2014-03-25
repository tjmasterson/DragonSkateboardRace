//
//  SoundManager.h
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"

enum eEffects
{
	kContratulations = 0,
    kYahoo,
	kEffectCount
};

enum eBackground
{
	kBRock = 0,
	kBackgroundCount
};

@interface SoundManager : NSObject {
	SimpleAudioEngine *soundEngine;
	CDAudioManager* audioManager;
	
	BOOL mbBackgroundMute;
	BOOL mbEffectMute;
}

+ (SoundManager*) sharedSoundManager;
+ (void) releaseSoundManager;

- (id) init;

- (void) loadData;
- (void) playEffect: (int) effectId bForce: (BOOL) bForce;
- (void) playBackgroundMusic:(int) soundId;
- (void) stopBackgroundMusic;
- (void) playRandomBackground;

- (void) setBackgroundMusicMute: (BOOL) bMute;
- (void) setEffectMute: (BOOL) bMute;

- (BOOL) getBackgroundMusicMuted;
- (BOOL) getEffectMuted;

- (void) setBackgroundVolume: (float) fVolume;
- (void) setEffectVolume: (float) fVolume;

- (float) backgroundVolume;
- (float) effectVolume;
@end
