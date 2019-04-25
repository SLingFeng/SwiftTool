//
//  LFImage.swift
//  SADF
//
//  Created by SADF on 2019/4/20.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFImage: NSObject {

}

extension UIImage {
    class func createImage(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}
