//
//  TitleScene.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@class Settings;

@protocol TitleSceneDelegate;

@interface TitleScene : CCLayer {
	id<TitleSceneDelegate> delegate;
	CGPoint			startPoint;
	CGPoint			endPoint;
	CCSprite		*title;
	CCSprite		*dashboard;
	CCSprite		*musicOn;
	CCSprite		*musicOff;
	BOOL			musicEnabled;
	Settings		*settingsRef;
}

@property (nonatomic, retain) id<TitleSceneDelegate> delegate;

+ (id)sceneWithDelegate:(id<TitleSceneDelegate>)aDelegate;
- (void)setup;

@end

@protocol TitleSceneDelegate <NSObject>

- (void)titleSceneDoesWantToGoToPlayScene:(TitleScene *)titleScene;
- (void)titleSceneDoesWantToGoToLeaderboards:(TitleScene *)titleScene;
- (void)titleSceneDoesWantToGoToCredits:(TitleScene *)titleScene;
- (Settings *)titleSceneDoesRequestSettings:(TitleScene *)titleScene;

@end