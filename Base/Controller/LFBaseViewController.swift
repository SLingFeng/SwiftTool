//
//  LFBaseViewController.swift
//
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LFBaseViewController: UIViewController {

    var obj: Any?
    
    public let dig = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
    }
    
    public func setNavTitle(text: String) {
        self.navigationItem.title = text
    }
    
    deinit {
        LFTool.Log(m: #function)
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


