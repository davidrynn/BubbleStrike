//
//  PauseNode.swift
//  BubbleStrike
//
//  Created by David Rynn on 2/15/24.
//

import SpriteKit

class PauseNode: SKNode {
    
    init(pauseAtPosition position: CGPoint) {
        let pauseLabel :SKLabelNode = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        pauseLabel.fontColor = .white
        pauseLabel.name = "Pause"
        pauseLabel.text = "Paused"
        pauseLabel.fontSize = 32;
        pauseLabel.position = position;
        super.init()
        addChild(pauseLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
