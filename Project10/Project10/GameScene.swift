//
//  GameScene.swift
//  Project10
//
//  Created by Виктор on 25.02.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var countOfBallsLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var balls = ["Blue", "Yellow", "Purple", "Grey", "Red", "Cyan", "Green"]
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    var countOfBalls = 5 {
        didSet {
            countOfBallsLabel.text = "Balls: \(countOfBalls)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        
        countOfBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        countOfBallsLabel.text = "Balls: 5"
        countOfBallsLabel.horizontalAlignmentMode = .right
        countOfBallsLabel.position = CGPoint(x: 580, y: 700)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        addChild(background)
        addChild(scoreLabel)
        addChild(countOfBallsLabel)
        addChild(editLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    
                    box.name = "box"
                    
                    addChild(box)
                } else if countOfBalls != 0{
                    let ball = SKSpriteNode(imageNamed: "ball" + "\(balls[Int.random(in: 0...balls.count - 1)])")
                    
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.position = CGPoint(x: location.x, y: 700)
                    ball.name = "ball"
                    countOfBalls -= 1
                    addChild(ball)
                }
            }
        }
    }
        
    
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode){
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            countOfBalls += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "box" {
            destroy(ball: object)
        }
    }
    
    func destroy(ball: SKNode){
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }

    func didBegin(_ contact: SKPhysicsContact){
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
        
        if nodeA.name == "box" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "box" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
