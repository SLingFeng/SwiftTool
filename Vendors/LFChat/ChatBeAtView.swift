//
//  ChatBeAtView.swift
//  jsbf
//
//  Created by big on 2019/8/27.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
///被@
class ChatBeAtView: UIView {

    let titleLabel = UILabel(fontSize: 12, fontColor: UIColor("#18C019"), text: "用户昵称")
    
    let subLabel = UILabel(fontSize: 12, fontColor: UIColor("#18C019"), text: " @了你")
    
    let xBtn = UIButton(fontSize: 17, fontColor: UIColor("#626262"), text: "x")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.cornerRadius = 17
        self.borderWidth = 1
        self.borderColor = UIColor("#E1E1E1")
        
        self.sd_addSubviews([titleLabel, subLabel, xBtn])
        
        titleLabel.snp_makeConstraints({ (make) in
            make.width.equalTo(50)
            make.centerY.equalTo(self)
            make.left.equalTo(10)
        })
        
        subLabel.snp_makeConstraints({ (make) in
            make.width.equalTo(40)
            make.centerY.equalTo(self)
            make.left.equalTo(titleLabel.snp_right)
        })
        
        xBtn.snp_makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(self)
            make.right.equalTo(-6)
        })
        
        self.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.removeFromSuperview()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
