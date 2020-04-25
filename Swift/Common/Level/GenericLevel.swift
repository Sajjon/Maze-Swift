//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-15.
//

import Foundation
import GameplayKit

public struct GenericLevel<MapTile>: Equatable where MapTile: Equatable {
   
    public let pathfindingGraph: GKGridGraph<GKGridGraphNode>
    public let playerStartPosition: GKGridGraphNode
    public let enemyStartPositions: [GKGridGraphNode]
    public let map: Map<MapTile>
    
    public init(
        pathfindingGraph: GKGridGraph<GKGridGraphNode>,
        playerStartPosition: GKGridGraphNode,
        enemyStartPositions: [GKGridGraphNode],
        map: Map<MapTile>
    ) {
        self.map = map
        self.pathfindingGraph = pathfindingGraph
        self.enemyStartPositions = enemyStartPositions
        self.playerStartPosition = playerStartPosition
    }
}

// MARK: Public
public extension GenericLevel {
    var width: AbstractLengthUnit { map.width }
    var height: AbstractLengthUnit { map.height }
    
    var cgWidth: CGFloat { map.cgWidth }
    var cgHeight: CGFloat { map.cgHeight }
}

// MARK: Error
public extension GenericLevel {
    
    enum Error: Swift.Error {
        case mapMustContainStaringPositionForPlayer
    }
}
