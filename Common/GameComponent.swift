//
//  GameComponent.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

public class GameComponent: GKComponent {}

public extension GameComponent {
    var gameEntity: GameEntity {
        guard let _entity = self.entity else {
            fatalError("GameComponent has no `entity` (GKEntity), bad state?!")
        }
        
        guard let gameEntity = _entity as? GameEntity else {
            fatalError("Failed to cast 'GKEntity' to 'GameEntity', this is probably bad..")
        }
        
        return gameEntity
    }
}
