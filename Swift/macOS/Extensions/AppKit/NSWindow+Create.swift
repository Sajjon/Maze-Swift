//
//  NSWindow+Create.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-26.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import AppKit

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
