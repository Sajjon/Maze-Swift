//
//  SpriteNode.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import SpriteKit

public final class SpriteNode: SKSpriteNode {
    
    unowned let owner: SpriteComponent
    
    public init(
        owner: SpriteComponent,
        color: SKColor,
        size: CGSize
    ) {
        self.owner = owner
        super.init(texture: nil, color: color, size: size)
    }
    
    public required init?(coder: NSCoder) {
        interfaceBuilderNotSupported
    }
}
