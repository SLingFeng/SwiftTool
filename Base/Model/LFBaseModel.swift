//
//  LFBaseModel.swift
//
//
//  Created by SADF on 2019/2/15.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import HandyJSON
import NSObject_Rx
import RxCocoa
import RxSwift
import Moya

class LFBaseModel: HandyJSON {

    var pageIndex = 0
    
    
    required init() {
        
    }
}

class LFResponseModel: NSObject, HandyJSON {
    /**
     状态码
     */
    var code: NSInteger = 1
    /**
     信息
     */
    var msg = ""
    
    var data: [String : Any] = [String : Any]()
    
    var success: Bool = false
    
    var agent_income = ""

    required override init() {
        super.init()
    }
}

class LFResponseMsgModel: NSObject, HandyJSON {
    /**
     状态码
     */
    var code: NSInteger = 1
    /**
     信息
     */
    var msg = ""
    
    var data = ""
    
    var success: Bool = false
    
    required override init() {
        super.init()
    }
}

class LFResponseArrayModel: NSObject, HandyJSON {
    /**
     状态码
     */
    var code: NSInteger = 1
    /**
     信息
     */
    var msg = ""
    
    var data : [Any] = []
    
    var success: Bool = false
    
    required override init() {
        super.init()
    }
}

//这里是为 RxSwift 中的 ObservableType和 Response写一个简单的扩展方法 mapModel，利用我们写好的Model 类，一步就把JSON数据映射成 model
//extension ObservableType where E == Response {
//    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
//        return flatMap { response -> Observable<T> in
//            return Observable.just(response.mapModel(T.self))
//        }
//    }
//}
//
//extension Response {
//    func mapModel<T: HandyJSON>(_ type: T.Type) -> T {
//        let jsonString = String.init(data: data, encoding: .utf8)
//        return JSONDeserializer<T>.deserializeFrom(json: jsonString)!
//    }
//}

public protocol LFBaseVMType {
//    var inputs: LFBaseVMInputs { get }
//    var outputs: LFBaseVMOutputs { get }
}

extension ObservableType where E == Response {
    ///扩展Moya支持HandyJSON的解析
    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(response.mapModel(T.self))
        }
    }
}
extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        if let modelT = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
            return modelT
        }
        return JSONDeserializer<T>.deserializeFrom(dict : ["msg" : "请求有误"])!
    }
}
//链接：https://www.jianshu.com/p/97a476c71678

