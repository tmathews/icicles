//
//  CaveBackgroundIceShard.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@interface CaveBackgroundIceShard : CCSprite {
	float	speed;
	BOOL	active;
}

@property (nonatomic) float speed;
@property (nonatomic) BOOL active;

- (id)initWithShardType:(int)type;

@end
