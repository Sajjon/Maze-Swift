//
//  EnemyChaseState.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public extension GKRandomSource {
    func shuffling<Element>(array: [Element]) -> [Element] {
        guard
            case let shuffledMapped = arrayByShufflingObjects(in: array).compactMap({
                $0 as? Element
            }),
            shuffledMapped.count == array.count
        else {
            fatalError("What? Array change Element type?")
        }
        
        return shuffledMapped
    }
}

public final class EnemyChaseState: EnemyState {
    
    private lazy var ruleSystem = EnemyChaseState.setupGameRuleSystem()
    
    private var isHunting: Bool = true {
        willSet {
            guard newValue == false && isHunting == true else {
                return
            }
       
            self.scatterTarget = randomEnemyStartPosition()
        }
    }
    
    private var scatterTarget: GKGridGraphNode?
}

// MARK: - Override
// ---
// ---
// ---
// MARK: GKState LifeCycle
public extension EnemyChaseState {
  
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == EnemyFleeState.self
    }
    
    override func didEnter(from _: GKState?) {
        // Set the enemy sprite to its normal appearance,
        // undoing any changes that happened in other states.
        spriteComponent.useNormalAppearance()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // If the enemy has reached its target, choose a new target.
        let gridPosition = entity.gridPosition
        if
            let scatterTarget = scatterTarget,
            scatterTarget.gridPosition == gridPosition
        {
            isHunting = true
        }
        
        let pathToPlayer_ = pathToPlayer()
        let distanceToPlayer = pathToPlayer_.count
        ruleSystem[.distanceToPlayer] = distanceToPlayer
        ruleSystem.reset()
        ruleSystem.evaluate()
        isHunting = ruleSystem.grade(forFact: .hunt) > 0
        if isHunting {
            startFollowing(path: pathToPlayer_)
        } else if let scatterTarget = scatterTarget {
            startFollowing(path: path(to: scatterTarget))
        }
    }
}

// MARK: RuleFact + StateKey
private extension EnemyChaseState {
    enum RuleFact: String, GameRuleFact {
        case hunt
    }
    enum RuleSystemStateKey: String, GameRuleSystemStateKey {
        case distanceToPlayer
    }
    
    typealias RuleSystem = GameRuleSystem<RuleFact, RuleSystemStateKey>
}

// MARK: Setup Rules
private extension EnemyChaseState {
    static func setupGameRuleSystem() -> RuleSystem {
        let ruleSystem = RuleSystem()
        
        func addDistanceToPlayerRule(
            factType: RuleSystem.RuleFactType,
            _ blockPredicate: @escaping (Int) -> Bool
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
        
        let playerProximityThreshold: Int = 10
        
        addDistanceToPlayerRule(factType: .asserting(.hunt)) {
            $0 >= playerProximityThreshold
        }
        
        addDistanceToPlayerRule(factType: .retracting(.hunt)) {
            $0 < playerProximityThreshold
        }
        return ruleSystem
    }
}
