//
//  EnemyState.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public typealias Path = [GKGridGraphNode]
public class EnemyState: GKState {
    private unowned let game: Game
    private unowned let entity: GameEntity
    
    public init(
        game: Game,
        entity: GameEntity
    ) {
        self.game = game
        self.entity = entity
        super.init()
    }
}

public extension EnemyState {
    func path(to destinationNode: GKGridGraphNode) -> Path? {
        let graph = game.level.pathfindingGraph
        guard let enemyNode = graph.node(atGridPosition: entity.gridPosition) else {
            return nil
        }
        let path = graph.findPath(from: enemyNode, to: destinationNode).map { graphNode -> GKGridGraphNode in
            guard let gridGraphNode = graphNode as? GKGridGraphNode else {
                fatalError("Failed to cast GraphNode to GridGraphNode.")
            }
            return gridGraphNode
        }
        return path
    }
    func startFollowing(path: Path) {
        fatalError()
    }
}
