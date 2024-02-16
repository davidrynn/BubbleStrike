//
//  PauseNode.m
//  Bubble Struggle
//
//  Created by David Rynn on 7/13/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import "PauseNode.h"

@implementation PauseNode
+ (instancetype) pauseAtPosition:(CGPoint)position  {
    PauseNode *pause = [self node];
    
    SKLabelNode *pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    pauseLabel.fontColor =[UIColor whiteColor];
    pauseLabel.name = @"Pause";
    pauseLabel.text = @"Paused";
    pauseLabel.fontSize = 32;
    pauseLabel.position = position;
    [pause addChild:pauseLabel];
    
    return pause;
}
@end
