//
//  Game.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension NSColor {
    class func random() -> NSColor {
        let red =   UInt32.random(in: 0...255)
        let green = UInt32.random(in: 0...255)
        let blue =  UInt32.random(in: 0...255)
        let color = NSColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
        return color
    }
}


public final class Game: NSObject {
    public let level: Level
    private static let powerupDuractionInSeconds: TimeInterval = 10
    private var lastUpdated: TimeInterval = -1
    public var playerIsImmortalAndLeathal: Bool = false {
        willSet {
            let nextState: AnyClass
            if newValue {
                // If player has power app, enemies should flee from her
                nextState = EnemyFleeState.self
                powerupTimeRemaining = Self.powerupDuractionInSeconds
            } else {
                nextState = EnemyChaseState.self
            }
            
            for component in intelligenceSystem.components {
                component.stateMachine.enter(nextState)
            }
        }
    }
    
    public let random: GKRandomSource
    
    public lazy var player: GameEntity = Game.setupPlayer(level: self.level)
    
    private lazy var enemies: [GameEntity] = Game.setupEnemies(game: self)
    
    private var powerupTimeRemaining: TimeInterval = 0
    
    private lazy var intelligenceSystem: GKComponentSystem<IntelligenceComponent> = {
        let intelligenceSystem = GKComponentSystem<IntelligenceComponent>()
        self.enemies.forEach { enemyEntity in
            intelligenceSystem.addComponent(foundIn: enemyEntity)
        }
        return intelligenceSystem
    }()
    
    public lazy var scene: Scene = {
        let scene = Scene(
            size: .init(
                width: CGFloat(level.width) * Scene.cellWidth,
                height: CGFloat(level.height) * Scene.cellWidth
            )
        )
        
        scene.delegate = self
        scene.sceneDelegate = self
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        scene.physicsWorld.contactDelegate = self
        
        return scene
    }()
    
    public init(
        level: Level
    ) {
        self.level = level
        self.random = GKRandomSource()
        
    }
}

// MARK: - Public
public extension Game {
    
    var playerDirection: Direction? {
        // N.B. the assymetry, _setter_ uses `attemptedDirection` but _getter_ uses
        // `direction`
        get {
            playerControlComponent.direction
        }
        
        set {
            playerControlComponent.attemptedDirection = newValue
        }
    }
    
}

// MARK: - Private
private extension Game {
    
    func playerAttacked() {
        // Respawn player at starting position
        spriteComponent.warp(to: level.playerStartPosition.gridPosition)
        
        // Reset the player's direction controls upon warping
        playerControlComponent.resetDirection()
    }
    
    var playerControlComponent: PlayerControlComponent {
        player.componentOf(type: PlayerControlComponent.self)
    }
    
    var spriteComponent: SpriteComponent {
        player.componentOf(type: SpriteComponent.self)
    }
    
    static func setupPlayer(level: Level) -> GameEntity {
        let player = GameEntity()
        try! player.updateGridPosition(level.playerStartPosition.gridPosition)
        player.addComponent(SpriteComponent(colorDefault: .cyan))
        player.addComponent(PlayerControlComponent(level: level))
        return player
    }
    
    static func setupEnemies(game: Game) -> [GameEntity] {
        game.level.enemyStartPositions.map { node in
            
            let enemy = GameEntity()
            
            try! enemy.updateGridPosition(node.gridPosition)
            
            enemy.addComponent(
                SpriteComponent(colorDefault: .random())
            )
            
            enemy.addComponent(
                IntelligenceComponent(
                    game: game,
                    enemy: enemy,
                    startingPosition: node
                )
            )
            return enemy
        }
        
    }
}

// MARK: SKPhysicsContactDelegate
extension Game: SKPhysicsContactDelegate {}
public extension Game {
    func didBegin(_ contact: SKPhysicsContact) {
        // MARK: This code is direction Swift conversion of Apple's not so pretty ObjC code
        let enemyNode: SpriteNode
        if contact.bodyA.categoryBitMask == ContactCategorySwift.enemy.rawValue {
            enemyNode = contact.bodyA.node as! SpriteNode
        } else if contact.bodyB.categoryBitMask == ContactCategorySwift.enemy.rawValue {
            enemyNode = contact.bodyB.node as! SpriteNode
        } else {
            fatalError("Expected player-enemy/enemy-player collision")
        }
        
        // If the player contacts an enemy that's in the Chase state, the player is attackeed.
        let entity = enemyNode.owner.gameEntity
        let aiComponent = entity.componentOf(type: IntelligenceComponent.self)
        if aiComponent.stateMachine.currentState is EnemyChaseState {
            playerAttacked()
        } else {
            // Otherwise, that enemy enters the Defeated state only if in a state that allows that transition.
            aiComponent.stateMachine.enter(EnemyDefeatedState.self)
        }
    }
}

extension Game: SKSceneDelegate {}
public extension Game {
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        if lastUpdated <= 0 {
            // edge case, first time
            lastUpdated = currentTime
        }
        let deltaTime = currentTime - lastUpdated
        lastUpdated = currentTime
        
        // Track remaining time on the powerup (playerImmortalAndLeathal)
        powerupTimeRemaining -= deltaTime
        
        // Update components with the new time delta
        intelligenceSystem.update(deltaTime: deltaTime)
        player.update(deltaTime: deltaTime)
    }
}

extension Game: SceneDelegate {}
public extension Game {
    func scene(_ scene: Scene, didMoveToView: SKView) {
        scene.backgroundColor = .black
        
        // Generate maze
        let maze = SKNode()
        let cellSize = CGSize(
            width: Scene.cellWidth,
            height: Scene.cellWidth
        )
        
        let graph = level.pathfindingGraph
        for x in 0..<level.width {
            for y in 0..<level.height {
                let gridPosition = GridPosition(x: Int32(x), y: Int32(y))
                guard let _ = graph.node(atGridPosition: gridPosition) else { continue }
                // Make nodes for traversable areas; leave walls as background color.
                let node = SKSpriteNode(color: .gray, size: cellSize)
                node.position = CGPoint(
                    x: (CGFloat(x) + 0.5) * Scene.cellWidth,
                    y: (CGFloat(y) + 0.5) * Scene.cellWidth
                )
                maze.addChild(node)
            }
        }
        scene.addChild(maze)
        
        // Add player entity to scene
        let playerComponent = player.componentOf(type: SpriteComponent.self)
        let playerSprite: SpriteNode = {
            let sprite = SpriteNode(
                owner: playerComponent,
                color: .cyan,
                size: cellSize
            )
            sprite.position = scene.pointFrom(gridPosition: player.gridPosition)
            sprite.zRotation = .pi / 4
            sprite.xScale = sqrt(1)/2
            sprite.yScale = sqrt(1)/2
            sprite.physicsBody = { () -> SKPhysicsBody in
                let body = SKPhysicsBody(circleOfRadius: Scene.cellWidth/2)
                body.categoryBitMask = ContactCategorySwift.player.rawValue
                body.contactTestBitMask = ContactCategorySwift.enemy.rawValue
                body.collisionBitMask = 0
                return body
                
            }()
            return sprite
        }()
        playerComponent.sprite = playerSprite
        scene.addChild(playerSprite)
        
        // Add enemy entities to scene
        for enemyEntity in enemies {
            let enemyComponent = enemyEntity.componentOf(type: SpriteComponent.self)
            
            let enemySprite: SpriteNode = {
                let sprite = SpriteNode(
                    owner: enemyComponent,
                    color: enemyComponent.colorDefault,
                    size: cellSize
                )
                sprite.position = scene.pointFrom(gridPosition: enemyEntity.gridPosition)
                sprite.physicsBody = { () -> SKPhysicsBody in
                    let body = SKPhysicsBody(circleOfRadius: Scene.cellWidth/2)
                    body.categoryBitMask = ContactCategorySwift.enemy.rawValue
                    body.contactTestBitMask = ContactCategorySwift.player.rawValue
                    body.collisionBitMask = 0
                    return body
                    
                }()
                return sprite
            }()
            
            enemyComponent.sprite = enemySprite
            scene.addChild(enemySprite)
        }
    }
}

// MUST be power of 2
public enum ContactCategorySwift: UInt32 {
    case player = 1
    case enemy  = 2
}
