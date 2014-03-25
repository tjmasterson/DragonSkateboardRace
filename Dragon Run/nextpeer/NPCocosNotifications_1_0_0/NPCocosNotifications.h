/*
 * This file is subject to the terms and conditions defined in
 * file 'NP_LICENSE.txt', which is part of this source code package.
 */



/*
 NPCocosNotifications is a notifications system in OpenGl for cocos2d (from v0.99.5) which give higer performance.
 
 In order to integrate NPCocosNotifications in your game you should follow the next steps:
 1) Open (ProdectName)AppDelegate.m, in your applicationDidFinishLaunching, where you initialize the CCDirector, add the following code:
 
 NPCocosNotifications *notifications = [NPCocosNotifications sharedManager];
 [[CCDirector sharedDirector] setNotificationNode:notifications];
 [notifications setPosition:kNPCocosNotificationPositionTop]; // You can customize the notification position
 
 2) Set the NPCocosNotifications as nextpeer notification delegate (Where you call [Nextpeer initializeWithProductKey])
 
 [Nextpeer initializeWithProductKey:@"your_product_key" andDelegates:
 [NPDelegatesContainer containerWithNextpeerDelegate:self notificationDelegate:[NPCocosNotifications sharedManager]];
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Nextpeer/Nextpeer.h"

#define KNOTIFICATIONMIN_SCALE 0.0001f

@class NPNotificationContainer;

// The NPCocosNotificationsDelegate protocol can be used to get information on the current notification state changes.
// You can use this method to play sounds and to perform ui changes.
@protocol NPCocosNotificationsDelegate <NSObject>
@optional

// States as kNPCocosNotificationStateHide, kNPCocosNotificationStateAnimationOut, kNPCocosNotificationStateShowing, kNPCocosNotificationStateAnimationIn
- (void) notification:(NPNotificationContainer*)notification newState:(char)state;
@end

// The NPCocosNotificationDesignProtocol used to apply textures on the current displayed notifications
@protocol NPCocosNotificationDesignProtocol <NSObject>
- (void) setTexture:(CCTexture2D*)texture;
@end

// Node container which will display the notification view as image
@interface NPCocosNotificationDesign : CCLayerColor <NPCocosNotificationDesignProtocol>
{
	CCSprite *image_;
}

@end

// Notification states
enum
{
	kNPCocosNotificationStateHide = 0,
	kNPCocosNotificationStateAnimationOut,
	kNPCocosNotificationStateShowing,
	kNPCocosNotificationStateAnimationIn,
};

// Notification positions
enum
{
	kNPCocosNotificationPositionBottom = 0,
	kNPCocosNotificationPositionTop,
};

// Notification animations
enum
{
	kNPCocosNotificationAnimationMovement = 0,
	kNPCocosNotificationAnimationScale,
};

@interface NPCocosNotifications : NSObject <CCStandardTouchDelegate, NPNotificationDelegate>
{
	id <NPCocosNotificationsDelegate>			delegate_;
	CCNode <NPCocosNotificationDesignProtocol>	*template_;
	char									state_;
	char									position_;
	ccTime									showingTime_;
	ccTime									timeAnimationIn_;
	ccTime									timeAnimationOut_;
	char									typeAnimationIn_;
	char									typeAnimationOut_;
	
	CCArray									*cachedNotifications_;
	NPNotificationContainer					*currentNotification_;
	
	CCActionInterval						*animationIn_;
	CCActionInterval						*animationOut_;
}

@property(nonatomic, retain) id <NPCocosNotificationsDelegate> delegate;
@property(nonatomic, retain) CCNode <NPCocosNotificationDesignProtocol> *notificationDesign;
@property(nonatomic, retain) CCActionInterval *animationIn;
@property(nonatomic, retain) CCActionInterval *animationOut;
@property(nonatomic, retain) NPNotificationContainer *currentNotification;
@property(nonatomic, readwrite, assign) char position;
@property(nonatomic, readwrite, assign) ccTime showingTime;

// Get the shared notification managar
+ (NPCocosNotifications *) sharedManager;

+ (void) purgeSharedManager;

// Will clear the cached notifications and dismiss without animation the current notification
- (void) clearAndDismiss;

// Will be called in case your CCDirector doesn't support notification node.
- (void) visit;
@end

