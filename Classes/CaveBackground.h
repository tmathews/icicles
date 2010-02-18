//
//  CaveBackgroundSprite.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@interface CaveBackground : CCNode {
	CCSprite	*base;
	CCSprite	*backgroundIce;
	CCSprite	*foregroundIce;
	CCSprite	*floor;
	NSArray		*shards;
	int			shardTimeTrigger;
	int			shardTimeCounter;
}

- (void)updateLoop;
- (void)updateBackgroundPositionsForCameraPoint:(CGPoint)point;

@end
