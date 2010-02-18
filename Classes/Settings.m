//
//  Settings.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-13.
//  Copyright 2010 Interactive TM. All rights reserved.
//

// We add some special functions to the SaveFileBase for the game, cause its special :P

#import "Settings.h"

@implementation Settings

- (void)setMusicEnabled:(BOOL)value {
	[contents setValue:[NSNumber numberWithBool:value] forKey:@"musicEnabled"];
}

- (BOOL)getMusicEnabled {
	return [[contents valueForKey:@"musicEnabled"] boolValue];
}

@end
