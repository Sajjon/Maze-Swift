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
    var playerIsImmortalAndLeathal: Bool { get set }
    var playerDirection: Direction? { get set }
    
    func scene(_ scene: Scene, didMoveToView: SKView)
}

public final class Scene: SKScene {
   public var sceneDelegate: SceneDelegate?
}


public extension GridPosition {
    
    func toPointForScene() -> CGPoint {
        toCGPoint(scaleBy: Scene.cellWidth)
    }
    
    func toCGPoint(scaleBy scalingFactor: CGFloat = 1) -> CGPoint {
        func cgPoint(_ keyPath: KeyPath<Self, Scalar>) -> CGFloat {
            let scalar = self[keyPath: keyPath]
            return (CGFloat(scalar) + 0.5) * scalingFactor
        }
        
        return CGPoint(
            x: cgPoint(\.x),
            y: cgPoint(\.y)
        )
    }
}

public extension Scene {
    
    static let cellWidth: CGFloat = 27
    var cellWidth: CGFloat { Scene.cellWidth }
    
//    func pointFrom(gridPosition: GridPosition) -> CGPoint {
//        gridPosition.toCGPoint(scaleBy: cellWidth)
//    }
    
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
                sceneDelegate?.playerIsImmortalAndLeathal = true
            default: break
            }
        }
        
    }
}
#endif
