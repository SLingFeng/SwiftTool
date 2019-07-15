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
        
        let styleTo = ["tj" : UIImage(named: "score_icon_tj")]
        
        var last: UIButton?
        let w = (kScreenW/CGFloat(titles.count))
        for i in 0..<titles.count  {
            
            let btn = UIButton(fontSize: 17, fontColor: k000000, text: titles[i])
            self.addSubview(btn)
            btn.tag = i + 10
            btnArr.append(btn)
            
            btn.setAttributedTitle(NSString(string: titles[i]).attributedString(withStyleBook: styleTo as [AnyHashable : Any]), for: .normal)
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
                btn.titleLabel?.textColor = kMainColor
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
                    strongSelf.lastBtn?.titleLabel?.textColor = k000000
                    btn.isSelected = true
                    btn.titleLabel?.textColor = kMainColor
                    
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
                        
                        if toIndex <= n || toIndex != -1 {
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
        self.lastBtn?.titleLabel?.textColor = k000000
        self.btnArr.forEach { (btn) in
            btn.isSelected = false
            btn.titleLabel?.textColor = k000000
        }
        let btn = btnArr[index]
        btn.isSelected = true
        btn.titleLabel?.textColor = kMainColor

        
        UIView.animate(withDuration: 0.3, animations: {
            var p = self.line.center
            p.x = btn.centerX
            self.line.center = p
        })
        
        ///箭头判断
        if isFilter {
            if toIndex <= btn.tag - 10 || toIndex != -1 {
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

//滑动的
class SelectScrollView: SelectView {
    
    let scroll = UIScrollView(frame: .zero)
    let leftBtn = UIButton()
    let rightBtn = UIButton()
    var index = 0
    var titles: Array<String> = []
    
    
    override func craetr(titles: Array<String>, isFilter: Bool = false, toIndex: Int = -1) {
        self.titles = titles
        
        self.addSubview(scroll)
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
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
        
        scroll.addSubview(self.line)
        self.line.backgroundColor = kMainColor
        line.layer.cornerRadius = 2
        
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        leftBtn.setImage(UIImage(named: "score_button_front"), for: .normal)
        rightBtn.setImage(UIImage(named: "score_button_more"), for: .normal)
        leftBtn.addTarget(self, action: #selector(arrorClick(btn:)), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(arrorClick(btn:)), for: .touchUpInside)
        
        leftBtn.tag = 10
        rightBtn.tag = 20
        
        leftBtn.snp_makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalTo(self)
            make.left.equalTo(5)
        })
        
        rightBtn.snp_makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalTo(self)
            make.right.equalTo(-5)
        })
        
        let styleTo = ["tj" : UIImage(named: "score_icon_tj")]
        
        var last: UIButton?
        let w = (kScreenW/4)
        for i in 0..<titles.count  {
            
            let btn = UIButton(fontSize: 17, fontColor: k000000, text: titles[i])
            scroll.addSubview(btn)
            btn.tag = i + 10
            btnArr.append(btn)
            
            btn.setAttributedTitle(NSString(string: titles[i]).attributedString(withStyleBook: styleTo as [AnyHashable : Any]), for: .normal)
            btn.setTitleColor(kMainColor, for: .selected)
            
            let bx = LFTool.JGG_X(0, w, 0, CGFloat(i), CGFloat(titles.count))
            let by = LFTool.JGG_Y(0, self.frame.height, 0, i, titles.count)
            btn.frame = CGRect(x: bx, y: by, width: w, height: self.frame.height)
//            btn.snp.makeConstraints({ (make) in
//                make.width.equalTo(w)
//                make.top.bottom.equalTo(0)
//                if i==0 {
//                    make.left.equalTo(0)
//                }else {
//                    make.left.equalTo(last!.snp.right).offset(0)
//                }
//            })
            
            if i==0 {
                btn.isSelected = true
                btn.titleLabel?.textColor = kMainColor
                self.lastBtn = btn
                line.frame = CGRect(x: 0, y: btn.bottom_sd - 7, width: 16, height: 4)
                var p = line.center
                p.x = btn.centerX
                line.center = p
//                line.snp.makeConstraints({ (make) in
//                    make.size.equalTo(CGSize(width: 16, height: 4))
//                    make.bottom.equalTo(-1)
//                    make.centerX.equalTo(btn.snp.centerX)
//                })
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
                    strongSelf.lastBtn?.titleLabel?.textColor = k000000
                    btn.isSelected = true
                    btn.titleLabel?.textColor = kMainColor
                    
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
        //设置
//        if let last = last {
        let ww = CGFloat(Int(kScreenW) * Int(titles.count / 4))
            scroll.contentSize = CGSize(width: ww, height: 20)
//        }
        
        //设置消失视图后箭头
        NotificationCenter.default.rx.notification(Noti_LFShowViewHidden).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.isTapTwo = false
            }
        }).disposed(by: dig)
    }
    
    @objc func arrorClick(btn: UIButton) {
        
        if btn.tag == 10 {
            index -= 1
        }else {
            index += 1
        }
        
        if index <= 0 {
            index = 0
        }else if index >= titles.count / 4 {
            index = (titles.count / 4) - 1
        }
        
        scroll.setContentOffset(CGPoint(x: kScreenW * CGFloat(index), y: 0), animated: true)
        
    }
    
    override func setSelectBtn(index: Int) {
        super.setSelectBtn(index: index)
        
        let num = floorf(Float(CGFloat(index) / 4.0))
        scroll.setContentOffset(CGPoint(x: kScreenW * CGFloat(num), y: 0), animated: true)
        
    }
}
