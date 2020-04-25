//
//  GameEntity.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit

public typealias GridPosition = SIMD2<Int32>

extension GridPosition: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.x < rhs.x { return true }
        if lhs.x > rhs.x { return false }
        return lhs.y < rhs.y
    }
}

public extension GridPosition {
    init<Integer>(x: Integer, y: Integer) where Integer: FixedWidthInteger {
        self.init(x: Scalar(x), y: Scalar(y))
    }
}

public final class GameEntity: GKEntity {
    
    public private(set) var gridPosition: GridPosition
    
    public init(gridPosition: GridPosition = .zero) {
        self.gridPosition = gridPosition
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        interfaceBuilderNotSupported
    }
}

// MARK: Public
public extension GameEntity {
    
    func updateGridPosition(_ newGridPosition: GridPosition) throws {
        // TODO validate that the new grid position exists....
        self.gridPosition = newGridPosition
    }
    
    
    /// An unsafe accessor of components from this entity. A runtime crashing function if passed in `type` is not found
    /// in this entity.
    func componentOf<ComponentType>(
        type: ComponentType.Type
    ) -> ComponentType where
        ComponentType: GameComponent
    {
        guard let component = component(ofType: type) else {
            fatalError("Failed to find any component of type: \(type) in entity: \(self)")
        }
        return component
    }
    
}
