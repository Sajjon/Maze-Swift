//
//  Scene.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import SpriteKit

public final class Scene: SKScene {}

public extension Scene {
    
    static let cellWidth: CGFloat = 27
    var cellWidth: CGFloat { Scene.cellWidth }
    
    func pointFrom(gridPosition: GridPosition) -> CGPoint {
        let x = CGFloat(gridPosition.x) * cellWidth + cellWidth / 2
        
        let y = CGFloat(gridPosition.y) * cellWidth + cellWidth / 2
        
        return CGPoint(x: x, y: y)
    }
}
