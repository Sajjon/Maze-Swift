//
//  Scene.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import SpriteKit

public protocol SceneDelegate: SKSceneDelegate, AnyObject {
    var hasPowerup: Bool { get set }
    var playerDirection: Direction { get set }
    
    func scene(_ scene: Scene, didMoveToView: SKView)
}

public final class Scene: SKScene {
   public var sceneDelegate: SceneDelegate?
}

public extension Scene {
    
    static let cellWidth: CGFloat = 27
    var cellWidth: CGFloat { Scene.cellWidth }
    
    func pointFrom(gridPosition: GridPosition) -> CGPoint {
        let x = CGFloat(gridPosition.x) * cellWidth + cellWidth / 2
        
        let y = CGFloat(gridPosition.y) * cellWidth + cellWidth / 2
        
        return CGPoint(x: x, y: y)
    }
    
    override func didMove(to view: SKView) {
        guard let sceneDelegate = sceneDelegate else {
            fatalError("bad bad, no sceneDelegate")
        }
        sceneDelegate.scene(self, didMoveToView: view)
    }
}

#if os(macOS)
import AppKit
import Carbon.HIToolbox.Events
public extension Scene {
    override func keyDown(with event: NSEvent) {
        if let direction = Direction(event: event) {
            sceneDelegate?.playerDirection = direction
        } else {
            let keyKode = Int(event.keyCode)
            switch keyKode {
            case kVK_Space:
                sceneDelegate?.hasPowerup = true
            default: break
            }
        }
        
    }
}
#endif
