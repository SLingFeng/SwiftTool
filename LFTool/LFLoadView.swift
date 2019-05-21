//
//  LFLoadView.swift
//  gct
//
//  Created by big on 2019/5/20.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit

class LFLoadView: UIView {

    let contentView : UIView?
    
    let title = UILabel(fontSize: 16, fontColor: k666666, text: "图片加载中...")
    
//    let load = UIActivityIndicatorView(style: .gray)
    let load = FLAnimatedImageView()
    
    
    init(_ contentView: UIView, gifName: String) {
        self.contentView = contentView
        super.init(frame: CGRect.zero)
        
        load.startAnimating()
        self.addSubview(title)
        self.addSubview(load)
        self.addSubview(contentView)
        contentView.isHidden = true
        
        let pathForFile = Bundle.main.path(forResource: gifName, ofType: "gif") ?? ""
        let dataOfGif = NSData(contentsOfFile: pathForFile) as Data?
        let gif = FLAnimatedImage(animatedGIFData: dataOfGif)
        load.animatedImage = gif
        load.snp.makeConstraints({ (make) in
           make.edges.equalTo(UIEdgeInsets.zero)
        })
//        load.snp.makeConstraints({ (make) in
//            make.size.equalTo(self.snp.size).multipliedBy(0.2)
//            make.center.equalTo(self.snp.center)
//        })
//
//        title.snp.makeConstraints({ (make) in
//            make.top.equalTo(load.snp.bottom).offset(10)
//            make.centerX.equalTo(self.snp.centerX)
//        })
        
        contentView.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
    }
    ///true 隐藏load
    func changeLoad(_ isChange: Bool) {
        if isChange {
            load.isHidden = true
            contentView?.isHidden = false
        }else {
            load.isHidden = false
            contentView?.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
