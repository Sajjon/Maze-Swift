//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-16.
//

import Foundation

public struct AbstractLengthUnit:
    ExpressibleByIntegerLiteral,
    Hashable,
    Comparable,
    CustomStringConvertible
{
    public typealias IntegerLiteralType = UInt
    public let value: IntegerLiteralType
    init(value: IntegerLiteralType) {
        self.value = value
    }
}

// MARK: ExpressibleByIntegerLiteral
public extension AbstractLengthUnit {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(value: value)
    }
}

// MARK: Comparable
public extension AbstractLengthUnit {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

public extension AbstractLengthUnit {
    init<Integer>(_ integer: Integer) throws where Integer: FixedWidthInteger {
        guard integer >= 0  else {
            throw Error.mustNotBeNegative
        }
        self.init(value: IntegerLiteralType(integer))
    }
    enum Error: Swift.Error {
        case mustNotBeNegative
    }
}

// MARK: CustomStringConvertible
public extension AbstractLengthUnit {
    var description: String { .init(describing: value) }
}
