//
//  CaveBackgroundSprite.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "CaveBackground.h"
#import "CaveBackgroundIceShard.h"
#import "RandomHelper.h"

#define ICE_SHARD_TIME_MAX			2400
#define ICE_SHARD_TIME_MIN			1400
#define ICE_SHARD_INACTIVE_Y_ZONE	160
#define ICE_SHARD_INACTIVE_Y_RESET	200

@interface CaveBackground (PrivateMethods)

- (void)createBackgrounds;
- (void)createShards;
- (void)setNextTriggerDate;
- (void)launchRandomShard;
- (void)checkIfShardShouldReset:(CaveBackgroundIceShard *)shard;
- (void)resetShard:(CaveBackgroundIceShard *)shard;

@end

@implementation CaveBackground
	
- (id)init {
	if ( (self = [super init]) ) {
		[self setPosition:CGPointMake(240, 160)];
		[self createBackgrounds];
		[self createShards];
		[self setNextTriggerDate];
	}
	return self;
}

- (void)dealloc {
	[base release];
	[backgroundIce release];
	[foregroundIce release];
	[floor release];
	[shards release];
	[super dealloc];
}

#pragma mark -
#pragma mark Setup Methods

- (void)createBackgrounds {
	base = [[CCSprite alloc] initWithFile:@"cave-background-1.png"];
	backgroundIce = [[CCSprite alloc] initWithFile:@"cave-background-2.png"];
	foregroundIce = [[CCSprite alloc] initWithFile:@"cave-background-3.png"];
	floor = [[CCSprite alloc] initWithFile:@"cave-background-4.png"];
	
	[base.texture setAliasTexParameters];
	[backgroundIce.texture setAliasTexParameters];
	[foregroundIce.texture setAliasTexParameters];
	[floor.texture setAliasTexParameters];
	
	[self addChild:base z:0];
	[self addChild:backgroundIce z:1];
	[self addChild:foregroundIce z:3];
	[self addChild:floor z:4];
}

- (void)createShards {
	
	CaveBackgroundIceShard *shard1 = [[CaveBackgroundIceShard alloc] initWithShardType:1];
	CaveBackgroundIceShard *shard2 = [[CaveBackgroundIceShard alloc] initWithShardType:2];
	CaveBackgroundIceShard *shard3 = [[CaveBackgroundIceShard alloc] initWithShardType:3];
	CaveBackgroundIceShard *shard4 = [[CaveBackgroundIceShard alloc] initWithShardType:4];
	
	shard1.position = CGPointMake(142 - 240, 0);
	shard2.position = CGPointMake(188 - 240, 0);
	shard3.position = CGPointMake(283 - 240, 0);
	shard4.position = CGPointMake(313 - 240, 0);
	
	shards = [[NSArray alloc] initWithObjects: shard1,
			  shard2,
			  shard3,
			  shard4,
			  nil];
	
	[shard1 release];
	[shard2 release];
	[shard3 release];
	[shard4 release];
	
	int count = [shards count];
	for ( int i = 0; i < count; i++ ) {
		CaveBackgroundIceShard *shard = [shards objectAtIndex:i];
		[self addChild:shard z:2];
		[self resetShard:shard];
	}
}

#pragma mark -
#pragma mark Running Update Methods

- (void)updateLoop {
	shardTimeCounter++;
	if ( shardTimeCounter >= shardTimeTrigger ) {
		int numShardsToLaunch = [RandomHelper randomIntMax:3 min:1];
		for ( int i = 0; i < numShardsToLaunch; i++ ) {
			[self launchRandomShard];
		}
		[self setNextTriggerDate];
	}
	int count = [shards count];
	for ( int i = 0; i < count; i++ ) {
		CaveBackgroundIceShard *shard = [shards objectAtIndex:i];
		if ( shard.active ) {
			shard.position = CGPointMake(shard.position.x, shard.position.y - shard.speed);
		}
		[self checkIfShardShouldReset:shard];
	}
}

#pragma mark Parallax Scrolling Methods

- (void)updateBackgroundPositionsForCameraPoint:(CGPoint)point {
	float xPercent = point.x / (480);
	int newX = 0 - (200 * xPercent) + 100;
	
	[foregroundIce setPosition:CGPointMake(newX, foregroundIce.position.y)];
	[backgroundIce setPosition:CGPointMake(newX * 0.75, backgroundIce.position.y)];
	[base setPosition:CGPointMake(newX * 0.5, base.position.y)];
}

#pragma mark Shards Methods (trigger, launch, reset)

- (void)setNextTriggerDate {
	shardTimeCounter = 0;
	shardTimeTrigger = [RandomHelper randomIntMax:ICE_SHARD_TIME_MAX min:ICE_SHARD_TIME_MIN];
}

- (void)launchRandomShard {
	int count = [shards count];
	NSMutableArray *freeShards = [[NSMutableArray alloc] init];
	for ( int i = 0; i < count; i++ ) {
		CaveBackgroundIceShard *shard = [shards objectAtIndex:i];
		if ( !shard.active ) [freeShards addObject:shard];
	}
	int freeCount = [freeShards count];
	int randPick = [RandomHelper randomIntMax:freeCount min:0];
	CaveBackgroundIceShard *randShard = [freeShards objectAtIndex:randPick];
	randShard.active = YES;
	randShard.visible = YES;
	[freeShards release];
}

- (void)checkIfShardShouldReset:(CaveBackgroundIceShard *)shard {
	if ( shard.position.y < 0 - ICE_SHARD_INACTIVE_Y_ZONE ) {
		[self resetShard:shard];
	}
}

- (void)resetShard:(CaveBackgroundIceShard *)shard {
	shard.active = NO;
	shard.visible = NO;
	shard.position = CGPointMake(shard.position.x, ICE_SHARD_INACTIVE_Y_RESET);
}

@end
