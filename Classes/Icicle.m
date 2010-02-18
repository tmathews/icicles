//
//  Icicle.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "Icicle.h"
#import "AnimatorController.h"
#import "SimpleAudioEngine.h"
#import "GlobalSettings.h"

@interface Icicle (PrivateMethods)

- (void)setTriangleTopDownPointsForRect:(CGRect)rect;

@end

@implementation Icicle

@synthesize type, broken, isBreaking, active, speed, velocity;

- (id)initIcicleType:(int)aType {
	if ( (self = [super init]) ) {
		type = aType;
		NSString *filename = [NSString stringWithFormat:@"icicle-%i.png", type];
		
		ice = [[CCSprite alloc] initWithFile:filename];
		[ice.texture setAliasTexParameters];
		[self addChild:ice];
		active = NO;
		speed = 2.0;
		velocity = 0.0;
		broken = NO;
		[self setTriangleTopDownPointsForRect:[ice textureRect]];
		
		breaking = [[CCSprite alloc] initWithFile:@"icicle-shatter.png" rect:CGRectMake(0, 0, 64, 32)];
		[breaking.texture setAliasTexParameters];
		[breaking setPosition:CGPointMake(tipPoint.x + 6, tipPoint.y + 32)];
		[self addChild:breaking];
		
		animator = [[AnimatorController alloc] initWithImageHeight:1024 frameSize:CGSizeMake(64, 32)];
	}
	return self;
}

- (void)dealloc {
	[breaking release];
	[animator release];
	[super dealloc];
}

#pragma mark -

- (void)updateLoop {
	if ( [animator getCurrentSpriteFrame] == 3 )  {
		broken = YES;
	}
	[animator updateAnimation];
	[breaking setTextureRect:[animator getTextureRectFrame]];
}

- (void)setTriangleTopDownPointsForRect:(CGRect)rect {
	rightPoint = ccp(rect.size.width / 2, rect.size.height / 2);
	leftPoint = ccp(0 - (rect.size.width / 2), rect.size.height / 2);
	tipPoint = ccp(0, 0 - (rect.size.height / 2));
}

- (void)kill {
	ice.visible = NO;
	breaking.visible = YES;
	isBreaking = YES;
	NSString *sfx = [NSString stringWithFormat:@"icicle-%i.wav", type];
	if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:sfx];
	[animator startAnimationWithFrame:0 endFrame:3 frameSpeed:57];
}

- (void)reset {
	ice.visible = YES;
	breaking.visible = NO;
	isBreaking = NO;
	broken = NO;
	active = NO;
	speed = 2.0;
	velocity = 0.0;
	[animator stopAnimation];
	[animator setFrame:0];
}

#pragma mark -
#pragma mark Collision Point Reteival Methods

- (CGPoint)getTopRightPoint {
	/*
	 Gets the point where the top right
	 position of the icicle is.
	 According to screen position.
	 */
	return ccp(self.position.x + rightPoint.x, self.position.y + rightPoint.y);
}

- (CGPoint)getTopLeftPoint {
	/*
	 Gets the point where the top left
	 position of the icicle is.
	 According to screen position.
	 */
	return ccp(self.position.x + leftPoint.x, self.position.y + leftPoint.y);
}

- (CGPoint)getTipPoint {
	/*
	 Gets the point where the bottom middle
	 of the icicle is.
	 According to screen position.
	 */
	return ccp(self.position.x + tipPoint.x, self.position.y + tipPoint.y);
}

@end
