//
//  EnemyChaseState.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public final class EnemyChaseState: EnemyState {
    private enum RuleFact: String, GameRuleFact {
        case hunt
    }
    private enum RuleSystemStateKey: String, GameRuleSystemStateKey {
        case distanceToPlayer
    }
    
    private typealias RuleSystem = GameRuleSystem<RuleFact, RuleSystemStateKey>
    
    private lazy var ruleSystem: RuleSystem = {
        let ruleSystem = RuleSystem()
        typealias Proximiy = Int
        func addDistanceToPlayerRule(
            factType: RuleSystem.RuleFactType,
            _ blockPredicate: (Proximiy) -> Bool
        ) {
            ruleSystem.addRule(
                factType: factType,
                grade: 1.0
            ) { (system: GameRuleSystem) -> Bool in
                
                guard let distanceToPlayer: Int = system[.distanceToPlayer] else {
                    return false
                }
                
                return blockPredicate(distanceToPlayer)
            }
        }
        
        let playerProximityThreshold: Proximiy = 10
        
        addDistanceToPlayerRule(factType: .asserting(.hunt)) {
            $0 >= playerProximityThreshold
        }
        
        addDistanceToPlayerRule(factType: .retracting(.hunt)) {
            $0 < playerProximityThreshold
        }
        return ruleSystem
    }()
    
    private var isHunting: Bool = false
    private var scatterTarget: GKGridGraphNode?
    
    public override init(
        game: Game,
        entity: GameEntity
    ) {
        super.init(game: game, entity: entity)
    }
}
