//
//  LFSwitchViewController.swift
//  jsbf
//
//  Created by big on 2019/6/21.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
///手势滑动 vc
class LFSwitchViewController: LFBaseViewController {

    lazy var contentView: UIView = {
        let contentView = UIView()
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        })
        return contentView
    }()
    
    ///存放需要滑动的vc
    var vcs: [UIViewController] = [] {
        didSet {
            vcs.forEach { (vc) in
                vc.view.isHidden = true
                self.contentView.addSubview(vc.view)
                vc.view.snp_makeConstraints({ (make) in
                    make.edges.equalTo(self.contentView).inset(UIEdgeInsets.zero)
                })
            }
            vcs[0].view.isHidden = false
        }
    }
    ///当前显示的vc
    var showIndex = 0
//    {
//        didSet {
//            showIndexSubject.onNext(showIndex)
//        }
//    }
    var showIndexSubject = PublishSubject<Int>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        self.addChild(UIViewController())
        let sw = UISwipeGestureRecognizer(target: self, action: #selector(switchVC(sw:)))
        sw.direction = .left
        self.view.addGestureRecognizer(sw)
        let sw1 = UISwipeGestureRecognizer(target: self, action: #selector(switchVC(sw:)))
        self.view.addGestureRecognizer(sw1)
    }
    
    @objc func switchVC(sw: UISwipeGestureRecognizer) {
        
        var lastVC: UIViewController = vcs[showIndex]

        switch sw.direction {
        case .right:
            showIndex -= 1
        case .left:
            showIndex += 1
            
        default:
            break
        }
        LFLog(showIndex)
        if showIndex > vcs.count - 1 {
            //右
            showIndex = 0
            lastVC = vcs.last!
        }else if showIndex < 0 {
            //左
            showIndex = vcs.count - 1
            lastVC = vcs.first!
        }
        lastVC.view.isHidden = true
        
        
        vcs[showIndex].view.isHidden = false
        showIndexSubject.onNext(showIndex)
    }
    
    func selIndexVC(num: Int) {
        vcs.forEach { (vc) in
            vc.view.isHidden = true
        }
        if num <= vcs.count - 1 || num > 0 {
            vcs[num].view.isHidden = false
            showIndex = num
        }
    }
    
}
