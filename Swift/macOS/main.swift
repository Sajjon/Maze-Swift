//
//  main.swift.swift
//  Maze-iOS
//
//  Created by Alexander Cyon on 2020-04-20.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import Cocoa


// This is the entry point of our program for more info see: https://stackoverflow.com/a/50750540/1311272
let app = NSApplication.shared
//let delegate = AppDelegate(didCloseWindow: { [unowned app] in
//    print("Window was closed => terminating app")
//    app.terminate(nil)
//})

let delegate = AppDelegate()

app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

