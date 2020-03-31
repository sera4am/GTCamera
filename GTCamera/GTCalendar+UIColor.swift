//
//  GTCalendar+UIColor.swift
//  Pods_GTCamera
//
//  Created by Sera Naoto on 2020/03/30.
//  Copyright © 2020 SHIJISHA. All rights reserved.
//

import UIKit

extension UIColor {
    
    func alpha(_ alpha:CGFloat) -> UIColor? {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: nil) {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        return nil
    }
    
    static func rgb(_ rgb:String) -> UIColor? {
        var rgbText = rgb
        if rgbText.hasPrefix("#") {
            rgbText = rgbText.substring(1...)
        }
        
        var rgbList:[CGFloat] = []
        if rgbText.count == 3 {
            for n in rgbText {
                guard let dec = Int(String(n) + String(n), radix:16) else { return nil }
                if dec < 0 || dec > 255 {
                    return nil
                }
                rgbList.append(CGFloat(dec))
            }
        } else if rgbText.count == 6 {
            var p:String = ""
            for n in rgbText {
                if p.count == 0 {
                    p = String(n)
                    continue
                }
                guard let dec = Int(p + String(n), radix:16) else { return nil }
                rgbList.append(CGFloat(dec))
            }
        } else {
            return nil
        }
        
        return UIColor(red: rgbList[0] / 255.0, green: rgbList[1] / 255.0, blue: rgbList[2] / 255, alpha: 1)
    }
    
    class var backgroundClearColor:UIColor {
        get {
            let color:UIColor = .black
            return color.withAlphaComponent(0.01)
        }
    }
}
