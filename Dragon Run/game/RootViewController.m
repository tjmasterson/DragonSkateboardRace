/*
 */

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "RootViewController.h"
#import "GameConfig.h"
#import "CCDirector.h"
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
#import <RevMobAds/RevMobAdsDelegate.h>
#import "Chartboost.h"

@implementation RootViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
 }
 */


// Override to allow orientations other than the default portrait orientation.
-(BOOL) shouldAutorotate
{
    return YES; // you are asking your current controller what it should do
}

-(NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController
- (void)removeRevMobBanner {
    NSLog(@"calling removeRevMobadbanner");
    if (self.bannerWindow) [self.bannerWindow hideAd];
    
    //    [RevMobAds deactivateBannerAd];
}
/*
-(void)removeAdMobBanner{
    NSLog(@"calling removeadbanner");
    //NSLog(@"remove google ad");
    [gADBbannerView removeFromSuperview];
    [gADBbannerView release];
    //gADBbannerView=nil;
}*/

-(void) addRevMobBanner:(CGFloat)y{
    
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    NSLog(@"winsizeHeight=%f",winSize.height);
    NSLog(@"winsizewidth=%f",winSize.width);
    
    self.bannerWindow = [[RevMobAds session] banner];
    self.bannerWindow.delegate = self;
    [self.bannerWindow setFrame:CGRectMake(80, y, 320, 50)];
    [self.bannerWindow loadAd];
    self.bannerWindow.supportedInterfaceOrientations = @[@(UIInterfaceOrientationLandscapeRight), @(UIInterfaceOrientationLandscapeLeft)];
    [self.bannerWindow showAd];
    
    //    [RevMobAds showBannerAdWithFrame:CGRectMake(80, y, 320, 50) withDelegate:self withSpecificOrientations:UIInterfaceOrientationLandscapeRight, UIInterfaceOrientationLandscapeLeft, nil];
}
/*
-(void) addAdMobBanner:(CGFloat)y{
    //NSLog(@"adding Admob");
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    NSLog(@"winsizeHeight=%f",winSize.height);
    NSLog(@"winsizewidth=%f",winSize.width);
    // Create a view of the standard size at the bottom of the screen.
    //    gADBbannerView = [[GADBannerView alloc]
    //                      initWithFrame:CGRectMake(winSize.width-adSize.width, winSize.height-adSize.height,
    //                                               
    //                                               adSize.width,
    //                                               adSize.height)];
    
    gADBbannerView = [[GADBannerView alloc]
                      initWithFrame:CGRectMake(80, y,
                                               320,
                                               50)];
    
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    gADBbannerView.adUnitID = @"a150097ac0493ea";//@"a15009864b9d71d";//@"a14e9a6ac2c1203";a150097ac0493ea
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    gADBbannerView.rootViewController = self;
    
    [self.view addSubview:gADBbannerView];
    
    [gADBbannerView loadRequest:[GADRequest request]];
    
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  bannerView.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];
}
*/
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)revmobAdDidReceive{
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] GetRevMobRequestFlag])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetRevMobRequestFlag:NO];        
    }
}

- (void)revmobAdDisplayed{
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] GetRevMobRequestFlag])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetRevMobRequestFlag:NO];
    }
}

- (void)revmobAdDidFailWithError:(NSError *)error {
   
    NSLog(@"[RevMob AvalancheMountian App] Ad failed: %@", error);
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] GetRevMobRequestFlag])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetRevMobRequestFlag:NO];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetChartBoostRequestFlag:YES];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showChartBoostAd];
    }
    
}

- (BOOL)shouldRequestInterstitial:(NSString *)location{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetChartBoostRequestFlag:YES];
    NSLog(@"[ChartBoost AvalancheMountian App] shouldRequestInterstitial :");
    return YES;
}

- (BOOL)shouldDisplayInterstitial:(NSString *)location{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetChartBoostRequestFlag:NO];
    NSLog(@"[ChartBoost AvalancheMountian App] shouldDisplayInterstitial :");
    return YES;    
}

- (void)didCacheInterstitial:(NSString *)location{
    NSLog(@"[ChartBoost AvalancheMountian App] didCacheInterstitial :");
}

- (void)didFailToLoadInterstitial:(NSString *)location{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetChartBoostRequestFlag:NO];
    NSLog(@"[ChartBoost AvalancheMountian App] didFailToLoadInterstitial :");
}

- (void)didCloseInterstitial:(NSString *)location{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] SetChartBoostRequestFlag:NO];
    NSLog(@"[ChartBoost AvalancheMountian App] didCloseInterstitial :");
}
@end
