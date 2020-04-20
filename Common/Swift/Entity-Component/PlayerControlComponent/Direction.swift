//
//  Direction.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-19.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation

public enum Direction: String, Equatable {
    case left, right, up, down
}

#if os(macOS)
import AppKit
import Carbon.HIToolbox.Events
extension Direction {
    init?(event: NSEvent) {
        let keyKode = Int(event.keyCode)
        switch keyKode {
        case kVK_LeftArrow: self = .left
        case kVK_RightArrow: self = .right
        case kVK_DownArrow: self = .down
        case kVK_UpArrow: self = .up
        default: return nil
        }
    }
}
#endif
