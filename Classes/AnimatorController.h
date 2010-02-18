//
//  iTM_animator
//  test
//
//  Created by Thomas Mathews on 10-06-04.
//  Copyright 2010 interactive tm. All rights reserved.
//

@interface AnimatorController:NSObject {
	int _fps;
	
	int _spriteFrame;
	int _currentFrame;
	int _animationFrameTurn;
	
	int _width;
	int _height;
	
	int _firstFrame;
	int _lastFrame;
	int _finishFrame;
	
	int _currentLoop;
	int _totalLoops;
	
	bool _paused;
	
	int _imageHeight;
}

-(id)initWithImageHeight:(int)imgHeight frameSize:(CGSize)fSize;

- (void)updateAnimation;
- (void)setSize:(int)width:(int)height;
- (void)setFrame:(int)frame;
- (void)setFPS:(int)speed;
- (void)startAnimationWithFrame:(int)startFrame endFrame:(int)endFrame frameSpeed:(int)frameSpeed;
-(void)startAnimationWithLimitedPlays:(int)numOfLoops startFrame:(int)startFrame endFrame:(int)endFrame finishFrame:(int)finishFrame frameSpeed:(int)frameSpeed;
- (void)playPauseAnimation;
- (void)stopAnimation;
- (CGRect)getTextureRectFrame;
- (int)getCurrentSpriteFrame;

@end
