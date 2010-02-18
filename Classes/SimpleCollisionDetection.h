//
//  SimpleCollisionDetection.h
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleCollisionDetection : NSObject

+ (BOOL)lineIntersectsWithLine:(CGPoint)pA pointB:(CGPoint)pB pointC:(CGPoint)pC pointD:(CGPoint)pD;
+ (BOOL)lineIntersectsWithRect:(CGRect)rect pointA:(CGPoint)pA pointB:(CGPoint)pB;
+ (BOOL)pointInsideRect:(CGRect)rect point:(CGPoint)point;
+ (BOOL)pointInsideCircleRadius:(float)radius circleCenterPoint:(CGPoint)circlePoint againstPoint:(CGPoint)point;
+ (float)getAngleBetweenPoints:(CGPoint)pA pointB:(CGPoint)pB;
+ (float)calculateDistanceBetweenPoints:(CGPoint)pA pointB:(CGPoint)pB;

@end
