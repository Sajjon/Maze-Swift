//
//  ExpressibleByIntegerLiteral+RawValue.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-25.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//


extension ExpressibleByIntegerLiteral where Self: RawRepresentable, Self.RawValue == IntegerLiteralType {
    public init(integerLiteral value: Self.IntegerLiteralType) {
        guard let selfFromValue = Self.init(rawValue: value) else {
            fatalError("Failed to init self from IntegerLiteralType: \(value)")
        }
        self = selfFromValue
    }
}
