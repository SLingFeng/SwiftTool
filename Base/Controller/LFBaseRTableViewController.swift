//
//  LFBaseRTableVIewViewController.swift
//  jsbf
//
//  Created by big on 2019/6/17.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFBaseRTableViewController: LFBaseTableViewController {

    var showLine = false
    
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

class LFBaseLineRTableViewController: LFBaseTableViewController {
    
    var showCenterCellLine = false
    
    var showCenterCellLineInSection: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as? LFBaseLineRTableViewCell
        
        var bd1: BorderDirection?
        var rc: UIRectCorner?
        
        
        
        if showCenterCellLineInSection.count > 0 {
            for i in 0..<showCenterCellLineInSection.count {
                let num = showCenterCellLineInSection[i]
                if num == indexPath.section {
//                    bd1 = .allCorners
                    showCenterCellLine = true
                    break
                }
            }
            
        }
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            //只有一个
            bd1 = .allCorners
            rc = .allCorners
        } else if indexPath.row == 0 {
            //最顶端的Cell（两个向下圆弧和一条线）
            bd1 = [.top, .left, .right]
            rc = [.topLeft, .topRight]
            
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            //最底端的Cell（两个向上的圆弧和一条线）
            if showCenterCellLine {
                bd1 = [.bottom, .left, .right, .top]
            }else {
                bd1 = [.bottom, .left, .right]
            }
            rc = [.bottomLeft, .bottomRight]
            
        } else {
            //中间的Cell
            
            if showCenterCellLine {
                bd1 = .allCorners
            }else {
                bd1 = [.left, .right]
            }
            

        }
        
        cell?.backView.bd = bd1 ?? []
        cell?.backView.borderWidth = 1
        cell?.backView.borderColor = UIColor("#D2E0EC")
        cell?.backView.corners = rc ?? []
        cell?.backView.radius = rc==nil ? 0 : 7
        cell?.backView.setNeedsDisplay()
    }
    
}
