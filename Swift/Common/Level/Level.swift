//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-15.
//

import Foundation
import GameplayKit

public enum Simple: UInt, Hashable, ExpressibleByIntegerLiteral {
    case open, wall, portal, playerStart
}

extension ExpressibleByIntegerLiteral where Self: RawRepresentable, Self.RawValue == IntegerLiteralType {
    public init(integerLiteral value: Self.IntegerLiteralType) {
        guard let selfFromValue = Self.init(rawValue: value) else {
            fatalError("Failed to init self from IntegerLiteralType: \(value)")
        }
        self = selfFromValue
    }
}

public extension GridPosition {
    static let zero = Self(x: 0, y: 0)
}

//public typealias Level = GenericLevel<Simple, GKGridGraphNode>
public typealias Level = GenericLevel<Simple>

//public struct GenericLevel<MapTile, GridGraphNodeType>: Equatable
public struct GenericLevel<MapTile>: Equatable
where
MapTile: Equatable
//, GridGraphNodeType: GKGridGraphNode
{
    public let pathfindingGraph: GKGridGraph<GKGridGraphNode>
    public let playerStartPosition: GKGridGraphNode
    public let enemyStartPositions: [GKGridGraphNode]
//    public let map: Map<MapTile, GridGraphNodeType>
    public let map: Map<MapTile>
    
    public enum Error: Swift.Error {
        case mapMustContainStaringPositionForPlayer
    }
    
    public init(
//        map: Map<MapTile, GridGraphNodeType>,
        map: Map<MapTile>,
        areDiagonalMovementsAllowed: Bool = false
    ) throws {
        
        let graph = GKGridGraph(
            fromGridStartingAt: .zero,
            width: Int32(map.width.value),
            height: Int32(map.height.value),
            diagonalsAllowed: areDiagonalMovementsAllowed
        )
        
        let walls = [GKGridGraphNode]()
        let spawnPoints = [GKGridGraphNode]()
        var playerStartingPosition: GKGridGraphNode?

        for mapTileAt in map where map.shouldGraphCreateNode(for: mapTileAt) {
            guard
                let node = graph.node(atGridPosition: mapTileAt.position)
            else {
                fatalError("No node, why? Bad state? Incorrect impl?")
            }
//            switch mapTileAt.
            fatalError("do something with node")
        }
        
        guard let playerStartPosition = playerStartingPosition else {
            throw Error.mapMustContainStaringPositionForPlayer
        }
        
        graph.remove(walls)
        self.enemyStartPositions = spawnPoints
        self.pathfindingGraph = graph
        self.playerStartPosition = playerStartPosition
        self.map = map
    }
}

public extension GenericLevel {
    var width: AbstractLengthUnit { map.width }
    var height: AbstractLengthUnit { map.height }
    
    var cgWidth: CGFloat { map.cgWidth }
    var cgHeight: CGFloat { map.cgHeight }
}
