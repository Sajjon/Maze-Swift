//
//  NSColor+Random.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-26.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import AppKit

extension NSColor {
    class func random() -> NSColor {
        let red =   UInt32.random(in: 0...255)
        let green = UInt32.random(in: 0...255)
        let blue =  UInt32.random(in: 0...255)
        let color = NSColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
        return color
    }
}
