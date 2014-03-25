//
//  AppSetting.m
//

#import "AppSettings.h"


@implementation AppSettings

+ (void) defineUserDefaults
{
	NSString* userDefaultsValuesPath;
	NSDictionary* userDefaultsValuesDict;
	
	// load the default values for the user defaults
	userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"option" ofType:@"plist"];
	userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile: userDefaultsValuesPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults: userDefaultsValuesDict];
}

+ (void) setBackgroundMute: (BOOL) bMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[NSNumber numberWithBool: bMute];	
	[defaults setObject:aVolume forKey:@"music"];	
	[NSUserDefaults resetStandardUserDefaults];	
}

+ (BOOL) backgroundMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults boolForKey:@"music"];
	
}

+ (void) setEffectMute: (BOOL) bMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[NSNumber numberWithBool: bMute];	
	[defaults setObject:aVolume forKey:@"effect"];	
	[NSUserDefaults resetStandardUserDefaults];	
}

+ (BOOL) effectMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults boolForKey:@"effect"];
	
}

+ (void) setStageFlag: (int) index flag: (BOOL) flag
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aFlag  =	[NSNumber numberWithFloat: flag];	
	[defaults setObject:aFlag forKey:[NSString stringWithFormat: @"stage%d", index]];	
	[NSUserDefaults resetStandardUserDefaults];		
}

+ (BOOL) getStageFlag: (int) index
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: [NSString stringWithFormat: @"stage%d", index]];	
}

+ (void) setCharLock: (int) index lockFlag: (BOOL) lockFlag
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aFlag  =	[NSNumber numberWithFloat: lockFlag];	
	[defaults setObject:aFlag forKey:[NSString stringWithFormat: @"lockchar%d", index]];	
	[NSUserDefaults resetStandardUserDefaults];			
}

+ (BOOL) getCharLock: (int) index
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: [NSString stringWithFormat: @"lockchar%d", index]];	
	
}

+ (int) getCurrentPlayer
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey: @"currentplayer"];				
}

+ (void) setCurrentPlayer: (int) playerIndex
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: playerIndex];	
	[defaults setObject:aIndex forKey:@"currentplayer"];	
	[NSUserDefaults resetStandardUserDefaults];			
}

+ (BOOL) isEnterGame
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: @"isentergame"];											
}

+ (void) setEnterGame
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aEnterGame = [NSNumber numberWithBool:YES];	
	[defaults setObject:aEnterGame forKey: @"isentergame"];	
	[NSUserDefaults resetStandardUserDefaults];				
}

+ (void) setCurrentStage: (int) stageIndex {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: stageIndex];	
	[defaults setObject:aIndex forKey:@"currentstage"];	
	[NSUserDefaults resetStandardUserDefaults];			
}

+ (int) currentStage {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey: @"currentstage"];					
}

+ (void) setScore: (int) nStageNo nScore: (int) nScore {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: nScore];	
	[defaults setObject:aIndex forKey:[NSString stringWithFormat: @"score_stage%d", nStageNo]];	
	[NSUserDefaults resetStandardUserDefaults];				
}

+ (int) getScore: (int) nStageNo {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey: [NSString stringWithFormat: @"score_stage%d", nStageNo]];						
}

+ (void) addBoostCoin: (int) nCount {
	int nBoostCount = [self boostCoinCount];
	if (nBoostCount == UNLIMIT)
		return;
	nBoostCount += nCount;
	[self setBoostCoin: nBoostCount];
}
+ (void) subBoostCoin: (int) nCount {
	int nBoostCount = [self boostCoinCount];
	if (nBoostCount == UNLIMIT)
		return;
	nBoostCount -= nCount;
	if (nBoostCount < 0)
		nBoostCount = 0;
	[self setBoostCoin: nBoostCount];	
}
+ (void) setBoostCoin: (int) nCount {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: nCount];	
	[defaults setObject:aIndex forKey:@"myboostcoin"];	
	[NSUserDefaults resetStandardUserDefaults];					
}
+ (int) boostCoinCount {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey: @"myboostcoin"];						
}

+ (void) addSkipCoin: (int) nCount {
	int nSkipCount = [self skipCoinCount];
	if (nSkipCount == UNLIMIT) 
		return;
	nSkipCount += nCount;
	[self setSkipCoin: nSkipCount];
}
+ (void) subSkipCoin: (int) nCount {
	int nSkipCount = [self skipCoinCount];
	if (nSkipCount == UNLIMIT) 
		return;
	nSkipCount -= nCount;
	if (nSkipCount < 0)
		nSkipCount = 0;
	[self setSkipCoin: nSkipCount];	
}
+ (void) setSkipCoin: (int) nCount {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: nCount];	
	[defaults setObject:aIndex forKey:@"myskipcoin"];	
	[NSUserDefaults resetStandardUserDefaults];						
}
+ (int) skipCoinCount {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults integerForKey: @"myskipcoin"];							
}

+ (void) setPurchasedAllOpenCoin: (BOOL) bPurchased {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithBool: bPurchased];	
	[defaults setObject:aIndex forKey:@"purchasedallopencoin"];	
	[NSUserDefaults resetStandardUserDefaults];	
	
	if (bPurchased) {
		for (int i = 0; i < TOTAL_LEVELS; i ++)  {
			[self setStageFlag: i flag:NO];
		}
		for (int i = 0; i < INITIAL_LEVELS; i ++)  {
			[self setCharLock:i lockFlag: NO];
		}
        [self setBoostCoin: UNLIMIT];
	}
}
+ (BOOL) purchasedAllOpenCoin {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: @"purchasedallopencoin"];								
}



@end
