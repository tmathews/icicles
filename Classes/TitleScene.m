//
//  TitleScene.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "TitleScene.h"
#import "SimpleCollisionDetection.h"
#import "SimpleAudioEngine.h"
#import "Settings.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GlobalSettings.h"

@interface TitleScene (PrivateMethods)

- (void)muteMusic;
- (void)hearMusic;
- (void)playMainMusic;

@end


@implementation TitleScene

@synthesize delegate;

+ (id)sceneWithDelegate:(id<TitleSceneDelegate>)aDelegate {
	CCScene *scene = [CCScene node];
	TitleScene *layer = [TitleScene node];
	layer.delegate = aDelegate;
	[layer setup];
	[scene addChild: layer];
	return scene;
}

- (id)init {
	if( (self=[super init] )) {
		
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"canPlayGameMusicNow"];
	[title release];
	[dashboard release];
	settingsRef = nil;
	[super dealloc];
}

- (void)setup {
	title = [[CCSprite alloc] initWithFile:@"icicles-title.png"];
	[title setPosition:CGPointMake(240, 480)];
	[title.texture setAliasTexParameters];
	[self addChild:title];
	
	dashboard = [[CCSprite alloc] initWithFile:@"menu-dashboard.png"];
	[dashboard setPosition:CGPointMake(240, -15)];
	[dashboard.texture setAliasTexParameters];
	[self addChild:dashboard];
	
	musicOn = [[CCSprite alloc] initWithFile:@"musical-note.png"];
	[musicOn.texture setAliasTexParameters];
	[musicOn setPosition:CGPointMake(20, 350)];
	[self addChild:musicOn];
	
	musicOff = [[CCSprite alloc] initWithFile:@"musical-note-broken.png"];
	[musicOff.texture setAliasTexParameters];
	[musicOff setPosition:CGPointMake(20, 350)];
	[self addChild:musicOff];
	
	settingsRef = [delegate titleSceneDoesRequestSettings:self];
	if ( [settingsRef getMusicEnabled] ) {
		[self hearMusic];
	} else {
		[self muteMusic];
	}
	
	/* if we have no mute and music is not already playing then play music!
	if ( mE && ![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] && ![[SimpleAudioEngine sharedEngine] mute] ) {
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main-music.wav" loop:YES];
	}*/
	
	id move = [CCMoveBy actionWithDuration:2.0 position:CGPointMake(0, -320)];
	id action = [CCEaseExponentialInOut actionWithAction:move];
	[title runAction:action];
	
	id move1 = [CCMoveBy actionWithDuration:2.0 position:CGPointMake(0, 30)];
	id action1 = [CCEaseExponentialInOut actionWithAction:move1];
	[dashboard runAction:action1];
	
	id move2 = [CCMoveBy actionWithDuration:2.0 position:CGPointMake(0, -50)];
	id action2 = [CCEaseExponentialInOut actionWithAction:move2];
	[musicOn runAction:action2];
	
	id move3 = [CCMoveBy actionWithDuration:2.0 position:CGPointMake(0, -50)];
	id action3 = [CCEaseExponentialInOut actionWithAction:move3];
	[musicOff runAction:action3];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMainMusic) name:@"canPlayGameMusicNow" object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(muteMusic) name:@"stopPlayingGameMusicNow" object:nil];
	
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)playMainMusic {
	if ( soundsOn && ![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] ) {
		[SimpleAudioEngine end];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main-music.wav" loop:YES];
	}
}

- (void)muteMusic {
	musicEnabled = NO;
	musicOn.visible = NO;
	musicOff.visible = YES;
	soundsOn = NO;
	[[SimpleAudioEngine sharedEngine] setMute:YES];
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[SimpleAudioEngine end];
	[settingsRef setMusicEnabled:NO];
	[settingsRef saveSettings];
}

- (void)hearMusic {
	musicEnabled = YES;
	musicOn.visible = YES;
	musicOff.visible = NO;
	soundsOn = YES;
	[[SimpleAudioEngine sharedEngine] setMute:NO];
	if ( [[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying ) {
		[[MPMusicPlayerController iPodMusicPlayer] pause];
	} else {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main-music.wav" loop:YES];
	}
	[settingsRef setMusicEnabled:YES];
	[settingsRef saveSettings];
}

- (void)toggleAudio {
	if ( musicEnabled ) {
		[self muteMusic];
	} else { 
		[self hearMusic];
		[[SimpleAudioEngine sharedEngine] playEffect:@"music-on.wav"];
	}
}

#pragma mark Touches Responding Methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	startPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	endPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	
	if ( [SimpleCollisionDetection pointInsideRect:CGRectMake(0, 280, 480, 250) point:endPoint] ) {
		if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
		[delegate titleSceneDoesWantToGoToPlayScene:self];
	} else if ( [SimpleCollisionDetection pointInsideRect:CGRectMake(0, 30, 100, 30) point:endPoint] ) {
		[delegate titleSceneDoesWantToGoToLeaderboards:self];
		if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
	} else if ( [SimpleCollisionDetection pointInsideRect:CGRectMake(380, 30, 100, 30) point:endPoint] ) {
		[delegate titleSceneDoesWantToGoToCredits:self];
		if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
	} else if ( [SimpleCollisionDetection pointInsideRect:CGRectMake(0, 320, 30, 30) point:endPoint] ) {
		[self toggleAudio];
	}
}


@end
