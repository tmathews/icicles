//
//  IcicleManager.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "IcicleManager.h"
#import "Icicle.h"
#import "RandomHelper.h"
#import "SimpleCollisionDetection.h"
#import "SimpleAudioEngine.h"
#import "Hero.h"
#import "FPSTimer.h"

#define TOTAL_DIFFICULTIES		10
#define TOTAL_ICICLES			56
#define DEFAULT_ICICLE_SPEED	4
#define DEFAULT_ICICLE_VELOCITY	1.025

int timesArray[TOTAL_DIFFICULTIES]  = { 0, 15, 30,  45,  60, 100, 150, 200, 300, 250};
int speedArray[TOTAL_DIFFICULTIES]  = {60, 50, 40,  30,  20,  15,  10,   5,   3,   1};
int numberArray[TOTAL_DIFFICULTIES] = { 1,  1,  1,   1,   1,   1,   1,   1,   1,   1};

@interface IcicleManager (PrivateMethods)

- (void)createIcicles;
- (void)runGenerator;
- (void)findFreeIcicleAndLaunchIt;
- (void)launchIcicle:(Icicle *)icicle;
- (void)checkIfIcicleShouldBreak:(Icicle *)icicle;
- (void)checkIfIcicleShouldReset:(Icicle *)icicle;
- (void)resetIcicle:(Icicle *)icicle;
- (void)updateIcicleFalling:(Icicle *)icicle;
- (BOOL)checkForIcicleHittingHero:(Icicle *)icicle;
- (void)icicleDidHitHero;

@end

@implementation IcicleManager

@synthesize iciclesFallen;

- (id)initWithHero:(Hero *)aHero delegate:(id<IcicleManagerDelegate>)aDelegate {
	if ( (self = [super init]) ) {
		hero = [aHero retain];
		delegate = aDelegate;
		[self createIcicles];
		
		playTimer = [[FPSTimer alloc] initWithFPS:59];
		[playTimer start];
	}
	return self;
}

- (void)dealloc {
	[hero release];
	[icicles release];
	[playTimer release];
	[super dealloc];
}

#pragma mark -
#pragma mark Setup Methods

- (void)createIcicles {
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	int type = 1;
	for ( int i = 0; i < TOTAL_ICICLES; i++ ) {
		Icicle *icy = [[Icicle alloc] initIcicleType:type];
		[temp addObject:icy];
		[icy release];
		type++;
		if ( type >= 7 ) type = 1;
	}
	icicles = [temp copy];
	[temp release];
}

- (void)addIciclesToView:(CCNode *)node z:(int)z {
	int count = [icicles count];
	for ( int i = 0; i < count; i++ ) {
		Icicle *icicle = [icicles objectAtIndex:i];
		[node addChild:icicle z:z];
		[self resetIcicle:icicle];
	}
}

#pragma mark -
#pragma mark Running Update Methods

- (void)updateLoop {
	[playTimer update];
	int count = [icicles count];
	for ( int i = 0; i < count; i++ ) {
		Icicle *icy = [icicles objectAtIndex:i];
		[icy updateLoop];
		if ( icy.active ) {
			if ( !icy.isBreaking ) [self updateIcicleFalling:icy];
			if ( !icy.isBreaking ) [self checkIfIcicleShouldBreak:icy];
			[self checkIfIcicleShouldReset:icy];
			if ( [self checkForIcicleHittingHero:icy] ) [self icicleDidHitHero];
		}
	}
}

#pragma mark -
#pragma mark Icicle Controlling

-(void)runGenerator {
	int icicleGenerateSpeed = 0;
	int icicleNumToGenerate = 0;
	
	for(int i = 0; i < TOTAL_DIFFICULTIES; i++) {
		if([playTimer getTotalTimeInSeconds] >= timesArray[i]) {
			icicleGenerateSpeed = speedArray[i];
			icicleNumToGenerate = numberArray[i];
		}
	}
	
	static int counter = 0;
	counter++;
	if(counter >= icicleGenerateSpeed) {
		for(int i = 0; i < icicleNumToGenerate; i++) {
			[self findFreeIcicleAndLaunchIt];
		}
		counter = 0;
	}
}

- (void)findFreeIcicleAndLaunchIt {
	int count = [icicles count];
	for ( int i = 0; i < count; i++ ) {
		Icicle *icy = [icicles objectAtIndex:i];
		if ( !icy.active ) {
			[self launchIcicle:icy];
			break;
		}
	}
}

- (void)launchIcicle:(Icicle *)icicle {
	int newX = [RandomHelper randomIntMax:480 min:0];
	icicle.active = YES;
	icicle.visible = YES;
	icicle.speed = DEFAULT_ICICLE_SPEED;
	icicle.velocity = DEFAULT_ICICLE_VELOCITY;
	icicle.position = CGPointMake(newX, 320+60);
	//NSLog(@"launching Icicle");
}

- (void)checkIfIcicleShouldBreak:(Icicle *)icicle {
	CGPoint point = [icicle getTipPoint];
	if ( point.y <  20 ) {
		iciclesFallen++;
		[icicle kill];
	}
}

- (void)checkIfIcicleShouldReset:(Icicle *)icicle {
	if ( icicle.broken ) {
		[self resetIcicle:icicle];
	}
}

- (void)resetIcicle:(Icicle *)icicle {
	//NSLog(@"reseting Icicle");
	icicle.visible = NO;
	[icicle reset];
	icicle.position = CGPointMake(-60, -60);
}

- (void)updateIcicleFalling:(Icicle *)icicle {
	
	int speedAdjustment = 0;
	if ( icicle.position.y > 310 ) {
		speedAdjustment = icicle.speed * 0.90;
	} else {
		icicle.speed *= icicle.velocity;
	}
	
	int x = icicle.position.x;
	int y = icicle.position.y - icicle.speed + speedAdjustment;
	
	icicle.position = CGPointMake(x, y);
}

#pragma mark -
#pragma mark Icicles VS Hero Methods

- (BOOL)checkForIcicleHittingHero:(Icicle *)icicle {
	if ( ([SimpleCollisionDetection lineIntersectsWithRect:[hero getCollisionBoundryBox] 
												  pointA:[icicle getTipPoint] 
												  pointB:[icicle getTopLeftPoint]] ||
		[SimpleCollisionDetection lineIntersectsWithRect:[hero getCollisionBoundryBox] 
												  pointA:[icicle getTipPoint]
												  pointB:[icicle getTopRightPoint]]) &&
		hero.alive && !icicle.isBreaking) {
		[icicle kill];
		return YES;
	}
	return NO;
}

- (void)icicleDidHitHero {
	if ( [delegate respondsToSelector:@selector(icicleManagerIcicleDidHitHero:)] ) {
		[delegate icicleManagerIcicleDidHitHero:self];
	}
}
				
@end
