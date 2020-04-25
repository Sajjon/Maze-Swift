//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-16.
//

import Foundation

/// An abstraction of size, this type is meant to be screen/resolution agnostic.
public struct AbstractSize: Hashable {
    
    /// Width of level in abstract length units
    public let width: AbstractLengthUnit
    
    /// Height of level in abstract length units
    public let height: AbstractLengthUnit
    
    public init(width: AbstractLengthUnit, height: AbstractLengthUnit) {
        self.width = width
        self.height = height
    }
}

public extension AbstractSize {
    init<Integer>(width: Integer, height: Integer) throws where Integer: FixedWidthInteger {
        self.init(
            width: try .init(width),
            height: try .init(height)
        )
    }
}

