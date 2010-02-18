//
//  IciclesAppDelegate.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright Interactive TM 2010. All rights reserved.
//

#import "cocos2d.h"

#import "IciclesAppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "Settings.h"
#import "SimpleAudioEngine.h"
#import <MediaPlayer/MediaPlayer.h>

@interface IciclesAppDelegate (PrivateMethods)

- (void)removeStartupFlicker;
- (void)musicPlayerStateDidChange;

@end


@implementation IciclesAppDelegate

@synthesize window, settings;

#pragma mark - 
#pragma mark Application State Responding Methods

- (void) applicationDidFinishLaunching:(UIApplication*)application {
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] ) [CCDirector setDirectorType:kCCDirectorTypeDefault];
	CCDirector *director = [CCDirector sharedDirector];
	
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	[director setOpenGLView:glView];
	
	[director enableRetinaDisplay:YES];
	
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	[viewController setView:glView];
	[window addSubview: viewController.view];
	[window makeKeyAndVisible];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	[self removeStartupFlicker];
	
	settings = [[Settings alloc] init];
	viewController.settingsRef = settings;
		
	[[CCDirector sharedDirector] runWithScene: [TitleScene sceneWithDelegate:self]];		
	[viewController startGameCenter];
	
	[[MPMusicPlayerController iPodMusicPlayer] beginGeneratingPlaybackNotifications];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerStateDidChange) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGame" object:nil];
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	[[director openGLView] removeFromSuperview];
	[viewController release];
	[window release];
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

#pragma mark -
#pragma mark PlayScene Delegates

- (void)playSceneDoesWantToGoToMenu:(PlayScene *)playScene {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipY transitionWithDuration:0.5f scene:[TitleScene sceneWithDelegate:self]]];
}

- (void)playSceneDoesWantToRestart:(PlayScene *)playScene {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:0.5f scene:[PlayScene sceneWithDelegate:self]]];
}

- (void)playSceneDoesWantToSubmitScore:(PlayScene *)playScene score:(int)score {
	[viewController submitLeaderboardScore:score];
}

#pragma mark TitleScene Delegates

- (void)titleSceneDoesWantToGoToPlayScene:(TitleScene *)titleScene {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipY transitionWithDuration:0.5f scene:[PlayScene sceneWithDelegate:self]]];
}

- (void)titleSceneDoesWantToGoToLeaderboards:(TitleScene *)titleScene {
	[viewController launchLeaderboards];
}

- (void)titleSceneDoesWantToGoToCredits:(TitleScene *)titleScene {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5f scene:[CreditScene sceneWithDelegate:self]]];
}

- (Settings *)titleSceneDoesRequestSettings:(TitleScene *)titleScene {
	return settings;
}

#pragma mark CreditScene Delegates

- (void)creditSceneDoesWantToGoToTitleScene:(CreditScene *)creditScene {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5f scene:[TitleScene sceneWithDelegate:self]]];
}

#pragma mark -
#pragma mark Other Methods

- (void)removeStartupFlicker {
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[glView swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	

}

- (void)musicPlayerStateDidChange {
	MPMusicPlaybackState state = [[MPMusicPlayerController iPodMusicPlayer] playbackState];
	if ( state == MPMusicPlaybackStatePaused || state == MPMusicPlaybackStateStopped ) {
		// ok start music!
		[[NSNotificationCenter defaultCenter] postNotificationName:@"canPlayGameMusicNow" object:nil];
		[settings.contents setValue:[NSNumber numberWithBool:YES] forKey:@"musicEnabled"];
	} else if ( state == MPMusicPlaybackStatePlaying ) {
		// ok stop music!
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlayingGameMusicNow" object:nil];
		//[settings.contents setValue:[NSNumber numberWithBool:NO] forKey:@"musicEnabled"];
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[settings release];
	[super dealloc];
}

@end
