//
//  EnemyDefeatedState.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public final class EnemyDefeatedState: EnemyState {
    public let respawnPosition: GKGridGraphNode
    public init(
        respawnPosition: GKGridGraphNode,
        game: Game,
        entity: GameEntity
    ) {
        self.respawnPosition = respawnPosition
        super.init(game: game, entity: entity)
    }
}
