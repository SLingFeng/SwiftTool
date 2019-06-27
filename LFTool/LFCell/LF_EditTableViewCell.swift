//
//  LF_EditTableViewCell.swift
//  SADF
//
//  Created by SADF on 2019/3/6.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxSwift
import SDAutoLayout
import WPAttributedMarkup

class LF_EditTableViewCell: UITableViewCell {

    var titleLabel: UILabel = UILabel(fontSize: 16, fontColor: k333333, text: "标题")
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
                    make.left.equalTo(titleLabel.snp.right).offset(10)
                    make.height.equalTo(32)
                })
                
                custom!.snp.makeConstraints({ (make) in
                    make.size.equalTo(CGSize(width: custom!.width, height: 30))
                    make.right.equalTo(-10)
                    make.left.equalTo(tf.snp.right).offset(5)
                    make.centerY.equalTo(self)
                })
            }else {
                tf.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(self)
                    make.right.equalTo(-10)
                    make.left.equalTo(titleLabel.snp.right).offset(10)
                    make.height.equalTo(32)
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
            
            titleLabel.attributedText = model!.title.attributedString(withStyleBook: style)
            
            titleLabel.text = model!.title
            
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
            if model!.type == 0 || model!.type == 21 {
                tf.isUserInteractionEnabled = false
                if model!.type == 21 {
                    tf.backgroundColor = kF8F8F8!
                }
            }else {
                tf.isUserInteractionEnabled = true
            }
//            if model!.tfText != nil {
//                tf.rx.text.bind(to: model!.tfText!).disposed(by: dig)
//            }
//            model!.tf = tf
//            if model!.tfSet != nil {
//                model!.tfSet!(tf)
//            }
            self.custom = model!.custom
            tf.isSecureTextEntry = model!.isSecureTextEntry
            
//            if #available(iOS 10.0, *) {
//                tf.textContentType = nil
//            } else {
//                // Fallback on earlier versions
//            }
//            if model!.type == 10 || model!.type == 0 {
//                rightIV.hidden = false
//            } else {
//                rightIV.hidden = true
//            }
            
//            rightLabel.hidden = model.type == 11 ? false : true
//            rightLabel.text = model.rightText
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(tf)
//        self.contentView.addSubview(rightIV)
        
        tf.borderStyle = .roundedRect
        tf.enterSpace = 10
        tf.font = UIFont.systemFont(ofSize: 16)
        if #available(iOS 10.0, *) {
            tf.textContentType = nil
        }
            
        titleLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(10)
            make.width.equalTo(70)
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
