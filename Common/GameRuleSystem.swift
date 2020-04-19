//
//  GameRuleSystem.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public protocol GameRuleFact: RawRepresentable where RawValue == String {}

public protocol GameRuleSystemStateKey: RawRepresentable where RawValue == String {}

public extension GKRuleSystem {
    func assertFact<Fact>(_ fact: Fact) where Fact: GameRuleFact {
        assertFact(NSString(string: fact.rawValue))
    }
    func assertFact<Fact>(_ fact: Fact, grade: Float) where Fact: GameRuleFact {
        assertFact(NSString(string: fact.rawValue), grade: grade)
    }
    
}

public final class GameRuleSystem<Fact, StateKey>: GKRuleSystem where
    Fact: GameRuleFact,
    StateKey: GameRuleSystemStateKey
{
    
}

public extension GameRuleSystem {
    
    enum RuleFactType {
        case asserting(Fact), retracting(Fact)
        var fact: Fact {
            switch self {
            case .asserting(let fact): return fact
            case .retracting(let fact): return fact
            }
        }
    }
    
    func addRule(
        factType: RuleFactType,
        grade: Float? = nil,
        blockPredicate: @escaping (GameRuleSystem) -> Bool
    ) {
        let fact = factType.fact
        let rule = GKRule(
            blockPredicate: { _ in blockPredicate(self) },
            action: {
                let factString = NSString(string: fact.rawValue)
                if let grade = grade {
                    switch factType {
                    case .asserting:
                        $0.assertFact(factString, grade: grade)
                    case .retracting:
                        $0.retractFact(factString, grade: grade)
                    }
                } else {
                    switch factType {
                    case .asserting:
                        $0.assertFact(factString)
                    case .retracting:
                        $0.retractFact(factString)
                    }
                }
        })
        self.add(rule)
    }
    
    subscript<Value>(key: StateKey) -> Value? {
        get {
            guard let anyValue = self.state[key.rawValue] else {
                print("no value for key: '\(key.rawValue)'")
                return nil
            }
            guard let value = anyValue as? Value else {
                print("Failed to cast anyValue to value of type: \(Value.self)")
                return nil
            }
            return value
        }
        
        set {
            self.state[key.rawValue] = newValue
        }
    }
}
