//
//  LF_EditModel.swift
//  SADF
//
//  Created by SADF on 2019/3/6.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LF_EditModel: NSObject {
    /**
     cell的状态
     0:LF_EditTableViewCell 选择
     1:LF_EditTableViewCell 输入
     
     20:LF_EditTableViewCell 右边视图
     21:不能点击tf
     
     3:LF_EditIVTableViewCell 多行拼层圆角的 输入 
     31:LF_EditIVTableViewCell 多行拼层圆角的 输入 不能点击tf
     
     39: 服务协议
     
     ------
     2：FY_HousePhotoAddTableViewCell
     3: FY_HouseEnterTextViewTableViewCell
     40: FY_MultipleTableViewCell 第一个和其他不能全选
     41: FY_MultipleTableViewCell 多选
     42: FY_MultipleTableViewCell 选3个
     
     */
    var type: Int = 0
    
//    var tf : BaseTextField?
//    var tfText : PublishSubject<String?>?
    
    
    var title = ""
    var btnTitle = ""
    var placeholder = ""
    var rightText = ""
    var cellDidClick: ((_ cell: UITableViewCell?) -> Void)?
    var textFieldChange: ((_ tf: BaseTextField?) -> Void)?
    var textFieldEditingDidEnd: ((_ tf: BaseTextField?) -> Void)?
//    var tfSet: ((_ tf: BaseTextField?) -> Void)?
//    var fsTextViewHandler: ((_ textView: FSTextView?) -> Void)?
//    var selectIDBlock: ((_ ids: String?) -> Void)?
//    var onClickBlock: ((_ sender: UIButton) -> Void)?
    
    var clickOne = PublishSubject<Int>()
    var clickTwo = PublishSubject<Void>()
    
    var keyboardType: UIKeyboardType?
    var enterType: BaseTextFieldEnterType?
    var isSecureTextEntry = false
    var mulitpleData: [AnyHashable] = []
    //用户输入文字保存起来
    var userEnterText = ""
    var enterNumber: Int = -1
    var rightIVHidden = false
    var custom : UIView?
    var leftIV_Image = ""
}
