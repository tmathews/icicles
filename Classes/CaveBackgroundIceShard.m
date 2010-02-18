//
//  CaveBackgroundIceShard.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "CaveBackgroundIceShard.h"


@implementation CaveBackgroundIceShard

@synthesize speed, active;

- (id)initWithShardType:(int)type {
	if ( type > 4 || type < 1 ) type = 1;
	
	if ( (self = [super initWithFile:[NSString stringWithFormat:@"ice-shard-%i.png", type]]) ) {
		active = NO;
		[self.texture setAliasTexParameters];
		switch ( type ) {
			case 1:
				speed = 5.5;
				break;
			case 2:
				speed = 3.5;
				break;
			case 3:
				speed = 4.0;
				break;
			case 4:
				speed = 5.0;
				break;
		}
	}
	return self;
}

@end
