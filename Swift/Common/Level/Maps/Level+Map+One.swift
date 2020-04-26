//
//  Level+Map+One.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-22.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import Foundation
import GameplayKit

public extension GenericLevel where MapTile == Simple {
    
    init(
        map: Map<MapTile>,
        areDiagonalMovementsAllowed: Bool = false
    ) throws {
        
        let graph = GKGridGraph(
            fromGridStartingAt: .zero,
            width: Int32(map.width.value),
            height: Int32(map.height.value),
            diagonalsAllowed: areDiagonalMovementsAllowed
        )
        
        var walls = [GKGridGraphNode]()
        var spawnPoints = [GKGridGraphNode]()
        var playerStartingPosition: GKGridGraphNode?
        
        for tileAt in map {
            guard let node = graph.node(atGridPosition: tileAt.position) else {
                incorrectImplementationShouldAlwaysBeAble(to: "find node")
            }
            switch tileAt.tile {
            case .wall: walls.append(node)
            case .portal: spawnPoints.append(node)
            case .playerStart:
                if playerStartingPosition != nil {
                    incorrectImplementation(should: "Not have seen multiple start positions")
                }
                playerStartingPosition = node
            case .open: break
            }
        }
        
        guard let playerStartPosition = playerStartingPosition else {
            throw Error.mapMustContainStaringPositionForPlayer
        }
        
        graph.remove(walls)
        
        self.init(
            pathfindingGraph: graph,
            playerStartPosition: playerStartPosition,
            enemyStartPositions: spawnPoints,
            map: map
        )
    }
    
}

public extension Level {
    static var one: Self {
        try! Self.init(map: .one)
    }
}


public extension GenericLevel.Map where MapTile == Simple {
    static var one: Self {
        try! .init(
            tilesByRowAndColumn:
            [
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,1],
                [1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1],
                [1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1],
                [1,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,0,1],
                [1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1],
                [1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1],
                [1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
                [1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1],
                [1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1],
                [1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1],
                [1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1],
                [1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1],
                [1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1],
                [1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1],
                [1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1],
                [1,0,1,1,0,1,1,1,1,0,1,1,0,3,0,0,1,1,0,1,1,1,1,0,1,1,0,1],
                [1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1],
                [1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1],
                [1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1],
                [1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1],
                [1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,1],
                [1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1],
                [1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1],
                [1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1],
                [1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1],
                [1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1],
                [1,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1],
                [1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1],
                [1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1],
                [1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
            ]
        )
    }
}
