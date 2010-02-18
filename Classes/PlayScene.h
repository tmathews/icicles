//
//  PlayScene.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"
#import "IcicleManager.h"

@class CaveBackground;
@class IcicleManager;
@class Hero;
@class GameOverBanner;
@class FreezingBoulder;

@protocol PlaySceneDelegate;

@interface PlayScene : CCLayer <IcicleManagerDelegate> {
	id<PlaySceneDelegate> delegate;
	CaveBackground	*background;
	IcicleManager	*icicles;
	Hero			*hero;
	FreezingBoulder	*freezingBoulder;
	GameOverBanner	*gameOverBanner;
	CCSprite		*pausedBanner;
	CCSprite		*pauseButton;
	BOOL			gamePaused;
	BOOL			gameStarted;
	BOOL			gameOver;
	int				currentTouchArea;
	CGPoint			startPoint;
	CGPoint			endPoint;
}

@property (nonatomic, retain) id<PlaySceneDelegate> delegate;

+ (id)sceneWithDelegate:(id<PlaySceneDelegate>)aDelegate;

@end

@protocol PlaySceneDelegate <NSObject>

- (void)playSceneDoesWantToGoToMenu:(PlayScene *)playScene;
- (void)playSceneDoesWantToRestart:(PlayScene *)playScene;
- (void)playSceneDoesWantToSubmitScore:(PlayScene *)playScene score:(int)score;

@end
