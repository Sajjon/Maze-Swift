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

public final class Game {
    public let level: Level
    public let enemies: [GameEntity]
    public private(set) var hasPowerup: Bool = false
    public let random: GKRandomSource
    
    public lazy var player: GameEntity = Game.setupPlayer(level: self.level)
    
    public lazy var scene: Scene = {
        fatalError()
    }()
    
    public init(
        level: Level
    ) {
        self.level = level
        self.enemies = .init()
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
    
    func killPlayer() {
        // Respawn player at starting position
        
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
}
