//
//  UIColor+Random.swift
//  Maze
//
//  Created by Alexander Cyon on 2020-04-26.
//  Copyright © 2020 Alexander Cyon. All rights reserved.
//

import UIKit

extension UIColor {
    class func random() -> UIColor {
        let redValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let greenValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let blueValue = CGFloat(arc4random_uniform(255)) / 255.0;
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}
