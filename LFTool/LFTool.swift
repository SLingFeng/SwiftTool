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

let kScreen = UIScreen.main.bounds

public func LFLog<T>(_ m: T,
                         file: String = #file,
                         method: String = #function,
                         line: Int = #line) {
    //新版本的 LLVM 编译器在遇到这个空方法时，甚至会直接将这个方法整个去掉，完全不去调用它，从而实现零成本。 https://swifter.tips/log/
    #if DEBUG
    NSLog("%@", "\((file as NSString).lastPathComponent)[\(line)], \(method): \(m)")
//    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(m)")
    #endif
}

let kPlImage = UIImage(named: "png_home_no")

class LFTool: NSObject {

    public class func isIPHONEXLAST() -> Bool {
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
    
    public class func Height_StatusBar() -> CGFloat {
        return LFTool.isIPHONEXLAST() ? 44.0 : 20.0
    }
    
    public class func Height_NavBar() -> CGFloat {
        return LFTool.isIPHONEXLAST() ? 88.0 : 60.0
    }
    
    public class func Height_TabBar() -> CGFloat {
        return LFTool.isIPHONEXLAST() ? 83.0 : 49.0
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
    ///宽除高得出比例
    class func heightScaleTo(scale: CGFloat, width: CGFloat) -> CGFloat {
        return width/scale
    }
    ///缩写万元
    class func toWanYi(money: String) -> String {
//        if money.count >= 9 {
//            let t = Double(money)! / 10000 / 10000
//            return String(format: "%.2f亿", t)
//        }else
            if money.count >= 5 {
            let t = Double(money)! / 10000
            return String(format: "%.2f万", t)
        }
        return money + "元"
    }
    class func toWanShou(money: String) -> String {
        if money.count >= 5 {
            let t = Double(money)! / 10000
            
            return String(format: "%.2f万手", t)
        }
        return money + "手"
    }
    //股票代码 1:上证 2深证
    class func marketJudgment(code: String) -> String {
        if (code.isEmpty == false && code.count > 3) {
            let topThree = (code as NSString).substring(to: 3)//code.slice(0, 3);
            switch (topThree) {
            case "110",
             "120",
             "129",
             "100",
             "201",
             "310",
             "500",
             "550",
             "600",
             "700",
             "710",
             "701",
             "720",
             "730",
             "735",
             "737",
             "900",
             "601",
             "603":
                return "1"
            default:
            return "2"
            }
        }
        return ""
    }
    //MARK: - 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
    class func isBetween(fromHour: Int, toHour: Int) -> Bool {
        
        let dateFrom = LFTool.getCustomDate(withHour: fromHour)
        let dateTo = LFTool.getCustomDate(withHour: toHour)
        
        let currentDate = Date()
        if currentDate.compare(dateFrom!) == .orderedDescending && currentDate.compare(dateTo!) == .orderedAscending {
            return true
        }
        return false
    }
    /// 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
    ///
    /// - Parameter hour: 如hour为“8”，就是上午8:00（本地时间）
    /// - Returns:
    class func getCustomDate(withHour hour: Int) -> Date? {
        //获取当前时间
        let currentDate = Date()
        let currentCalendar = Calendar(identifier: .gregorian)
        var currentComps = DateComponents()
        
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .weekday, .hour, .minute, .second])
        
        currentComps = currentCalendar.dateComponents(unitFlags, from: currentDate)
        
        //设置当天的某个点
        var resultComps = DateComponents()
        resultComps.year = currentComps.year
        resultComps.month = currentComps.month
        resultComps.day = currentComps.day
        resultComps.hour = hour
        
        let resultCalendar = Calendar(identifier: .gregorian)
        return resultCalendar.date(from: resultComps)
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

