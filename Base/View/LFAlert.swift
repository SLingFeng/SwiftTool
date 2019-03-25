//
//  LFAlert.swift
//  SADF
//
//  Created by SADF on 2019/3/4.
//  Copyright © 2019 SADF. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

typealias alertClickIndex = (Int) -> Void

class LFAlert: NSObject {
    
   
    
    class func initAlert(title: String, leftTitle: String, rightTitle: String, change: Bool, contentView: UIView?) -> Single<Int> {
//        let dig = DisposeBag()

        return Single<Int>.create { single in
            
            let _backgroundView = UIView(frame: kScreen)
            _backgroundView.tag = 67893
            UIApplication.shared.keyWindow?.addSubview(_backgroundView)
            
            let b = UIView(frame: kScreen)
            b.backgroundColor = SLFCommonTools.colorHex(0x000000, alpha: 0.5)
            _backgroundView.addSubview(b)
            
            let alertView = UIView()
            _backgroundView.addSubview(alertView)
            alertView.backgroundColor = .white
            alertView.layer.masksToBounds = true
            alertView.layer.cornerRadius = 5
            
            let titleLabel = UILabel(fontSize: 19, fontColor: k333333, text: title)
            alertView.addSubview(titleLabel)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
            titleLabel.textAlignment = .center
            
            let leftBtn = UIButton(fontSize: 19, fontColor: k666666, text: leftTitle)
            alertView.addSubview(leftBtn)
            leftBtn.backgroundColor = UIColor("#DDDDDD")
            leftBtn.layer.cornerRadius = 5
            
            let rightBtn = UIButton(fontSize: 19, fontColor: .white, text: rightTitle)
            alertView.addSubview(rightBtn)
            rightBtn.backgroundColor = kMainColor
            rightBtn.layer.cornerRadius = 5
            
            alertView.snp.makeConstraints({ (make) in
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.centerX.equalTo(_backgroundView)
                make.centerY.equalTo(_backgroundView).offset(-50)
                if (contentView != nil) {
                    make.height.equalTo(150 + contentView!.frame.size.height)
                }else {
                    make.height.equalTo(150)
                }
            })
            if (contentView != nil) {
                alertView.addSubview(contentView!)
                
                contentView!.snp.makeConstraints({ (make) in
                    make.left.right.equalTo(0)
                    make.top.equalTo(titleLabel.snp.bottom).offset(20)
                    make.height.equalTo(contentView!.frame.height)
                })
            }
            
            _ = leftBtn.rx.tap.subscribe({_ in
//                LFAlert.removeView()
                UIView.animate(withDuration: 0.3, animations: {
                    _backgroundView.alpha = 0
                }) { (_) in
                    _backgroundView.removeFromSuperview()
                }
                single(.success(0))
            })
            
            _ = rightBtn.rx.tap.subscribe({_ in
//                LFAlert.removeView()
                UIView.animate(withDuration: 0.3, animations: {
                    _backgroundView.alpha = 0
                }) { (_) in
                    _backgroundView.removeFromSuperview()
                }
                single(.success(1))
            })
            
            titleLabel.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(20)
            })
            
            rightBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(-10)
                make.height.equalTo(40)
                make.bottom.equalTo(-20)
                make.left.equalTo(leftBtn.snp.right).offset(15)
            })
            
            leftBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(10)
                make.height.equalTo(40)
                make.bottom.equalTo(-20)
                make.right.equalTo(rightBtn.snp.left).offset(-15)
                make.width.equalTo(rightBtn).priority(999)
            })
            
            
            
            return Disposables.create()
        }
    }
    
    
    class func removeView() {
        if let view = UIApplication.shared.keyWindow?.viewWithTag(67893) {
            
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 0
            }) { (_) in
                view.removeFromSuperview()
            }
        }
    }
    
}

