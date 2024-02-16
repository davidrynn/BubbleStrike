//
//  GameScene.swift
//  BubbleStrike
//
//  Created by David Rynn on 1/29/24.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    private var restart: Bool = false
    private var gameOverDisplayed: Bool = false
    
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
    
    func soundSetup() {
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
    
    func addPoints(_ points: Int) {
        if !gameOverDisplayed {
            if let hud = childNode(withName: "HUD") as? HudNode {
                hud.addPoints(points)
                score = hud.score
            }
        }
    }
    
    func joinBodies(bodyA: SKPhysicsBody, secondBody bodyB: SKPhysicsBody, jointPoint point: CGPoint) {
        let joint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: point)
        physicsWorld.add(joint)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scene?.view?.isPaused == true {
            backgroundMusic?.play()
            scene?.view?.isPaused = false
        }
        
        if let touchedNode = touches.first {
            let touchPoint = touchedNode.location(in: self)
            let node = atPoint(touchPoint)
            
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
            } else if let groundNode = node as? GroundNode, groundNode.name == "Ground", !gameOverDisplayed {
                if let sceneView = scene?.view, !sceneView.isPaused {
                    performPause()
                }
            } else if restart {
                for childNode in children {
                    childNode.removeFromParent()
                }
                
                let newScene = GameScene(size: view!.bounds.size)
                view!.presentScene(newScene)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //TODO: Figure out how to compensate for paused time.
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
    
    func performPause() {
        scene?.view?.isPaused = true
        backgroundMusic?.pause()
    }
    
    func performGameOver(completionBlock: @escaping (Bool) -> Void) {
        if !gameOverDisplayed {
            let gameOver = GameOverNode(position: CGPoint(x: frame.midX, y: frame.midY), withScore: score * Int(totalGameTime / 2))
            addChild(gameOver)
            restart = true
            gameOverDisplayed = true
            gameOverMusic?.play()
            gameOver.performAnimation()
            backgroundMusic?.stop()
            completionBlock(true)
        }
    }
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func generateBubble() {
        let bubble = BubbleNode()
       // let bubble = SKShapeNode(circleOfRadius: 20)
//        bubble.fillColor = .green
        //    float dy = [Utility randomIntegerBetweenAndIncluding:100 maximum:400];
//          bubble.physicsBody = SKPhysicsBody()
        
        let y = self.frame.size.height / 2 + bubble.frame.height+30;
        let max = frame.width / 2
        let min = -max
        let x = CGFloat.random(in: (min + bubble.size.width)...(max - (bubble.frame.width)))
        bubble.position = CGPoint(x: x, y: y)
        addChild(bubble)
    
    }
    
    
}
