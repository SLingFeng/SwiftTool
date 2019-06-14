//
//  LFBaseTableViewController.swift
//
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
///tableView的代理必须在base里面先写一次 然后继承的类 override 方法才起作用
class LFBaseTableViewController: LFBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: MyTableView!
    
    
    func needTableView(style: UITableView.Style) {
        self.tableView = MyTableView(frame: .zero, style: style)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        self.tableView.tState = MyTableViewStatusNormal
        self.view.addSubview(self.tableView)
        if  #available(iOS 11.0, *) {
            self.tableView.estimatedSectionHeaderHeight = 0.01
            self.tableView.estimatedSectionFooterHeight = 0.01
            self.tableView.estimatedRowHeight = 0.01;
//            self.tableView.estimatedSectionHeaderHeight = 0;
//            self.tableView.estimatedSectionFooterHeight = 0;
        }
//        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        })
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

class LFRxBaseTableViewController: LFBaseViewController, UITableViewDelegate {
    
    var tableView: MyTableView!
    
    
    func needTableView(style: UITableView.Style) {
        self.tableView = MyTableView(frame: .zero, style: style)
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
        self.tableView.backgroundColor = kF8F8F8
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.tState = MyTableViewStatusNormal
        self.view.addSubview(self.tableView)
        if  #available(iOS 11.0, *) {
            self.tableView.estimatedSectionHeaderHeight = 0.01
            self.tableView.estimatedSectionFooterHeight = 0.01
            self.tableView.estimatedRowHeight = 0.01;
//            self.tableView.estimatedSectionHeaderHeight = 0;
//            self.tableView.estimatedSectionFooterHeight = 0;
        }
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        self.tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        })
        
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0
        
        self.tableView.headerSetup()
        self.tableView.footerSetup()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

//对MyTableView增加rx扩展
extension Reactive where Base: MyTableView {
    
//    状态
    var toState: Binder<MyTableViewStatus> {
        return Binder(base) { tableView, state in
            tableView.tState = state
        }
    }
    var toFooterState: Binder<Int> {
        return Binder(base) { tableView, index in
            if index == 0 {
                tableView.mj_footer.resetNoMoreData()
            }else {
                tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
}
//对MJRefreshComponent增加rx扩展
extension Reactive where Base: MJRefreshComponent {
    
    //正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    //停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
    
    //停止刷新
//    var endRefreshingStatus: Binder<Int> {
//        return Binder(base) { refresh, status in
//            if status == 0 {
//                refresh.state = MJRefreshState(rawValue: 5)!
//            }
//            refresh.endRefreshing()
//        }
//    }
}
