//
//  LFPaoMaView.swift
//
//  Created by SADF on 2019/4/25.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LFPaoMaView: UIView {

    let title = UILabel(fontSize: 15, fontColor: UIColor("#379AFF"), text: "")
    
    var timer : Observable<Int>?
    var timerDib : Disposable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(title)
        self.layer.masksToBounds = true
        title.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
    }
    
    func start() {
//        UIView.animate(withDuration: 0.1) {
//            self.title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//        }

        timerDib?.dispose()
        
        timer = Observable<Int>.interval(0.02, scheduler: MainScheduler.instance)
        
        timerDib = timer!.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.moveLabel()
                
            }
        })
    }
    
    func moveLabel() {
        
        let tw = SLFCommonTools.textSize(title.text, font: title.font).width + 1
        
//        if tw < self.frame.size.width {
//            return
//        }
        
        var rect = title.frame
        rect.size.width = tw
        
        let sp = (title.frame.origin.x + title.frame.size.width)
//        debugPrint(String(format: "%f-%f", sp, tw))
        if sp < 0 {
            rect.origin.x = self.frame.size.width
        }else {
        
            rect.origin.x -= 1
        }
        title.frame = rect

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timerDib?.dispose()
    }
}
