//
//  StoreLayer.m
//
#import "TitleLayer.h"
#import "StoreLayer.h"
#import "GrowButton.h"
#import "ResourceManager.h"
#import "AppSettings.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"
#import "StageLayer.h"

@implementation StoreLayer
@synthesize btnSelect=_btnSelect;
@synthesize btnUnlock=_btnUnlock;
@synthesize btnBuy=_btnBuy;
@synthesize spriteSelected=_spriteSelected;
@synthesize spritePreview=_spritePreview;
@synthesize labelSkipCount=_labelSkipCount;
@synthesize labelSpeedCount=_labelSpeedCount;

-(void)dealloc
{
	self.btnSelect = nil;
	self.btnUnlock = nil;
	self.spriteSelected = nil;
	self.btnBuy = nil;
	self.labelSkipCount = nil;
	self.labelSpeedCount = nil;

    [super dealloc];
}

- (id) init {
    
	if ((self = [super init])) 
	{
        CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite* sprite;
        if( size.width == 568 || size.height == 568 )
            sprite = [CCSprite spriteWithFile: @"stage_back-5x.png"];
        else
            sprite = [CCSprite spriteWithFile: @"stage_back.png"];
		[sprite setPosition: ccp(size.width/2, size.height/2)];
		[self addChild: sprite];

		CCSprite* spriteStore = [CCSprite spriteWithFile: @"bg_store.png"];
        CGSize StoreSize = spriteStore.contentSize;
		[spriteStore setPosition: ccp(size.width/2, spriteStore.contentSize.height/2)];        	
        [sprite addChild: spriteStore];
        
		CCSprite* spriteTemp = [CCSprite spriteWithSpriteFrameName: @"btn_back.png"];
        CGSize BackSize = spriteTemp.contentSize;         

		GrowButton *btnClose = [GrowButton buttonWithSpriteFrame:@"btn_back.png" 
												  selectframeName: @"btn_back.png" 
														   target:self 
														selector:@selector(actionClose:)];
		[btnClose setPosition: ccp(size.width/6 ,BackSize.height/2)];
		[sprite addChild: btnClose];		


        
        
		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"tab_2.png"];
        CGSize Tab2Size = spriteTemp.contentSize;         

		GrowButton *btnTab2 = [GrowButton buttonWithSpriteFrame:@"tab_2.png" 
												selectframeName: @"tab_2.png" 
														 target:self 
													   selector:@selector(actionTab2)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnTab2 setPosition: ccp((size.width/2 - StoreSize.width/2)>Tab2Size.width*0.70 ? size.width/2 - StoreSize.width/2 : Tab2Size.width*0.70,StoreSize.height*0.70 - Tab2Size.height/2)];
        else
            [btnTab2 setPosition: ccp(60 ,255)];
        
		[spriteStore addChild: btnTab2];
		
		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"tab_0.png"];
        CGSize Tab0Size = spriteTemp.contentSize;         

		GrowButton *btnTab0 = [GrowButton buttonWithSpriteFrame:@"tab_0.png" 
												selectframeName: @"tab_0.png" 
														 target:self 
													   selector:@selector(actionTab0)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnTab0 setPosition: ccp((size.width/2 - StoreSize.width/2)>Tab0Size.width*0.70 ? size.width/2 - StoreSize.width/2 : Tab0Size.width*0.70,StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height/2)];
        else
            [btnTab0 setPosition: ccp(60,215)];
		[spriteStore addChild: btnTab0];

		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"ss_00.png"];
        CGSize PrevSize = spriteTemp.contentSize;         

		GrowButton *btnPrev = [GrowButton buttonWithSpriteFrame:@"ss_00.png" 
                                                selectframeName: @"ss_00.png" 
                                                         target:self 
                                                       selector:@selector(actionPrev:)];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnPrev setPosition: ccp(size.width/2 - StoreSize.width*0.40 + PrevSize.width/2,StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height/2)];
        else
            [btnPrev setPosition: ccp(70,330-160)];
		[spriteStore addChild: btnPrev];        
        
		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"ss_01.png"];
        CGSize NextSize = spriteTemp.contentSize;         
        
		GrowButton *btnNext = [GrowButton buttonWithSpriteFrame:@"ss_01.png" 
												selectframeName: @"ss_01.png" 
														 target:self 
													   selector:@selector(actionNext:)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnNext setPosition: ccp(size.width/2 + StoreSize.width*0.40 - NextSize.width,StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - NextSize.height/2)];
        else
            [btnNext setPosition: ccp(370, 330-160)];
        [spriteStore addChild: btnNext];		
        
        
		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"tab_1.png"];
        CGSize Tab1Size = spriteTemp.contentSize;         
        
		GrowButton *btnTab1 = [GrowButton buttonWithSpriteFrame:@"tab_1.png" 
												selectframeName: @"tab_1.png" 
														 target:self 
													   selector:@selector(actionTab1)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnTab1 setPosition: ccp((size.width/2 - StoreSize.width/2)>Tab1Size.width*0.70 ? size.width/2 - StoreSize.width/2 : Tab1Size.width*0.70,StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height)];
        else
            [btnTab1 setPosition: ccp(60,120)];
        
		[spriteStore addChild: btnTab1];

		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"tab_3.png"];
        CGSize Tab3Size = spriteTemp.contentSize;         
        
		GrowButton *btnTab3 = [GrowButton buttonWithSpriteFrame:@"tab_3.png" 
												selectframeName: @"tab_3.png" 
														 target:self 
													   selector:@selector(actionTab3)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnTab3 setPosition: ccp((size.width/2 - StoreSize.width/2)>Tab3Size.width*0.70 ? size.width/2 - StoreSize.width/2 : Tab3Size.width*0.70, StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height - Tab3Size.height)];
        else
            [btnTab3 setPosition: ccp(60,80)];
		[spriteStore addChild: btnTab3];

		self.spritePreview = [CCSprite spriteWithSpriteFrameName: @"store_dragon00.png"];
        CGSize CharSize = spriteTemp.contentSize;         
        
         if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [_spritePreview setPosition: ccp(size.width/2, size.height/2-CharSize.height/2)];
        else
            [_spritePreview setPosition: ccp( spriteStore.contentSize.width / 2.f, spriteStore.contentSize.height / 2 + 10 ) ];
        
        [spriteStore addChild: _spritePreview];
		
		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"btn_select.png"];
        CGSize BtnSelectSize = spriteTemp.contentSize;         

		GrowButton *btnSelect = [GrowButton buttonWithSpriteFrame:@"btn_select.png" 
                                                  selectframeName: @"btn_select.png" 
                                                           target:self
                                                         selector:@selector(actionSelect:)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnSelect setPosition: ccp(size.width/2,StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height - Tab3Size.height  - BtnSelectSize.height/8)];
        else
            [btnSelect setPosition: ccp(spriteStore.contentSize.width / 2.f,330-258)];
		[spriteStore addChild: btnSelect];		
		self.btnSelect = btnSelect;


		spriteTemp = [CCSprite spriteWithSpriteFrameName: @"btn_unlock.png"];
        CGSize BtnUnlockSize = spriteTemp.contentSize;         
		GrowButton *btnUnlock = [GrowButton buttonWithSpriteFrame:@"btn_unlock.png" 
												  selectframeName: @"btn_unlock.png" 
														   target:self 
														 selector:@selector(actionUnlock:)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnUnlock setPosition: ccp(size.width/2, StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height - Tab3Size.height - BtnUnlockSize.height/8)];
        else
            [btnUnlock setPosition: ccp(spriteStore.contentSize.width / 2.f,330-258)];
        
		[spriteStore addChild: btnUnlock];		
		self.btnUnlock = btnUnlock;

        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_buy.png"];
        CGSize BtnBuySize = spriteTemp.contentSize;        
		GrowButton *btnBuy = [GrowButton buttonWithSpriteFrame:@"btn_buy.png" 
												  selectframeName: @"btn_buy.png" 
														   target:self 
														 selector:@selector(actionBuy:)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnBuy setPosition: ccp(size.width/2, StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height - Tab3Size.height - BtnBuySize.height/8)];
        else
            [btnBuy setPosition: ccp(spriteStore.contentSize.width / 2.f,330-258)];
		[spriteStore addChild: btnBuy];		
		self.btnBuy = btnBuy;

        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_restore.png"];
        CGSize BtnRestoreSize = spriteTemp.contentSize;        
        GrowButton *btnrestore = [GrowButton buttonWithSpriteFrame:@"btn_restore.png" 
                                                   selectframeName: @"btn_restore.png" 
                                                            target:self 
                                                          selector:@selector(restoreClick:)];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnrestore setPosition: ccp(size.width/2 + StoreSize.width/2 - BtnRestoreSize.width*1.10,StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height - Tab3Size.height - BtnRestoreSize.height/2 + 150)];
        else
            [btnrestore setPosition: ccp(370,125)];
        
		[spriteStore addChild: btnrestore];
        
        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_play_now.png"];
        CGSize BtnPlayNowSize = spriteTemp.contentSize;
        GrowButton *btnplaynow = [GrowButton buttonWithSpriteFrame:@"btn_play_now.png"
                                                   selectframeName: @"btn_play_now.png"
                                                            target:self
                                                          selector:@selector(actionStart:)];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [btnplaynow setPosition: ccp(size.width/2 + StoreSize.width/2 - BtnPlayNowSize.width*1.10,StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height - Tab3Size.height - BtnPlayNowSize.height/2)];
        else
            [btnplaynow setPosition: ccp(370,85)];
        
		[spriteStore addChild: btnplaynow];
		
        CCSprite* spriteSelected = [CCSprite spriteWithSpriteFrameName:@"selected.png"];
        CGSize SelectedSize = spriteSelected.contentSize;        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [spriteSelected setPosition: ccp(size.width/2, StoreSize.height*0.70 - Tab2Size.height - Tab0Size.height - PrevSize.height - Tab1Size.height - Tab3Size.height - SelectedSize.height/8)];
        else
            [spriteSelected setPosition: ccp(spriteStore.contentSize.width / 2.f, 330-258)];
        
		[spriteStore addChild: spriteSelected];
		self.spriteSelected = spriteSelected;

		CCSprite* spriteI = [CCSprite spriteWithSpriteFrameName: @"icon_skip_coin.png"];
        CGSize IconSkipSize = spriteI.contentSize;        
		[spriteI setPosition: ccp(size.width/2 + StoreSize.width/5 + IconSkipSize.width/2, StoreSize.height*0.80)];
		//[spriteStore addChild: spriteI];
        
		CCLabelBMFont* labelSkipCount = [CCLabelBMFont labelWithString:@"" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
		[labelSkipCount setPosition: ccp(size.width/2 + StoreSize.width/5 + IconSkipSize.width, StoreSize.height*0.80)];
        //[spriteStore addChild: labelSkipCount];
		self.labelSkipCount = labelSkipCount;

		
		spriteI = [CCSprite spriteWithSpriteFrameName: @"icon_speed_coin.png"];
        CGSize IconSpeedSize = spriteI.contentSize;        
		[spriteI setPosition: ccp(size.width/2 + StoreSize.width/5 + IconSpeedSize.width/2, StoreSize.height*0.75)];
		[spriteStore addChild: spriteI];
		
		CCLabelBMFont* labelSpeedCount = [CCLabelBMFont labelWithString:@"" fntFile:[[ResourceManager sharedResourceManager] getShadowFontName]];
		[labelSpeedCount setPosition: ccp(size.width/2 + StoreSize.width/5 + IconSpeedSize.width-25, StoreSize.height*0.75)];
		[spriteStore addChild: labelSpeedCount];
		self.labelSpeedCount = labelSpeedCount;
		[self updateCoinLabel];
		_btnUnlock.visible = NO;
		_spriteSelected.visible = NO;
		_btnBuy.visible = NO;
		_selectedTab = 0;
		for (int i = 0; i < 4; i ++) {
			_selectedItem[i] = 0;
		}

		[self setPreviewAnimation];
		[self schedule:@selector(detectPurchaseStatus:) interval:1];
        
        
	}
//    if (![AppSettings RemoveAdMob]){
        //[(AppDelegate*)[[UIApplication sharedApplication] delegate] displayGoogleAd:270];
        //[(AppDelegate*)[[UIApplication sharedApplication] delegate] displayRevMobAd:270];

//    }

	return self;
}

- (void) updateCoinLabel {
	NSString* strSkipCount = ([AppSettings skipCoinCount] == UNLIMIT)?@"*":[NSString stringWithFormat:@"%d", [AppSettings skipCoinCount]];
	NSString* strSpeedCount = ([AppSettings boostCoinCount] == UNLIMIT)?@"*":[NSString stringWithFormat:@"%d", [AppSettings boostCoinCount]];
	[_labelSkipCount setString: strSkipCount];
	[_labelSpeedCount setString: strSpeedCount];
}

- (void) setPreviewAnimation {
	if (_selectedTab == 0) {
		_btnBuy.visible = NO;
		[_spritePreview stopAllActions];
		CCSpriteFrame* frame1, *frame2, *frame3, *frame4;	
		frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"store_dragon%d0.png", _selectedItem[0]]];
		frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"store_dragon%d1.png", _selectedItem[0]]];
		frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"store_dragon%d2.png", _selectedItem[0]]];
		frame4 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"store_dragon%d3.png", _selectedItem[0]]];
		
		CCAnimation *danceAnimation = [CCAnimation animationWithFrames:[NSArray arrayWithObjects:frame1, frame2,frame3, frame4, nil] delay:0.1f];
		
		CCAnimate *danceAction = [CCAnimate actionWithAnimation:danceAnimation];
		CCRepeatForever *repeat = [CCRepeatForever actionWithAction:danceAction];
		[_spritePreview runAction:repeat];	
		
		if ([AppSettings getCharLock: _selectedItem[0]]) {		
			_btnUnlock.visible = YES;
			_spriteSelected.visible = NO;
			_btnSelect.visible = NO;
			return;
		} else {
			_btnUnlock.visible = NO;		
		}
		
		if (_selectedItem[0] == [AppSettings getCurrentPlayer]) {
			_spriteSelected.visible = YES;
			_btnSelect.visible = NO;
		} else {
			_spriteSelected.visible = NO;
			_btnSelect.visible = YES;
		}
		return;
	} 
	
	_spriteSelected.visible = NO;
	_btnSelect.visible = NO;
	_btnBuy.visible = YES;
	[_spritePreview stopAllActions];
	if (_selectedTab == 1) {
		CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"skip_coin%d.png", _selectedItem[1]]];
		[_spritePreview setDisplayFrame:frame1];
	} else if (_selectedTab == 2) {
		CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"speed_coin%d.png", _selectedItem[2]]];
		[_spritePreview setDisplayFrame:frame1];
	} else if (_selectedTab == 3) {
		CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"allopen_coin.png"];
		[_spritePreview setDisplayFrame:frame1];		
	}
}

- (void) actionPrev: (id) sender {
	int nSelectedItem = (_selectedItem[_selectedTab] - 1);
	if (nSelectedItem < 0) {
		if (_selectedTab == 0)
			nSelectedItem = 4;
		if (_selectedTab == 1)
			nSelectedItem = 2;
		if (_selectedTab == 2)
			nSelectedItem = 2;
		if (_selectedTab == 3)
			nSelectedItem = 0;
	}
	
	_selectedItem[_selectedTab] = nSelectedItem;
	[self setPreviewAnimation];
}

- (void) actionNext: (id) sender {
	int nTotalCount = 1;
	if (_selectedTab == 0)
		nTotalCount = 5;
	if (_selectedTab == 1)
		nTotalCount = 3;
	if (_selectedTab == 2)
		nTotalCount = 3;
	if (_selectedTab == 3)
		nTotalCount = 1;
	
	_selectedItem[_selectedTab] = (_selectedItem[_selectedTab] + 1) % nTotalCount;	
	[self setPreviewAnimation];
}

- (void) actionUnlock: (id) sender {
	switch (_selectedItem[0]) {
		case 1:
			[[MKStoreManager sharedManager] buyFeature0];
			break;
		case 2:
			[[MKStoreManager sharedManager] buyFeature1];
			break;
		case 3:
			[[MKStoreManager sharedManager] buyFeature2];
			break;
		case 4:
			[[MKStoreManager sharedManager] buyFeature3];
			break;
	}

	/*switch (_selectedItem[0]) {
		case 1:
			[AppSettings setCharLock:1 lockFlag:NO];
		break;
		case 2:
			[AppSettings setCharLock:2 lockFlag:NO];
			break;
		case 3:
			[AppSettings setCharLock:3 lockFlag:NO];
			break;
		case 4:
			[AppSettings setCharLock:4 lockFlag:NO];
			break;
		case 5:
			[AppSettings setCharLock:5 lockFlag:NO];
			break;
		case 6:
			[AppSettings setCharLock:6 lockFlag:NO];
			break;
		case 7:
			[AppSettings setCharLock:7 lockFlag:NO];
			break;
		case 8:
			[AppSettings setCharLock:8 lockFlag:NO];
			break;
		case 9:
			[AppSettings setCharLock:9 lockFlag:NO];
			break;
	}*/
}

- (void) actionBuy: (id) sender {
	if (_selectedTab == 1) {
		switch (_selectedItem[1]) {
			case 0:
				[[MKStoreManager sharedManager] buyFeatureSkipCoin0];
				break;
			case 1:
				[[MKStoreManager sharedManager] buyFeatureSkipCoin1];
				break;
			case 2:
				[[MKStoreManager sharedManager] buyFeatureSkipCoin2];
				break;
		}
	} else if (_selectedTab == 2) {
		switch (_selectedItem[2]) {
			case 0:
				[[MKStoreManager sharedManager] buyFeatureBoostCoin0];
				break;
			case 1:
				[[MKStoreManager sharedManager] buyFeatureBoostCoin1];
				break;
			case 2:
				[[MKStoreManager sharedManager] buyFeatureBoostCoin2];
				break;
		}
	} else if (_selectedTab == 3) {
		[[MKStoreManager sharedManager] buyFeatureAllOpenCoin];
	}
}

- (void) actionTab0 {
	_selectedTab = 0;
	[self setPreviewAnimation];
}
- (void) actionTab1 {
	_selectedTab = 1;
	[self setPreviewAnimation];
}
- (void) actionTab2 {
	_selectedTab = 2;
	[self setPreviewAnimation];
}
- (void) actionTab3 {
	_selectedTab = 3;
	[self setPreviewAnimation];
}

- (void) detectPurchaseStatus: (ccTime) t {
	[self updateCoinLabel];
	if (_selectedTab != 0) {
		_btnSelect.visible = NO;
		_btnUnlock.visible = NO;
		_btnBuy.visible = YES;
		
		if (_selectedTab == 3) {
			if ([AppSettings purchasedAllOpenCoin]) {
				_btnBuy.visible = NO;
			}
		}
		return;
	}
	
	if (![AppSettings getCharLock:_selectedItem[0]] && [AppSettings getCurrentPlayer] != _selectedItem[0]) {
		_btnSelect.visible = YES;
		_btnUnlock.visible = NO;
	}
}

- (void) actionSelect: (id) sender {
	[AppSettings setCurrentPlayer: _selectedItem[_selectedTab]];
	[self setPreviewAnimation];
}
-(void)restoreClick:(id)sender
{
    NSLog(@"hello");
    [[MKStoreManager sharedManager] restorePurchase];
    
}
- (void) actionClose: (id) sender {
	CCScene* layer = [TitleLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInL transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];
}

- (void)actionStart:( id )sender{
    
    CCScene* layer = [StageLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];
    
}

@end
