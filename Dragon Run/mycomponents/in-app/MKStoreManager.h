

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;	
	
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;

- (void) requestProductData;

- (void) buyFeature0; // expose product buying functions, do not expose
- (void) buyFeature1; // your product ids. This will minimize changes when you change product ids later
- (void) buyFeature2;
- (void) buyFeature3;
- (void) buyFeature4;
- (void) buyFeature5;
- (void) buyFeature6;
- (void) buyFeature7;
- (void) buyFeature8;
- (void) buyFeature9;

- (void) buyFeatureBoostCoin0;
- (void) buyFeatureBoostCoin1;
- (void) buyFeatureBoostCoin2;

- (void) buyFeatureSkipCoin0;
- (void) buyFeatureSkipCoin1;
- (void) buyFeatureSkipCoin2;

- (void) buyFeatureAllOpenCoin;

// do not call this directly. This is like a private method
- (void) buyFeature:(NSString*) featureId;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier;

+ (MKStoreManager*)sharedManager;

+ (BOOL) feature0Purchased;
+ (BOOL) feature1Purchased;
+ (BOOL) feature2Purchased;
+ (BOOL) feature3Purchased;
+ (BOOL) feature4Purchased;
+ (BOOL) feature5Purchased;
+ (BOOL) feature6Purchased;
+ (BOOL) feature7Purchased;
+ (BOOL) feature8Purchased;
+ (BOOL) feature9Purchased;
+ (BOOL) featureAllOpenCoinPurchased;

+(void) loadPurchases;
+(void) updatePurchases;
-(void)restorePurchase;
-(void) setLockKey: (NSString*) productIdentifier;

@end
