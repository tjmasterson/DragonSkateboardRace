//
//  TitleLayer.mm
//  Game
//
//
#import "AppDelegate.h"
#import "TitleLayer.h"
#import "GameLayer.h"
#import "StageLayer.h"
#import "StageLayer.h"
#import "StoreLayer.h"
#import "BackgroundManager.h"
#import "GrowButton.h"
#import "GrowIconButton.h"
#import "Terrain.h"
#import "Sky.h"
#import "ScoreManager.h"
#import "AppSettings.h"
#import "RoundedRectNode.h"
#import "SoundManager.h"
#import "CreditLayer.h"
#import "Database.h"
@implementation TitleLayer
@synthesize optionRectNode=_optionRectNode;
@synthesize shareRectNode=_shareRectNode;
@synthesize btnSound=_btnSound;
@synthesize btnEffect=_btnEffect;


+ (CCScene*) scene {
    CCScene *scene = [CCScene node];
    [scene addChild:[TitleLayer node]];
    return scene;
}

-(void)dealloc
{
	self.btnEffect = nil;
	self.btnSound = nil;	
	self.optionRectNode = nil;
	self.shareRectNode = nil;
    [super dealloc];
}

- (id) init {
    
	if ((self = [super init])) 
	{
//        [ AppDelegate get ].m_nPrevPage =   PAGE_TITLE;

        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite* sprite;
        if( size.width == 568 || size.height == 568 )
            sprite = [CCSprite spriteWithFile: @"title_back-5x.png"];
        else
            sprite = [CCSprite spriteWithFile: @"title_back.png"];
        //		[sprite setPosition: ccp(240, 160)];
		[sprite setPosition: ccp(size.width/2, size.height/2)];
		[self addChild: sprite];
		
		CCSprite* spriteBar = [[ResourceManager sharedResourceManager] getTextureWithName: @"bar"];
		[spriteBar setPosition: ccp(size.width/2 - spriteBar.contentSize.width/2, spriteBar.contentSize.height/2)];
        spriteBar.visible = NO;
		[sprite addChild: spriteBar];
		
		GrowButton *btnPlay = [GrowButton buttonWithSpriteFrame:@"btn_play.png"
												   selectframeName: @"btn_play.png"
															   target:self 
															 selector:@selector(actionStore:)];
        CCSprite* spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_play.png"];
   		btnPlay.position =  ccp(size.width/2 - spriteBar.contentSize.width/2, spriteBar.contentSize.height - spriteTemp.contentSize.height/2 - 60);
		[sprite addChild:btnPlay];

//		GrowButton *btnStore = [GrowButton buttonWithSpriteFrame:@"btn_store.png"
//												selectframeName: @"btn_store.png"
//														 target:self 
//													   selector:@selector(actionStore:)];
//        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_store.png"];
//        
//		btnStore.position =  ccp(size.width/2 - spriteBar.contentSize.width/2, spriteBar.contentSize.height/2 - spriteTemp.contentSize.height/2);          
//
//		
//        [sprite addChild:btnStore];
		
        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"stop_icon.png"];
        CGSize StopSize = spriteTemp.contentSize;
        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"icon_setting.png"];
        CGSize IconSize = spriteTemp.contentSize;
        
		float fX = 20;
		float fRoundWidth = 50;
		self.optionRectNode = [[[RoundedRectNode alloc] initWithRectSize: CGSizeMake(IconSize.width, IconSize.height*2.1)] autorelease];
        _optionRectNode.position = ccp(IconSize.width/2, IconSize.height);
		[sprite addChild: _optionRectNode];

        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_music.png"];
        CGSize MusicSize = spriteTemp.contentSize;
		
		GrowIconButton *btnSound = [GrowIconButton buttonWithSpriteFrame:@"btn_music.png" 
														  selectframeName: @"btn_music.png" 
															iconframeName: @"stop_icon.png" 
																  posIcon: ccp(StopSize.width/2, StopSize.height/2)
																   target:self 
																 selector:@selector(actionSound:)];
		btnSound.position =  ccp(IconSize.width/2, IconSize.height*0.90);
		[_optionRectNode addChild:btnSound];
		self.btnSound = btnSound;

		GrowIconButton *btnEffect = [GrowIconButton buttonWithSpriteFrame:@"btn_sound.png" 
														 selectframeName: @"btn_sound.png" 
														   iconframeName: @"stop_icon.png" 
																 posIcon: ccp(StopSize.width/2, StopSize.height/2)
																  target:self 
																selector:@selector(actionEffect:)];
		btnEffect.position =  ccp(IconSize.width/2,IconSize.height*0.90+MusicSize.height); //100
		[_optionRectNode addChild:btnEffect];
		self.btnEffect = btnEffect;
		
		GrowIconButton *btnOnline = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png" 
														  selectframeName: @"btn_blank.png" 
															iconframeName: @"icon_setting.png" 
																  posIcon: ccp(IconSize.width/2, IconSize.height/2)
																   target:self 
																 selector:@selector(actionOptions:)];

		btnOnline.position =  ccp(IconSize.width,IconSize.height);
		[sprite addChild:btnOnline];
		
		[_optionRectNode setVisible: NO];
		[_optionRectNode setScaleY: 0.0f];
		_bShowOptionNode= NO;

        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_gamecenter.png"];
        CGSize GameCenterSize = spriteTemp.contentSize;
        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"share_icon.png"];
        CGSize ShareSize = spriteTemp.contentSize;        
        
		fX = 400;
		fRoundWidth = 50;
		self.shareRectNode = [[[RoundedRectNode alloc] initWithRectSize: CGSizeMake(ShareSize.width, ShareSize.width * 3)] autorelease];
		_shareRectNode.position = ccp(size.width - ShareSize.width * 1.5, ShareSize.height);
		[sprite addChild: _shareRectNode];
		
		GrowButton *btnLeaderboard = [GrowButton buttonWithSpriteFrame:@"btn_gamecenter.png" 
														 selectframeName: @"btn_gamecenter.png" 
																  target:self 
																selector:@selector(actionLeaderboard:)];
        btnLeaderboard.position =  ccp(ShareSize.width/2,ShareSize.height*0.90);
		[_shareRectNode addChild:btnLeaderboard];
		
        spriteTemp = [CCSprite spriteWithSpriteFrameName:@"btn_facebook.png"];
        CGSize FaceBookSize = spriteTemp.contentSize;
        
		GrowButton *btnFacebook = [GrowButton buttonWithSpriteFrame:@"btn_facebook.png" 
													   selectframeName: @"btn_facebook.png" 
																target:self 
															  selector:@selector(actionFacebook:)];
		btnFacebook.position =  ccp(ShareSize.width/2, ShareSize.height*0.95 + GameCenterSize.height);
		[_shareRectNode addChild:btnFacebook];

		GrowButton *btnCredit = [GrowButton buttonWithSpriteFrame:@"btn_info.png" 
													selectframeName: @"btn_info.png" 
															 target:self 
														   selector:@selector(actionCredit)];
		btnCredit.position =  ccp(ShareSize.width/2, ShareSize.height + GameCenterSize.height + FaceBookSize.height);
		[_shareRectNode addChild:btnCredit];
		
		GrowIconButton *btnShare = [GrowIconButton buttonWithSpriteFrame:@"btn_blank.png" 
														  selectframeName: @"btn_blank.png" 
															iconframeName: @"share_icon.png" 
																  posIcon: ccp(ShareSize.width/2, ShareSize.height/2)
																   target:self 
																 selector:@selector(actionShare:)];
		btnShare.position =  ccp(size.width - ShareSize.width, ShareSize.height);
		
        [sprite addChild:btnShare];
		
		[_shareRectNode setVisible: NO];
		[_shareRectNode setScaleY: 0.0f];
		_bShowShareNode= NO;
		
		[_btnSound setIconVisible: [AppSettings backgroundMute]];
		[_btnEffect setIconVisible: [AppSettings effectMute]];

	}
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] flgRMdisplay])
    {
//        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeGoogleAd];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeRevMobAd];
    }
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showFullscreen];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showChartBoostAd];
    
    NSString *sqlselectreview = [NSString stringWithFormat:@"select * from review"];               
    
    NSMutableArray *arr=[Database executeQuery:sqlselectreview];
    
    int i=[[[arr objectAtIndex:0] valueForKey:@"count"] intValue];
    int j=[[[arr objectAtIndex:0] valueForKey:@"later"] intValue];
    int k=[[[arr objectAtIndex:0] valueForKey:@"never"] intValue];
    int l=[[[arr objectAtIndex:0] valueForKey:@"review"] intValue];
    
    if (i>=2) {
        
        if (l>0) {
            
        }
        else if(k>0)
        {
            //            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Review Our App. We greatly appreciate your positive feedback!" delegate:self cancelButtonTitle:@"Never" otherButtonTitles:@"Ok",@"Later", nil];
            //            [alert show];
            //            [alert release];
        }
        else if(j>0)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Review Our App. We greatly appreciate your positive feedback!" delegate:self cancelButtonTitle:@"Never" otherButtonTitles:@"Ok",@"Later", nil];
            [alert show];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Review Our App. We greatly appreciate your positive feedback!" delegate:self cancelButtonTitle:@"Never" otherButtonTitles:@"Ok",@"Later", nil];
            [alert show];
            [alert release];
        }
    }

	return self;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    NSString *sqlselectreview = [NSString stringWithFormat:@"select * from review"];               
    
    NSMutableArray *arr=[Database executeQuery:sqlselectreview];
    
    if (buttonIndex ==1)
    {
        int i=[[[arr objectAtIndex:0] valueForKey:@"review"] intValue];
        i=i+1;
        NSString *sqlUpdate = [NSString stringWithFormat:@"update review Set review = %d where id=1", i];
        [Database executeScalarQuery:sqlUpdate];
        
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
        str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
        str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
                      
        // Here is the app id from itunesconnect480931262
        str = [NSString stringWithFormat:@"%@840113894", str]; 
        NSLog(@"urlll=%@",str);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
    else if (buttonIndex ==0)
    {
        NSLog(@"1");
        int i=[[[arr objectAtIndex:0] valueForKey:@"never"] intValue];
        i=i+1;
        NSString *sqlUpdate = [NSString stringWithFormat:@"update review Set never = %d where id=1", i];
        [Database executeScalarQuery:sqlUpdate];
    }
    else if (buttonIndex ==2)
    {
        NSLog(@"2");
        NSLog(@"1");
        int i=[[[arr objectAtIndex:0] valueForKey:@"later"] intValue];
        i=i+1;
        NSString *sqlUpdate = [NSString stringWithFormat:@"update review Set later = %d where id=1", i];
        [Database executeScalarQuery:sqlUpdate];
        
    }
    
}
-(void) setRevMobAds{
    
    [self schedule:@selector(StartAddPage) interval:1];
}

-(void) StartAddPage
{
    [self unschedule:@selector(StartAddPage)];
    NSLog(@"[AM - StageLayer - StartAddPage] RevMob -> showFullscreen");
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showFullscreen];
    [self schedule:@selector(EndAddPage) interval:1];
}

- (void) EndAddPage
{
    BOOL RMAd = [(AppDelegate*)[[UIApplication sharedApplication] delegate] GetRevMobRequestFlag];
    BOOL CBAd = [(AppDelegate*)[[UIApplication sharedApplication] delegate] GetChartBoostRequestFlag];
    [self unschedule:@selector(EndAddPage)];
    //    [(AppDelegate*)[[UIApplication sharedApplication] delegate] releaseFullscreen];
    
    if (RMAd==NO){
        if (CBAd == NO){
            
        }
    }
    [self schedule:@selector(EndAddPage) interval:1];
    
}

- (void) actionEndAnimation: (id) sender {
	[_optionRectNode setVisible: _bShowOptionNode];
}

- (void) actionSound: (id) sender {
	BOOL bMute = ![AppSettings backgroundMute];
	[AppSettings setBackgroundMute: bMute];
	[_btnSound setIconVisible: bMute];
	[[SoundManager sharedSoundManager] setBackgroundMusicMute: bMute];
}

- (void) actionEffect: (id) sender {
	BOOL bMute = ![AppSettings effectMute];
	[AppSettings setEffectMute: bMute];
	[_btnEffect setIconVisible: bMute];	
	[[SoundManager sharedSoundManager] setEffectMute: bMute];
}

- (void) actionOptions: (id) sender
{
	_bShowOptionNode = !_bShowOptionNode;
	if (_bShowOptionNode) {
		id aniFunc = [CCCallFunc actionWithTarget:self selector:@selector(actionEndAnimation:)];
		id scale = [CCScaleTo actionWithDuration: 0.1f scaleX:1.0f scaleY:1.0f];
		id sequence = [CCSequence actions: aniFunc, scale, nil];
		[_optionRectNode runAction:sequence];	
	} else {
		id scale = [CCScaleTo actionWithDuration: 0.1f scaleX:1.0f scaleY:0.0f];
		id aniFunc = [CCCallFunc actionWithTarget:self selector:@selector(actionEndAnimation:)];
		id sequence = [CCSequence actions: scale, aniFunc, nil];
		[_optionRectNode runAction:sequence];	
	}
}

- (void) actionShareEndAnimation: (id) sender {
	[_shareRectNode setVisible: _bShowShareNode];
}

- (void) actionShare: (id) sender
{
	_bShowShareNode = !_bShowShareNode;
	if (_bShowShareNode) {
		id aniFunc = [CCCallFunc actionWithTarget:self selector:@selector(actionShareEndAnimation:)];
		id scale = [CCScaleTo actionWithDuration: 0.1f scaleX:1.0f scaleY:1.0f];
		id sequence = [CCSequence actions: aniFunc, scale, nil];
		[_shareRectNode runAction:sequence];	
	} else {
		id scale = [CCScaleTo actionWithDuration: 0.1f scaleX:1.0f scaleY:0.0f];
		id aniFunc = [CCCallFunc actionWithTarget:self selector:@selector(actionShareEndAnimation:)];
		id sequence = [CCSequence actions: scale, aniFunc, nil];
		[_shareRectNode runAction:sequence];	
	}
}

- (void) actionPlay: (id) sender
{
    CCScene* layer = [StoreLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];

    
//	CCScene* layer = [StageLayer node];
//	ccColor3B color;
//	color.r = 0x0;
//	color.g = 0x0;
//	color.b = 0x0;
//	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
//    [(StageLayer*)layer setRevMobAds];
//	[[CCDirector sharedDirector] replaceScene:ts];
}

- (void) actionHelp: (id) sender
{
}

- (void) actionStore: (id) sender
{
	CCScene* layer = [StoreLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];	
}

- (void) actionCredit
{
	CCScene* layer = [CreditLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];		
}

- (void) actionFacebook: (id) sender
{
	[self actionShare: nil];
	AppDelegate* delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	[delegate submitScoreToFacebook: [[ScoreManager sharedScoreManager] topScoreValue]];
}

- (void) actionAchievements: (id) sender
{
	[self actionShare: nil];
	AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	[appDelegate showAchievements];	
}

- (void) actionLeaderboard: (id) sender
{
	[self actionShare: nil];
	AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	[appDelegate showLeaderboard];
}

@end
