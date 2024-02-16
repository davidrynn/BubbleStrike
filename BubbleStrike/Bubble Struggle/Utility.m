//
//  Utility.m
//  Bubble Struggle
//
//  Created by David Rynn on 7/8/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import "Utility.h"

@implementation Utility
//+(float)randomFloatNumberBetween: (float) min : (float) max{
//
//}

+(NSUInteger)randomIntegerBetweenAndIncluding: (NSUInteger) min maximum: (NSUInteger) max{

    NSUInteger range = max - min;
    NSUInteger randomNumber = (NSUInteger)arc4random_uniform((u_int32_t)range) +1;
    NSUInteger numberToReturn = randomNumber + min;
    
    
    return numberToReturn;
}
@end
