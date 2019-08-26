//
//  Message.swift
//  NbChatView-swift
//
//  Created by xiuxiong ding on 2017/4/19.
//  Copyright © 2017年 xiuxiongding. All rights reserved.
//

import Foundation

enum MessageType {
    case chat
    case announcement
}

class Message {
    ///true 对方 false 自己
    var incoming = true
    var name = ""
    var text = ""
    var avatar = ""
    var image: UIImage?
    var imageUrl: URL?
    var imageView: UIImageView?
    var messageType: MessageType = .chat
    
    
    var time: String = {
        let calender = Calendar(identifier: .gregorian)
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd HH:mm"
        var timeString: String = formater.string(from: date)
        return timeString
    }()
    
    init(incoming: Bool, text: String, avatar: String, name: String) {
        self.incoming = incoming
        self.text = text
        self.avatar = avatar
        self.name = name
    }
    
    init(incoming: Bool, image: UIImage?, avatar: String, name: String) {
        self.incoming = incoming
        self.image = image
        self.avatar = avatar
        self.name = name
    }
    
    init(incoming: Bool, imageUrl: URL?, avatar: String, name: String) {
        self.incoming = incoming
        self.imageUrl = imageUrl
        imageView = UIImageView()
        imageView!.layer.cornerRadius = 7.0
        imageView!.layer.masksToBounds = true
        imageView!.contentMode = .scaleAspectFit
//        imageView!.sd_setImage(with: imageUrl) {[weak self] (image, e, type, url) in
//            self?.image = image
//        }
        self.avatar = avatar
        self.name = name
    }
    
    init() {
        
    }
    
}
