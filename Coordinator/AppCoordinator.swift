
//
//  AppCoordinator.swift
//  gct
//
//  Created by big on 2019/3/7.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxSwift
class AppCoordinator: BaseCoordinator<Void> {

    
    
    override func start() -> Observable<Void> {
     
//        let et = Environment()
//        if !et.tokenExists {
//            let loginCoordinator = LoginCoordinator(window: window)
//            return coordinate(to: loginCoordinator)
//        }
        let mainTB = RootTabBarCoordinator(window: window)
        return coordinate(to: mainTB)
        
    }
    
}
