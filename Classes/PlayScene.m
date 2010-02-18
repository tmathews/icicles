//
//  PlayScene.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "PlayScene.h"
#import "CaveBackground.h"
#import "Hero.h"
#import "GameOverBanner.h"
#import "SimpleCollisionDetection.h"
#import "SimpleAudioEngine.h"
#import "FreezingBoulder.h"
#import "GlobalSettings.h"

@interface PlayScene (PrivateMethods)

- (void)frameLoop:(ccTime)dt;
- (void)pauseGame;
- (void)unpauseGame;

@end

@implementation PlayScene

@synthesize delegate;

+ (id)sceneWithDelegate:(id<PlaySceneDelegate>)aDelegate {
	CCScene *scene = [CCScene node];
	PlayScene *layer = [PlayScene node];
	layer.delegate = aDelegate;
	[scene addChild: layer];
	return scene;
}

- (id)init {
	if( (self=[super init] )) {
		background = [[CaveBackground alloc] init];
		hero = [[Hero alloc] initHero];
		icicles = [[IcicleManager alloc] initWithHero:hero delegate:self];
		gameOverBanner = [[GameOverBanner alloc] initBannerWithText:@""];
		pausedBanner = [[CCSprite alloc] initWithFile:@"paused-banner.png"];
		pauseButton = [[CCSprite alloc] initWithFile:@"pause-button.png"];
		
		[gameOverBanner setPosition:CGPointMake(240, 400)];
		gameOverBanner.visible = NO;
		
		[pausedBanner setPosition:CGPointMake(240, 160)];
		pausedBanner.visible = NO;
		[pausedBanner.texture setAliasTexParameters];
		
		[pauseButton setPosition:CGPointMake(15, 305)];
		[pauseButton.texture setAliasTexParameters];
		
		[self addChild:background z:0];
		[icicles addIciclesToView:self z:2];
		[self addChild:hero z:1];
		[self addChild:gameOverBanner z:3];
		[self addChild:pausedBanner z:3];
		[self addChild:pauseButton z:3];
		
		hero.alive = YES;
		
		freezingBoulder = [[FreezingBoulder alloc] initBoulderWithHero:hero];
		[self addChild:freezingBoulder z:10];
		[freezingBoulder setPosition:CGPointMake(240, 160)];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGame) name:@"pauseGame" object:nil];
		
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		[self schedule:@selector(frameLoop:)];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"pauseGame"];
	[background release];
	[hero release];
	[icicles release];
	[gameOverBanner release];
	[delegate release];
	[super dealloc];
}

#pragma mark -
#pragma mark Main Loop

- (void)frameLoop:(ccTime)dt {
	if ( !gamePaused ) {
		[background updateLoop];
		[background updateBackgroundPositionsForCameraPoint:hero.position];
		if ( !gameOver && gameStarted ) [icicles runGenerator];
		[icicles updateLoop];
		[hero updateLoop];
		[freezingBoulder updateLoop];
	}
}

#pragma mark -
#pragma mark Pause Methods

- (void)pauseGame {
	if ( !gameOver ) {
		gamePaused = YES;
		pausedBanner.visible = YES;
		pauseButton.visible = NO;
		if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"pause-in.wav"];
	}
}

- (void)unpauseGame {
	gamePaused = NO;
	pausedBanner.visible = NO;
	pauseButton.visible = YES;
	if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"pause-out.wav"];
}

#pragma mark -
#pragma mark Responding Methods

- (void)icicleManagerIcicleDidHitHero:(IcicleManager *)icicleManager {
	[delegate playSceneDoesWantToSubmitScore:self score:icicleManager.iciclesFallen];
	gameOver = YES;
	[hero kill];
	[freezingBoulder freeze];
	if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"death-sequence.wav"];
	pauseButton.visible = NO;
	gameOverBanner.visible = YES;
	[gameOverBanner setBannerText:[GameOverBanner getBannerTextForScore:icicles.iciclesFallen]];
	id move = [CCMoveBy actionWithDuration:1.0 position:CGPointMake(0, 320 - 400 - 160)];
	id action = [CCEaseBounceOut actionWithAction:move];
	[gameOverBanner runAction:action];
}

#pragma mark Touches Responding Methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	
	startPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	
	if(startPoint.x < 240) {
		currentTouchArea = 1;
		if ( hero.alive ) [hero moveLeft];
	} else {
		currentTouchArea = 2;
		if ( hero.alive ) [hero moveRight];
	}
	
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	endPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	
	if ( !gameStarted && !gamePaused) gameStarted = YES;
	
	if ( !gamePaused && [SimpleCollisionDetection pointInsideRect:CGRectMake(0, 320, 60, 60) 
															point:endPoint] ) {
		[self pauseGame];
	} else if ( gamePaused ) {
		[self unpauseGame];
	}
	
	if((endPoint.x < 240 && currentTouchArea == 1) || (endPoint.x >= 240 && currentTouchArea == 2)) {
		if ( hero.alive ) [hero idle];
		currentTouchArea = 0;
	}
	
	if ( gameOver && [SimpleCollisionDetection pointInsideRect:CGRectMake(330, 150, 150, 40) 
												 point:endPoint] ) {
		if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
		[delegate playSceneDoesWantToRestart:self];
	} else if ( gameOver && [SimpleCollisionDetection pointInsideRect:CGRectMake(0, 150, 85, 40) 
											 point:endPoint] ) {
		if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
		[delegate playSceneDoesWantToGoToMenu:self];
	}
}

@end
