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
    public init(
        game: Game,
        enemy: GameEntity,
        startingPosition origin: GKGridGraphNode
    ) {
        
        self.stateMachine = GKStateMachine(states: [
            
        ])
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        interfaceBuilderNotSupported
    }
}
