/*
 *
 */

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>
#import "Chartboost.h"

@interface RootViewController : UIViewController <RevMobAdsDelegate, ChartboostDelegate>{
    RevMobAds *ad;
}
-(void) addRevMobBanner:(CGFloat)y;
-(void)removeRevMobBanner;
@property (nonatomic, strong)RevMobBanner *bannerWindow;
@end
