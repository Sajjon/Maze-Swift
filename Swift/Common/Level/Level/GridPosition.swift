//
//  GridPosition.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-25.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import Foundation

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

public extension GridPosition {
    static let zero = Self(x: 0, y: 0)
}
