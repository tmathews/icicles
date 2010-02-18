//
//  CreditScene.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-13.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "CreditScene.h"
#import "SimpleAudioEngine.h"
#import "GlobalSettings.h"

@implementation CreditScene

@synthesize delegate;

+ (id)sceneWithDelegate:(id<CreditSceneDelegate>)aDelegate {
	CCScene *scene = [CCScene node];
	CreditScene *layer = [CreditScene node];
	layer.delegate = aDelegate;
	[scene addChild: layer];
	return scene;
}

- (id)init {
	if( (self = [super init] )) {
		CCSprite *title = [[CCSprite alloc] initWithFile:@"credits.png"];
		[title setPosition:CGPointMake(240, 160)];
		[title.texture setAliasTexParameters];
		[self addChild:title];
		[title release];
		
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark Touches Responding Methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	startPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	endPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	if ( soundsOn ) [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
	[delegate creditSceneDoesWantToGoToTitleScene:self];
}


@end