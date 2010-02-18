//
//  SimpleCollisionDetection.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-10.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "SimpleCollisionDetection.h"

@implementation SimpleCollisionDetection

+ (BOOL)lineIntersectsWithLine:(CGPoint)pA pointB:(CGPoint)pB pointC:(CGPoint)pC pointD:(CGPoint)pD {
    int d   =   (pD.y - pC.y)*(pB.x-pA.x) - (pD.x - pC.x)*(pB.y-pA.y);
    int n_a =   (pD.x - pC.x)*(pA.y-pC.y) - (pD.y - pC.y)*(pA.x-pC.x);
    int n_b =   (pB.x - pA.x)*(pA.y - pC.y) - (pB.y - pA.y)*(pA.x - pC.x);
	
    if(d == 0) return 0;
	
    int ua = (n_a << 14)/d;
    int ub = (n_b << 14)/d;
    
    if(ua >=0 && ua <= (1<<14) && ub >= 0 && ub <= (1<<14)) {
        return YES;
    }
    return NO;
}

+ (BOOL)lineIntersectsWithRect:(CGRect)rect pointA:(CGPoint)pA pointB:(CGPoint)pB {
	
	int numOfLinesIntersecting = 0;
	
	if ([self lineIntersectsWithLine:CGPointMake(rect.origin.x, rect.origin.y)  //line 1 top side of rectangle
							  pointB:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y) 
							  pointC:pA 
							  pointD:pB]) {
		numOfLinesIntersecting++;
	}
	if ([self lineIntersectsWithLine:CGPointMake(rect.origin.x  + rect.size.width, rect.origin.y) //line 2 right side of rectangle
							  pointB:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y - rect.size.height) 
							  pointC:pA 
							  pointD:pB]) {
		numOfLinesIntersecting++;
	}
	if ([self lineIntersectsWithLine:CGPointMake(rect.origin.x, rect.origin.y - rect.size.height) //line 3 bottom side of rectangle
							  pointB:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y - rect.size.height) 
							  pointC:pA 
							  pointD:pB]) {
		numOfLinesIntersecting++;
	}
	if ([self lineIntersectsWithLine:CGPointMake(rect.origin.x, rect.origin.y) //line 4 left side of rectangle
							  pointB:CGPointMake(rect.origin.x, rect.origin.y - rect.size.height) 
							  pointC:pA 
							  pointD:pB]) {
		numOfLinesIntersecting++;
	}
	
	if(numOfLinesIntersecting > 0) return YES;
	else return NO;
}

+ (BOOL)pointInsideRect:(CGRect)rect point:(CGPoint)point {
	if(
	   (point.x > rect.origin.x && point.x < rect.size.width + rect.origin.x) &&
	   (point.y < rect.origin.y && point.y > rect.origin.y - rect.size.height)
	   ) return YES;
	
	return NO;
}

+ (BOOL)pointInsideCircleRadius:(float)radius circleCenterPoint:(CGPoint)circlePoint againstPoint:(CGPoint)point {
	/*
	 In general, x and y must satisfy (x-center_x)^2 + (y - center_y)^2 < radius^2.
	 
	 Please note that points that satisfy the above equation 
	 with < replaced by == are considered the points on the circle, 
	 and the points that satisfy the above equation with < replaced
	 by > are consider the exterior of the circle.
	 */
	if(
	   ((point.x - circlePoint.x) * (point.x - circlePoint.x)) + 
	   ((point.y - circlePoint.y) * (point.y - circlePoint.y)) <
	   (radius * radius)
	   ) return YES;
	return NO;
}

+ (float)getAngleBetweenPoints:(CGPoint)pA pointB:(CGPoint)pB {
	return atan2((pB.y - pA.y), (pB.x - pA.x));
}

+ (float)calculateDistanceBetweenPoints:(CGPoint)pA pointB:(CGPoint)pB {
	float disX = pA.x - pB.x;
	float disY = pA.y - pB.y;
	return sqrt( (disX * disX) + (disY * disY) );
}



@end
