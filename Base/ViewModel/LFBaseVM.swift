//
//  LFBaseVM.swift
//  gct
//
//  Created by big on 2019/3/18.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LFBaseVM {

    //停止刷新状态序列
    var endHeaderRefreshing: Driver<Bool> = Driver.just(false)
    
    //停止尾部刷新状态
    var endFooterRefreshing: Driver<Bool> = Driver.just(false)
    
    var status: Driver<MyTableViewStatus> = Driver.just(MyTableViewStatusNormal)
    var footerStatus: Driver<Int> = Driver.just(0)
    
    var page = 1
    
    init() {
        
    }
    
}
