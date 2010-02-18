//
//  Hero.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "Hero.h"
#import "AnimatorController.h"

#define HITBOX_WIDTH		34
#define HITBOX_HEIGHT		62
#define HITBOX_X_OFFSET		-17
#define HITBOX_Y_OFFSET		31

#define LEFT_CLAMP			0 + (HITBOX_WIDTH/2)
#define RIGHT_CLAMP			480 - (HITBOX_WIDTH/2)

#define DEFAULT_SPEED		1.0
#define DEFAULT_VELOCITY	1.03
#define DEFAULT_DEVELOCITY	0.95

#define MOVE_LEFT			NO
#define MOVE_RIGHT			YES

@interface Hero (PrivateMethods)

- (void)idleTimeTracker;

@end

@implementation Hero

@synthesize alive;

- (id)initHero {
	if ( (self = [super initWithFile:@"hero.png" rect:CGRectMake(0, 0, 58, 66)]) ) {
		[self.texture setAliasTexParameters];
		self.position = CGPointMake(240, 58);
		speed = DEFAULT_SPEED;
		velocity = DEFAULT_VELOCITY;
		animator = [[AnimatorController alloc] initWithImageHeight:1024 frameSize:CGSizeMake(58, 66)];
		[self idle];
	}
	return self;
}

- (void)dealloc {
	[animator release];
	[super dealloc];
}

#pragma mark -
#pragma mark Running Update Methods

- (void)updateLoop {
	[self idleTimeTracker];
	[self updatePosition];
	[animator updateAnimation];
	[self setTextureRect:[animator getTextureRectFrame]];
}

#pragma mark Movement Methods

/*
 * Move outside? Movement shouldn't be controlled by itself, but by its parent.
 */
- (void)updatePosition {
	CGPoint currentPosition = self.position;	
	if(moving) {
		if(speed < 3)	speed *= velocity;
		else			speed = 3;
	} else {
		if(speed > 0.25)	speed *= DEFAULT_DEVELOCITY;
		else				speed = 0;
	}
	
	if (movementDirection) currentPosition.x += speed;
	else currentPosition.x -= speed;
	
	if(currentPosition.x >= LEFT_CLAMP && currentPosition.x <= RIGHT_CLAMP) [self setPosition:currentPosition];
}

#pragma mark -
#pragma mark Animation Methods

- (void)moveLeft {
	speed = DEFAULT_SPEED;
	moving = YES;
	movementDirection = MOVE_LEFT;
	[self setFlipX:NO];
	[animator startAnimationWithFrame:5 endFrame:11 frameSpeed:57];
}

- (void)moveRight {
	speed = DEFAULT_SPEED;
	moving = YES;
	movementDirection = MOVE_RIGHT;
	[self setFlipX:YES];
	[animator startAnimationWithFrame:5 endFrame:11 frameSpeed:57];
}

- (void)idle {
	moving = NO;
	[animator setFrame:0];
}

- (void)kill {
	alive = NO;
	moving = NO;
	[animator setFrame:12];
}

#pragma mark -
#pragma mark Updating Animations Methods

- (void)idleTimeTracker {
	static int counter = 0;
	if ( !moving && alive ) counter++;
	if ( counter > 300 ) {
		[animator startAnimationWithLimitedPlays:1 startFrame:0 endFrame:3 finishFrame:0 frameSpeed:50];
		counter = 0;
	}
}

#pragma mark -
#pragma mark Collision Mthods

- (CGRect)getCollisionBoundryBox {
	return CGRectMake(self.position.x + HITBOX_X_OFFSET, self.position.y + HITBOX_Y_OFFSET, HITBOX_WIDTH, HITBOX_HEIGHT);
}

@end
