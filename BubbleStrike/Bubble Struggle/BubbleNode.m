//
//  BubbleNode.m
//  Bubble Struggle
//
//  Created by David Rynn on 7/6/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import "BubbleNode.h"
#import "Utility.h"


#define ARC4RANDOM_MAX 0x100000000

@implementation BubbleNode

-(SKSpriteNode *)bubbleAtPosition:(CGPoint)position{
    
    SKSpriteNode *bubble = [SKSpriteNode spriteNodeWithImageNamed:@"bubble_sml_1"];
    bubble.position = position;
    bubble.name = @"bubbleNode";
    
    

    //Physics
    [self setupPhysics:bubble];

    //RandomFloating
    [self randomBubbleFloat:bubble];
    
    //Bubble Random Size
    [self randomBubbleSize:bubble];
    
    //Bubble rotations
    [self randomBubbleRotation:bubble];
    [self randomBubbleScaling:bubble];
    
    
    return bubble;
}
-(void)setupPhysics:(SKSpriteNode *)bubble {
    bubble.colorBlendFactor = .5;
    bubble.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(bubble.frame.size.width/2)-0.5];
    bubble.physicsBody.affectedByGravity = YES;
    bubble.physicsBody.categoryBitMask = CollisionCategoryBubbleTypeA;
    bubble.physicsBody.collisionBitMask = CollisionCategoryGround | CollisionCategoryBubbleTypeB | CollisionCategorySide;
    bubble.physicsBody.contactTestBitMask = CollisionCategoryGround | CollisionCategorySide | CollisionCategoryBubbleTypeB;
}

-(void)setupPhysicsTypeB:(SKSpriteNode *)bubble {
    

    //    bubble.physicsBody.velocity = CGVectorMake(0, -150);
    bubble.physicsBody.categoryBitMask = CollisionCategoryBubbleTypeB;
//    bubble.physicsBody.collisionBitMask = 0;
    bubble.physicsBody.contactTestBitMask = CollisionCategoryGround; // 0010
    
    
}

-(void)randomBubbleFloat:(SKSpriteNode *)bubble{
    
    CGVector right = CGVectorMake([self generateRandomFloatBetween:10 and:15], 0);
    CGVector left = CGVectorMake( - [self generateRandomFloatBetween:10 and:15], 0);
    
    SKAction *moveToRight = [SKAction moveBy: right duration:1.5];
    SKAction *moveToLeft =  [SKAction moveBy:left duration:1.5];
    SKAction *repeatLeftRight = [SKAction repeatActionForever:[SKAction sequence:@[moveToRight,moveToLeft]]];
    
    [bubble runAction: repeatLeftRight];

}

-(void)randomBubbleSize:(SKSpriteNode *)bubble{
    float number = ((float)[Utility randomIntegerBetweenAndIncluding:3.5 maximum:6.5])/10;
    SKAction *scale = [SKAction scaleXBy:number y:number duration:0];
    [bubble runAction:scale];
}

-(void)randomBubbleRotation:(SKSpriteNode *)bubble{
    SKAction *rotation = [SKAction rotateByAngle: M_PI/13.0 duration:1.7];
    SKAction *reverseRotation = [SKAction rotateByAngle: - M_PI/13.0 duration:1.7];
    SKAction *repeatBubbleRotation = [SKAction repeatActionForever:[SKAction sequence:@[rotation,reverseRotation]]];
    [bubble runAction: repeatBubbleRotation];
}

-(void)randomBubbleScaling:(SKSpriteNode *)bubble{
    SKAction *scaleBubbleUp = [SKAction scaleXBy:(1/1.04) y:1.04 duration:0.3];
    SKAction *scaleBubbleDown = [SKAction scaleXBy:1.04  y:(1/1.04)  duration:0.3];
    SKAction *repeatBubbleScaling = [SKAction repeatActionForever:[SKAction sequence:@[scaleBubbleUp,scaleBubbleDown]]];
    [bubble runAction:repeatBubbleScaling];
}


-(float)generateRandomFloatBetween:(float) firstNumber and:(float)secondNumber{
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (secondNumber - firstNumber) + firstNumber);

}

@end
