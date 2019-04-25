//
//  LFDatePicker.swift
//  SADF
//
//  Created by SADF on 2019/3/5.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

enum LFDatePickerType {
    case yearMonthDay
    case text
}

class LFDateModel: NSObject {
    
    var id = ""
    
    var text = ""
    
    var traders_money = ""
}

class LFDatePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    
    var doneSub = PublishSubject<LFDateModel>()
    
    var doneDateSub = PublishSubject<[Any]>()
    
    var str = ""
    
    var selRow = 0
    
    var data = Array<LFDateModel>()
    
    
//    //最简单的pickerView适配器（显示普通文本）
//    private let stringPickerAdapter = RxPickerViewStringAdapter<[String]>(
//        components: [],
//        numberOfComponents: { dataSource,pickerView,components  in 1 },
//        numberOfRowsInComponent: { (_, _, components, component) -> Int in
//            return components.count},
//        titleForRow: { (_, _, components, row, component) -> String? in
//
//
//            return components[row]}
//    )
    
    var selectHeight = LFTool.isIPHONEXLAST() ? 299 : 260
    
    var type = LFDatePickerType.yearMonthDay
    
    let backView = UIView()

    let titleLabel = UILabel(fontSize: 19, fontColor: k333333, text: nil)
    
    let disposeBag = DisposeBag()
    
    
    //日期格式化器
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"// HH:mm
        return formatter
    }()
    
    init(type: LFDatePickerType, title: String, data:Array<LFDateModel>) {
        super.init(frame: kScreen)
        self.type = type
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(backView)
            make.top.equalTo(11)
        })
        
//        self.setPicker()
//    }
//
//    func setPicker() {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.backgroundColor = SLFCommonTools.colorHex(0x000000, alpha: 0.5)
        self.alpha = 0.3
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
        
        self.addSubview(backView)
        backView.backgroundColor = .white
        backView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(selectHeight)
        })
        
        
        switch self.type {
        case .yearMonthDay:
            datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "zh_CN")
            backView.addSubview(datePicker)
            datePicker.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.bottom.equalTo(-39)
            })
            datePicker.rx.date.subscribe(onNext: {[weak self] x in
                if let strongSelf = self {
                     strongSelf.doneDateSub.onNext([strongSelf.dateFormatter.string(from: x), strongSelf.selRow])
                }
               
            }).disposed(by: disposeBag)
        case .text:
            self.data = data
            pickerView = UIPickerView()
            backView.addSubview(pickerView)
            pickerView.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.bottom.equalTo(-39)
            })
            pickerView.delegate = self
        }
     
        let cancelBtn = UIButton(fontSize: 17, fontColor: UIColor("#379AFF"), text: "取消")
        backView.addSubview(cancelBtn)
        
        let doneBtn = UIButton(fontSize: 17, fontColor: UIColor("#379AFF"), text: "确定")
        backView.addSubview(doneBtn)
        
        cancelBtn.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 70, height: 50))
            make.left.top.equalTo(0)
        })
        
        doneBtn.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 70, height: 50))
            make.right.top.equalTo(0)
        })
        
        doneBtn.rx.tap.subscribe({ [weak self] _ in
            if let strongSelf = self {
                if strongSelf.type == .yearMonthDay {
                    strongSelf.doneDateSub.onNext([strongSelf.dateFormatter.string(from: strongSelf.datePicker.date), strongSelf.selRow])
                }else {
                    if strongSelf.str.isEmpty {
                        strongSelf.doneSub.onNext(data.first ?? LFDateModel())//([data.first ?? "", strongSelf.selRow])
                    }else {
                        strongSelf.doneSub.onNext(strongSelf.data[strongSelf.selRow])
                    }
                }
                self?.cancelView()
            }
        }).disposed(by: disposeBag)
        
        cancelBtn.rx.tap.subscribe({ [weak self] _ in
            if let strongSelf = self {
                strongSelf.cancelView()
            }
        }).disposed(by: disposeBag)
    }
    
    func cancelView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let m = data[row]
        return m.text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selRow = row
//        doneSub.onNext(data[row])
        if data.count == 0 {
            return
        }
        let m = data[row]
        str = m.text
    }
}
