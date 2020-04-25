//
//  AppDelegate.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-20.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//


import Cocoa
import SpriteKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private lazy var window = createWindow(titled: "Pacman")
    private lazy var game = Game(level: .one)
 
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create game and its SpriteKit Scene
        let scene = game.scene
        scene.scaleMode = .aspectFit
        
        let nsView = NSView(frame: .init(x: 0, y: 0, width: 800, height: 600))
        window.contentView = nsView
        let skView = SKView()
        skView.translatesAutoresizingMaskIntoConstraints = false
        
        nsView.autoresizingMask = [.width, .height]
        nsView.addSubview(skView)
        skView.leadingAnchor.constraint(equalTo: nsView.leadingAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: nsView.trailingAnchor).isActive = true
        skView.topAnchor.constraint(equalTo: nsView.topAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: nsView.bottomAnchor).isActive = true
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        window.makeKeyAndOrderFront(nil)
        print("applicationDidFinishLaunching END")
    }
        
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
}

// TODO Move to extension
func createWindow(titled title: String) -> NSWindow {
    guard let frame = NSScreen.main?.frame else {
        fatalError("Failed to get main screen, do you expect to play a game without a screen?")
    }
    
    let window = NSWindow(
        contentRect:
        .init(
            origin: .zero,
            size: .init(width: frame.midX, height: frame.midY)
        ),
        
        styleMask: [.closable, .titled, .resizable, .miniaturizable],
        backing: .buffered,
        defer: false
    )
    
    window.isRestorable = true
    window.title = title
    window.isOpaque = false
    window.center()
    window.isMovableByWindowBackground = true
    window.isReleasedWhenClosed = false
    window.autorecalculatesKeyViewLoop = false
    window.animationBehavior = .default
    window.backgroundColor = NSColor(calibratedHue: 0, saturation: 1.0, brightness: 0, alpha: 0.7)

    return window
}
