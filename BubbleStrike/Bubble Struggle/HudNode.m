//
//  HudNode.m
//  Bubble Struggle
//
//  Created by David Rynn on 7/12/15.
//  Copyright (c) 2015 David Rynn. All rights reserved.
//

#import "HudNode.h"

@implementation HudNode
+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame {
    HudNode *hud = [self node];
    hud.position = position;
    hud.zPosition = 10;
    hud.name = @"HUD";

    
    

    
 
    
    SKLabelNode *scoreShadowLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    scoreShadowLabel.name = @"ScoreShadow";
    scoreShadowLabel.text = @"Bubbles Popped: 0";
    scoreShadowLabel.fontColor = [UIColor grayColor];
    scoreShadowLabel.fontSize = 24;
    scoreShadowLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreShadowLabel.position = CGPointMake(frame.size.width-218, -12);
    scoreShadowLabel.zPosition =10;
    
    [hud addChild:scoreShadowLabel];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    scoreLabel.name = @"Score";
    scoreLabel.text = @"Bubbles Popped: 0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.position = CGPointMake(frame.size.width-220, -10);
    scoreLabel.zPosition =15;
    
    [hud addChild:scoreLabel];
    
    SKLabelNode *timeShadowLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    timeShadowLabel.name = @"TimeShadow";
    timeShadowLabel.text = @"0:00";
    timeShadowLabel.fontColor = [UIColor grayColor];
    timeShadowLabel.fontSize = 24;
    timeShadowLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timeShadowLabel.position = CGPointMake(22, -12);
    timeShadowLabel.zPosition =10;
    [hud addChild:timeShadowLabel];
    
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    timeLabel.name = @"Time";
    timeLabel.text = @"0:00";

    timeLabel.fontSize = 24;
    timeLabel.fontColor = [UIColor whiteColor];
    timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timeLabel.position = CGPointMake(20, -10);
    timeLabel.zPosition =15;
    [hud addChild:timeLabel];
    
    return hud;
}

- (void) addPoints:(NSInteger)points {
    self.score += points;
    
    SKLabelNode *scoreLabel = (SKLabelNode*)[self childNodeWithName:@"Score"];
    scoreLabel.text = [NSString stringWithFormat:@"Bubbles Popped:%d",self.score];
    SKLabelNode *scoreShadowLabel = (SKLabelNode*)[self childNodeWithName:@"ScoreShadow"];
    scoreShadowLabel.text = [NSString stringWithFormat:@"Bubbles Popped:%d",self.score];
    
}
- (void) addTimeInterval:(NSTimeInterval) t {
    
    NSInteger seconds = (NSInteger)t%60;
    NSInteger minutes = (NSInteger)t/60;
    SKLabelNode *timeLabel = (SKLabelNode*)[self childNodeWithName:@"Time"];
    timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",minutes, seconds];
    SKLabelNode *timeShadowLabel = (SKLabelNode*)[self childNodeWithName:@"TimeShadow"];
    timeShadowLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",minutes, seconds];
    
}

@end
