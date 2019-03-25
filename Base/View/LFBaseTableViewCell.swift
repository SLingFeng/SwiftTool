//
//  LFBaseTableViewCell.swift
//  gct
//
//  Created by big on 2019/3/25.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LFBaseTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    //单元格重用时调用
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
