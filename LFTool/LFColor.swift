//
//  LFColor.swift
//  SADF
//
//  Created by SADF on 2019/2/21.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

let kMainColor = SLFCommonTools.colorHex("#e70202")
let k333333 = SLFCommonTools.colorHex("#333333")
let k666666 = SLFCommonTools.colorHex("#666666")
let k999999 = SLFCommonTools.colorHex("#999999")

let kF8F8F8 = SLFCommonTools.colorHex("#F8F8F8")

let kEEEEEE = SLFCommonTools.colorHex("#EEEEEE")
let kDDDDDD = SLFCommonTools.colorHex("#DDDDDD")
let k0076FF = UIColor("#0076FF")

let kF62028 = UIColor("#F62028")



class LFColor: NSObject {

//    class func MainColor() -> UIColor {
//        return SLFCommonTools.colorHex("#F52028")
//    }
//
//    class func k333333() -> UIColor {
//        return SLFCommonTools.colorHex("#333333")
//    }
//
//    class func k666666() -> UIColor {
//        return SLFCommonTools.colorHex("#666666")
//    }
//
    class func k999999() -> UIColor {
        return SLFCommonTools.colorHex("#999999")
    }
    //渐变
    class func jianbian(gradientColors: Array<CGColor>, frame: CGRect) -> CAGradientLayer {
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        //设置渲染的起始结束位置（横向渐变）
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = frame
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
}


extension UIColor {
    
    class func hex(hex: String) -> UIColor {
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default: break
//                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
//            print("Scan hex error")
        }
        return UIColor.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func hexAlpha(hex: String, talpha: CGFloat) -> UIColor {
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = talpha
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default: break
//                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
//            print("Scan hex error")
        }
        return UIColor.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}
//---------------------
//作者：jhy835239104
//原文：https://blog.csdn.net/jhy835239104/article/details/79611974
