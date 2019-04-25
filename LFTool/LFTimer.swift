//
//  LFTimer.swift
//  SADF
//
//  Created by SADF on 2019/4/8.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LFTimer: NSObject {

    static let shared = LFTimer()
    
    var timer : Observable<Int>?
    var timerDib : Disposable?
    
    var num = 60 {
        didSet {
            if num <= 0 {
                timerDib?.dispose()
                num = 60
            }
//            LFLog(num)
        }
    }
    
    private override init() {
        
    }
    
    func startTimer() {
        
        timerDib?.dispose()
        
        timer = Observable<Int>.interval(RxTimeInterval(1), scheduler: MainScheduler.instance)
        
        timerDib = timer!.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.num -= 1
            }
        }, onError: { (e) in
        }, onCompleted: {
        }, onDisposed: {
        })
    }
    
}
