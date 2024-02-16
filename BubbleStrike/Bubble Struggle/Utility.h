//
//  Utility.h
//  Bubble Struggle
//
//  Created by David Rynn on 7/8/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryBubbleTypeA = 1 << 0,       // 0000
    CollisionCategoryBubbleTypeB =1  << 1,      // 0010
    CollisionCategoryGround     = 1 << 3,       // 0100
    CollisionCategorySide       = 1 << 4,        // 1000
    CollisionCategoryCeiling    = 1 << 5

};



@interface Utility : NSObject
//how to stack, and change states
//particles
//game over
//random timing generation
//frame problem
//+(float)randomFloatNumberBetween: (float) min : (float) max;
//get ground to work and remove the stop at floor

+(NSUInteger)randomIntegerBetweenAndIncluding: (NSUInteger) min maximum: (NSUInteger) max;
@end
