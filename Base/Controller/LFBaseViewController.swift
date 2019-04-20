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

class LFBaseViewController: UIViewController {

    var obj: Any?
    
    var index = 1
    
    public let dig = DisposeBag()
    
    lazy var webView = UIWebView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kF8F8F8
        
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.shadowImage = UIImage()

//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage.createImage(with: UIColor("#DCDCDC"))
        
    }

    override func loadView() {
        super.loadView()
    
        if  #available(iOS 11.0, *) {
            let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(self.backTap))
            self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_fanhui")
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_fanhui")
            self.navigationItem.backBarButtonItem = item

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
    
    func showLoginVC() {
        SLFHUD.showHint("请先登录后在操作", delay: 1.5) {[weak self] in
            if let strongSelf = self {
                LoginCoordinator(vc: strongSelf).start().subscribe().disposed(by: strongSelf.dig)
            }
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
