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
    var sendBtn = UIButton(fontSize: 15, fontColor: kMainColor, text: "发送", backg: UIColor("#F7F7F7"), radius: 20, borderColor: UIColor("#EEEEEE"), borderWidth: 1)
    
    let backView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        self.addSubview(backView)
        backView.backgroundColor = UIColor("#F7F7F7")
        backView.cornerRadius = 20
        
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
//        textView.layer.cornerRadius = 5.0
        textView.enablesReturnKeyAutomatically = true
        textView.scrollsToTop = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = .clear
        textView.returnKeyType = .send
        self.addSubview(textView)
        
        self.addSubview(sendBtn)
        
        eomjiButton = UIButton()
        eomjiButton.setImage(UIImage(named: "home_chat_emoji"), for: .normal)
        self.addSubview(eomjiButton)

        imageBtn.setImage(UIImage(named: "home_chat_pic"), for: .normal)
        self.addSubview(imageBtn)

        backView.snp_makeConstraints({ (make) in
            make.left.equalTo(15)
            make.right.equalTo(-76)
            make.top.equalTo(self.snp.top).offset(8)
            make.height.equalTo(40)
        })

        eomjiButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.right.equalTo(imageBtn.snp_left).offset(-6)
            make.centerY.equalTo(backView)
        }

        imageBtn.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.right.equalTo(backView.snp_right).offset(-6)
            make.centerY.equalTo(backView)
        })
        
        sendBtn.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 50, height: 40))
            make.right.equalTo(-15)
            make.top.equalTo(self.snp.top).offset(7)
        })
        
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(15)
            make.top.equalTo(self.snp.top).offset(6)
            make.right.equalTo(eomjiButton.snp.left).offset(-6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
