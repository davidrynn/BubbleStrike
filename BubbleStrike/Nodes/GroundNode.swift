//
//  GroundNode.swift
//  BubbleStrike
//
//  Created by David Rynn on 2/15/24.
//

import SpriteKit

final class GroundNode: SKSpriteNode {
    
    init(size: CGSize) {
        let textureForGround: SKTexture = SKTexture(imageNamed: "traditional-tile")
        super.init(texture: textureForGround, color: .black, size: size)
        name = "Ground"
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func groundWithSize(size: CGSize) -> GroundNode {
//        let textureForGround: SKTexture = SKTexture(imageNamed: "traditional-tile")
//        let ground: GroundNode =  GroundNode(texture: textureForGround, size: size)
//        ground.name = "Ground";
//        ground.position = CGPointMake(size.width/2,size.height/2);
//        ground.setupPhysicsBody()
//        return ground;
//    }

        
    private func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.isDynamic = false;
        self.physicsBody?.categoryBitMask = CollisionCategory.ground.rawValue;
        self.physicsBody?.collisionBitMask = CollisionCategory.bubbleA.rawValue;
    }
}
