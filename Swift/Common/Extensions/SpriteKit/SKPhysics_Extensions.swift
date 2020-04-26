//
//  SKPhysics_Extensions.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-26.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import Foundation
import SpriteKit

extension SKPhysicsBody {
    static func == (body: SKPhysicsBody, contactCandidate: ContactCategory) -> Bool {
        body.categoryBitMask == contactCandidate.rawValue
    }
}

extension SKPhysicsContact {
    func between(bodyA typeA: ContactCategory, and typeB: ContactCategory) -> Bool {
        bodyA == typeA && bodyB == typeB
    }
}

