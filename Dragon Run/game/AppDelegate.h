/*
 *
 */

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "GCViewController.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import "Global.h"
#import "CMailComposeViewController.h"
#import <RevMobAds/RevMobAds.h>
#import "Nextpeer/Nextpeer.h"
enum {
	LANG_ENGLISH = 0,
	LANG_CHINESE
};
#define NOTIFICATION_GOT_BLIND_ATTACK @"gotBlindAttackInGame"

@class RootViewController;
@class AppDelegate;

@protocol FacebookEventDelegate
- (void) didFinishFacebook: (AppDelegate *) sender;
@end

@interface AppDelegate : NSObject <UIApplicationDelegate,
									GKAchievementViewControllerDelegate, 
									GKLeaderboardViewControllerDelegate, 
									FBRequestDelegate,
									FBDialogDelegate,
									FBSessionDelegate,
									UIAlertViewDelegate,
									GameCenterManagerDelegate,
									MFMailComposeViewControllerDelegate,NextpeerDelegate,NPTournamentDelegate>  {
    UIWindow			*window;
    RootViewController	*viewController;

	//GameCenter
	GameCenterManager* gameCenterManager;
	NSString* currentLeaderBoard;
	int	m_nLanguage;		

	//Facebook relation
	Facebook *facebook;
	NSString*   tempString;
								
	int nTopScore;
    int levelNo;
    BOOL flgADdisplay;  // AdMob Display Flag
    BOOL flgRMdisplay;  // RevMob Display Flag
    BOOL flgCBdisplay;  // Chartboost Display Flag
    UIActivityIndicatorView *spinner;
    UIActivityIndicatorView *activityView;
    UIImageView *activityImageView;
    UIView *loadingView;
    UILabel *loadingLabel;
}

@property (readwrite) int levelNo;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, strong)RevMobFullscreen *fullscreen;
@property (nonatomic, readwrite) BOOL flgADdisplay;         // AdMob Display Flag
@property (nonatomic, readwrite) BOOL flgRMdisplay;         // RevMob Display Flag
@property (nonatomic, readwrite) BOOL flgRMFulldisplay;     // RevMob Display Flag - Full Screen
@property (nonatomic, readwrite) BOOL flgCBdisplay;         // Chartboost Display Flag
@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) GameCenterManager* gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

@property (nonatomic, retain) Facebook *facebook;
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)displayGoogleAd:(CGFloat)adSize;
-(void)displayRevMobAd:(CGFloat)adSize;
-(void)removeGoogleAd;
-(void)removeRevMobAd;
- (void) loadFacebookParam;
- (void) UploadScoreOnFacebook:(NSString*) strMsg;
- (void) UploadTextFBProcess:(NSString*) pszMsg;
- (void) submitScoreToFacebook: (int) score;

- (void) submitScore: (int) nScore;
- (void) showLeaderboard;
- (void) showAchievements;
- (void) submitArchivement: (int) nDistance nGoldCount: (int) nGoldCount;
- (void) showEmail: (int) score;
- (void) loadDefaultLanguage;
- (void) showFullscreen;
- (void) releaseFullscreen;
- (void) showChartBoostAd;
- (void) SetRevMobRequestFlag:(BOOL)Flag;
- (BOOL) GetRevMobRequestFlag;
- (void) SetChartBoostRequestFlag:(BOOL)FLAG;
- (BOOL) GetChartBoostRequestFlag;
- (NSString*) getLocalizeString: (NSString*) fileName;
- (NSString*) getLocalizeString1: (NSString*) fileName;
- (NSString*) getLocalizeString2: (NSString*) key;
-(void) logGameOver:(int)nScore;

@end

