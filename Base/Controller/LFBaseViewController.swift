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

        self.view.backgroundColor = kF8F8F8
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }

    override func loadView() {
        super.loadView()
    
        if  #available(iOS 11.0, *) {
            let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(self.backTap))
            self.navigationController!.navigationBar.backIndicatorImage = UIImage(named: "ic_fanhui")
            self.navigationController!.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_fanhui")
            self.navigationItem.backBarButtonItem = item

        }

    }
    
    @objc func backTap() {
        self.navigationController!.popViewController(animated: true)
    }
    
    public func setNavTitle(_ text: String) {
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


