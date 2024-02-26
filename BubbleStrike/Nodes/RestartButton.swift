//
//  RestartButton.swift
//  BubbleStrike
//
//  Created by David Rynn on 2/25/24.
//

import SpriteKit

class RestartNode: SKLabelNode {
        
    init(position: CGPoint) {

        super.init()
        fontName = "Futura-CondensedExtraBold"
        fontColor = .red
        name = "RestartButton"
        text = "Touch To Restart"
        fontSize = 22

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performAnimation() {
            xScale = 0
            yScale = 0
            
            let scaleUp = SKAction.scale(to: 1.2, duration: 0.75)
            let scaleDown = SKAction.scale(to: 0.9, duration: 0.25)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            run(scaleSequence)
    }
    
}
