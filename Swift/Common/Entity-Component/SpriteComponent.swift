//
//  SpriteComponent.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

public final class SpriteComponent: GameComponent {
    
    public let colorDefault: SKColor
    
    // SHOULD be set in `Game:didMove:to`
    public var sprite: SpriteNode?
    private var nextGridPosition: GridPosition?
    

    public var isPulseEffectEnabled: Bool = false {
        willSet {
            guard newValue != isPulseEffectEnabled else {
                return
            }
            
            if isPulseEffectEnabled {
                let grow: SKAction = .scale(to: 1.5, duration: 0.5)
                let shrink = grow.reversed()
                run(
                    actions: [
                        grow,
                        shrink
                    ],
                    withKey: ActionKey.pulse
                )
            } else {
                sprite?.removeAction(forKey: ActionKey.pulse.rawValue)
                run(actions: [.scale(to: 1.0, duration: 0.5)])
            }
        }
    }
    
    public init(colorDefault: SKColor) {
        self.colorDefault = colorDefault
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        interfaceBuilderNotSupported
    }
}

// MARK: Appearance
public extension SpriteComponent {
    
    func useNormalAppearance() {
        changeColor(to: colorDefault)
    }

    func useFleeAppearance() {
        changeColor(to: .white)
    }
    
    func useDefeatedAppearance() {
        run(actions: [.scale(to: 0.25, duration: 0.25)])
    }
}

public extension SpriteComponent {
    
    func setNextGridPosition(
        _ nextGridPosition: GridPosition
    ) {
        guard nextGridPosition != self.nextGridPosition else {
            return
        }
        self.nextGridPosition = nextGridPosition
        
        let move: SKAction = .move(
            to: pointFrom(gridPosition: nextGridPosition),
            duration: 0.35
        )
        
        run(
            actions: [
                move,
                actionUpdate(gridPosition: nextGridPosition)
            ],
            
            withKey: .move
        )
    }
    
    func warp(to gridPosition: GridPosition) {
        let fadeOut: SKAction = .fadeOut(withDuration: 0.5)
        let warp: SKAction = .move(
            to: pointFrom(gridPosition: gridPosition),
            duration: 0.5
        )
        let fadeIn: SKAction = .fadeIn(withDuration: 0.5)
        
        run(actions: [
            fadeOut,
            actionUpdate(gridPosition: gridPosition),
            warp,
            fadeIn
        ])
    }
    
    func followPath(
        _ path: [GKGridGraphNode],
        _ done: @escaping () -> Void
    ) {
        let actions: [SKAction] = path.dropFirst().map { node -> [SKAction] in
            
            return [
                actionMoveTo(positionOf: node),
                actionUpdate(gridPosition: node.gridPosition)
            ]
            
        }.flatMap { $0 }
        
        run(actions: actions, done)
    }
}

private extension SpriteComponent {
    
    enum ActionKey: String {
        case pulse, move
    }
    
    var scene: Scene {
        guard let sprite = sprite else {
            fatalError("No 'sprite', bad state! should have been set in 'Game' setup?")
        }
        
        guard let skScene = sprite.scene else {
            fatalError("'sprite' does not belong to ANY SKScene! Bad state?")
        }
        guard let scene = skScene as? Scene else {
            fatalError("SKScene is not of type `Scene`, what is it?")
        }
        
        return scene
    }
    
    
    func pointFrom(gridPosition: GridPosition) -> CGPoint {
        scene.pointFrom(gridPosition: gridPosition)
    }
    
    
    func changeColor(to color: SKColor) {
        guard let sprite = sprite else {
//            fatalError("Sprite is nil, this is bad!")
            return
        }
        sprite.color = color
    }
    
    // MARK: Actions
    func actionMove(
        to gridPosition: GridPosition,
        duration: TimeInterval = 0.5
    ) -> SKAction {
        .move(
            to: pointFrom(gridPosition: gridPosition),
            duration: duration
        )
    }
    
    func actionMoveTo(
        positionOf graphNode: GKGridGraphNode,
        duration: TimeInterval = 0.15
    ) -> SKAction {
        actionMove(to: graphNode.gridPosition, duration: duration)
    }
    
    func actionUpdate(gridPosition: GridPosition) -> SKAction {
        .run { [unowned self] in
            try! self.gameEntity.updateGridPosition(gridPosition)
        }
    }
    
    func run(
        actions: [SKAction],
        withKey key: ActionKey? = nil,
        _ done: (() -> Void)? = nil
    ) {
        guard let sprite = sprite else {
            fatalError("Sprite is nil, this is very bad!")
        }
        
        var actions = actions
        if let done = done {
            actions.append(SKAction.run(done))
        }
        let action: SKAction = .sequence(actions)
        
        if let key = key {
            sprite.run(action, withKey: key.rawValue)
        } else {
            sprite.run(action)
        }
    }
}
