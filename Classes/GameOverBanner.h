//
//  GameOverBanner.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverBanner : CCNode {
	CCSprite	*banner;
	CCLabelTTF	*text;
}

-(id)initBannerWithText:(NSString *)string;
- (void)setBannerText:(NSString *)string;
+ (NSString *)getBannerTextForScore:(int)score;

@end
