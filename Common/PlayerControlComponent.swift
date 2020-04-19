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
    public private(set) var direction: Direction? = nil
    public var attemptedDirection: Direction? = nil
    
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
