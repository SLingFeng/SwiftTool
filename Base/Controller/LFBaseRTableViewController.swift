//
//  LFBaseRTableVIewViewController.swift
//  jsbf
//
//  Created by big on 2019/6/17.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFBaseRTableViewController: LFBaseTableViewController {

    var showLine = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let cell = cell as? LFBaseRTableViewCell

//        var rc: UIRectCorner?
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            //只有一个
            cell?.changeShow(type: .one)
            cell?.line.isHidden = true
//            rc = .allCorners
        } else if indexPath.row == 0 {
            //最顶端的Cell（两个向下圆弧和一条线）
            cell?.line.isHidden = false
//            rc = [.topLeft, .topRight]
            cell?.changeShow(type: .top)
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            //最底端的Cell（两个向上的圆弧和一条线）
            cell?.line.isHidden = true
//            rc = [.bottomLeft, .bottomRight]
            cell?.changeShow(type: .botton)
        } else {
            //中间的Cell
            cell?.changeShow(type: .middin)
            cell?.line.isHidden = false
            return
        }
        
        if showLine == false {
            cell?.line.isHidden = true
        }
//        let maskPath = UIBezierPath(roundedRect: cell.contentView.bounds, byRoundingCorners: rc!, cornerRadii: CGSize(width: 7, height: 7))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = cell.contentView.bounds
//        maskLayer.path = maskPath.cgPath
//        cell.layer.mask = maskLayer
    }

}
