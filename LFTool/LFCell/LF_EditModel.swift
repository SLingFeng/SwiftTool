//
//  LF_EditModel.swift
//  SADF
//
//  Created by SADF on 2019/3/6.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LF_EditModel: NSObject {
    /**
     cell的状态
     0:LF_EditTableViewCell 选择
     1:LF_EditTableViewCell 输入
     2:LF_EditTableViewCell 右边视图
     ----
     10: 输入 带箭头
     11: 输入 带文本
     12: 点击 带文本
     2：FY_HousePhotoAddTableViewCell
     3: FY_HouseEnterTextViewTableViewCell
     40: FY_MultipleTableViewCell 第一个和其他不能全选
     41: FY_MultipleTableViewCell 多选
     42: FY_MultipleTableViewCell 选3个
     
     */
    var type: Int = 0
    var title = ""
    var btnTitle = ""
    var placeholder = ""
    var rightText = ""
    var cellDidClick: ((_ cell: LF_EditTableViewCell?) -> Void)?
    var textFieldChange: ((_ tf: BaseTextField?) -> Void)?
//    var fsTextViewHandler: ((_ textView: FSTextView?) -> Void)?
//    var selectIDBlock: ((_ ids: String?) -> Void)?
//    var onClickBlock: ((_ sender: MyButton?) -> Void)?
    var keyboardType: UIKeyboardType?
    var enterType: BaseTextFieldEnterType?
    var mulitpleData: [AnyHashable] = []
    //用户输入文字保存起来
    var userEnterText = ""
    var enterNumber: Int = 0
    var rightIVHidden = false
    var custom : UIView?
    
}
