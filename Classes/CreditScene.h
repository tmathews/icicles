//
//  CreditScene.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-13.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "cocos2d.h"

@protocol CreditSceneDelegate;

@interface CreditScene : CCLayer {
	id<CreditSceneDelegate> delegate;
	CGPoint			startPoint;
	CGPoint			endPoint;
}

@property (nonatomic, retain) id<CreditSceneDelegate> delegate;

+ (id)sceneWithDelegate:(id<CreditSceneDelegate>)aDelegate;

@end

@protocol CreditSceneDelegate <NSObject>

- (void)creditSceneDoesWantToGoToTitleScene:(CreditScene *)creditScene;

@end