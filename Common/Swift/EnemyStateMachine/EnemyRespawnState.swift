//
//  EnemyRespawnState.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public final class EnemyRespawnState: EnemyState {
    private var timeUntilRespawn: TimeInterval = 0
}

public extension EnemyRespawnState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == EnemyChaseState.self
    }
    
    override func didEnter(from _: GKState?) {
        timeUntilRespawn = EnemyRespawnState.defaultRespawnTime
        spriteComponent.isPulseEffectEnabled = true
    }
    
    override func willExit(to _: GKState) {
        // Restore the sprite's original appearance.
        spriteComponent.isPulseEffectEnabled = false
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        timeUntilRespawn -= seconds
        if timeUntilRespawn <= 0 {
            stateMachine?.enter(EnemyChaseState.self)
        }
    }
}

private extension EnemyRespawnState {
    static let defaultRespawnTime: TimeInterval = 10
}
