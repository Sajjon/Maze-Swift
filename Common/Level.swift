//
//  Level.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

//public protocol LevelProtocol {
//    var width: UInt { get }
//    var height: UInt { get }
//    var pathfindingGraph: GKGridGraph<GKGridGraphNode> { get }
//    var playerStartPosition: GKGridGraphNode { get }
//    var enemyStartPositions: [GKGridGraphNode] { get }
//}
//
//public struct LevelBlueprint: LevelProtocol {
//    public let width: UInt
//    public let height: UInt
//    public let pathfindingGraph: GKGridGraph<GKGridGraphNode>
//    public let playerStartPosition: GKGridGraphNode
//    public let enemyStartPositions: [GKGridGraphNode]
//}
//
///// An updatable representation of a level
//public final class Level: LevelProtocol {
//    public let width: UInt
//    public let height: UInt
//    public let pathfindingGraph: GKGridGraph<GKGridGraphNode>
//    public let playerStartPosition: GKGridGraphNode
//    public let enemyStartPositions: [GKGridGraphNode]
//
//    public init(blueprint: LevelBlueprint) {
//        self.width = blueprint.width
//        self.height = blueprint.height
//        self.pathfindingGraph = blueprint.pathfindingGraph
//        self.playerStartPosition = blueprint.playerStartPosition
//        self.enemyStartPositions = blueprint.enemyStartPositions
//    }
//}

public struct Level {
    public let width: UInt
    public let height: UInt
    public let pathfindingGraph: GKGridGraph<GKGridGraphNode>
    public let playerStartPosition: GKGridGraphNode
    public let enemyStartPositions: [GKGridGraphNode]
}
