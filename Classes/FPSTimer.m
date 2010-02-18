//
//  FPSTimer.m
//  Icicles
//
//  Created by Thomas Mathews on 10-07-21.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "FPSTimer.h"

#define MAX_FPS			60
#define MAX_MINUTES		60
#define MAX_SECONDS		60

@implementation FPSTimer

@synthesize hours;
@synthesize minutes;
@synthesize seconds;

-(id)initWithFPS:(int)nFPS {
	if((self = [super init])) {
		
		targetFPS = nFPS;
		if(targetFPS > MAX_FPS) targetFPS = MAX_FPS;
		
		currentCount = 0;
		
		hours = 0;
		minutes = 0;
		seconds = 0;
		
	}
	return self;
}

-(void)dealloc {
	[super dealloc];
}

-(void)start {
	/*
	 Start the timer at new. Also like reset
	 */
	currentCount = 0;
	
	hours = 0;
	minutes = 0;
	seconds = 0;
	
	active = YES;
}

-(void)play {
	/*
	 Resume from paused state, make active.
	 */
	active = YES;
}

-(void)pause {
	/*
	 Pause the timer, make non-active.
	 */
	active = NO;
}

-(void)update {
	/*
	 update the timer based on the frame count
	 adjust seconds, minutes and hours accordingly
	 */
	
	if(active) {
		currentCount++;
		if(currentCount >= targetFPS) {
			seconds++;
			currentCount = 0;
		}
		
		if(seconds >= MAX_SECONDS) {
			minutes++;
			seconds = 0;
		}
		
		if(minutes >= MAX_MINUTES) {
			hours++;
			minutes = 0;
		}
	}
}


#pragma mark -
#pragma mark Get Time Methods

-(int)getTotalTimeInSeconds {
	/*
	 Get a total of time in seconds.
	 */
	return (seconds) + (minutes * 60) + (hours * 60);
}

@end
