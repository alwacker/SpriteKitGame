//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Oleksandr Vaker on 17/09/16.
//  Copyright © 2016 Oleksandr Vaker. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Texture
    var bgTexture: SKTexture!
    var flyHeroTex: SKTexture!

    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var hero = SKSpriteNode()
    
    //Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var heroObject = SKNode()
    
    //Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    
    //Textures Array for animateWithTextures
    var heroFlyTexturesArray = [SKTexture]()
    
    override func didMove(to view: SKView) {
        //BG texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        //Hero texture
        flyHeroTex = SKTexture(imageNamed: "Fly0.png")
        
        createObjects()
        createGame()
    }
    
    func createObjects(){
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(heroObject)
    }
    
    func createGame(){
        createBg()
        createGround()
        createHero()
        
    }
    
    func createBg(){
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 3)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg,replaceBg]))
        
        for i in 0..<3{
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: size.width/4 + bgTexture.size().width * CGFloat(i), y: size.height/2.0)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            bgObject.addChild(bg)
        }
    }
    
    func createGround(){
        ground = SKSpriteNode()
        ground.position = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height/4 + self.frame.height/8))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        ground.zPosition = 1
        
        groundObject.addChild(ground)
    }
    
    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint){
        hero = SKSpriteNode(texture: flyHeroTex)
        
        //Anim hero
        heroFlyTexturesArray = [SKTexture(imageNamed: "Fly0.png"),SKTexture(imageNamed: "Fly1.png"),SKTexture(imageNamed: "Fly2.png"),SKTexture(imageNamed: "Fly3.png"),SKTexture(imageNamed: "Fly4.png")]
        let heroFlyAnimation = SKAction.animate(with: heroFlyTexturesArray, timePerFrame: 0.1)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        hero.run(flyHero)
        
        hero.position = position
        
        hero.size.height = 84
        hero.size.width = 120
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
        
        hero.physicsBody?.categoryBitMask = heroGroup
        hero.physicsBody?.contactTestBitMask = groundGroup
        hero.physicsBody?.contactTestBitMask = groundGroup
        
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.zPosition = 1
        
        heroObject.addChild(hero)
    }
    
    func createHero(){
        addHero(heroNode: hero, atPosition: CGPoint(x: self.size.width/4, y: 0 + flyHeroTex.size().height + 400))
    }
}
