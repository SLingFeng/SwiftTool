//
//  LFLabel.swift
//  
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    lazy var bacView: LFLineRView = {
        let bacView = LFLineRView()
        self.addSubview(bacView)
        bacView.snp_makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        return bacView
    }()
    
    
    func setLine(_ bd: BorderDirection = .allCorners) {
        
        bacView.bd = bd
        bacView.borderWidth = 0.5
        bacView.borderColor = UIColor("#D2E0EC")
        bacView.corners = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UILabel {
    

    public convenience init(fontSize: CGFloat, fontColor: UIColor?, text: String?) {
        self.init()
        if let color = fontColor {
            self.textColor = color
        }
//        numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: fontSize)
//        self.font = SLFCommonTools.pxFont(fontSize) //[UIFont systemFontOfSize:kAH(fontSize)];
        self.text = text
    }
}



