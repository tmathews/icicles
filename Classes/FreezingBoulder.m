//
//  FreezingBoulder.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-17.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "FreezingBoulder.h"
#import "AnimatorController.h"
#import "Hero.h"

@implementation FreezingBoulder

- (id)initBoulderWithHero:(Hero *)hero {
	if ( (self = [super initWithFile:@"freezing-boulder.png" rect:CGRectMake(0, 0, 128, 128)]) ) {
		[self.texture setAliasTexParameters];
		self.visible = NO;
		heroRef = hero;
		animator = [[AnimatorController alloc] initWithImageHeight:1024 frameSize:CGSizeMake(128, 128)];
	}
	return self;
}

- (void)dealloc {
	heroRef = nil;
	[animator release];
	[super dealloc];
}

- (void)updateLoop {
	self.flipX = heroRef.flipX;
	CGPoint newPosition = heroRef.position;
	newPosition.y += 25;
	[self setPosition:newPosition];
	[animator updateAnimation];
	[self setTextureRect:[animator getTextureRectFrame]];
}

- (void)freeze {
	self.visible = YES;
	[animator startAnimationWithLimitedPlays:1 startFrame:0 endFrame:6 finishFrame:6 frameSpeed:40];
}

@end
