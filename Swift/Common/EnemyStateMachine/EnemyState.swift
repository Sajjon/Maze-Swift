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
    internal unowned let entity: GameEntity
    
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
    
    func pathToPlayer() -> Path? {
        let graph = game.level.pathfindingGraph
        guard let playerNode = graph.node(atGridPosition: game.player.gridPosition) else {
            return nil
        }
        return path(to: playerNode)
    }
    
    func randomEnemyStartPosition() -> GKGridGraphNode? {
        game.random.shuffling(array: game.level.enemyStartPositions).first
    }
    
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
    
    func startFollowing(path: Path?) {
        guard
            let path = path,
            path.count > 1
            else {
                return
        }
        
        // Set up a move to the first node on the path, but
        // no farther because the next update will recalculate the path.
        
        let firstMove = path[1] // path[0] is the enemy's current position.
        spriteComponent.setNextGridPosition(firstMove.gridPosition)
    }
    
    var spriteComponent: SpriteComponent {
        entity.componentOf(type: SpriteComponent.self)
    }
}
