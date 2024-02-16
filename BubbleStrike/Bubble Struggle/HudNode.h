//
//  HudNode.h
//  Bubble Struggle
//
//  Created by David Rynn on 7/12/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger time;

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

- (void) addPoints:(NSInteger)points;
- (void) addTimeInterval: (NSTimeInterval) interval;
@end
