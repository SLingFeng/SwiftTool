//
//  RootTabBarCooordinator.swift
//  gct
//
//  Created by big on 2019/3/7.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit
import RxSwift

class RootTabBarCoordinator: BaseCoordinator<Void> {

    override func start() -> Observable<Void> {
                
        self.window.rootViewController = MainTabbarConfig.shared.getMainTabBarViewController()
        window.makeKeyAndVisible()
        return Observable.never()
    }
    
}
