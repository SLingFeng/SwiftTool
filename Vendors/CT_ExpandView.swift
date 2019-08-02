//
//  CT_ExpandView.swift
//  gct
//
//  Created by big on 2019/4/4.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit

class CT_ExpandView: UIView {

    init(frame: CGRect, titles: Array<String>, subs: Array<String>, insertView: UIView?, insert: Int) {
        super.init(frame: frame)
        
//        let titles = ["投入本金", "当前配资倍数", "当前配资金额", "扩大配资倍数至", "扩大后利息"]
        var last: UILabel?
        for i in 0..<titles.count {
            
            let t = UILabel(fontSize: 16, fontColor: k1A1A1A, text: titles[i])
            self.addSubview(t)
            
            let tw = SLFCommonTools.textSize(t.text, font: t.font).width + 1
            
            t.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
//                make.right.equalTo(self.snp.centerX).offset(-20)
                make.width.equalTo(tw)
                if i == 0 {
                    make.top.equalTo(5)
                }else {
                    make.top.equalTo(last!.snp.bottom).offset(20)
                }
            })
            last = t
            if i == insert {
                if insertView != nil {

                    self.addSubview(insertView!)
                    insertView!.snp.makeConstraints({ (make) in
                        make.right.equalTo(0)
                        //                    make.left.equalTo(self.centerX).offset(0)
                        make.size.equalTo(CGSize(width: 70, height: 30))
                        make.centerY.equalTo(last!)
                    })
                }
            }else {
                let s = UILabel(fontSize: 16, fontColor: k393939, text: subs[i])
                self.addSubview(s)
                s.tag = i + 20
                s.textAlignment = .right
                s.snp.makeConstraints({ (make) in
                    make.right.equalTo(-0)
                    make.left.equalTo(t.snp.right).offset(5)
                    if i == 0 {
                        make.centerY.equalTo(t)
                    }else {
                        make.centerY.equalTo(last!)
                    }
                })
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
///余额弹窗
class CT_ExpandContractView: UIView {
    
    init(frame: CGRect, subs: Array<String>) {
        super.init(frame: frame)
        
        let ts = ["当前余额", "支付保证金", "预存利息", "总费用", "本次支付还差"]
        var last: UILabel?
        for i in 0..<subs.count {
            
            let t = UILabel(fontSize: 15, fontColor: k333333, text: ts[i])
            self.addSubview(t)
            
            t.snp.makeConstraints({ (make) in
                make.left.equalTo(10)
                //                make.right.equalTo(self.centerX).offset(0)
                if i == 0 {
                    make.top.equalTo(5)
                }else {
                    make.top.equalTo(last!.snp.bottom).offset(20)
                }
            })
            
            let s = UILabel(fontSize: 15, fontColor: k333333, text: subs[i])
            self.addSubview(s)
            s.textAlignment = .right
            
            s.snp.makeConstraints({ (make) in
                make.right.equalTo(-10)
                //                    make.left.equalTo(self.centerX).offset(0)
//                if i == 0 {
                    make.centerY.equalTo(t)
//                }else {
//                    make.centerY.equalTo(last!)
//                }
            })
            last = t
            if i == 0 {
                s.textColor = kMainColor
                
            }else if i == subs.count - 1 {
                s.textColor = kMainColor
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

