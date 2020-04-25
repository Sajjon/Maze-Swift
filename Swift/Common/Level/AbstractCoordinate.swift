//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-16.
//

import Foundation
/// An abstraction of a coordinate, this type is meant to be screen/resolution agnostic.
public struct AbstractCoordinate: Hashable, Comparable, CustomStringConvertible {
    
    /// X coordinate in abstract length units
    public let x: AbstractLengthUnit
    
    /// Y coordinate in abstract length units
    public let y: AbstractLengthUnit
    
    
    public init(x: AbstractLengthUnit, y: AbstractLengthUnit) {
        self.x = x
        self.y = y
    }
}


public extension AbstractCoordinate {
    init<Integer>(x: Integer, y: Integer) throws where Integer: FixedWidthInteger {
        self.init(
            x: try .init(x),
            y: try .init(y)
        )
    }
}

// MARK: Comparable
public extension AbstractCoordinate {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }
}

// MARK: CustomStringConvertible
public extension AbstractCoordinate {
    var description: String { "(\(x), \(y))" }
}

