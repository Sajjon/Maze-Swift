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
    public private(set) var hasPowerup: Bool = false
    public let random: GKRandomSource
    
    public lazy var player: GameEntity = Game.setupPlayer(level: self.level)
    
    private lazy var enemies: [GameEntity] = Game.setupEnemies(game: self)
    
    private lazy var intelligenceSystem: GKComponentSystem<IntelligenceComponent> = {
        let intelligenceSystem = GKComponentSystem<IntelligenceComponent>()
        self.enemies.forEach { enemyEntity in
            intelligenceSystem.addComponent(foundIn: enemyEntity)
        }
        return intelligenceSystem
    }()
    
    public lazy var scene: Scene = {
        fatalError()
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

// MUST be power of 2
public enum ContactCategorySwift: UInt32 {
    case player = 1
    case enemy  = 2
}
