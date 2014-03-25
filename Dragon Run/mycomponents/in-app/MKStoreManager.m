

#import "MKStoreManager.h"
#import "AppSettings.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;

// all your features should be managed one and only by StoreManager
static NSString *feature0Id = @"com.avalanche.mountain1.char1";
static NSString *feature1Id = @"com.avalanche.mountain1.char2";
static NSString *feature2Id = @"com.avalanche.mountain1.char3";
static NSString *feature3Id = @"com.avalanche.mountain1.char4";
static NSString *feature4Id = @"com.avalanche.mountain1.char5";///done
static NSString *feature5Id = @"com.avalanche.mountain1.char6";
static NSString *feature6Id = @"com.avalanche.mountain1.char8";
static NSString *feature7Id = @"com.avalanche.mountain1.char9";
static NSString *feature8Id = @"com.avalanche.mountain1.char10";
static NSString *feature9Id = @"com.avalanche.mountain1.char10";

static NSString *featureBoostCoin0 = @"com.avalanche.mountain1.boostcoin0";
static NSString *featureBoostCoin1 = @"com.avalanche.mountain1.boostcoin1";
static NSString *featureBoostCoin2 = @"com.avalanche.mountain1.boostcoin2";

static NSString *featureSkipCoin0 = @"com.avalanche.mountain1.skipcoin0";
static NSString *featureSkipCoin1 = @"com.avalanche.mountain1.skipcoin1";
static NSString *featureSkipCoin2 = @"com.avalanche.mountain1.skipcoin2";
static NSString *featureAllOpenCoin = @"com.avalanche.mountain1.allopencoin";

BOOL feature0Purchased;
BOOL feature1Purchased;
BOOL feature2Purchased;
BOOL feature3Purchased;
BOOL feature4Purchased;
BOOL feature5Purchased;
BOOL feature6Purchased;
BOOL feature7Purchased;
BOOL feature8Purchased;
BOOL feature9Purchased;


BOOL featureBoostCoin0Purchased;
BOOL featureBoostCoin1Purchased;
BOOL featureBoostCoin2Purchased;

BOOL featureSkipCoin0Purchased;
BOOL featureSkipCoin1Purchased;
BOOL featureSkipCoin2Purchased;

BOOL featureAllOpenCoinPurchased;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
	
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (BOOL) feature0Purchased {	
	return feature0Purchased;
}
+ (BOOL) feature1Purchased {	
	return feature1Purchased;
}
+ (BOOL) feature2Purchased {	
	return feature2Purchased;
}
+ (BOOL) feature3Purchased {	
	return feature3Purchased;
}
+ (BOOL) feature4Purchased {	
	return feature4Purchased;
}
+ (BOOL) feature5Purchased {	
	return feature5Purchased;
}
+ (BOOL) feature6Purchased {	
	return feature6Purchased;
}
+ (BOOL) feature7Purchased {	
	return feature7Purchased;
}
+ (BOOL) feature8Purchased {	
	return feature8Purchased;
}
+ (BOOL) feature9Purchased {	
	return feature9Purchased;
}
+ (BOOL) featureAllOpenCoinPurchased {	
	return featureAllOpenCoinPurchased;
}
+ (MKStoreManager*)sharedManager
{
	NSLog(@"pass sharedManager");
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
			[_sharedStoreManager requestProductData];
			
			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

//- (void)release
//{
//    //do nothing
//}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 
								 [NSSet setWithObjects: 
                                  feature0Id, 
								  feature1Id, 
								  feature2Id,
								  feature3Id,
								  feature4Id,
								  feature5Id,
								  feature6Id,
								  feature7Id,
                                  feature8Id,
								 feature9Id,
								  featureAllOpenCoin,
								  nil]]; // add any other product here
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

- (void) buyFeature0 {
	[self buyFeature:feature0Id];
}
- (void) buyFeature1 {
	[self buyFeature:feature1Id];
}
- (void) buyFeature2 {
	[self buyFeature:feature2Id];
}
- (void) buyFeature3 {
	[self buyFeature:feature3Id];
}
- (void) buyFeature4 {
	[self buyFeature:feature4Id];
}
- (void) buyFeature5 {
	[self buyFeature:feature5Id];
}
- (void) buyFeature6 {
	[self buyFeature:feature6Id];
}
- (void) buyFeature7 {
	[self buyFeature:feature7Id];
}
- (void) buyFeature8 {
	[self buyFeature:feature8Id];
}
- (void) buyFeature9 {
	[self buyFeature:feature9Id];
}
- (void) buyFeatureBoostCoin0 {
	[self buyFeature:featureBoostCoin0];
}
- (void) buyFeatureBoostCoin1 {
	[self buyFeature:featureBoostCoin1];
}
- (void) buyFeatureBoostCoin2 {
	[self buyFeature:featureBoostCoin2];
}
- (void) buyFeatureSkipCoin0 {
	[self buyFeature:featureSkipCoin0];
}
- (void) buyFeatureSkipCoin1 {
	[self buyFeature:featureSkipCoin1];
}
- (void) buyFeatureSkipCoin2 {
	[self buyFeature:featureSkipCoin2];
}
- (void) buyFeatureAllOpenCoin {
	[self buyFeature:featureAllOpenCoin];	
}
- (void) buyFeature:(NSString*) featureId
{
//	[self setLockKey: featureId];
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AvalancheMountain" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void) setLockKey: (NSString*) productIdentifier
{
	if([productIdentifier isEqualToString:feature0Id])
		[AppSettings setCharLock:1 lockFlag:NO];
	if([productIdentifier isEqualToString:feature1Id])
		[AppSettings setCharLock:2 lockFlag:NO];
	if([productIdentifier isEqualToString:feature2Id])
		[AppSettings setCharLock:3 lockFlag:NO];
	if([productIdentifier isEqualToString:feature3Id])
		[AppSettings setCharLock:4 lockFlag:NO];
	if([productIdentifier isEqualToString:feature4Id])
		[AppSettings setCharLock:5 lockFlag:NO];
	if([productIdentifier isEqualToString:feature5Id])
		[AppSettings setCharLock:6 lockFlag:NO];
	if([productIdentifier isEqualToString:feature6Id])
		[AppSettings setCharLock:7 lockFlag:NO];
	if([productIdentifier isEqualToString:feature7Id])
		[AppSettings setCharLock:8 lockFlag:NO];
	if([productIdentifier isEqualToString:feature8Id])
		[AppSettings setCharLock:9 lockFlag:NO];
	if([productIdentifier isEqualToString:feature9Id])
		[AppSettings setCharLock:10 lockFlag:NO];
	
	if([productIdentifier isEqualToString:featureBoostCoin0])
		[AppSettings addBoostCoin:5];
	if([productIdentifier isEqualToString:featureBoostCoin1])
		[AppSettings addBoostCoin:15];
	if([productIdentifier isEqualToString:featureBoostCoin2])
		[AppSettings setBoostCoin: UNLIMIT];

	if([productIdentifier isEqualToString:featureSkipCoin0])
		[AppSettings addSkipCoin:3];
	if([productIdentifier isEqualToString:featureSkipCoin1])
		[AppSettings addSkipCoin:8];
	if([productIdentifier isEqualToString:featureSkipCoin2])
		[AppSettings setSkipCoin: UNLIMIT];

	if([productIdentifier isEqualToString:featureAllOpenCoin])
		[AppSettings setPurchasedAllOpenCoin: YES];
}

-(void) provideContent: (NSString*) productIdentifier
{
	if([productIdentifier isEqualToString:feature0Id])
		feature0Purchased = YES;
	if([productIdentifier isEqualToString:feature1Id])
		feature1Purchased = YES;
	if([productIdentifier isEqualToString:feature2Id])
		feature2Purchased = YES;
	if([productIdentifier isEqualToString:feature3Id])
		feature3Purchased = YES;
	if([productIdentifier isEqualToString:feature4Id])
		feature4Purchased = YES;
	if([productIdentifier isEqualToString:feature5Id])
		feature5Purchased = YES;
	if([productIdentifier isEqualToString:feature6Id])
		feature6Purchased = YES;
	if([productIdentifier isEqualToString:feature7Id])
		feature7Purchased = YES;
	if([productIdentifier isEqualToString:feature8Id])
		feature8Purchased = YES;
	if([productIdentifier isEqualToString:feature9Id])
		feature9Purchased = YES;
    
    if([productIdentifier isEqualToString:featureBoostCoin0])
		featureBoostCoin0Purchased = YES;
	if([productIdentifier isEqualToString:featureBoostCoin1])
		featureBoostCoin1Purchased = YES;
	if([productIdentifier isEqualToString:featureBoostCoin2])
		featureBoostCoin2Purchased = YES;
    
	if([productIdentifier isEqualToString:featureSkipCoin0])
		featureSkipCoin0Purchased = YES;
	if([productIdentifier isEqualToString:featureSkipCoin1])
		featureSkipCoin1Purchased = YES;
	if([productIdentifier isEqualToString:featureSkipCoin2])
		featureSkipCoin2Purchased = YES;
    
	if([productIdentifier isEqualToString:featureAllOpenCoin])
		featureAllOpenCoinPurchased = YES;
	
	[MKStoreManager updatePurchases];
}


+(void) loadPurchases 
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	feature0Purchased = [userDefaults boolForKey:feature0Id]; 
	feature1Purchased = [userDefaults boolForKey:feature1Id]; 	
	feature2Purchased = [userDefaults boolForKey:feature2Id]; 	
	feature3Purchased = [userDefaults boolForKey:feature3Id]; 	
	feature4Purchased = [userDefaults boolForKey:feature4Id]; 	
	feature5Purchased = [userDefaults boolForKey:feature5Id]; 	
	feature6Purchased = [userDefaults boolForKey:feature6Id]; 	
	feature7Purchased = [userDefaults boolForKey:feature7Id]; 	
	feature8Purchased = [userDefaults boolForKey:feature8Id]; 	
	feature9Purchased = [userDefaults boolForKey:feature9Id]; 	
	featureAllOpenCoinPurchased = [userDefaults boolForKey:featureAllOpenCoin]; 	
}


+(void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:feature0Purchased forKey:feature0Id];
	[userDefaults setBool:feature1Purchased forKey:feature1Id]; 
	[userDefaults setBool:feature2Purchased forKey:feature2Id];
	[userDefaults setBool:feature3Purchased forKey:feature3Id];
	[userDefaults setBool:feature4Purchased forKey:feature4Id];
	[userDefaults setBool:feature5Purchased forKey:feature5Id];
	[userDefaults setBool:feature6Purchased forKey:feature6Id];
	[userDefaults setBool:feature7Purchased forKey:feature7Id];
	[userDefaults setBool:feature8Purchased forKey:feature8Id];
	[userDefaults setBool:feature9Purchased forKey:feature9Id];
	[userDefaults setBool:featureAllOpenCoinPurchased forKey:featureAllOpenCoin];
}
-(void)restorePurchase
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    
}

@end
