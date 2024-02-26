//
//  SideNode.swift
//  BubbleStrike
//
//  Created by David Rynn on 2/15/24.
//

import SpriteKit

final class SideNode: SKSpriteNode {
    
    init(frame: CGRect, isLeft: Bool) {
        let textureForGround: SKTexture = SKTexture(imageNamed: "traditional-tile")
        super.init(texture: textureForGround, color: .clear, size: CGSize(width: 20, height: frame.height))
        if (isLeft) {
            name = "LeftSide"
            position = CGPoint(x: (-frame.width/2), y: 0)
        } else {
            name = "RightSide"
            position = CGPoint(x: (frame.width) / 2, y: 0)
        }
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.isDynamic = false;
        self.physicsBody?.categoryBitMask = CollisionCategory.side.rawValue
        //        self.physicsBody.collisionBitMask = CollisionCategoryDebris;
        //        self.physicsBody.contactTestBitMask = CollisionCategoryEnemy;
    }


}
