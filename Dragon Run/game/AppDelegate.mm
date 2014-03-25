/*
 *
 */

#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "GameLayer.h"
#import "RootViewController.h"
#import "ResourceManager.h"
#import "LoadingLayer.h"
#import "MKStoreManager.h"
#import "CLeaderboardViewController.h"
#import "CAchievementViewController.h"
#import "Sky.h"
#import "Terrain.h"
#import "Database.h"
#import <RevMobAds/RevMobAds.h>
#import "Chartboost.h"
#import "Nextpeer/Nextpeer.h"
#import "NPCocosNotifications.h"
#import "StageLayer.h"
static NSString* kAppId = @"455812764541715";

@implementation AppDelegate

@synthesize window;
@synthesize gameCenterManager;
@synthesize currentLeaderBoard;
@synthesize facebook;
@synthesize flgADdisplay;
@synthesize flgRMdisplay;
@synthesize flgRMFulldisplay;
@synthesize flgCBdisplay;
@synthesize levelNo;

-(void)displayGoogleAd:(CGFloat)adSize{
    [viewController addAdMobBanner:adSize];
    flgADdisplay=YES;
}
-(void)displayRevMobAd:(CGFloat)adSize{
    [viewController addRevMobBanner:adSize];
    flgRMdisplay=YES;
}
-(void)removeGoogleAd{
    flgADdisplay=NO;
    [viewController removeAdMobBanner];
}
-(void)removeRevMobAd{
    flgRMdisplay=NO;
    [viewController removeRevMobBanner];
}
- (void) removeStartupFlicker {

    //
    // THIS CODE REMOVES THE STARTUP FLICKER
    //
    // Uncomment the following code if you Application only supports landscape mode
    //
    
    [window setRootViewController: viewController];
    
    //	CC_ENABLE_DEFAULT_GL_STATES();
    //	CCDirector *director = [CCDirector sharedDirector];
    //	CGSize size = [director winSize];
    //	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
    //	sprite.position = ccp(size.width/2, size.height/2);
    //	sprite.rotation = -90;
    //	[sprite visit];
    //	[[director openGLView] swapBuffers];
    //	CC_ENABLE_DEFAULT_GL_STATES();
	
    //#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {
    
    [self SetChartBoostRequestFlag:NO];    // Nothing Chartboost Yet

    [RevMobAds startSessionWithAppID:REVMOB_ID];

//    [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
    
    self.fullscreen = [[RevMobAds session] fullscreen];
    self.fullscreen.delegate = viewController;
    [self.fullscreen loadAd];
    flgRMFulldisplay=NO;

	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    flgADdisplay=NO;

	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	//if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
    if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
    
	
	CCDirector *director = [CCDirector sharedDirector];

	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	[director setDepthTest:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [LoadingLayer scene]];
	
	self.currentLeaderBoard = kEasyLeaderboardID;
	if ([GameCenterManager isGameCenterAvailable])
	{
		self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalUser];
	}	
	
	[self loadDefaultLanguage];
	[self loadFacebookParam];
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *sqlselectreview = [NSString stringWithFormat:@"select * from review"];               
    
    NSMutableArray *arr=[Database executeQuery:sqlselectreview];
    
    NSLog(@"asaasa=%@", arr);
    if ([arr count]==0) {
        NSString *sqlInsertreview = [NSString stringWithFormat:@"insert into review (review, never, later,count) values (0, 0, 0,1)"];               
        
        
        [Database executeScalarQuery:sqlInsertreview];
    }
    else
    {
        int i=[[[arr objectAtIndex:0] valueForKey:@"count"] intValue];
        i=i+1;
        NSString *sqlUpdate = [NSString stringWithFormat:@"update review Set count = %d where id=1", i];
        [Database executeScalarQuery:sqlUpdate];
        //        NSString *sqlInsertreview = [NSString stringWithFormat:@"insert into review (review, never, later,count) values (0, 0, 0,1)"];               
        //        
        //        
        //        BOOL flag = [Database executeScalarQuery:sqlInsertreview];
        
    }
/*
    UIImage *statusImage = [UIImage imageNamed:@"spinner1.png"];
    activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"spinner1.png"],
                                         [UIImage imageNamed:@"spinner2.png"],
                                         [UIImage imageNamed:@"spinner3.png"],
                                         [UIImage imageNamed:@"spinner4.png"],
                                         nil];
    activityImageView.animationDuration = 0.8;
    
    //Position the activity image view somewhere in
    //the middle of your current view
    CGSize size = [director winSize];
    activityImageView.frame = CGRectMake(
                                         size.width/2
                                         -statusImage.size.width/2,
                                         size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width, 
                                         statusImage.size.height);
    
    //Add your custom activity indicator to your current view
    activityImageView.hidden = TRUE;
    [viewController.view addSubview:activityImageView];
*/

    CGRect winSize = [window bounds];
    CGSize size = winSize.size;
    CGAffineTransform makeLandscape = CGAffineTransformMakeRotation(M_PI * 0.5f);
    makeLandscape = CGAffineTransformTranslate(makeLandscape, 0, 0);
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(size.width/2 - 85, size.height/2 - 85, 170, 170)];
    loadingView.transform = makeLandscape;
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(65, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.text = @"Loading...";
    [loadingView addSubview:loadingLabel];
    
    [window addSubview:loadingView];
    loadingView.hidden = TRUE;
    
	[MKStoreManager sharedManager];



NPCocosNotifications *notifications = [NPCocosNotifications sharedManager];
[[CCDirector sharedDirector] setNotificationNode:notifications];
[notifications setPosition:kNPCocosNotificationPositionTop];

//------------------------------- Nextpeer SDK ---------------------------------//
// Nextpeer: Initialize the Nextpeer SDK once the game finished his splash screen
[self initializeNextpeer];
//------------------------------------------------------------------------------//

// Register for push (Your provision profile should support it)
[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
}

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// Nextpeer: Initialize Nextpeer with your product key and the display name.
- (void)initializeNextpeer
{
//	NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
//                              
//                              // This game has no retina support - therefore we have to let the platform know
//                              [NSNumber numberWithBool:TRUE], NextpeerSettingGameSupportsRetina,
//                              // Support orientation change for the dashboard notifications
//                              [NSNumber numberWithBool:FALSE], NextpeerSettingSupportsDashboardRotation,
//                              // Support orientation change for the in game notifications
//                              [NSNumber numberWithBool:TRUE], NextpeerSettingObserveNotificationOrientationChange,
//                              //  Place the in game notifications on the bottom screen (so the current score will be visible)
//							  [NSNumber numberWithInt:NPNotificationPosition_BOTTOM], NextpeerSettingNotificationPosition,
//							  nil];
	
	[Nextpeer initializeWithProductKey:@"2230a1221a7e5fe1e8872167b0149bc4"
                          andDelegates:[NPDelegatesContainer containerWithNextpeerDelegate:self]];
    
    
    
	//[Nextpeer initializeWithProductKey:@"c3c99e05c92a6212555d5c186b52b0718a3a70f8" andSettings:settings andDelegates:
     //[NPDelegatesContainer containerWithNextpeerDelegate:self notificationDelegate:[NPCocosNotifications sharedManager] tournamentDelegate:self]];
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Avalanche.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) 
        return;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Avalanche.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) 
    {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [Nextpeer registerDeviceToken:deviceToken];
    // Tell Parse about the device token.
//    [PFPush storeDeviceToken:deviceToken];
    // Subscribe to the global broadcast channel.
//    [PFPush subscribeToChannelInBackground:@""];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [Nextpeer handleRemoteNotification:userInfo];

    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
    [facebook release];
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

- (void) loadDefaultLanguage 
{
	NSArray *prefLanguages = [NSLocale preferredLanguages];
	NSString *iphoneLanguage = [prefLanguages objectAtIndex:0];
	
	m_nLanguage = LANG_ENGLISH;
	if ( [iphoneLanguage compare:@"en"] == 0 ) {
		m_nLanguage = LANG_ENGLISH;
	} else if ( [iphoneLanguage compare:@"zh-Hans"] == 0 ) {
		m_nLanguage = LANG_CHINESE;
	}
}

- (NSString*) getLocalizeString: (NSString*) fileName
{
//	if (m_nLanguage == LANG_CHINESE) 
//	{
//		NSArray* array= [fileName componentsSeparatedByString: @"."];
//		if (array == nil || [array count] == 0)
//			return nil;
//	
//		return [NSString stringWithFormat: @"%@_ch.png", [array objectAtIndex: 0]];
//	}
	
	return fileName;
}

- (NSString*) getLocalizeString1: (NSString*) fileName
{
//	if (m_nLanguage == LANG_CHINESE) 
//	{
//		return [NSString stringWithFormat: @"%@_ch", fileName];
//	}
	
	return fileName;
}

- (NSString*) getLocalizeString2: (NSString*) key
{
	NSString* strLocalize;
	switch(m_nLanguage) 
	{
		case LANG_CHINESE:		
			strLocalize =  NSLocalizedStringFromTable(key, @"Chinese",  @"");		
			break;
		default:		
			strLocalize =  NSLocalizedStringFromTable(key, @"English",  @"");		
			break;
	}
	
	return strLocalize;	
}

#pragma mark GameCenter View Controllers
- (void) showLeaderboard
{
	CLeaderboardViewController *leaderboardController = [[CLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) {
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[viewController presentModalViewController: leaderboardController animated: YES];
		[leaderboardController release];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *) gkViewController{
	[gkViewController dismissModalViewControllerAnimated: YES];
}

- (void) showAchievements{
	CAchievementViewController *achievements = [[CAchievementViewController alloc] init];
	if (achievements != NULL){
		achievements.achievementDelegate = self;
		[viewController presentModalViewController: achievements animated: YES];
	}
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)gkViewController;{
	[gkViewController dismissModalViewControllerAnimated: YES];
}


- (IBAction) resetAchievements: (id) sender{
	[gameCenterManager resetAchievements];
}

- (void) submitScore: (int) nScore 
{
	if(nScore > 0)
	{
		[self.gameCenterManager reportScore: nScore forCategory: self.currentLeaderBoard];
	}
}

-(void) logGameOver:(int)nScore
{
}

- (void) submitArchivement: (int) nDistance nGoldCount: (int) nGoldCount
{
}

#pragma mark Facebook

- (void) loadFacebookParam
{
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }	
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void) UploadScoreOnFacebook:(NSString*) strMsg
{
    if (![facebook isSessionValid]) {
        NSArray *checkinPermissions = [[NSArray alloc] initWithObjects:@"publish_stream", @"read_stream", nil];
        [facebook authorize:checkinPermissions];
        tempString = [strMsg retain];
    }
    else
    {
        [self UploadTextFBProcess:strMsg];
    }
}

- (void) submitScoreToFacebook: (int) score {
	nTopScore = score;
	[self UploadScoreOnFacebook: [NSString stringWithFormat: @"My score is %d", score]];
}


- (void) UploadTextFBProcess:(NSString*) pszMsg
{
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"post", @"type",
                                   @"Hey, I just played Dragon Skate Board Race and i love it!", @"name",
                                   @"Dragon Skate Board Race", @"caption",
                                   pszMsg, @"description",
                                   @"https://itunes.apple.com/us/app/dragon-skate-board-race/id840113894?ls=1&mt=8", @"link",
                                   nil];
	
    [facebook requestWithGraphPath:@"me/feed"
						 andParams:params
					 andHttpMethod:@"POST"
					   andDelegate:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Posting success!" message:nil 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 0;
	[alert show];
	[alert release];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"error %@", error.description);
    
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"request error!" message:error.description 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 2;
	[alert show];
	[alert release];
}


- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self UploadTextFBProcess:tempString];
    [tempString release];
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
}

- (void) showEmail: (int) score
{
	CMailComposeViewController *picker = [[CMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Check out Dragon Skate Board Race on your iphone."];
	
	// Fill out the email body text
	[picker setMessageBody:[NSString stringWithFormat: @"<html><body>check out Dragon Skate Board Race on your iphone. it is a great game!</body></html>", score] isHTML:YES];
	
	// CRASH HAPPENS ON THE LINE BELOW //
	[viewController  presentModalViewController:picker animated:YES];
	 [picker release];	
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
	//message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
        case MFMailComposeResultCancelled:
			NSLog (@"Result: canceled");
			break;
        case MFMailComposeResultSaved:
			NSLog (@"Result: saved");
			break;
        case MFMailComposeResultSent:
			NSLog (@"Result: sent");
			break;
        case MFMailComposeResultFailed:
			NSLog (@"Result: failed");
			break;
        default:
			NSLog (@"Result: not sent");
			break;
	}
	[controller dismissModalViewControllerAnimated:YES];
}
- (void) SetRevMobRequestFlag:(BOOL)Flag{
    flgRMFulldisplay=Flag;
    
    if (!flgRMFulldisplay){
        NSLog(@"[RevMob AvalancheMountian App] SetRevMobRequestFlag - StopLoadingWait");
        [self StopLoadingWait];
    }
}

- (BOOL) GetRevMobRequestFlag{
    return flgRMFulldisplay;
}

- (void)startSession {
    [RevMobAds startSessionWithAppID:REVMOB_ID];
}

- (void)showFullscreen {
    [spinner startAnimating];
    [self SetRevMobRequestFlag:YES];
    self.fullscreen.delegate=viewController;
    //    flgRMFulldisplay=YES;
    if (self.fullscreen)  [self.fullscreen showAd];
}

- (void)loadFullscreen {
    //    [RevMobAds loadFullscreenAd];
}


- (void)releaseFullscreen {
    if (self.fullscreen) [self.fullscreen hideAd];
    [self SetRevMobRequestFlag:NO];
    //    flgRMFulldisplay=NO;
}

- (void) SetChartBoostRequestFlag:(BOOL)Flag{
    flgCBdisplay=Flag;
    
    if (!flgCBdisplay){
        NSLog(@"[RevMob AvalancheMountian App] SetChartBoostRequestFlag - StopLoadingWait");
        [self StopLoadingWait];
    }
   
}

- (BOOL) GetChartBoostRequestFlag{
    return flgCBdisplay;
}

- (void)showChartBoostAd {
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.appId = CHARTBOOST_APPID;
    cb.appSignature = CHARTBOOST_APPSIG;
    cb.delegate = [viewController self];
    [self SetChartBoostRequestFlag:YES];
    NSLog(@"[RevMob AvalancheMountian App] showChartBoostAd - ShowLoadingWait");
    [self ShowLoadingWait];
    [cb startSession];
    [cb showInterstitial];
}

- (void)ShowLoadingWait {
    [activityView startAnimating];
    loadingView.hidden = FALSE;
}

-(void)StopLoadingWait{
    NSLog(@"[RevMob AvalancheMountian App] StopLoadingWait routine");
    loadingView.hidden = TRUE;
	[activityView stopAnimating];
}


#pragma mark NextpeercDelegate methods

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// Nextpeer: This delegate method will be called once the user is about to start a
//            tournament with the given id.
// @note: If your game supports more than one type of tournament, you should use tournamentUuid to start the right one.
-(void)nextpeerDidTournamentStartWithDetails:(NPTournamentStartDataContainer *)tournamentContainer
{
    CCScene* layer = [GameLayer node];
    ((GameLayer*)layer).mGameType = (GAMETYPE)(GAME_QUICK);
    ccColor3B color;
    color.r = 0x0;
    color.g = 0x0;
    color.b = 0x0;
    
    
    
    CCTransitionScene *ts = [CCTransitionFade transitionWithDuration:1.0f scene:layer withColor:color];
    [[CCDirector sharedDirector] replaceScene:ts];
  
    
}
//------------------------------------------------------------------------------//

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 2
// Nextpeer: This delegate method will be called once the time for the current ongoing game is up.
// You should stop the game when this method is called.
-(void)nextpeerDidTournamentEnd
{
    [[NPCocosNotifications sharedManager] clearAndDismiss];
	[[SoundManager sharedSoundManager] stopBackgroundMusic];
	CCScene* layer = [StageLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] flgRMdisplay])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeRevMobAd];
    }
	CCTransitionScene *transitionScene = [CCTransitionFade transitionWithDuration:1.0f scene:layer withColor:color];
	[[CCDirector sharedDirector] replaceScene:transitionScene];
     

    
    
}
//-(BOOL)nextpeerSupportsTournamentWithId:(NSString* )tournamentUuid
//{
//    // We supports only this type of tournament in the current version, block all others!
//    NSLog(@"Level Number : %d", levelNo);
//    if(levelNo == 0)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215159305"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 1)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215170650"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 2)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253094"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 3)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253096"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 4)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253097"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 5)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253154"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 6)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253155"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 7)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253156"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 8)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253158"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 9)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253159"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 10)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253160"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 11)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253161"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 12)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253162"]))
//        {
//            return YES;
//        }
//    }
//  
//    if(levelNo == 13)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253164"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 14)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253165"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 15)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253166"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 16)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253167"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 17)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253168"]))
//        {
//            return YES;
//        }
//    }
// 
//    if(levelNo == 18)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253169"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 19)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253170"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 20)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253171"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 21)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253172"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo ==22)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253174"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 23)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253175"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 24)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253176"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 25)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253177"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 26)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253178"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 27)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253179"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 28)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253181"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 29)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253183"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 30)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253187"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 31)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253188"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 32)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253189"]))
//        {
//            return YES;
//        }
//    }
//    if(levelNo == 33)
//    {
//        if (([tournamentUuid isEqualToString:@"NPA23903563215253190"]))
//        {
//            return YES;
//        }
//    }
////    if(levelNo == 34)
////    {
////        if (([tournamentUuid isEqualToString:@"NPA23903563215170650"]))
////        {
////            return YES;
////        }
////    }
//   
//        return NO;
//    
//}
-(void)nextpeerDidReceiveTournamentCustomMessage:(NPTournamentCustomMessageContainer*)message{
    
   // NSLog(@"test");
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOT_BLIND_ATTACK object:message.message];
}


// Local notification alert handling
-(void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [Nextpeer handleLocalNotification:notification];
}
@end
