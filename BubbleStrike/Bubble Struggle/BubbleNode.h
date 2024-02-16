//
//  BubbleNode.h
//  Bubble Struggle
//
//  Created by David Rynn on 7/6/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, BubbleType) {

    BubbleTypeA  = 0,
    BubbleTypeB  = 1

};

@interface BubbleNode : SKSpriteNode


-(SKSpriteNode *)bubbleAtPosition: (CGPoint) position;
-(void)setupPhysicsTypeB:(SKSpriteNode *)bubble;
@end
