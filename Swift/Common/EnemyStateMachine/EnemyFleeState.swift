//
//  EnemyFleeState.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public final class EnemyFleeState: EnemyState {
    private var target: GKGridGraphNode?
}

public extension EnemyFleeState {
    
    override var description: String {
        "FleeState"
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == EnemyChaseState.self || stateClass == EnemyDefeatedState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        spriteComponent.useFleeAppearance()
        
        // Choose a location to flee towards.
        target = randomEnemyStartPosition()
    }
    
    override func update(deltaTime _: TimeInterval) {
        // If the enemy has reached its target, choose a new target.
        let position = entity.gridPosition
        if target?.gridPosition == position {
            target = randomEnemyStartPosition()
        }
        
        // Flee towards the current target point.
        if let target = target {
            startFollowing(path: path(to: target))
        }
    }
}
