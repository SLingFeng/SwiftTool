//
//  LF_EditIVTableViewCell.swift
//  
//
//  Created by big on 2019/6/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxSwift
import SDAutoLayout
import WPAttributedMarkup

class LF_EditIVTableViewCell: LFBaseRTableViewCell {
    
    var leftIV = UIImageView(image: UIImage(named: ""))
//    var titleLabel: UILabel = UILabel(fontSize: 16, fontColor: k333333, text: "标题")
    var tf = BaseTextField()
    var rightLabel: UILabel?
    //    var rightIV = UIImageView(image: UIImage(named: "ic_set_mor"))
    var rightBtn: UIButton?
    var dig = DisposeBag()
    var custom : UIView? {
        didSet {
            if custom != nil {
                self.addSubview(custom!)
                tf.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(custom!.snp.right).offset(-5).priority(998)
                    make.left.equalTo(leftIV.snp.right).offset(10)
                    make.height.equalTo(34)
                })
                
                custom!.snp.makeConstraints({ (make) in
                    make.size.equalTo(CGSize(width: custom!.width, height: 32))
                    make.right.equalTo(-spW)
                    make.left.equalTo(tf.snp.right).offset(5)
                    make.centerY.equalTo(self)
                })
            }else {
                tf.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(-spW)
                    make.left.equalTo(leftIV.snp.right).offset(10)
                    make.height.equalTo(34)
                })
            }
        }
    }
    var model: LF_EditModel?{
        
        didSet {
            let style = [
                "font": SLFCommonTools.pxFont(30),
                "font2": SLFCommonTools.pxFont(30),
                "color": UIColor.gray,
                //                "color2": k232931,
                //                "color3": HEXCOLOR(0xff0000)
                ] as [String : Any]
            tf.attributedPlaceholder = model!.placeholder.attributedString(withStyleBook: style)
            
            tf.text = model!.userEnterText
            tf.textFieldChange = model!.textFieldChange
            tf.textFieldEditingDidEnd = model!.textFieldEditingDidEnd
            if (model!.keyboardType != nil) {
                tf.keyboardType = model!.keyboardType!
            }
            if model!.enterType != nil {
                tf.enterType = model!.enterType!
            }
            tf.enterNumber = model!.enterNumber
            
            tf.backgroundColor = .clear
            if model!.type == 0 || model!.type == 31 {
                tf.isUserInteractionEnabled = false
//                if model!.type == 31 {
//                    tf.backgroundColor = kF8F8F8!
//                }
            }else {
                tf.isUserInteractionEnabled = true
            }
            
            self.custom = model!.custom
            tf.isSecureTextEntry = model!.isSecureTextEntry
            
            leftIV.image = UIImage(named: model!.leftIV_Image)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(leftIV)
        self.contentView.addSubview(tf)
        //        self.contentView.addSubview(rightIV)
        
//        tf.borderStyle = .roundedRect
        tf.enterSpace = 10
        tf.font = UIFont.systemFont(ofSize: 15)
        if #available(iOS 10.0, *) {
            tf.textContentType = nil
        }
        
        leftIV.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(spW)
            make.size.equalTo(CGSize(width: 20, height: 20))
        })
        
        //        tf.snp.makeConstraints({ (make) in
        //            make.centerY.equalTo(self)
        //            make.right.equalTo(-10)
        //            make.left.equalTo(titleLabel.snp.right).offset(10)
        //            make.height.equalTo(32)
        //        })
        
        //        rightIV.snp.makeConstraints({ (make) in
        //            make.size.equalTo(CGSize(width: 8, height: 14))
        //            make.right.equalTo(-10)
        //            make.centerY.equalTo(self.contentView)
        //        })
    }
    
    //    func setModel(model: LF_EditModel) {
    //
    //    }
    
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
