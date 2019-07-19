//
//  LFShowBackView.swift
//  gct
//
//  Created by big on 2019/4/4.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias lfShowBackClickIndex = (Int) -> Void

///消失通知
let Noti_LFShowBackViewHidden = NSNotification.Name("Noti_LFShowBackViewHidden")
///让self消失 的通知
let Noti_LFShowBackViewDoHidden = NSNotification.Name("Noti_LFShowBackViewDoHidden")

class LFShowBackView: UIView {
    
    let backgroundView = UIView(frame: kScreen)
    
    let dig = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: kScreen)

        UIApplication.shared.keyWindow?.addSubview(self)
        self.addSubview(backgroundView)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        
//        let d1 = NotificationCenter.default.rx.notification(Noti_LFShowViewDoHidden).subscribe(onNext: { (_) in
//            UIView.animate(withDuration: 0.1, animations: {
//                _backgroundView.alpha = 0
//            }) { (_) in
//                LFShowView.hiddenView()
//                _backgroundView.removeFromSuperview()
//            }
//            single(.success(0))
//        })
        NotificationCenter.default.rx.notification(Noti_LFShowBackViewDoHidden).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (_) in
            self?.hide()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundView.alpha = 1;
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

    deinit {

    }
}
