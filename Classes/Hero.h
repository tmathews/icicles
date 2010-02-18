//
//  Hero.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@class AnimatorController;

@interface Hero : CCSprite {
	BOOL				alive;
	BOOL				moving;
	BOOL				movementDirection;
	float				speed;
	float				velocity;
	AnimatorController	*animator;
}

@property (nonatomic) BOOL alive;

- (id)initHero;
- (void)updateLoop;
- (void)updatePosition;
- (void)moveLeft;
- (void)moveRight;
- (void)idle;
- (void)kill;
- (CGRect)getCollisionBoundryBox;

@end
