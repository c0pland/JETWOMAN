import SpriteKit
import GameplayKit

class GameScene: SKScene {
	private var symbolLabel: SKLabelNode?
	private var scoreLabel : SKLabelNode?
	private var highScoreLabel : SKLabelNode?
	private var jetwoman: SKSpriteNode?
	private var startButton: SKSpriteNode?
	private var score = 0
	private var currentCharacter: String?
	private let characterKeycodes = ["A": Keycode.a, "B": Keycode.b, "C": Keycode.c, "D": Keycode.d, "E": Keycode.e, "F": Keycode.f, "G": Keycode.g, "H": Keycode.h, "I": Keycode.i, "J": Keycode.j, "K": Keycode.k, "L": Keycode.l, "M": Keycode.m, "N": Keycode.o, "P": Keycode.p, "Q": Keycode.q, "R": Keycode.r, "S": Keycode.s, "T": Keycode.t, "U": Keycode.u, "V": Keycode.v, "W": Keycode.w, "X": Keycode.x, "y": Keycode.y, "Z": Keycode.z, "0": Keycode.zero, "1": Keycode.one, "2": Keycode.two, "3": Keycode.three, "4": Keycode.four, "5": Keycode.five, "6": Keycode.six, "7": Keycode.seven, "8": Keycode.eight, "9": Keycode.nine]
	
	override func didMove(to view: SKView) {
		self.symbolLabel = self.childNode(withName: Consts.symbolLabel) as? SKLabelNode
		self.jetwoman = self.childNode(withName: Consts.jetwoman) as? SKSpriteNode
		self.startButton = self.childNode(withName: Consts.startButton) as? SKSpriteNode
		self.scoreLabel = self.childNode(withName: Consts.score) as? SKLabelNode
		self.highScoreLabel = self.childNode(withName: Consts.highScore) as? SKLabelNode
		self.physicsWorld.contactDelegate = self
		self.symbolLabel?.isHidden = true
		scoreLabel?.text = "Score: \(score)"
		updateHighScore()
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
		if let currentCharacter = currentCharacter {
			switch event.keyCode {
			case characterKeycodes[currentCharacter]:
				if let jetwoman = jetwoman {
					jetwoman.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (300 - score * Consts.difficultyCoefficient)))
					score += 1
					chooseNextKey()
					scoreLabel?.text = "Score: \(score)"
				}
			default:
				print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
			}
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
			symbolLabel?.isHidden = false
			chooseNextKey()
		}
	}
	
	func chooseNextKey() {
		currentCharacter = characterKeycodes.randomElement()?.key
		if let symbolLabel = symbolLabel {
			symbolLabel.text = currentCharacter
		}
	}
	
	func updateHighScore () {
		let highScore = UserDefaults.standard.integer(forKey: "highScore")
		highScoreLabel?.text = "Hi Score: \(highScore)"
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
					currentCharacter = nil
					symbolLabel?.isHidden = true
				}
				// Check for high score
				let highScore = UserDefaults.standard.integer(forKey: "highScore")
				if score > highScore {
					UserDefaults.standard.set(score, forKey: "highScore")
					UserDefaults.standard.synchronize()
					highScoreLabel?.text = "Hi Score: \(score)"
				}
			}
		}
	}
}
