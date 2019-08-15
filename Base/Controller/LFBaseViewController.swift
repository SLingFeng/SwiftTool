//
//  LFBaseViewController.swift
//
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UIColor_Hex_Swift

class LFBaseViewController: UIViewController {

    var obj: Any?
    
    var index = 1
    
    public let dig = DisposeBag()
    
    lazy var webView = UIWebView(frame: CGRect.zero)
    
//    var topLoadView: LFLoadView!
    
    lazy var navTitleLabel: UILabel = {
        let label = UILabel(fontSize: 23, fontColor: .white, text: "")
        label.tag = 123
        label.frame = CGRect(x: 15, y: 0, width: 200, height: 38)
        self.navigationController?.navigationBar.addSubview(label)
        return label
    }()
    
    func changeNavLabel(isHidden: Bool) {
        if let v = self.navigationController?.navigationBar.viewWithTag(123) {
            v.isHidden = isHidden
        }
//        UIView.animate(withDuration: 0.11, animations: {
//            v?.alpha = isHidden ? 0 : 1
//        }) { (b) in
        
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.shadowImage = UIImage()

//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
//        self.navigationController?.navigationBar.shadowImage = UIImage.createImage(with: UIColor("#DCDCDC"))
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }

    override func loadView() {
        super.loadView()
    
        if  #available(iOS 11.0, *) {
            let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(self.backTap))
            self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "")
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "")
            self.navigationItem.backBarButtonItem = item

        }else if  #available(iOS 10.0, *) {
        //自定义返回按钮
        var backButtonImage: UIImage? = nil
            backButtonImage = UIImage(named: "me_icon_back")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        
        //将返回按钮的文字position设置不在屏幕上显示
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: CGFloat(NSInteger.min), vertical: CGFloat(NSInteger.min)), for: .default)
        }
        
    }
    
    @objc func backTap() {
        self.navigationController!.popViewController(animated: true)
    }
    
    public func setNavTitle(_ text: String) {
        self.navigationItem.title = text
    }
    
    deinit {
        LFLog("\(self.self)")
    }
    
    func showLoginVC(_ go: Bool = true) {
        if go {
            SLFHUD.showHint("请先登录", delay: 1.5) {[weak self] in
                if let strongSelf = self {
                    LoginCoordinator(str: "").start().subscribe().disposed(by: strongSelf.dig)
                }
                self?.tabBarController?.selectedIndex = 4
            }
        }else {
            SLFHUD.showHint("请先登录")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//    func leftView() {
//
//        let logoIV = UIImageView()
//        topLoadView = LFLoadView(logoIV, gifName: "topLogoLoad")
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: topLoadView)
//        logoIV.sd_setImage(with: URL(string: ApiUrl + GVUserDefaults.standard().app_web_logo)) {[weak self] (image, e, type, url) in
//            if image != nil {
//                self?.topLoadView.changeLoad(true)
//            }
//        }
//
//        logoIV.widthAnchor.constraint(equalToConstant: 106).isActive = true
//        logoIV.heightAnchor.constraint(equalToConstant: 32).isActive = true
//    }
}

//扩展view 显示Hud
extension Reactive where Base: UIViewController {
    //让验证结果（ValidationResult类型）可以绑定到label上
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            switch result {
            case .ok(let m),
                 .failed(let m):
                SLFHUD.show(in: label.view, hint: m)
            case .empty: break
            case .validating: break
//            case .failed(let message):
//                SLFHUD.show(in: label.view, hint: message)
            }
            
//            label.textColor = result.textColor
//            label.text = result.description
        }
    }
}
public enum ValidationResult {
    case ok(_ message: String)
    case empty
    case validating
    case failed(_ message: String)
}
extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
