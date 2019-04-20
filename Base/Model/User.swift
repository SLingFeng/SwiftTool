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
