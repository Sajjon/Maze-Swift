//
//  PlayerControlComponent.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public final class PlayerControlComponent: GameComponent {
    
    private let level: Level
    public private(set) var direction: Direction?
    
    public var attemptedDirection: Direction?
    private var nextNode: GKGridGraphNode?
    
    public init(
        level: Level
    ) {
        self.level = level
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        interfaceBuilderNotSupported
    }
}

public extension PlayerControlComponent {
    func resetDirection() {
        direction = nil
        attemptedDirection = nil
    }
    
    
    func setDirection(_ newDirection: Direction?) {
        var proposedNode: GKGridGraphNode?
        if isCurrentlyMoving {
            proposedNode = nodeInDirection(newDirection, from: nextNode)
        } else {
            let currentNode = level.pathfindingGraph.node(atGridPosition: gameEntity.gridPosition)
            proposedNode = nodeInDirection(newDirection, from: currentNode)
        }
        if proposedNode == nil { return }
        self.direction = newDirection
    }

    
    override func update(deltaTime _: TimeInterval) {
        makeNextMove()
    }
}

// MARK: Private
private extension PlayerControlComponent {
    func nodeInDirection(
        _ newDirection: Direction?,
        from node: GKGridGraphNode?
    ) -> GKGridGraphNode? {
        guard let newDirection = newDirection, let node = node else {
            return nil
        }
        
        let nextPosition: GridPosition
            switch newDirection {
            case .left:
                nextPosition = node.gridPosition &+ GridPosition.init(x: -1, y: 0)
            case .right:
                nextPosition = node.gridPosition &+ GridPosition.init(x: 1, y: 0)
            case .down:
                nextPosition = node.gridPosition &+ GridPosition.init(x: 0, y: -1)
            case .up:
                nextPosition = node.gridPosition &+ GridPosition.init(x: 0, y: 1)
            }
            return level.pathfindingGraph.node(atGridPosition: nextPosition)
        
//        let positionDelta: GridPosition
//        switch newDirection {
//        case .left:
//            positionDelta = .init(x: -1, y: 0)
//        case .right:
//            positionDelta = .init(x: 1, y: 0)
//        case .down:
//            positionDelta = .init(x: 0, y: -1)
//        case .up:
//            positionDelta = .init(x: 0, y: 1)
//        }
//        let currentPosition = node.gridPosition
//        let currentIndex = level.map.toTileIndexFrom(gridPosition: currentPosition)
//        let indexDelta = level.map.toTileIndexFrom(gridPosition: positionDelta)
//        let nextIndex = currentIndex + indexDelta
//        let nextPosition = level.map.toGridPositionFrom(tileIndex: nextIndex)
//        print("newDir: \(newDirection), curPos: \(currentPosition), nextPos: \(nextPosition)")
//        return level.pathfindingGraph.node(atGridPosition: nextPosition)
    }
    
    func makeNextMove() {
        let currentNode = level.pathfindingGraph.node(atGridPosition: gameEntity.gridPosition)
        if let attemptedNextNode = nodeInDirection(attemptedDirection, from: currentNode) {
            // Move in the attempted direction.
            direction = attemptedDirection
            self.nextNode = attemptedNextNode
            spriteComponent.setNextGridPosition(attemptedNextNode.gridPosition)
            
        } else if let nextNode = nodeInDirection(direction, from: currentNode) {
            // Keep moving in the same direction.
            self.nextNode = nextNode
            spriteComponent.setNextGridPosition(nextNode.gridPosition)
        } else {
             // Can't move any more.
            direction = nil
        }
    }
    
    var spriteComponent: SpriteComponent {
        gameEntity.componentOf(type: SpriteComponent.self)
    }

    var isCurrentlyMoving: Bool {
        direction != nil
    }
}
