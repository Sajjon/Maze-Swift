//
//  IntelligenceComponent.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public final class IntelligenceComponent: GameComponent {
    let stateMachine: GKStateMachine
    
    // MARK: Init
    public init(
        game: Game,
        enemy: GameEntity,
        startingPosition origin: GKGridGraphNode
    ) {
        
        let chase = EnemyChaseState(game: game, entity: enemy)
        let flee = EnemyFleeState(game: game, entity: enemy)
        let defeated = EnemyDefeatedState(game: game, entity: enemy)
        defeated.respawnPosition = origin
        let respawn = EnemyRespawnState(game: game, entity: enemy)
        
        self.stateMachine = GKStateMachine(states: [
            chase, flee, defeated, respawn
        ])
        defer {
            stateMachine.enter(EnemyChaseState.self)
        }
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        interfaceBuilderNotSupported
    }
    
    // MARK: Override
    public override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
    }
}
