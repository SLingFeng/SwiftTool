//
//  LFTextTableViewCell.swift
//  SADF
//
//  Created by SADF on 2019/2/23.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LFTextTableViewCell: LFBaseTableViewCell {
    
    var titleLabel = UILabel(fontSize: 16, fontColor: k333333, text: "标题")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.contentView)
//            make.right.equalTo(self.contentView.snp.centerX).offset(-10)
        })
        
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
