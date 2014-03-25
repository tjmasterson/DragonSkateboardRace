//
//  ResourceManager.m
//  glideGame
//
//

#import "ResourceManager.h"
#include <mach/mach.h>
#include <mach/machine.h>
@implementation ResourceManager
@synthesize shadowFont;

static ResourceManager *_sharedResource = nil;

+ (ResourceManager*) sharedResourceManager 
{
	if (!_sharedResource) 
	{
		_sharedResource = [[ResourceManager alloc] init];
	}
	
	return _sharedResource;
}

+ (void) releaseResourceManager 
{
	if (_sharedResource) 
	{
		[_sharedResource release];
		_sharedResource = nil;
	}
}

- (id) init
{
	if ( (self=[super init]) )
	{
	}
	
	return self;
}

- (void) loadLoadingData 
{
}

- (void) print_memory_size { 
	mach_port_t host_port; 
	mach_msg_type_number_t host_size; 
	vm_size_t pagesize; 
    
	host_port = mach_host_self(); 
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t); 
	host_page_size(host_port, &pagesize);         
	
	vm_statistics_data_t vm_stat; 
	
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) 
		NSLog(@"Failed to fetch vm statistics"); 
	
	/* Stats in bytes */ 
	natural_t mem_used = (vm_stat.active_count + 
						  vm_stat.inactive_count + 
						  vm_stat.wire_count) * pagesize; 
	natural_t mem_free = vm_stat.free_count * pagesize; 
	natural_t mem_total = mem_used + mem_free; 
	NSLog(@"used: %d free: %d total: %d", mem_used, mem_free, mem_total); 
} 

- (void) loadData 
{
	if ([[CCDirector sharedDirector] contentScaleFactor] == 2.0f)
	{
		shadowFont = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"shadowFont-2x.fnt"];
	}
	else
	{
		shadowFont = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"shadowFont.fnt"];
	}

	textures[kSclouds] = [[CCSprite spriteWithFile: @"clouds.png"] retain];	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_common.plist"];	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_dragon.plist"];	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_gamepack.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_store.plist"];
}


- (NSString*) getShadowFontName
{
	if ([[CCDirector sharedDirector] contentScaleFactor] == 2.0f)
		return @"shadowFont-2x.fnt";
	return @"shadowFont.fnt";
}

- (CCSprite*) getTextureWithId: (int) textureId 
{
	return textures[textureId];
}

- (CCSprite*) getTextureWithName: (NSString*) textureName
{
	return [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png", textureName]];
}

- (void) dealloc 
{
	[super dealloc];
	[shadowFont release];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	
	for (int i = 0; i < TEXTURE_COUNT; i ++)
	{
		[textures[i] release];
	}
}

@end
