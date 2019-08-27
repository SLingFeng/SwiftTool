//
//  Created File to 2019-08-23 17:37:32
//
//
//  Created by 孙凌锋   https://github.com/SLingFeng
//  Copyright © 2017年 孙凌锋. All rights reserved.
//  Reference
//      Automatic Coder https://github.com/zhangxigithub/AutomaticCoder
//      AutomaticCoder(修改版) https://github.com/yinxianwei/AutomaticCoder-
//
//  Created by 孙凌锋 on 2017/11/24.


import UIKit
import HandyJSON


class BF_ChatUserListDataModel: HandyJSON {
    
    ///Optional(哈哈哈哈1)
    var nick_name : String = ""

    ///Optional(16)
    var user_id : String = ""

    ///Optional(hqtzc0)
    var client_name : String = ""
    
    var client_id: String = ""

    ///Optional(1)
    var room_id : String = ""
    ///0普通1聊天室管理员
    var chat_admin: String = "0"
    ///Optional(http://cs.flyv888.com/upload/20190820/b6d82c901177a7bdbd51546728477ce0.jpg)
    var image_path : String = ""

     

    required init() {

    }
}
class BF_ChatUserListModel: HandyJSON {
    
    var data : [BF_ChatUserListDataModel] = []

     

    required init() {

    }
}
