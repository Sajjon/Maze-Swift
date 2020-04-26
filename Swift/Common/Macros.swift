//
//  Macros.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation

var interfaceBuilderNotSupported: Never {
    fatalError("Interface Builder not supported")
}

func incorrectImplementation(should reason: String) -> Never {
    fatalError("Incorrect implementation, should \(reason)")
}

func incorrectImplementationShouldAlwaysBeAble(to performAction: String) -> Never {
    incorrectImplementation(should: "always be able to: \(performAction)")
}

func castOrKill<From, To>(_ from: From, to: To.Type) -> To {
    guard let to = from as? To else {
        incorrectImplementationShouldAlwaysBeAble(to: "Cast from `\(from)` to `\(To.self)`")
    }
    return to
}
