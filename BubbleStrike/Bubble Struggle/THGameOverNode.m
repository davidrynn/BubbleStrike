//
//  THGameOverNode.m
//  Space Cat
//
//  Created by Amit Bijlani on 5/29/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THGameOverNode.h"

@implementation THGameOverNode
+ (instancetype) gameOverAtPosition:(CGPoint)position withScore: (NSInteger) score {
    THGameOverNode *gameOver = [self node];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverLabel.fontColor =[UIColor blueColor];
    gameOverLabel.name = @"GameOver";
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 32;
    gameOverLabel.position = position;
    [gameOver addChild:gameOverLabel];
    
    SKLabelNode *gameOverScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverScoreLabel.fontColor =[UIColor blueColor];
    gameOverScoreLabel.name = @"GameOver";
    gameOverScoreLabel.text = [NSString stringWithFormat:@"Final Score (Pops x Time): %ld", score];
    gameOverScoreLabel.fontSize = 22;
    gameOverScoreLabel.position = CGPointMake(position.x, position.y -80);
    [gameOver addChild:gameOverScoreLabel];
    
    return gameOver;
}

- (void) performAnimation {
    SKLabelNode *label = (SKLabelNode*)[self childNodeWithName:@"GameOver"];
    label.xScale = 0;
    label.yScale = 0;
    SKAction *scaleUp = [SKAction scaleTo:1.2f duration:0.75f];
    SKAction *scaleDown = [SKAction scaleTo:0.9f duration:0.25f];
    SKAction *run = [SKAction runBlock:^{
        SKLabelNode *touchToRestart = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        touchToRestart.text = @"Touch To Restart";
        touchToRestart.fontSize = 24;
        touchToRestart.fontColor = [UIColor blueColor];
        touchToRestart.position = CGPointMake(label.position.x, label.position.y-40);
        [self addChild:touchToRestart];
    }];
    
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp,scaleDown,run]];
    [label runAction:scaleSequence];
    
}

@end






















