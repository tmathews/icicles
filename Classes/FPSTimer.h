//
//  FPSTimer.h
//  Icicles
//
//  Created by Thomas Mathews on 10-07-21.
//  Copyright 2010 Interactive TM. All rights reserved.
//

/*
 This class is simply to make a time object out of
 integers. It will increase based on your framerate,
 not that this isn't that accurate, and is estimated.
 */

@interface FPSTimer:NSObject {
	bool	active;
	
	int		currentCount;
	int		targetFPS;
	
	int		hours;
	int		minutes;
	int		seconds;
}

@property (nonatomic) int hours;
@property (nonatomic) int minutes;
@property (nonatomic) int seconds;

-(id)initWithFPS:(int)nFPS;
-(void)start;
-(void)play;
-(void)pause;
-(void)update;

-(int)getTotalTimeInSeconds;

@end
