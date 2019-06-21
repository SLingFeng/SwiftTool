//
//  LFButton.swift
//  SADF
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

enum MKButtonEdgeInsetsStyle : Int {
    case top // image在上，label在下
    case left // image在左，label在右
    case bottom // image在下，label在上
    case right // image在右，label在左
}

class LFButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
struct UIButtonKeys {
    static var onClick = "konClick"
//    static var kAnotherProperty = "kAnotherProperty"
}
extension UIButton {

//    (str: String) -> Void
    
//    var onClick: (_ sender: UIButton) -> Void {
//        get {
//            return objc_getAssociatedObject(self, &UIButtonKeys.onClick) as! (UIButton) -> Void
//        }
//
//        set {
//            objc_setAssociatedObject(self,&UIButtonKeys.onClick, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
    
    
    
    public convenience init(fontSize: CGFloat, fontColor: UIColor?, text: String?) {
        self.init()

        
        self.setTitleColor(fontColor, for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: fontSize)
        self.setTitle(text, for: .normal)
    }
    
    public convenience init(fontSize: CGFloat, fontColor: UIColor?, text: String?, backg: UIColor?, radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) {
        self.init()
        
        self.setTitleColor(fontColor, for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: fontSize)
        self.setTitle(text, for: .normal)
        self.backgroundColor = backg
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
//    func setClick() {
//        self.addTarget(self, action: #selector(onBtnClick(sender:)), for: .touchUpInside)
//    }
//    
//    @objc func onBtnClick(sender: UIButton) {
//        self.onClick(sender)
//    }
    
    class func button(with buttonType: UIButton.ButtonType, fontSize: CGFloat, fontColor color: UIColor?, fontText text: String?) -> UIButton {
        return UIButton.button(with: buttonType, fontSize: fontSize, fontColor: color, fontText: text, backg: UIColor.clear, radius: 0, borderColor: UIColor.clear, borderWidth: 0)
    }
    
    class func button(with buttonType: UIButton.ButtonType, fontSize: CGFloat, fontColor color: UIColor?, fontText text: String?, backg: UIColor?, radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) -> UIButton {
        let btn: UIButton = UIButton.init(type: buttonType)
        btn.setTitleColor(color, for: .normal)
        btn.titleLabel!.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitle(text, for: .normal)
        
        btn.backgroundColor = backg
        btn.layer.cornerRadius = radius
        btn.layer.borderColor = borderColor?.cgColor
        btn.layer.borderWidth = borderWidth
        btn.layer.masksToBounds = true
//        btn.setup()
        return btn
    }
 
    func layoutButton(with style: MKButtonEdgeInsetsStyle, imageTitleSpace space: CGFloat) {
        
        //    self.backgroundColor = [UIColor cyanColor];
        
        /**
         
         *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
         
         *  如果只有title，那它上下左右都是相对于button的，image也是一样；
         
         *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
         
         */
        
        // 1. 得到imageView和titleLabel的宽、高
        
        let imageWith: CGFloat! = Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 ? imageView?.intrinsicContentSize.width : imageView?.frame.size.width
        
        let imageHeight: CGFloat! = Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 ? imageView?.intrinsicContentSize.height : imageView?.frame.size.height
        
        var labelWidth: CGFloat = 0.0
        
        var labelHeight: CGFloat = 0.0
        
        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
            
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            
            labelWidth = titleLabel?.intrinsicContentSize.width ?? 0.0
            
            labelHeight = titleLabel?.intrinsicContentSize.height ?? 0.0
        } else {
            
            labelWidth = titleLabel?.frame.size.width ?? 0.0
            
            labelHeight = titleLabel?.frame.size.height ?? 0.0
        }
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        
        var imageEdgeInsets: UIEdgeInsets = .zero
        
        var labelEdgeInsets: UIEdgeInsets = .zero
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        
        switch style {
        case .top:
            
            imageEdgeInsets = UIEdgeInsets(top: CGFloat(-labelHeight - space / 2.0), left: 0, bottom: 0, right: -labelWidth)
            
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: CGFloat(-imageHeight - space / 2.0), right: 0)
        case .left:
            
            imageEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(-space / 2.0), bottom: 0, right: CGFloat(space / 2.0))
            
            labelEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(space / 2.0), bottom: 0, right: CGFloat(-space / 2.0))
        case .bottom:
            
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(-labelHeight - space / 2.0), right: -labelWidth)
            
            labelEdgeInsets = UIEdgeInsets(top: CGFloat(-imageHeight - space / 2.0), left: -imageWith, bottom: 0, right: 0)
        case .right:
            
            imageEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(labelWidth + space / 2.0), bottom: 0, right: CGFloat(-labelWidth - space / 2.0))
            
            labelEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(-imageWith - space / 2.0), bottom: 0, right: CGFloat(imageWith + space / 2.0))        
        }
        
        // 4. 赋值
        
        self.titleEdgeInsets = labelEdgeInsets
        
        self.imageEdgeInsets = imageEdgeInsets
    }
}
