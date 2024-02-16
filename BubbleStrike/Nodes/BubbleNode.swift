//
//  BubbleNode.swift
//  BubbleStrike
//
//  Created by David Rynn on 1/29/24.
//

import SpriteKit

enum BubbleType: Int {
    case a = 0
    case b = 1
}

class BubbleNode: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "bubble_sml_1")
        let size = CGSize(width: 80, height: 80)
        super.init(texture: texture, color: .white, size: size)
        self.position = position
        name = "BubbleNode"
        setupPhysics()
        randomBubbleFloating()
        randomBubbleSize()
        randomBubbleRotation()
        randomBubbleScaling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysics(){
        colorBlendFactor = 0.5
        physicsBody = SKPhysicsBody(circleOfRadius: (frame.size.width/2) - 0.5)
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = CollisionCategory.bubbleA.rawValue;
        physicsBody?.collisionBitMask = CollisionCategory.ground.rawValue | CollisionCategory.bubbleB.rawValue | CollisionCategory.side.rawValue;
        physicsBody?.contactTestBitMask = CollisionCategory.ground.rawValue | CollisionCategory.side.rawValue | CollisionCategory.bubbleB.rawValue;
    }

    private func setupPhysicsTypeB() {
    //    bubble.physicsBody.velocity = CGVectorMake(0, -150);
        physicsBody?.categoryBitMask = CollisionCategory.bubbleB.rawValue;
    //    bubble.physicsBody.collisionBitMask = 0;
        physicsBody?.contactTestBitMask = CollisionCategory.ground.rawValue // 0010
    }

    private func randomBubbleFloating(){
        let right: CGVector = CGVector(dx: Int.random(in: 10..<15), dy: 0)
        let left = CGVector(dx: -Int.random(in: 10..<15), dy: 0)
        let moveToRight: SKAction = SKAction.move(by: right, duration: 1.5)
        let moveToLeft: SKAction = SKAction.move(by: left, duration: 1.5)
        let sequenceRepeat = SKAction.sequence([moveToRight, moveToLeft])
        let repeatLeftRight = SKAction.repeatForever(sequenceRepeat)
        run(repeatLeftRight)
    }

    private func randomBubbleSize() {
        let scaleNumber = CGFloat.random(in: 3.5...6.5) / 10
        let scale = SKAction.scaleX(by: scaleNumber, y: scaleNumber, duration: 0)
        run(scale)
    }

    private func randomBubbleRotation() {
        let rotation = SKAction.rotate(byAngle: Double.pi/13.0, duration: 1.7)
        let reverseRotation = SKAction.rotate(byAngle: -Double.pi/13.0, duration: 1.7)
        let sequenceRotations = SKAction.sequence([rotation, reverseRotation])
        let repeateRotations = SKAction.repeatForever(sequenceRotations)
        run(repeateRotations)
    }
    
    private func randomBubbleScaling() {
        let scaleUp = SKAction.scaleX(by: 1/1.04, y: 1.04, duration: 0.3)
        let scaleDown = SKAction.scaleX(by: 1.04, y: 1/1.04, duration: 0.3)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction)
    }

}
