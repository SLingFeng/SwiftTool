//
//  ToolBarView.swift
//  NbChatView-swift
//
//  Created by xiuxiong ding on 2017/4/19.
//  Copyright © 2017年 xiuxiongding. All rights reserved.
//

import SnapKit

class ToolBarView: UIView {
    var textView: UITextView!
    var eomjiButton: UIButton!
    
    var imageBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.cornerRadius = 5.0
        textView.scrollsToTop = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = UIColor("#F7F7F7")
        textView.returnKeyType = .send
        self.addSubview(textView)
        
        eomjiButton = UIButton()
        eomjiButton.setImage(UIImage(named: "home_chat_emoji"), for: .normal)
        self.addSubview(eomjiButton)
        
        imageBtn.setImage(UIImage(named: "home_chat_pic"), for: .normal)
        self.addSubview(imageBtn)

        
        eomjiButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.equalTo(self.snp.top).offset(15)
            make.right.equalTo(imageBtn.snp_left).offset(-15)
        }
        
        imageBtn.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.right.equalTo(-15)
            make.top.equalTo(self.snp.top).offset(15)
        })
        
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(15)
            make.top.equalTo(self.snp.top).offset(6)
            make.right.equalTo(self.snp.right).offset(-100)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
