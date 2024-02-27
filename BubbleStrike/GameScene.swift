//
//  GameScene.swift
//  BubbleStrike
//
//  Created by David Rynn on 1/29/24.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var lastPoint: CGPoint?
    var newPoint: CGPoint = CGPoint(x: 100.0, y: 100.0)
    var line: SKShapeNode?

    
    private var lastUpdateTimeInterval: TimeInterval = 0
    private var timeSinceBubbleAdded: TimeInterval = 0
    private var addBubbleTimeInterval: TimeInterval = 0.5
    private var totalGameTime: TimeInterval = 0
    private var popSFX: SKAction!
    private var spawnSFX: SKAction!
    private var backgroundMusic: AVAudioPlayer?
    private var gameOverMusic: AVAudioPlayer?
    private var score: Int = 0
    private var pauseLabel: SKLabelNode?
    private var addBubbleToggle: Bool = false
    private var gameOver: Bool = false
    private var shouldRestart: Bool = false
    private var gameOverDisplayed: Bool = false
    
    // MARK: Lifecycle
    
    override func didMove(to view: SKView) {
        lastUpdateTimeInterval = 0
        timeSinceBubbleAdded = 0
        addBubbleTimeInterval = 0.5
        totalGameTime = 0

        size = view.frame.size
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.08)
        
        let centerScreen = CGPoint(x: frame.midX, y: frame.midY)
        let background = SKSpriteNode(imageNamed: "bubble")
        background.position = centerScreen
        background.zPosition = -1
        addChild(background)
        
        let groundSize = CGSize(width: size.width, height: 54)
        let ground = GroundNode(size: groundSize)
        ground.position = CGPoint(x: 0, y: -size.height / 2 + ground.size.height)
        ground.zPosition = 2
        addChild(ground)
        
        let leftSide = SideNode(frame: frame, isLeft: true)
        leftSide.zPosition = 15
        addChild(leftSide)
        
        let rightSide = SideNode(frame: frame, isLeft: false)
        rightSide.zPosition = 14
        addChild(rightSide)
        
        let hud = HudNode(position: CGPoint(x: 0, y: 0), frame: frame)
        hud.zPosition = 15
        hud.position = CGPoint(x: -size.width / 2, y: ground.position.y)
        addChild(hud)
        
        soundSetup()
        backgroundMusic?.play()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //TODO: Figure out how to compensate for paused time.
        //need to enumerate though all nodes and if node height is greater than ceiling ---> game over. 667?
        enumerateChildNodes(withName: "BubbleNode") { [weak self] node, stop in
            guard let self else { return }
            if (node.physicsBody?.categoryBitMask == CollisionCategory.bubbleB.rawValue &&  node.position.y>(frame.size.height / 2 )) {
                self.performGameOver { success in
                    return
                }
            }
        }

        if !gameOverDisplayed {
            if let hud = childNode(withName: "HUD") as? HudNode {
                hud.addTimeInterval(totalGameTime)
            }
        }
        
        if lastUpdateTimeInterval > 0 {
            timeSinceBubbleAdded += currentTime - lastUpdateTimeInterval
            totalGameTime += currentTime - lastUpdateTimeInterval
        }
        
        if timeSinceBubbleAdded > addBubbleTimeInterval, !gameOver {
            generateBubble()
            timeSinceBubbleAdded = 0
        }
        
        lastUpdateTimeInterval = currentTime
        
        if totalGameTime > 480 && addBubbleToggle {
            addBubbleToggle = false
            addBubbleTimeInterval *= 0.75
        } else if totalGameTime > 240 && totalGameTime <= 480 && !addBubbleToggle {
            addBubbleToggle = true
            addBubbleTimeInterval *= 0.75
        } else if totalGameTime > 20 && totalGameTime <= 240 && addBubbleToggle {
            addBubbleToggle = false
            addBubbleTimeInterval *= 0.75
        } else if totalGameTime > 10 && totalGameTime <= 20 && !addBubbleToggle {
            addBubbleToggle = true
            addBubbleTimeInterval *= 0.75
        }
    }
    
    // MARK: Setup
    
    private func soundSetup() {
        if let url = Bundle.main.url(forResource: "BubbleIntro2wBass", withExtension: "m4a") {
            backgroundMusic = try? AVAudioPlayer(contentsOf: url)
            backgroundMusic?.numberOfLoops = -1
            backgroundMusic?.volume = 0.3
            backgroundMusic?.prepareToPlay()
        }
        
        popSFX = SKAction.playSoundFileNamed("bubbleSpawn3.caf", waitForCompletion: false)
        spawnSFX = SKAction.playSoundFileNamed("bubbleSpawn3.caf", waitForCompletion: true)
        
        if let gameOverURL = Bundle.main.url(forResource: "gameOver", withExtension: "m4a") {
            gameOverMusic = try? AVAudioPlayer(contentsOf: gameOverURL)
            gameOverMusic?.volume = 0.3
            gameOverMusic?.numberOfLoops = 1
            gameOverMusic?.prepareToPlay()
        }
    }
    
    
    private func generateBubble() {
        let bubble = BubbleNode()
        let y = self.frame.size.height / 2 + bubble.frame.height+30;
        let max = frame.width / 2
        let min = -max
        let x = CGFloat.random(in: (min + bubble.size.width)...(max - (bubble.frame.width)))
        bubble.position = CGPoint(x: x, y: y)
        addChild(bubble)
    }
    
    // MARK: Actions
    
    // MARK: Touch Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scene?.view?.isPaused == true {
            backgroundMusic?.play()
            scene?.view?.isPaused = false
        }
        deleteLine()
        if let touchedNode = touches.first {
            let touchPoint = touchedNode.location(in: self)
            let node = atPoint(touchPoint)
            if let _ = node as? RestartNode {
                restart()
                return
            }
            

  

            popBubbleOnContact(node: node, touchPoint: touchPoint)
            
            if let groundNode = node as? GroundNode, groundNode.name == "Ground", !gameOverDisplayed {
                if let sceneView = scene?.view, !sceneView.isPaused {
                    performPause()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchedNode = touches.first {
            let touchPoint = touchedNode.location(in: self)
            let node = atPoint(touchPoint)
            
            if let lastPoint {
                newPoint = touchPoint
                
                line = SKShapeNode()
                let path = CGMutablePath()
                path.addLines(between: [lastPoint, newPoint])
                line?.path = path
                line?.strokeColor = .black
                line?.lineWidth = 2
                addChild(line ?? SKShapeNode())
            }
            self.lastPoint = newPoint
 
            
            popBubbleOnContact(node: node, touchPoint: touchPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        deleteLine()
    }
    
    func popBubbleOnContact(node: SKNode, touchPoint: CGPoint) {
        if let bubbleNode = node as? BubbleNode, bubbleNode.name == "BubbleNode", !gameOverDisplayed, !scene!.view!.isPaused {
            bubbleNode.removeFromParent()
            addPoints(1)
            if let popNode = SKEmitterNode(fileNamed: "PopParticle") {
                popNode.position = touchPoint
                addChild(popNode)
                run(popSFX)
                popNode.run(SKAction.wait(forDuration: 2.0), completion: {
                    popNode.removeFromParent()
                })
            }
        }
    }
    
    private func deleteLine() {
        lastPoint = nil
        line?.removeFromParent()
        line = nil
    }
    
    // MARK: Game Life Cycle
    
    private func restart() {
        for childNode in children {
            childNode.removeFromParent()
        }
        if let view, let gameScene:GameScene = GameScene(fileNamed: "GameScene") // create your new scene
        {
            let transition = SKTransition.fade(withDuration: 1.0) // create type of transition (you can check in documentation for more transtions)
            gameScene.scaleMode = SKSceneScaleMode.fill
            view.presentScene(gameScene, transition: transition)
        }
    }
    
    private func performPause() {
        scene?.view?.isPaused = true
        backgroundMusic?.pause()
    }
    
    private func performGameOver(completionBlock: @escaping (Bool) -> Void) {
        if !gameOverDisplayed {
            let gameOver = GameOverNode(position: CGPoint(x: frame.midX, y: frame.midY), withScore: score * Int(totalGameTime / 2))
            let restartNode = RestartNode(position: CGPoint(x: frame.midX, y: frame.midY))
            restartNode.position.y = frame.midY - 100
            addChild(gameOver)
            addChild(restartNode)
            
            shouldRestart = true
            gameOverDisplayed = true
            gameOverMusic?.play()
            gameOver.performAnimation()
            restartNode.performAnimation()
            backgroundMusic?.stop()
            completionBlock(true)
        }
    }
    
    // MARK: Utilities
    
    private func addPoints(_ points: Int) {
        if !gameOverDisplayed {
            if let hud = childNode(withName: "HUD") as? HudNode {
                hud.addPoints(points)
                score = hud.score
            }
        }
    }
    
    private func joinBodies(bodyA: SKPhysicsBody, secondBody bodyB: SKPhysicsBody, jointPoint point: CGPoint) {
        let joint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: point)
        physicsWorld.add(joint)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody, secondBody: SKPhysicsBody
        //typeB
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if (
            firstBody.categoryBitMask == CollisionCategory.bubbleA.rawValue &&
            ((secondBody.categoryBitMask == CollisionCategory.ground.rawValue) ||
             (secondBody.categoryBitMask == CollisionCategory.bubbleB.rawValue )) )
        {
            joinBodies(bodyA: firstBody, secondBody: secondBody, jointPoint: contact.contactPoint)
//            [self joinBodies:firstBody secondBody:secondBody jointPoint:contact.contactPoint];
            let bubble = firstBody.node as? BubbleNode
//            BubbleNode *bubble = (BubbleNode *) firstBody.node;
            bubble?.colorBlendFactor = 0;
            bubble?.physicsBody?.categoryBitMask = CollisionCategory.bubbleB.rawValue;
            bubble?.physicsBody?.collisionBitMask = CollisionCategory.ground.rawValue | CollisionCategory.bubbleA.rawValue | CollisionCategory.side.rawValue | CollisionCategory.bubbleB.rawValue;
    //        bubble.physicsBody.contactTestBitMask = CollisionCategoryCeiling;

        }
        
        if (
            firstBody.categoryBitMask == CollisionCategory.bubbleB.rawValue &&
            ( secondBody.categoryBitMask == CollisionCategory.bubbleB.rawValue) )
        {
            joinBodies(bodyA: firstBody, secondBody: secondBody, jointPoint: contact.contactPoint)
        }
        
    }
}
