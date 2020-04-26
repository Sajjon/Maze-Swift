//
//  AppDelegate.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-20.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//


import Cocoa
import SpriteKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private lazy var window = createWindow(titled: "Pacman")
    private lazy var game = Game(level: .one)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create game and its SpriteKit Scene
        let scene = game.scene
        scene.scaleMode = .aspectFit
        
        window.contentView = AppDelegate.createView { sceneView in
            sceneView.presentScene(scene)
        }
        
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
}

private extension AppDelegate {
    static func createView(_ presentSceneIn: (SKView) -> Void) -> NSView {
        let nsView = NSView(frame: .init(x: 0, y: 0, width: 800, height: 600))
        let skView = SKView()
        skView.translatesAutoresizingMaskIntoConstraints = false
        
        nsView.autoresizingMask = [.width, .height]
        nsView.addSubview(skView)
        skView.leadingAnchor.constraint(equalTo: nsView.leadingAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: nsView.trailingAnchor).isActive = true
        skView.topAnchor.constraint(equalTo: nsView.topAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: nsView.bottomAnchor).isActive = true
        presentSceneIn(skView)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        return nsView
    }
}
