//
//  iTM_animator.m
//  test
//
//  Created by Thomas Mathews on 10-06-04.
//  Copyright 2010 interactive tm. All rights reserved.
//

#import "AnimatorController.h"

@implementation AnimatorController

-(id)initWithImageHeight:(int)imgHeight frameSize:(CGSize)fSize {
	_spriteFrame = 0;
	_currentFrame = 0;
	_fps = 60;
	_animationFrameTurn = ((60 - (_fps - 1)) - 1);
	
	_firstFrame = 0;
	_lastFrame = 0;
	
	_width = fSize.width;
	_height = fSize.height;
	
	_paused = true;
	
	_imageHeight = imgHeight;
	
	return self;
}

/*
- (void)updateAnimation {
	_animationFrameTurn = ((60 - (_fps - 1)) - 1);
	if(!_paused) {
		_currentFrame++;
		if(_currentFrame >= _animationFrameTurn){
			_spriteFrame++;
			if(_spriteFrame > _lastFrame) {
				_spriteFrame = _firstFrame;
			}
			_currentFrame = 0;
		}
	}
}
*/


- (void)updateAnimation {
	_animationFrameTurn = ((60 - (_fps - 1)) - 1);
	if(!_paused) {
		_currentFrame++;
		if (_currentFrame >= _animationFrameTurn) {
			_spriteFrame++;
			if (_spriteFrame > _lastFrame) {
				_currentLoop++;
				// NSLog(@"finish 1 loop of animation.");
				if(_currentLoop > _totalLoops && _totalLoops != -1) {
					// NSLog(@"Done with limited play animation.");
					_spriteFrame = _finishFrame;
					_paused = YES;
				} else {
					_spriteFrame = _firstFrame;
				}
			}
			_currentFrame = 0; //_firstFrame;
		}
	}
}

- (void)setSize:(int)width:(int)height {
	_width = width;
	_height = height;
}

- (void)setFrame:(int)frame {
	_spriteFrame = frame;
	_currentFrame = _spriteFrame;
	[self stopAnimation];
}

- (void)setFPS:(int)speed {
	_fps = speed;
}

-(void)startAnimationWithFrame:(int)startFrame endFrame:(int)endFrame frameSpeed:(int)frameSpeed {
	_spriteFrame = startFrame;
	_currentFrame = startFrame;
	_firstFrame = startFrame;
	_lastFrame = endFrame;
	_fps = frameSpeed;
	_paused = false;
	_totalLoops = -1;
}

-(void)startAnimationWithLimitedPlays:(int)numOfLoops startFrame:(int)startFrame endFrame:(int)endFrame finishFrame:(int)finishFrame frameSpeed:(int)frameSpeed {
	_spriteFrame = startFrame;
	_currentFrame = startFrame;
	_currentLoop = 1;
	_firstFrame = startFrame;
	_lastFrame = endFrame;
	_finishFrame = finishFrame;
	_fps = frameSpeed;
	_paused = false;
	_totalLoops = numOfLoops;
}

- (void)playPauseAnimation {
	_paused = !_paused;
}

- (void)stopAnimation {
	_paused = true;
}

- (CGRect)getTextureRectFrame {
	int xCor = (_spriteFrame / (int)(_imageHeight/_height)) * _width;
	int yCor = (_spriteFrame % (int)(_imageHeight/_height)) * _height;
	
	return CGRectMake(xCor, yCor, _width, _height);
}

- (int)getCurrentSpriteFrame {
	return _spriteFrame;
}

-(void)dealloc {
	[super dealloc];
}

@end
