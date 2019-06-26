//
//  SelectView.swift
//  gct
//
//  Created by big on 2019/2/21.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDAutoLayout

class SelectView: UIView {

    let line = UIImageView()
    var btnArr: [UIButton] = []
    let btnTap = PublishSubject<Int>()
    let btnTapTwo = PublishSubject<Int>()
    var lastBtn: UIButton?
    let dig = DisposeBag()
    
    lazy var arrowIV: UIImageView = {
        let arrowIV = UIImageView(image: UIImage(named: "score_ic_up"))
        self.addSubview(arrowIV)
        arrowIV.frame = CGRect(x: 0, y: 0, width: 10, height: 7)
        arrowIV.isHidden = true
        return arrowIV
    }()
    
    var isTapTwo = false {
        didSet {
            arrowIV.image = UIImage(named: isTapTwo ? "score_ic_down" : "score_ic_up")
        }
    }
    var tapTwoNum = 0
    //释放显示箭头
    var isFilter: Bool = false
    //箭头只能移动到哪个为止
    var toIndex = 0
    
    init(frame: CGRect, titles: Array<String>) {
        super.init(frame: frame)
        
        craetr(titles: titles)
        
    }
    
    init(frame: CGRect, titles: Array<String>, isFilter: Bool, toIndex: Int) {
        super.init(frame: frame)
        
        craetr(titles: titles, isFilter: isFilter, toIndex: toIndex)
        
    }
    
    func craetr(titles: Array<String>, isFilter: Bool = false, toIndex: Int = -1) {
        
        self.shadowColor = UIColor.hexAlpha(hex: "#000000", talpha: 0.37)
        self.shadowOffset = CGSize(width: 0, height: 3)
        self.shadowOpacity = 0.33
        self.shadowRadius = 12
        self.backgroundColor = UIColor.white
//        self.cornerRadius = 22
        
        self.toIndex = toIndex
        self.isFilter = isFilter
//        let bLine = UIView()
//        self.addSubview(bLine)
//        bLine.backgroundColor = kF8F8F8
//        bLine.snp.makeConstraints({ (make) in
//            make.left.right.equalTo(0)
//            make.bottom.equalTo(-1)
//            make.height.equalTo(1)
//        })
        
        self.addSubview(self.line)
        self.line.backgroundColor = kMainColor
        line.layer.cornerRadius = 2
        
        var last: UIButton?
        let w = (kScreenW/CGFloat(titles.count))
        for i in 0..<titles.count  {
            
            let btn = UIButton(fontSize: 17, fontColor: k000000, text: titles[i])
            self.addSubview(btn)
            btn.tag = i + 10
            btnArr.append(btn)
            btn.setTitleColor(kMainColor, for: .selected)

            btn.snp.makeConstraints({ (make) in
                make.width.equalTo(w)
                make.top.bottom.equalTo(0)
                if i==0 {
                    make.left.equalTo(0)
                }else {
                    make.left.equalTo(last!.snp.right).offset(0)
                }
            })
            
            if i==0 {
                btn.isSelected = true
                self.lastBtn = btn
                line.snp.makeConstraints({ (make) in
                    make.size.equalTo(CGSize(width: 16, height: 4))
                    make.bottom.equalTo(-1)
                    make.centerX.equalTo(btn.snp.centerX)
                })
                if isFilter {
//                    self.bringSubviewToFront(arrowIV)
//                    var p = arrowIV.center
//                    p.x = btn.centerX + btn.width/4
//                    p.y = btn.centerY
//                    arrowIV.center = p
                    arrowIV.isHidden = false
                    arrowIV.snp.makeConstraints({ (make) in
                        make.size.equalTo(CGSize(width: 10, height: 7))
                        make.centerX.equalTo(btn.snp_centerX).offset(w/4)
                        make.centerY.equalTo(btn.snp.centerY)
                    })
                    
                }
            }
            
            last = btn
            
            btn.rx.tap.map{ i }.subscribe(onNext: { [weak self] n in
                if let strongSelf = self {
                    strongSelf.lastBtn?.isSelected = false
                    btn.isSelected = true
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        var p = strongSelf.line.center
                        p.x = btn.centerX
                        strongSelf.line.center = p
                    })
                    ///箭头判断
                    if isFilter {
                        if strongSelf.lastBtn?.tag == btn.tag {
                            strongSelf.tapTwoNum += 1
                            
                        }else {
                            strongSelf.isTapTwo = false
                            strongSelf.tapTwoNum = 0
                        }
                        
                        if toIndex == n || toIndex == -1 {
                            //UIView.animate(withDuration: 0, animations: {
                            var p = strongSelf.arrowIV.center
                            p.x = btn.centerX + btn.width/4
                            p.y = btn.centerY
                            strongSelf.arrowIV.center = p
                            //})
                            
                            if strongSelf.tapTwoNum >= 1 {
                                strongSelf.isTapTwo = true
                                strongSelf.btnTapTwo.onNext(n)
                            }
                        }
                    }
                    strongSelf.btnTap.onNext(n)
                    strongSelf.lastBtn = btn

                }
                
            }).disposed(by: dig)
        }
        
        //设置消失视图后箭头
        NotificationCenter.default.rx.notification(Noti_LFShowViewHidden).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.isTapTwo = false
            }
        }).disposed(by: dig)
    }
    
    func setSelectBtn(index: Int) {
        
//        let btn = self.viewWithTag(index) as! UIButton
//        self.lastBtn?.isSelected = false
//        btn.isSelected = true
//        self.lastBtn = btn
//
        self.lastBtn?.isSelected = false
        self.btnArr.forEach { (btn) in
            btn.isSelected = false
        }
        let btn = btnArr[index]
        btn.isSelected = true
        
        UIView.animate(withDuration: 0.3, animations: {
            var p = self.line.center
            p.x = btn.centerX
            self.line.center = p
        })
        
        ///箭头判断
        if isFilter {
            if toIndex == btn.tag - 10 || toIndex == -1 {
//            UIView.animate(withDuration: 0.3, animations: {
                var p = self.arrowIV.center
                p.x = btn.centerX + btn.width/4
                p.y = btn.centerY
                self.arrowIV.center = p
//            })
            }
        }
        
        self.btnTap.onNext(index)
        self.lastBtn = btn
    }
    
    func setTitle(titles: Array<String>) {
        for i in 0..<btnArr.count  {
            let btn = btnArr[i]
            btn.setTitle(titles[i], for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
