//
//  SKSpriteNode_Extensions.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-26.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    
    func run<Key>(_ action: SKAction, withKeyIfPresent key: Key? = nil) where Key: RawRepresentable, Key.RawValue == String {
        run(action, withKeyIfPresent: key?.rawValue)
    }
    
    func run(_ action: SKAction, withKeyIfPresent key: String? = nil) {
        if let key = key {
            run(action, withKey: key)
        } else {
            run(action)
        }
    }
}
