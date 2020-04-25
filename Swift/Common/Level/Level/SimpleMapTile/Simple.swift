//
//  Simple.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-25.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import Foundation

public enum Simple: UInt, Hashable, ExpressibleByIntegerLiteral {
    case open, wall, portal, playerStart
}

public typealias Level = GenericLevel<Simple>
