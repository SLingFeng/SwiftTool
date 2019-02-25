//
//  LFTool.swift
//  
//
//  Created by SADF on 2019/2/12.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

public let kScreenW = UIScreen.main.responds(to: #selector(getter: UIScreen.nativeBounds)) ? UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale : UIScreen.main.bounds.size.width

public let kScreenH = UIScreen.main.responds(to: #selector(getter: UIScreen.nativeBounds)) ? UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale : UIScreen.main.bounds.size.height

class LFTool: NSObject {

    public class func LF_isIPHONEXLAST () -> Bool {
        var isX = false
    
        //判断iPHoneXr
        if (UIScreen.main.preferredMode?.size.equalTo(CGSize.init(width: 828, height: 1792)))! {
            isX = true
        }
        //判断iPhoneXs iPHoneX
        if (UIScreen.main.preferredMode?.size.equalTo(CGSize.init(width: 1125, height: 2436)))! {
            isX = true
        }
        //判断iPhoneXs Max
        if (UIScreen.main.preferredMode?.size.equalTo(CGSize.init(width: 1242, height: 2688)))! {
            isX = true
        }
//        print(isX)
        return isX
    }
    
    
    public class func Log<T>(m: T,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line) {
        //新版本的 LLVM 编译器在遇到这个空方法时，甚至会直接将这个方法整个去掉，完全不去调用它，从而实现零成本。 https://swifter.tips/log/
        #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(m)")
        #endif
    }
    // MARK: - 九宫格
    public class func JGG_X(_ xl: CGFloat, _ width: CGFloat, _ w: CGFloat, _ i: CGFloat, _ count: CGFloat) -> CGFloat {
        return xl + (width + w) * (i.truncatingRemainder(dividingBy: count))
    }
    public class func JGG_Y(_ yl: CGFloat, _ height: CGFloat, _ h: CGFloat, _ i: Int, _ count: Int) -> CGFloat {
        return yl + (height + h) * CGFloat(i / (count))
    }
    
    //字符串是否为空
    public class func kStringIsEmpty(_ str: NSString) -> Bool {
        return (str.isKind(of: NSNull.self)) || str.length < 1 ? true : false
    }
    //数组是否为空
    public class func kArrayIsEmpty(_ array: NSArray) -> Bool {
        return (array.isKind(of: NSNull.self)) || array.count == 0
    }
    //字典是否为空
    public class func kDictIsEmpty(_ dic: NSDictionary) -> Bool {
        return (dic.isKind(of: NSNull.self)) || dic.allKeys.count == 0
    }
    //是否是空对象
    public class func kObjectIsEmpty(_ object: Any) -> Bool {
        return ((object as AnyObject).isKind(of: NSNull.self)) || ((object as AnyObject).responds!(to: #selector(getter: NSData.length)) && ((object as? Data)?.count ?? 0) == 0)  || ((object as AnyObject).responds!(to: #selector(getter: NSArray.count)) && (object as? [Any])?.count == 0)
    }
    
    public class func kViewBorderRadius(view: UIView, radius: CGFloat, width: CGFloat, color: UIColor) {
        if view.isKind(of: UIView.self) {
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
            view.layer.borderWidth = width
            view.layer.borderColor = color.cgColor
        }
    }
    
    
    public class func shapeLine(view: UIView, bouns: CGRect, lineWidth: CGFloat, strokeColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        let layer = CAShapeLayer()
        layer.frame = bouns
        layer.strokeColor = UIColor.clear.cgColor
//        layer.lineDashPattern = [1,2]
//        layer.lineWidth = 3
        layer.fillColor = UIColor.clear.cgColor
        layer.contentsScale = UIScreen.main.scale
        view.layer.addSublayer(layer)
        
        let m = CAShapeLayer()
        m.strokeColor = strokeColor.cgColor
        m.lineWidth = lineWidth
        m.contentsScale = UIScreen.main.scale
        
        let left = UIBezierPath()
        left.move(to: startPoint)
        left.addLine(to: endPoint)
        m.path = left.cgPath
        layer.addSublayer(m)
    }
    
    
}

//var str = "hangge.com"
//print(str[7,3])
//print(str[7])
//
//str[7,3] = "COM"
//str[0] = "H"
//
//print(str[0,10])
extension String
{
    subscript(start:Int, length:Int) -> String
    {
        get{
            let index1 = self.index(self.startIndex, offsetBy: start)
            let index2 = self.index(index1, offsetBy: length)
            return String(self[index1..<index2])
        }
        set{
            let tmp = self
            var s = ""
            var e = ""
            for (idx, item) in tmp.enumerated() {
                if(idx < start)
                {
                    s += "\(item)"
                }
                if(idx >= start + length)
                {
                    e += "\(item)"
                }
            }
            self = s + newValue + e
        }
    }
    subscript(index:Int) -> String
    {
        get{
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set{
            let tmp = self
            self = ""
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                }else{
                    self += "\(item)"
                }
            }
        }
    }
}

