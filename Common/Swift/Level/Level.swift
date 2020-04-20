//
//  Level.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public struct Level {
    public let width: UInt
    public let height: UInt
    public let pathfindingGraph: GKGridGraph<GKGridGraphNode>
    public let playerStartPosition: GKGridGraphNode
    public let enemyStartPositions: [GKGridGraphNode]
}
