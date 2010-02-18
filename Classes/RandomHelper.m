//
//  RandomHelper.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "RandomHelper.h"


@implementation RandomHelper

+ (int)randomIntMax:(int)max min:(int)min {
	int _max = max;
	int _min = min;
	if(_max < _min) {
		_max = min;
		_min = max;
	}
	return (_min + arc4random() % (_max - _min));
}

@end
