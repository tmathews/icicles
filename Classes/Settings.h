//
//  Settings.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-13.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveFileBase.h"

@interface Settings : SaveFileBase {
	
}

- (BOOL)getMusicEnabled;
- (void)setMusicEnabled:(BOOL)value;

@end
