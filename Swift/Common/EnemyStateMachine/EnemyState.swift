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

// MARK: Public
public extension EnemyState {
    
    func node(at gridPosition: GridPosition) -> GKGridGraphNode {
        guard let node = graph.node(atGridPosition: gridPosition) else {
            incorrectImplementationShouldAlwaysBeAble(to: "get player node")
        }
        return node
    }
    
    func pathToPlayer() -> Path {
        path(to: playerNode)
    }
    
    func randomEnemyStartPosition() -> GKGridGraphNode? {
        game.random.shuffling(array: game.level.enemyStartPositions).first
    }
    
    func path(to destinationNode: GKGridGraphNode) -> Path {
        let enemyNode = node(at: entity.gridPosition)
        return graph.findPath(from: enemyNode, to: destinationNode)
            .map { castOrKill($0, to: GKGridGraphNode.self) }
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
    
    var playerNode: GKGridGraphNode {
//        graph.node(atGridPosition: game.player.gridPosition)
        node(at: game.player.gridPosition)
    }
}

// MARK: Private
private extension EnemyState {
    
    var graph: GKGridGraph<GKGridGraphNode> {
        game.level.pathfindingGraph
    }
}
