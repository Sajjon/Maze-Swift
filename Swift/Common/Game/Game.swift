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

public typealias IntelligenceSystem = GKComponentSystem<IntelligenceComponent>

public final class Game: NSObject {
    public let level: Level
    private var lastUpdated: TimeInterval = -1
    private var powerupTimeRemaining: TimeInterval = 0
    public let random: GKRandomSource
    
    public lazy var player: GameEntity                      = Game.setupPlayer(level: level)
    private lazy var enemies: [GameEntity]                  = Game.setupEnemies(game: self)
    private lazy var intelligenceSystem: IntelligenceSystem = Game.setupAI(enemies: enemies)
    public lazy var scene: Scene                            = Game.setupScene(game: self)
    
    public var playerIsImmortalAndLeathal: Bool = false {
        willSet {
            if newValue { powerupTimeRemaining = Self.powerupDuractionInSeconds }
            updateBehaviourOfEnemies(nextState: newValue ? EnemyFleeState.self : EnemyChaseState.self)
        }
    }
    
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
    
    static let powerupDuractionInSeconds: TimeInterval = 10
    
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
    
    func updateBehaviourOfEnemies<State>(nextState: State.Type) where State: EnemyState {
        intelligenceSystem.components.forEach {
            $0.stateMachine.enter(nextState as AnyClass)
        }
    }
}

// MARK: Static Setup
private extension Game {
    
    static func setupScene(game: Game) -> Scene {
        {
            let scene = Scene(
                size: .init(
                    width: game.level.cgWidth * Scene.cellWidth,
                    height: game.level.cgHeight * Scene.cellWidth
                )
            )
            
            scene.delegate = game
            scene.sceneDelegate = game
            scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            scene.physicsWorld.contactDelegate = game
            
            return scene
        }()
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
                SpriteComponent(colorDefault: Game.randomColor())
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
    
    static func setupAI(enemies: [GameEntity]) -> IntelligenceSystem {
        // N.B.: Do NOT use the empty initializer `GKComponentSystem<IntelligenceComponent>()`,
        // this is not at all the same thing as `GKComponentSystem<IntelligenceComponent>(componentClass: IntelligenceComponent.self)`
        // the empty init will result in no intelligence what so ever.
        let intelligenceSystem = IntelligenceSystem(componentClass: IntelligenceComponent.self)
        
        enemies.forEach { enemyEntity in
            intelligenceSystem.addComponent(foundIn: enemyEntity)
        }
        
        return intelligenceSystem
    }
}

// MARK: SKPhysicsContactDelegate
extension Game: SKPhysicsContactDelegate {}
public extension Game {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let enemyNode: SpriteNode
        if contact.between(bodyA: .enemy, and: .player) {
            enemyNode = castOrKill(contact.bodyA.node, to: SpriteNode.self)
        } else if contact.between(bodyA: .player, and: .enemy) {
            enemyNode = castOrKill(contact.bodyB.node, to: SpriteNode.self)
        } else {
            incorrectImplementation(should: "have been either 'player-enemy' or 'enemy-player' collision")
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

// MARK: SKSceneDelegate
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

// MARK: SceneDelegate
extension Game: SceneDelegate {}
public extension Game {
    func scene(_ scene: Scene, didMoveToView: SKView) {
        defer {
            updateBehaviourOfEnemies(nextState: EnemyChaseState.self)
        }
        scene.backgroundColor = .black
        
        // Generate maze
        let maze = SKNode()
        let cellSize = CGSize(
            width: Scene.cellWidth,
            height: Scene.cellWidth
        )
        
        let graph = level.pathfindingGraph
        
        for tileAt in level.map {
            let gridPosition = tileAt.position
            
            
            guard let _ = graph.node(atGridPosition: gridPosition) else { continue }
            // Make nodes for traversable areas; leave walls as background color.
            let node = SKSpriteNode(color: .gray, size: cellSize)
            
            node.position = gridPosition.toPointForScene()
            
            maze.addChild(node)
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
            sprite.position = player.point
            sprite.zRotation = .pi / 4
            sprite.xScale = sqrt(1)/2
            sprite.yScale = sqrt(1)/2
            sprite.physicsBody = { () -> SKPhysicsBody in
                let body = SKPhysicsBody(circleOfRadius: Scene.cellWidth/2)
                body.categoryBitMask = ContactCategory.player.rawValue
                body.contactTestBitMask = ContactCategory.enemy.rawValue
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
                sprite.position = enemyEntity.point
                sprite.physicsBody = { () -> SKPhysicsBody in
                    let body = SKPhysicsBody(circleOfRadius: Scene.cellWidth/2)
                    body.categoryBitMask = ContactCategory.enemy.rawValue
                    body.contactTestBitMask = ContactCategory.player.rawValue
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

extension Game {
    static func randomColor() -> SKColor {
        #if os(macOS)
        return NSColor.random()
        #elseif(iOS)
        return UIColor.random()
        #else
        fatalError("unsupported OS")
        #endif
    }
}
