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
        
        self.navigationController?.navigationBar.shadowImage = UIImage()

        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationBar.tintColor = k666666
        self.navigationBar.barTintColor = .white
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
}
