//
//  HudNode.swift
//  BubbleStrike
//
//  Created by David Rynn on 2/15/24.
//

import SpriteKit

final class HudNode: SKSpriteNode {
    
    var score: Int = 0
    
    init(position: CGPoint, frame: CGRect) {
        super.init(texture: nil, color: .clear, size: CGSize(width: 100, height: 20))
//            self.position = position
            self.zPosition = 10
            self.name = "HUD"
            
            let scoreShadowLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
            scoreShadowLabel.name = "ScoreShadow"
            scoreShadowLabel.text = "Bubbles Popped: 0"
            scoreShadowLabel.fontColor = .gray
            scoreShadowLabel.fontSize = 24
            scoreShadowLabel.horizontalAlignmentMode = .left
            scoreShadowLabel.position = CGPoint(x: frame.size.width - 218, y: -12)
            scoreShadowLabel.zPosition = 10
            addChild(scoreShadowLabel)
            
            let scoreLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
            scoreLabel.name = "Score"
            scoreLabel.text = "Bubbles Popped: 0"
            scoreLabel.fontSize = 24
            scoreLabel.horizontalAlignmentMode = .left
            scoreLabel.position = CGPoint(x: frame.size.width - 220, y: -10)
            scoreLabel.zPosition = 15
            addChild(scoreLabel)
            
            let timeShadowLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
            timeShadowLabel.name = "TimeShadow"
            timeShadowLabel.text = "0:00"
            timeShadowLabel.fontColor = .gray
            timeShadowLabel.fontSize = 24
            timeShadowLabel.horizontalAlignmentMode = .left
            timeShadowLabel.position = CGPoint(x: 22, y: -12)
            timeShadowLabel.zPosition = 10
            addChild(timeShadowLabel)
            
            let timeLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
            timeLabel.name = "Time"
            timeLabel.text = "0:00"
            timeLabel.fontSize = 24
            timeLabel.fontColor = .white
            timeLabel.horizontalAlignmentMode = .left
            timeLabel.position = CGPoint(x: 20, y: -10)
            timeLabel.zPosition = 15
            addChild(timeLabel)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPoints(_ points: Int) {
        score += points
        
        if let scoreLabel = childNode(withName: "Score") as? SKLabelNode,
           let scoreShadowLabel = childNode(withName: "ScoreShadow") as? SKLabelNode {
            scoreLabel.text = "Bubbles Popped: \(score)"
            scoreShadowLabel.text = "Bubbles Popped: \(score)"
        }
    }
    
    func addTimeInterval(_ time: TimeInterval) {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60
        
        if let timeLabel = childNode(withName: "Time") as? SKLabelNode,
           let timeShadowLabel = childNode(withName: "TimeShadow") as? SKLabelNode {
            timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            timeShadowLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
}
/*

 - (void) addTimeInterval:(NSTimeInterval) t {
     
     NSInteger seconds = (NSInteger)t%60;
     NSInteger minutes = (NSInteger)t/60;
     SKLabelNode *timeLabel = (SKLabelNode*)[self childNodeWithName:@"Time"];
     timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",minutes, seconds];
     SKLabelNode *timeShadowLabel = (SKLabelNode*)[self childNodeWithName:@"TimeShadow"];
     timeShadowLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",minutes, seconds];
     
 }

 @end

 */
