//
//  snowflake.mm
//  Game
//
//  Created by KCU on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "snowflake.h"
#import "ResourceManager.h"

@implementation snowflake
@synthesize snowType=_snowType;
@synthesize x = _x;
@synthesize y = _y;

- (id) init
{
	if( (self=[super init]) )
	{
		_snowType = SNOW_NONE;
	}
	
	return self;
}

- (void) draw
{
	CCSprite* sprite;
	ResourceManager *resManager = [ResourceManager sharedResourceManager];
	switch (_snowType)
	{
		case SNOW_GOLD:
			sprite = [resManager getTextureWithName: @"coin1"];
			break;
		default:
			return;
	}
	
	[sprite setPosition: ccp(_x, _y)];
	[sprite visit];
}

- (void) setY:(float) y
{
	_y = y;
    if (_snowType==SNOW_GOLD)
    {
        if (arc4random()%9==0)
        {
            _y+=250;
        }
    }
}

- (void) dealloc
{
	[super dealloc];
}

@end
