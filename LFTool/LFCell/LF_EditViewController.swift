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
//            self.setCellModelContent()
        }
    }
    
    let doBtn = UIButton(fontSize: 16, fontColor: .white, text: "确定")

//    func setCellModelContent() {
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.needTableView(style: .grouped)
        self.tableView.register(BF_AgreementTableViewCell.self, forCellReuseIdentifier: "BF_AgreementTableViewCell")
        self.tableView.register(LF_EditIVTableViewCell.self, forCellReuseIdentifier: "LF_EditIVTableViewCell")

        
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenW, bottom: 0, right: 0)
//        self.tableView.backgroundColor = kF8F8F8
        self.tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
        let model = cellArr![indexPath.section][indexPath.row]
        
        if model.type == 39 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BF_AgreementTableViewCell") as! BF_AgreementTableViewCell
            
            cell.model = model
            
            return cell
            
        }
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "LF_EditIVTableViewCell") as! LF_EditIVTableViewCell
            
            cell.model = model
            
            return cell
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LF_EditTableViewCell") as! LF_EditTableViewCell
//
//        cell.model = model
//
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = cellArr![indexPath.section][indexPath.row]
        if (model.cellDidClick != nil) {
            model.cellDidClick!(tableView.cellForRow(at: indexPath))
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
            
            doBtn.setBackgroundImage(UIImage.gradient(size: CGSize(width: 100, height: 44), colors: [UIColor("#A1C73B"), UIColor("#11A23C")]), for: .normal)
            doBtn.setBackgroundImage(UIImage.createImage(with: UIColor("#A1C73B")), for: .highlighted)
            doBtn.shadowOffset = CGSize(width: 0, height: 3)
            doBtn.shadowOpacity = 0.33
            doBtn.shadowRadius = 12
            doBtn.shadowColor = UIColor.hexAlpha(hex: "#12A23C", talpha: 0.33)
            doBtn.backgroundColor = UIColor.white
            doBtn.cornerRadius = 22
            
            doBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.centerY.equalTo(view)
                make.height.equalTo(44)
            })
            
            return view
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let model = cellArr![indexPath.section][indexPath.row]
//
//        if model.type == 3 || model.type == 31 {
            let cell = cell as? LFBaseRTableViewCell
            
            if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                //只有一个
                cell?.changeShow(type: .one)
                cell?.line.isHidden = true
            } else if indexPath.row == 0 {
                //最顶端的Cell（两个向下圆弧和一条线）
                cell?.line.isHidden = false
                cell?.changeShow(type: .top)
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                //最底端的Cell（两个向上的圆弧和一条线）
                cell?.line.isHidden = true
                cell?.changeShow(type: .botton)
            } else {
                //中间的Cell
                cell?.changeShow(type: .middin)
                cell?.line.isHidden = false
                return
            }
//        }
    }
}
