//
//  User.swift
//  gct
//
//  Created by big on 2019/4/18.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit

class User: NSObject {
    static let shared = User()
    
    var user_phone : String = ""
    
    var showAnnouncement = false
    ///去交易
    var goTran = false
    
    var goTranModel: CT_MyChooseListDataModel?
    
    private override init() {
        
    }
    
//    {
//        get {
//            return GVUserDefaults.standard().user_phone
//        }
//        set {
//            user_phone = newValue
//        }
//    }
}
