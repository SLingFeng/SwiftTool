//
//  LoginCoordinator.swift
//  gct
//
//  Created by big on 2019/3/7.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxSwift
import CYLTabBarController

class LoginCoordinator: BaseCoordinator<Void> {

    override func start() -> Observable<Void> {
        
//        let login = CT_LoginViewController()
//        login.vm = CT_LoginVM()
//        login.vm.outputs.signedIn.drive(onNext: { si in
//            if si.isValid {
//                let rootTabBarCoordinator = RootTabBarCoordinator(window: self.window)
//                self.coordinate(to: rootTabBarCoordinator)
//                    .subscribe()
//                    .disposed(by: self.disposeBag)
//            }else {
////                SLFHUD.showHint("登录失败")
//            }
//        }).disposed(by: disposeBag)
//
//
//        self.window.rootViewController = LFBaseNavigationViewController(rootViewController :login)
//        window.makeKeyAndVisible()
//        return Observable.never()


        
//        login.vm = CT_LoginVM()
//        login.vm.signedIn.drive(onNext: {[weak login] si in
//            if si.isValid {
//                login?.dismiss(animated: true, completion: {
//
//                })
////                self.window
////                self.window.rootViewController?.navigationController?.popToRootViewController(animated: true)
//            }else {
//
//            }
//        }).disposed(by: disposeBag)
//        debugPrint("sssss+\(self.vc)")
        
        if self.vc.isKind(of: BF_LoginViewController.self) {
            return Observable.never()
        }
        
        let login = BF_LoginViewController()

        login.loginStr = self.str
        self.vc.present(LFBaseNavigationViewController(rootViewController :login), animated: true, completion: {
                let v = UIApplication.shared.keyWindow?.viewWithTag(8901)
                v?.isHidden = false
//            GVUserDefaults.standard().isShowLoginVC = true
        })
//        self.vc.tabBarController?.selectedIndex = 0
//        self.window.rootViewController = LFBaseNavigationViewController(rootViewController :login)
//        window.makeKeyAndVisible()
        return Observable.never()
    }
    
}
