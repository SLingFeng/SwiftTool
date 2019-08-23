//
//  ChatVM.swift
//  jsbf
//
//  Created by big on 2019/8/23.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChatVM: NSObject {

    
//    getChatNotice聊天室公告 已经阅读过的就返回一个空数据
    class func user_getChatNotice() -> Driver<String> {
        
        return Observable<String>.create({ (ob) -> Disposable in
            let x = apiProvider.rx.request(Api.user_getChatNotice).asObservable().mapModel(LFResponseMsgModel.self).subscribe(onNext: { (model) in
                if model.code == 0 {
                    ob.onNext(model.data)
                }else {
                    ob.onNext("")
                }
                ob.onCompleted()
            }, onError: { (error) in
                SLFHUD.showHint(error.localizedDescription)
                ob.onError(error)
            })
            return Disposables.create{
                x.dispose()
            }
        }).asDriver(onErrorJustReturn: "")
    }
}
