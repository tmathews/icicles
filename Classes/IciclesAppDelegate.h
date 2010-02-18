//
//  IciclesAppDelegate.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright Interactive TM 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayScene.h"
#import "TitleScene.h"
#import "CreditScene.h"

@class RootViewController;
@class Settings;

@interface IciclesAppDelegate : NSObject <UIApplicationDelegate, PlaySceneDelegate, TitleSceneDelegate, CreditSceneDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
	Settings			*settings;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) Settings *settings;

@end
