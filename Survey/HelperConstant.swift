//
//  HelperConstant.swift
//  Survey
//
//  Created by Dan Do on 4/20/17.
//  Copyright © 2017 Dan Do. All rights reserved.
//

import Foundation
import UIKit

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

struct Color {
    static func black() -> UIColor {
        return hexStringToUIColor(hex: "0F1319")
        //return UIColor(hexString: "0F1319")
    }
    static func green() -> UIColor {
        return hexStringToUIColor(hex: "2DD9A7")

        //return UIColor(hexString: "2DD9A7")
    }
    static func red() -> UIColor {
        return hexStringToUIColor(hex: "F73E38")

        //return UIColor(hexString: "F73E38")
    }
    static func gray() -> UIColor {
        return hexStringToUIColor(hex: "565B72")

        //return UIColor(hexString: "565B72")
    }
//    static func graySubView() -> UIColor {
//        return hexStringToUIColor(hex: "0F1319")
//
//        return UIColor(hexString: "565B72")
//    }
}

enum Direction: Int {
    case Left
    case Right
}

// Animation for label.view.button
extension UIView {
    func pushTransition(_ duration:CFTimeInterval, direction: Direction) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        if direction == .Left {
            animation.subtype = kCATransitionFromLeft

        } else {
            animation.subtype = kCATransitionFromRight

        }
        
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
}
