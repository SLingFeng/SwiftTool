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
        self.view.sendSubviewToBack(contentView)
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
    var currentVC: UIViewController?
    ///上一个显示的vc
    var lastVC: UIViewController?
    ///当前显示第几个vc
    var showIndex = 0
//    {
//        didSet {
//            showIndexSubject.onNext(showIndex)
//        }
//    }
    var showIndexSubject = PublishSubject<Int>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentVC = self.children.first
        selIndexVC(num: 0)
    }
    
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
        guard self.children.count != 0 else {
            return
        }
        lastVC = self.children[showIndex]

        switch sw.direction {
        case .right:
            showIndex -= 1
        case .left:
            showIndex += 1
            
        default:
            break
        }

        if showIndex > self.children.count - 1 {
            //右
            showIndex = 0
            lastVC = self.children.last!
        }else if showIndex < 0 {
            //左
            showIndex = self.children.count - 1
            lastVC = self.children.first!
        }
        lastVC?.view.removeFromSuperview()
        
        LFLog(showIndex)
        self.currentVC = self.children[showIndex]
        self.contentView.addSubview(self.currentVC!.view)
        self.contentView.sendSubviewToBack(self.currentVC!.view)

        self.currentVC?.view.snp.remakeConstraints({ (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets.zero)
        })
        showIndexSubject.onNext(showIndex)
    }
    
    func selIndexVC(num: Int) {
        guard self.children.count != 0 else {
            return
        }
        self.children.forEach { (vc) in
            vc.view.removeFromSuperview()
        }
        if num <= self.children.count - 1 || num > 0 {
            
            lastVC?.view.removeFromSuperview()
            showIndex = num
            self.currentVC = self.children[showIndex]
            self.contentView.addSubview(self.currentVC!.view)
            self.contentView.sendSubviewToBack(self.currentVC!.view)

            self.currentVC?.view.snp.remakeConstraints({ (make) in
                make.edges.equalTo(self.contentView).inset(UIEdgeInsets.zero)
            })
        }
    }
    
}
