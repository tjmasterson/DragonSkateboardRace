//
//  TitleLayer.h
//  Game
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResourceManager.h"

@class RoundedRectNode;
@class GrowIconButton;
@interface TitleLayer : CCLayer 
{
	ResourceManager* resManager;
	RoundedRectNode *_optionRectNode;
	RoundedRectNode *_shareRectNode;
	
	GrowIconButton *_btnSound;
	GrowIconButton *_btnEffect;
	
	BOOL _bShowOptionNode;	
	BOOL _bShowShareNode;
}

@property(nonatomic, retain) RoundedRectNode *optionRectNode;
@property(nonatomic, retain) RoundedRectNode *shareRectNode;
@property(nonatomic, retain) GrowIconButton *btnSound;
@property(nonatomic, retain) GrowIconButton *btnEffect;

+ (CCScene*) scene;
- (id) init;

@end
