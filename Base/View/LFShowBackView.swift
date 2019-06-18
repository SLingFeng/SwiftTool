//
//  LFShowBackView.swift
//  gct
//
//  Created by big on 2019/4/4.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias lfShowBackClickIndex = (Int) -> Void

class LFShowBackView: UIView {
    
    let backgroundView = UIView(frame: kScreen)
    
    let dig = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: kScreen)

        UIApplication.shared.keyWindow?.addSubview(self)
        self.addSubview(backgroundView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundView.alpha = 1;
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

    deinit {

    }
}
