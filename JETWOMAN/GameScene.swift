import SpriteKit
import GameplayKit

class GameScene: SKScene {
	private var scoreLabel : SKLabelNode?
	private var highScoreLabel : SKLabelNode?
	private var jetwoman: SKSpriteNode?
	private var startButton: SKSpriteNode?
	private var score = 0
	
	override func didMove(to view: SKView) {
		self.jetwoman = self.childNode(withName: Consts.jetwoman) as? SKSpriteNode
		self.startButton = self.childNode(withName: Consts.startButton) as? SKSpriteNode
		self.scoreLabel = self.childNode(withName: Consts.score) as? SKLabelNode
		self.highScoreLabel = self.childNode(withName: Consts.highScore) as? SKLabelNode
		self.physicsWorld.contactDelegate = self
		scoreLabel?.text = "Score: \(score)"
	}
	
	override func mouseDown(with event: NSEvent) {
		let pointClicked = event.location(in: self)
		let nodesAtPoint = nodes(at: pointClicked)
		for node in nodesAtPoint {
			if node.name == Consts.startButton {
				print("START")
				startGame()
			}
		}
	}
	
	override func keyDown(with event: NSEvent) {
		switch event.keyCode {
		case 0x31:
			if let jetwoman = jetwoman {
				jetwoman.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
				score += 1
				scoreLabel?.text = "Score: \(score)"
			}
		default:
			print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
	
	func startGame() {
		if let jetwoman = jetwoman {
			jetwoman.position = CGPoint(x: 0,y: 0)
			jetwoman.physicsBody?.pinned = false
			startButton?.removeFromParent()
			score = 0
			scoreLabel?.text = "Score: \(score)"
			
		}
	}
}

extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		print("Contact")
		if contact.bodyA.categoryBitMask == Consts.spikesCategoryMask || contact.bodyB.categoryBitMask == Consts.spikesCategoryMask {
			// GAME OVER
			print("GAME OVER")
			if let startButton = self.startButton {
				if startButton.parent != self {
					addChild(startButton)
				}
			}
		}
	}
}
