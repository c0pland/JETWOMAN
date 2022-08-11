//
//  GameScene.swift
//  JETWOMAN
//
//  Created by Богдан Беннер on 09.08.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var scoreLabel : SKLabelNode?
	private var highScoreLabel : SKLabelNode?
	private var jetwoman: SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
		self.jetwoman = self.childNode(withName: Consts.jetwoman) as? SKSpriteNode
		self.physicsWorld.contactDelegate = self
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
		case 0x31:
			if let jetwoman = jetwoman {
				jetwoman.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
			}
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		print("Contact")
		if contact.bodyA.categoryBitMask == Consts.spikesCategoryMask || contact.bodyB.categoryBitMask == Consts.spikesCategoryMask {
			// GAME OVER
			print("GAME OVER")
		}
	}
}
