//
//  LFTool.swift
//  
//
//  Created by SADF on 2019/2/12.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFTool: NSObject {
    
    static public let kScreenW = UIScreen.main.responds(to: #selector(getter: UIScreen.nativeBounds)) ? UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale : UIScreen.main.bounds.size.width

    static public let kScreenH = UIScreen.main.responds(to: #selector(getter: UIScreen.nativeBounds)) ? UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale : UIScreen.main.bounds.size.height

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
    public class func JGG_Y(_ yl: CGFloat, _ height: CGFloat, _ h: CGFloat, _ i: CGFloat, _ count: CGFloat) -> CGFloat {
        return yl + (height + h) * (i / (count))
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
    
    
    
}
