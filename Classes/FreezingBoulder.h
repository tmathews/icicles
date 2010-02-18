//
//  FreezingBoulder.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-17.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@class AnimatorController;
@class Hero;

@interface FreezingBoulder : CCSprite {
	AnimatorController	*animator;
	Hero				*heroRef;
}

- (id)initBoulderWithHero:(Hero *)hero;
- (void)updateLoop;
- (void)freeze;

@end
