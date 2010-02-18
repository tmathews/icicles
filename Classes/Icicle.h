//
//  Icicle.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@class AnimatorController;

@interface Icicle : CCNode {
	int			type;
	BOOL		active;
	BOOL		isBreaking;
	BOOL		broken;
	float		speed;
	float		velocity;
	CGPoint		tipPoint;
	CGPoint		rightPoint;
	CGPoint		leftPoint;
	CCSprite	*ice;
	CCSprite	*breaking;
	AnimatorController *animator;
}

@property (nonatomic) int type;
@property (nonatomic) BOOL isBreaking;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL broken;
@property (nonatomic) float speed;
@property (nonatomic) float velocity;

- (id)initIcicleType:(int)type;
- (void)updateLoop;
- (void)kill;
- (void)reset;
- (CGPoint)getTipPoint;
- (CGPoint)getTopLeftPoint;
- (CGPoint)getTopRightPoint;

@end
