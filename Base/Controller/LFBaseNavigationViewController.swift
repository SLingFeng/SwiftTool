//
//  LFBaseNavigationViewController.swift
//  gct
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFBaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: .default)
        
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
//        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = .white
//        navigationController?.navigationBar.apply(gradient: [UIColor("#A1C73B"), UIColor("#11A23C")])
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
            let v = self.navigationBar.viewWithTag(123)
            v?.isHidden = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
//        LFLog(self.viewControllers.count)
        if (self.viewControllers.count <= 2) {
            let v = self.navigationBar.viewWithTag(123)
            v?.isHidden = false
        }
        
        return super.popViewController(animated: animated)
    }

}

extension UINavigationController {
    
    func lfPopToVC(vcc : AnyClass) {
        
        let vc = SLFCommonTools.currentViewController()
        
//        let nav = vc?.navigationController
        
        for v in vc!.navigationController!.viewControllers {
            if v.isKind(of: vcc) {
                vc?.navigationController?.popToViewController(v, animated: true)
            }
        }
    }
    
//    func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        let v = self.navigationController?.navigationBar.viewWithTag(123)
//        
//        if (self.viewControllers.count > 0) {
//            viewController.hidesBottomBarWhenPushed = true
//            v?.isHidden = true
//            
//        }else {
//            v?.isHidden = false
//        }
//        super.pushViewController(viewController, animated: animated)
//    }
    
}

extension UINavigationBar{
    
    /// Applies a background gradient with the given colors
    func apply(gradient colors : [UIColor]) {
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 20 // add 20 to account for the status bar
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage? {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
