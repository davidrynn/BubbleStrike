//
//  GameOverNode.swift
//  BubbleStrike
//
//  Created by David Rynn on 2/15/24.
//

import SpriteKit

class GameOverNode: SKNode {
    
    init(position: CGPoint, withScore score: Int) {
        super.init()
        let gameOverLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        gameOverLabel.fontColor = .blue
        gameOverLabel.name = "GameOver"
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 32
        gameOverLabel.position = position
        addChild(gameOverLabel)
        
        let gameOverScoreLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        gameOverScoreLabel.fontColor = .blue
        gameOverScoreLabel.name = "GameOver"
        gameOverScoreLabel.text = "Final Score (Pops x Time): \(score)"
        gameOverScoreLabel.fontSize = 22
        gameOverScoreLabel.position = CGPoint(x: position.x, y: position.y - 80)
        addChild(gameOverScoreLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performAnimation() {
        if let label = childNode(withName: "GameOver") as? SKLabelNode {
            label.xScale = 0
            label.yScale = 0
            
            let scaleUp = SKAction.scale(to: 1.2, duration: 0.75)
            let scaleDown = SKAction.scale(to: 0.9, duration: 0.25)
            let run = SKAction.run {
                let touchToRestart = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
                touchToRestart.text = "Touch To Restart"
                touchToRestart.fontSize = 24
                touchToRestart.fontColor = .blue
                touchToRestart.position = CGPoint(x: label.position.x, y: label.position.y - 40)
                self.addChild(touchToRestart)
            }
            
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown, run])
            label.run(scaleSequence)
        }
    }
}

