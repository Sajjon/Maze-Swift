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
    public var respawnPosition: GKGridGraphNode?
}

public extension EnemyDefeatedState {
    
    override var description: String {
         "DefeatedState"
     }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == EnemyRespawnState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
         // Change the enemy sprite's appearance to indicate defeat.
        spriteComponent.useDefeatedAppearance()
        
        // Use pathfinding to find a route back to this enemy's starting position.
        guard let respawnPosition = respawnPosition else { return }
        let pathToRespawn = path(to: respawnPosition)
        
        spriteComponent.followPath(pathToRespawn) { [unowned self] in
            self.stateMachine?.enter(EnemyRespawnState.self)
        }
    }
}
