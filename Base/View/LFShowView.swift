//
//  LFShowView.swift
//  jsbf
//
//  Created by big on 2019/6/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class LFShowView: NSObject {

    
    class func show(tapPoint: CGPoint, contentView: UIView?) -> Single<Int> {
        //        let dig = DisposeBag()
        
        return Single<Int>.create { single in
            
//            let rect = UIApplication.shared.keyWindow?.convert(, to: UIApplication.shared.keyWindow)
            
            let _backgroundView = UIView(frame: kScreen)
//            _backgroundView.tag = 67893
//            _backgroundView.alpha = 0.3
            
            UIApplication.shared.keyWindow?.addSubview(_backgroundView)
            
            let b = UIView(frame: kScreen)
            b.backgroundColor = SLFCommonTools.colorHex(0x000000, alpha: 0.3)
            _backgroundView.addSubview(b)
            
            let alertView = UIView()
            _backgroundView.addSubview(alertView)
            alertView.backgroundColor = UIColor("#F3F3F3")
//            alertView.layer.cornerRadius = 13
            
            alertView.snp.makeConstraints({ (make) in
                make.top.equalTo(tapPoint.y)
                make.left.right.equalTo(0)
                if (contentView != nil) {
                    make.height.equalTo(50 + contentView!.frame.size.height)
                }else {
                    make.height.equalTo(325)
                }
            })
            
            
            
            if (contentView != nil) {
                alertView.addSubview(contentView!)
                
                contentView!.snp.makeConstraints({ (make) in
                    make.edges.equalTo(UIEdgeInsets.zero)
//                    make.height.equalTo(contentView!.frame.height)
                })
            }
            
            
            let d2 = b.rx.tapGesture().when(.recognized).subscribe(onNext: { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    _backgroundView.alpha = 0
                }) { (_) in
                    _backgroundView.removeFromSuperview()
                }
                single(.success(0))
            })
            return Disposables.create{
                d2.dispose()
            }
        }
    }
    

}
