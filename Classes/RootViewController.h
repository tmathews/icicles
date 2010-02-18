//
//  RootViewController.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright Interactive TM 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"

@class GameCenterManager;
@class Settings;

@interface RootViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate> {
	GameCenterManager	*gameCenterManager;
	Settings			*settingsRef;
}

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) Settings *settingsRef;

- (void)startGameCenter;
- (void)checkToSubmitSavedScore;
- (void)submitLeaderboardScore:(int)score;
- (void)launchLeaderboards;

@end
