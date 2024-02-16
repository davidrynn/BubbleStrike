//
//  GroundNode.m
//  Bubble Struggle
//
//  Created by David Rynn on 7/10/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import "GroundNode.h"
#import "Utility.h"

@implementation GroundNode

+ (instancetype) groundWithSize:(CGSize)size {
    SKTexture *textureForGround = [SKTexture textureWithImageNamed:@"traditional-tile"];
    GroundNode *ground = [self spriteNodeWithTexture:textureForGround size:size];
    ground.name = @"Ground";
    ground.position = CGPointMake(size.width/2,size.height/2);
    [ground setupPhysicsBody];
    
    return ground;
}

    
- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryGround;
    self.physicsBody.collisionBitMask = CollisionCategoryBubbleTypeA;
}



@end
