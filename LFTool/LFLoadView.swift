//
//  LFLoadView.swift
//  gct
//
//  Created by big on 2019/5/20.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit

class LFLoadView: UIView {

    var contentView : UIView?
    
    let title = UILabel(fontSize: 16, fontColor: k666666, text: "图片加载中...")
    

    let load = FLAnimatedImageView()
    
    
    init(_ contentView: UIView, gifName: String) {
        super.init(frame: CGRect.zero)
        self.contentView = contentView

        load.startAnimating()
//        self.addSubview(title)
        self.addSubview(load)
        self.addSubview(contentView)
        contentView.isHidden = true
//
        let pathForFile = Bundle.main.path(forResource: gifName, ofType: "gif") ?? ""
        let dataOfGif = NSData(contentsOfFile: pathForFile) as Data?
        let gif = FLAnimatedImage(animatedGIFData: dataOfGif)
        load.animatedImage = gif
        load.snp.makeConstraints({ (make) in
           make.edges.equalTo(UIEdgeInsets.zero)
        })
        
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
