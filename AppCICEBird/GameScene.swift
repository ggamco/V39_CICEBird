//
//  GameScene.swift
//  AppCICEBird
//
//  Created by cice on 21/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Variables LOCALES
    var background : SKSpriteNode?
    var bird : SKSpriteNode?
    var pipeFinal1 = SKSpriteNode()
    var pipeFinal2 = SKSpriteNode()
    var limitLand = SKNode()
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        
        makeLimitLand()
        makeBackground()
        makeBird()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        //animacion
        bird?.run(makeBirdForever)
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
            self.addChild(background!)
        }
        
    }
    
    func makeLimitLand() {
        limitLand.position = CGPoint(x: 0, y: 0)
        limitLand.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        limitLand.physicsBody?.isDynamic = false
        limitLand.zPosition = 2
        self.addChild(limitLand)
    }
    
    
    
    
    
    
    
    
    
    
    
}
