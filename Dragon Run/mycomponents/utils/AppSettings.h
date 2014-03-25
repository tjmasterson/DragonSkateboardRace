//
//  AppSetting.h
//
//

#import <Foundation/Foundation.h>

#define UNLIMIT	-999

@interface AppSettings : NSObject 
{

}

+ (void) defineUserDefaults;

+ (void) setBackgroundMute: (BOOL) bMute;
+ (void) setEffectMute: (BOOL) bMute;
+ (BOOL) backgroundMute;
+ (BOOL) effectMute;
+ (void) setStageFlag: (int) index flag: (BOOL) flag;
+ (BOOL) getStageFlag: (int) index;

+ (void) setCharLock: (int) index lockFlag: (BOOL) lockFlag;
+ (BOOL) getCharLock: (int) index;

+ (int) getCurrentPlayer;
+ (void) setCurrentPlayer: (int) playerIndex;

+ (BOOL) isEnterGame;
+ (void) setEnterGame;

+ (void) setCurrentStage: (int) stageIndex;
+ (int) currentStage;

+ (void) setScore: (int) nStageNo nScore: (int) nScore;
+ (int) getScore: (int) nStageNo;

+ (void) addBoostCoin: (int) nCount;
+ (void) subBoostCoin: (int) nCount;
+ (void) setBoostCoin: (int) nCount;
+ (int) boostCoinCount;

+ (void) addSkipCoin: (int) nCount;
+ (void) subSkipCoin: (int) nCount;
+ (void) setSkipCoin: (int) nCount;
+ (int) skipCoinCount;

+ (void) setPurchasedAllOpenCoin: (BOOL) bPurchased;
+ (BOOL) purchasedAllOpenCoin;
@end
