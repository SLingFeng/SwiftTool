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
    
    let dig = DisposeBag()
    
    
    init() {
        
    }
    
}

public extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    func insert(_ subElement: Element.Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(subElement, at: index)
        accept(newValue)
    }
    
    func insert(contentsOf newSubelements: Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(contentsOf: newSubelements, at: index)
        accept(newValue)
    }
    
    func remove(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
}
//https://stackoverflow.com/questions/47452582/how-to-use-behaviorrelay-as-an-alternate-to-variable-in-rxswift
