//
//  LFExtensionView.swift
//  jsbf
//
//  Created by big on 2019/8/16.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFExtensionView: NSObject {

    /// 截取当前屏幕 https://juejin.im/post/5ae92feb6fb9a07acc118436
    class func snapshotCurrentFullScreen() -> UIImage? {
        let window = UIApplication.shared.keyWindow!
        // 判断是否为retina屏, 即retina屏绘图时有放大因子
        if UIScreen.main.responds(to: #selector(getter: UIScreen.scale)) {
            
            UIGraphicsBeginImageContextWithOptions(window.bounds.size, _: false, _: UIScreen.main.scale)
        } else {
            
            UIGraphicsBeginImageContext(window.bounds.size)
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            window.layer.render(in: context)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // 保存到相册
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        return image
    }
    
//    #pragma mark  -----截取屏幕指定区域view-----
//    - (UIImage *)snapshotScreenInView:(UIView *)contentView{
//
//    CGSize size = contentView.bounds.size;
//    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//    CGRect rect = contentView.frame;
//
//    //  自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates: 它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
//    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//
//    return image;
//    }
//
//
//    作者：一滴水的生活
//    链接：https://juejin.im/post/5ae92feb6fb9a07acc118436
//    来源：掘金
//    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
}
///http://www.hangge.com/blog/cache/detail_2071.html
extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            // Fallback on earlier versions
            return UIImage()
        }
        
    }
}
