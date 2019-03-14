//
//  LFLabel.swift
//  
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFLabel: UILabel {
    
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



