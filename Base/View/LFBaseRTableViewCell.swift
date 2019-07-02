//
//  LFBaseRTableViewCell.swift
//  
//
//  Created by big on 2019/6/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

enum LFBaseRShowType {
    case one
    case top
    case middin
    case botton
}

class LFBaseRTableViewCell: LFBaseTableViewCell {

//    let showType: LFBaseRShowType
    let line = UIView()
    
    let radiusView = UIImageView(image: UIImage(named: "home_shape"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(radiusView)

        self.contentView.addSubview(line)
        line.backgroundColor = UIColor("#D2E0EC")


        radiusView.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets(top: 2.3, left: 8.2, bottom: 2.3, right: 8.3))
        })

        line.snp.makeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(1)
            make.left.equalTo(28)
            make.right.equalTo(-29)
        })
    }
    
    func changeShow(type: LFBaseRShowType) {
        if type == .top {
            radiusView.image = UIImage(named: "home_shape_1")
            radiusView.snp.remakeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: -2.3, left: 8.2, bottom: 0, right: 8.3))
            })
            
        }else if type == .middin {
            radiusView.image = UIImage(named: "home_shape_2")
            radiusView.snp.remakeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 8.2, bottom: 0, right: 8.3))
            })
            
        }else if type == .botton {
            radiusView.image = UIImage(named: "home_shape_3")
            radiusView.snp.remakeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 8.2, bottom: -2.3, right: 8.3))
            })
            
        }else if type == .one {
            radiusView.image = UIImage(named: "home_shape")
            radiusView.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: 2.3, left: 8.2, bottom: 2.3, right: 8.3))
            })
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
///带线
class LFBaseLineRTableViewCell: LFBaseTableViewCell {
    
    let backView = LFLineRView(frame: .init(x: 15, y: 0, width: kScreenW - 30, height: 0))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(backView)
        
        self.selectionStyle = .none

        backView.snp_makeConstraints({ (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.top.equalTo(0)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
