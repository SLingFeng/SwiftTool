//
//  ChatBaseCell.swift
//  NbChatView-swift
//
//  Created by xiuxiong ding on 2017/4/19.
//  Copyright © 2017年 xiuxiongding. All rights reserved.
//

import UIKit
class ChatBaseCell: UITableViewCell {
    
    typealias cellChangeBlock = () -> ()
    
    var avatarImageView: UIImageView!
    let timeLabel = UILabel(fontSize: 12, fontColor: UIColor("#A3A3A3"), text: "")
    
    let userName = UILabel(fontSize: 12, fontColor: k858585, text: "昵称")
    
    var cellChange: cellChangeBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xF7F5F9)
        
        timeLabel.textAlignment = .center
        
        avatarImageView = UIImageView()
        avatarImageView.cornerRadius = 27.5
//        avatarImageView.layer.masksToBounds = true
        
        self.addSubview(avatarImageView)
        self.addSubview(timeLabel)
        self.addSubview(userName)
    }
    
    func setUpWithModel(message: Message) {
        timeLabel.text = message.time
        userName.text = message.name
//        avatarImageView.image = UIImage(named: message.avatar)
        
        avatarImageView.sd_setImage(with: URL(string: message.avatar), placeholderImage: kPlaceholderImageUser)
//        #if DEBUG
//        avatarImageView.backgroundColor = .red
//        #endif
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(2)
            make.height.equalTo(10)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            if message.incoming {
                make.left.equalTo(self.snp.left).offset(10)
            } else {
                make.right.equalTo(self.snp.right).offset(-10)
            }
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.size.equalTo(55)
        }
        
        userName.snp_makeConstraints({ (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(17)
            if message.incoming {
                make.left.equalTo(avatarImageView.snp.right).offset(10)
            } else {
                make.right.equalTo(avatarImageView.snp.left).offset(-10)
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
