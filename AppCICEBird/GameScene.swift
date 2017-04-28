//
//  GameScene.swift
//  AppCICEBird
//
//  Created by cice on 21/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import SpriteKit
import GameplayKit



//El delegado lo insertamos con posterioridad para controlar las fisicas de colisiones
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: - Variables LOCALES
    var background : SKSpriteNode?
    var bird : SKSpriteNode?
    var pipeFinal1 = SKSpriteNode()
    var pipeFinal2 = SKSpriteNode()
    var limitLand = SKNode()
    var timer = Timer()
    
    //GRUPOS DE COLISIONES -> Insertamos este grupo tras crear pipes y movimientos
    let birdGroup: UInt32 = 1
    let objectGroup: UInt32 = 2
    let gapGroup: UInt32 = 4
    let movingGroup = SKNode()
    
    //GRUPO DE LABELS
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var gameOver = false
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5.0) //Modificamos la gravedad
        self.addChild(movingGroup)
        
        makeLimitLand()
        makeBackground()
        makeLoopPipe1AndPipe2()
        makeBird()
        makeLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameOver {
            bird?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
        } else {
            resetGame()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup{
            score += 1
            scoreLabel.text = String(score)
        } else if !gameOver {
            gameOver = true
            movingGroup.speed = 0
            timer.invalidate()
            makeLabelGameOver()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    //MARK: - UTILS
    func makeBird() {
        
        //creacion de las texturas
        let birdTexture1 = SKTexture(imageNamed: "flappy1")
        let birdTexture2 = SKTexture(imageNamed: "flappy2")
        
        //primera accion
        let animationBird = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.1)
        
        //accion continuada en el tiempo
        let makeBirdForever = SKAction.repeatForever(animationBird)
        
        //asignar la textura a SKSpriteNode
        bird = SKSpriteNode(texture: birdTexture1)
        
        //posicion en el espacio
        bird?.position = CGPoint(x: 0, y: 0)
        bird?.zPosition = 15
        
        //GRUPO DE FISICAS
        bird?.physicsBody = SKPhysicsBody(circleOfRadius: (bird?.size.width)! / 2)
        /*bird?.physicsBody = SKPhysicsBody(texture: birdTexture1,
                                          alphaThreshold: 0.5,
                                          size: CGSize(width: (bird?.size.width)!, height: (bird?.size.height)!))*/
        
        bird?.physicsBody?.isDynamic = true
        bird?.physicsBody?.allowsRotation = false
        
        //Nueva insserccion
        bird?.physicsBody?.categoryBitMask = birdGroup
        bird?.physicsBody?.collisionBitMask = objectGroup
        bird?.physicsBody?.contactTestBitMask = objectGroup | gapGroup
        
        //animacion
        bird?.run(makeBirdForever)
    
        //self.addChild(bird!)
        
        self.addChild(bird!)
        
    }
    
    func makeBackground() {
        
        let backgroundFinal = SKTexture(imageNamed: "bg")
        let moveBackground = SKAction.moveBy(x: -backgroundFinal.size().width, y: 0, duration: 9)
        let replaceBackground = SKAction.moveBy(x: backgroundFinal.size().width, y: 0, duration: 0)
        
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for c_imagen in 0..<3 {
            background = SKSpriteNode(texture: backgroundFinal)
            background?.position = CGPoint(x: -(backgroundFinal.size().width/2) + (backgroundFinal.size().width * CGFloat(c_imagen)), y: 0)
            background?.zPosition = 1
            background?.size.height = self.frame.height
            background?.run(moveBackgroundForever)
            
            //self.addChild(background!)
            
            //asignamos el movingroup
            self.movingGroup.addChild(background!)
        }
        
    }
    
    func makeLimitLand() {
        limitLand.position = CGPoint(x: 0, y: -(self.frame.height / 2))
        limitLand.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        limitLand.physicsBody?.isDynamic = false
        
        //Nueva inserccion -> Insertamos estas lineas para controlar la fisica de colisiones
        limitLand.physicsBody?.categoryBitMask = objectGroup
        
        limitLand.zPosition = 2
        self.addChild(limitLand)
    }
    
    
    func makeLoopPipe1AndPipe2() {
        
        timer = Timer.scheduledTimer(timeInterval: 3,
                                     target: self,
                                     selector: #selector(makePipeFinal),
                                     userInfo: nil,
                                     repeats: true)
   
    }
    
    func makePipeFinal() {
        let gapHeight = (bird?.size.height)! * 4
        let movementAmount = arc4random_uniform(UInt32(self.frame.height / 2))
        let pipeOffset = CGFloat(movementAmount) - (self.frame.height / 4)
        
        //creamos el pipe1
        let pipeTexture1 = SKTexture(imageNamed: "pipe1")
        pipeFinal1 = SKSpriteNode(texture: pipeTexture1)
        pipeFinal1.position = CGPoint(x: self.frame.width / 2,
                                      y: (pipeFinal1.size.height / 2) + (gapHeight / 2) + pipeOffset)
        pipeFinal1.physicsBody = SKPhysicsBody(rectangleOf: pipeFinal1.size)
        pipeFinal1.physicsBody?.isDynamic = false
        
        //Nueva inserccion
        pipeFinal1.physicsBody?.categoryBitMask = objectGroup
        
        pipeFinal1.zPosition = 4
        
        //creamos el pipe2
        let pipeTexture2 = SKTexture(imageNamed: "pipe2")
        pipeFinal2 = SKSpriteNode(texture: pipeTexture2)
        pipeFinal2.position = CGPoint(x: (self.frame.width / 2),
                                      y: -(pipeFinal2.size.height / 2) - (gapHeight / 2) + pipeOffset)
        pipeFinal2.physicsBody = SKPhysicsBody(rectangleOf: pipeFinal2.size)
        pipeFinal2.physicsBody?.isDynamic = false
        
        //Nueva inserccion
        pipeFinal2.physicsBody?.categoryBitMask = objectGroup
        
        pipeFinal2.zPosition = 4
        
        //mover la tuberia
        let movePipes = SKAction.moveBy(x: -self.frame.width - pipeFinal1.size.width*2, y: 0, duration: TimeInterval(self.frame.width / 200))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        pipeFinal1.run(moveAndRemovePipes)
        //self.addChild(pipeFinal1)
        
        self.movingGroup.addChild(pipeFinal1)
        
        pipeFinal2.run(moveAndRemovePipes)
        //self.addChild(pipeFinal2)
        
        self.movingGroup.addChild(pipeFinal2)
        
        
        makeGapNode(pipeOffset, gapHeight: gapHeight, moveAndRemovePipes: moveAndRemovePipes)
        
    }
    
    func makeGapNode(_ pipeOffSet: CGFloat, gapHeight: CGFloat, moveAndRemovePipes: SKAction) {
        let gap = SKNode()
        gap.position = CGPoint(x: (self.frame.width / 2), y: pipeOffSet)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeFinal2.size.width, height: gapHeight))
        gap.physicsBody?.isDynamic = false
        gap.run(moveAndRemovePipes)
        gap.zPosition = 7
        gap.physicsBody?.categoryBitMask = gapGroup
        self.movingGroup.addChild(gap)
        
        
        
    }
    
    
    func makeLabel(){
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: (self.frame.height / 2) - 90)
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
    }
    
    func makeLabelGameOver(){
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontSize = 50
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: 0, y: 0)
        gameOverLabel.zPosition = 10
        self.addChild(gameOverLabel)
    }
    
    func resetGame(){
        score = 0
        scoreLabel.text = "0"
        movingGroup.removeAllChildren()
        makeBackground()
        makeLoopPipe1AndPipe2()
        bird?.position = CGPoint(x: 0, y: 0)
        bird?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        gameOverLabel.removeFromParent()
        movingGroup.speed = 1
        gameOver = false
    }
    
    
    
}//FIN DE LA CLASE
