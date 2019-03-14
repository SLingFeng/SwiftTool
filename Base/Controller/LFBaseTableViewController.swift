//
//  LFBaseTableViewController.swift
//
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import SnapKit

class LFBaseTableViewController: LFBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: MyTableView!
    
    
    func needTableView(style: UITableView.Style) {
        self.tableView = MyTableView(frame: .zero, style: style)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.tState = MyTableViewStateNormal
        self.view.addSubview(self.tableView)
        if  #available(iOS 11.0, *) {
            self.tableView.estimatedSectionHeaderHeight = 0.01
            self.tableView.estimatedSectionFooterHeight = 0.01
        }
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        self.tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        })
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
    
}

class LFRxBaseTableViewController: LFBaseViewController, UITableViewDelegate {
    
    var tableView: MyTableView!
    
    
    func needTableView(style: UITableView.Style) {
        self.tableView = MyTableView(frame: .zero, style: style)
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
        self.tableView.backgroundColor = kF8F8F8
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.tState = MyTableViewStateNormal
        self.view.addSubview(self.tableView)
        if  #available(iOS 11.0, *) {
            self.tableView.estimatedSectionHeaderHeight = 0.01
            self.tableView.estimatedSectionFooterHeight = 0.01
        }
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        self.tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        })
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
    
}
