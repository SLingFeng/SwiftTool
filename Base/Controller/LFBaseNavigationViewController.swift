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
