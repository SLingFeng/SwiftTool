//
//  LF_EditViewController.swift
//  gct
//
//  Created by big on 2019/3/6.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit

class LF_EditViewController: LFBaseTableViewController {

    var cellArr: [[LF_EditModel]]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let doBtn = UIButton(fontSize: 19, fontColor: .white, text: "确定", backg: kMainColor, radius: 5, borderColor: .clear, borderWidth: 0)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.needTableView(style: .plain)
        self.tableView.register(LF_EditTableViewCell.self, forCellReuseIdentifier: "LF_EditTableViewCell")
        
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenW, bottom: 0, right: 0)
        self.tableView.backgroundColor = kF8F8F8

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellArr == nil {
            return 0
        }
        return cellArr!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellArr == nil {
            return 0
        }
        return cellArr![section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LF_EditTableViewCell") as! LF_EditTableViewCell
        
        cell.model = cellArr![indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = cellArr![indexPath.section][indexPath.row]
        if (model.cellDidClick != nil) {
            model.cellDidClick!(tableView.cellForRow(at: indexPath) as? LF_EditTableViewCell)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == cellArr!.count - 1 {
            return 80
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == cellArr!.count - 1 {
            
            let view = UIView()
            view.backgroundColor = .white
            view.addSubview(doBtn)
            
            doBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.centerY.equalTo(view)
                make.height.equalTo(40)
            })
            
            return view
        }
        return nil
    }
    
}
