//
//  IcicleManager.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@class Hero;
@class FPSTimer;

@protocol IcicleManagerDelegate;

@interface IcicleManager : NSObject {
	id<IcicleManagerDelegate>	delegate;
	NSArray						*icicles;
	Hero						*hero;
	int							iciclesFallen;
	FPSTimer					*playTimer;
}

@property (nonatomic) int iciclesFallen;

- (id)initWithHero:(Hero *)aHero delegate:(id<IcicleManagerDelegate>)delegate;
- (void)updateLoop;
- (void)addIciclesToView:(CCNode *)node z:(int)z;
- (void)runGenerator;

@end

@protocol IcicleManagerDelegate <NSObject>

- (void)icicleManagerIcicleDidHitHero:(IcicleManager *)icicleManager;

@end

