//
//  RootViewController.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright Interactive TM 2010. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"
#import "RootViewController.h"
#import "GameConfig.h"
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import "SimpleAudioEngine.h"
#import "Settings.h"
#import "GlobalSettings.h"

@implementation RootViewController

@synthesize gameCenterManager, settingsRef;

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect;
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	if ( gameCenterManager ) [gameCenterManager release];
	[settingsRef release];
    [super dealloc];
}

#pragma mark -

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message {
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
												   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Game Center Management

- (void)startGameCenter {
	if ( [GameCenterManager isGameCenterAvailable] ) {
		self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalUser];
	} else {
		[self showAlertWithTitle:@"Game Center Support Required" message:@"This game requires Game Center in order to record high score data."];
	}
}

- (void)checkToSubmitSavedScore {
	int scoreToSubmit = [[settingsRef.contents valueForKey:@"scoreToSubmit"] intValue];
	if ( scoreToSubmit != 0 ) {
		[self submitLeaderboardScore:scoreToSubmit];
	}
}

- (void)submitLeaderboardScore:(int)score {
	int currentScore = [[settingsRef.contents valueForKey:@"scoreToSubmit"] intValue];
	if ( score > currentScore ) {
		[settingsRef.contents setValue:[NSNumber numberWithInt:score] forKey:@"scoreToSubmit"];
		[settingsRef saveSettings];
	}
	[gameCenterManager reportScore:score forCategory:iciclesDodgedLeaderboardID];
}

- (void)launchLeaderboards {
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if ( leaderboardController != NULL ) {
		leaderboardController.category = iciclesDodgedLeaderboardID;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self;
		[self presentModalViewController:leaderboardController animated:YES];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
	[self dismissModalViewControllerAnimated:YES];
	[viewController release];
}

- (void)submitAchievement:(NSString *)achievementId {
	[gameCenterManager submitAchievement:achievementId percentComplete:1];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	
}

#pragma mark GameCenterManager Delegate Responding Methods

- (void) processGameCenterAuth:(NSError*)error {
	//NSLog(@"Process GameCenter Auth: %@", error);
}

- (void) scoreReported:(NSError*)error {
	//NSLog(@"Score Reported: %@", error);
	if ( !error ) {
		int iciclesDodgedTotal = [[settingsRef.contents valueForKey:@"iciclesDodgedTotal"] intValue] + 
									[[settingsRef.contents valueForKey:@"scoreToSubmit"] intValue];
		[settingsRef.contents setValue:[NSNumber numberWithInt:iciclesDodgedTotal] forKey:@"iciclesDodgedTotal"];
		[settingsRef.contents setValue:[NSNumber numberWithInt:0] forKey:@"scoreToSubmit"];
		[settingsRef saveSettings];
	}
}

- (void) reloadScoresComplete:(GKLeaderboard*)leaderBoard error:(NSError*)error {
	
}

- (void) achievementSubmitted:(GKAchievement*)ach error:(NSError*)error {
	
}

- (void) achievementResetResult:(NSError*)error {
	
}

- (void) mappedPlayerIDToPlayer:(GKPlayer*)player error:(NSError*)error {
	
}

@end

