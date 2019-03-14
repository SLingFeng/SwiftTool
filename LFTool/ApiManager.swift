//
//  ApiManager.swift
//
//
//  Created by SADF on 2019/2/15.
//  Copyright © 2019 SADF. All rights reserved.
//

import Foundation
import Moya

import RxSwift
import RxCocoa
import enum Result.Result
import Alamofire

//let token = Environment().token
//let authPlugin = AccessTokenPlugin { token ?? "" }

let apiProvider = MoyaProvider<Api>(manager: WebService.manager(), plugins: [RequestLoadingPlugin(), AuthPlugin()])
let apiProviderNo = MoyaProvider<Api>(manager: WebService.manager(),plugins: [AuthPlugin()])


enum Api {
    case commonverify
    case user_login([String : String])
    case user_register([String : String])
    case common_checkCode([String : String])
    case common_sendCode([String : String])
    case user_rePwd([String : String])
    case article_getArticleInfo([String : String])
    case user_showBalance([String : String])
    case user_uploadImg([Data])
    case user_realNameAuth([String : String])
    case user_getRealNameStatus
    case user_setBankCard([String : String])
    case user_bankCardInfo
    case user_setWDPwd([String : String])
    case user_issetWDPwd
    case user_resetPhone([String : String])
    
}

extension Api: TargetType {
    var baseURL: URL {
//        switch self {
//        case .getList:
//            return URL(string: "https://itunes.apple.com/")!
//        case .postData:
            return URL(string: "http://pzy.stocklu.com/")!
//        }
    }
    
    var path: String {
        switch self {
            //登录图形验证码
        case .commonverify:
            return "api/common/verify"
            //登录
        case .user_login:
            return "api/user/login"
            //注册接口
        case .user_register:
            return "api/user/register"
            //检验图形验证码
        case .common_checkCode:
            return "api/common/checkCode"
            //短信验证码
        case .common_sendCode:
            return "api/common/sendCode"
        case .user_rePwd(_):
            return "api/user/rePwd"
        case .article_getArticleInfo(_):
            return "api/article/getArticleInfo"
        case .user_showBalance(_):
            return "api/user/showBalance"
        case .user_uploadImg(_):
            return "api/user/uploadImg"
        case .user_realNameAuth(_):
            return "api/user/realNameAuth"
        case .user_getRealNameStatus:
            return "api/user/getRealNameStatus"
        case .user_setBankCard:
            return "api/user/setBankCard"
        case .user_bankCardInfo:
            return "api/user/bankCardInfo"
        case .user_setWDPwd:
            return "api/user/setWDPwd"
        case .user_issetWDPwd:
            return "api/user/issetWDPwd"
        case .user_resetPhone:
            return "api/user/resetPhone"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .commonverify:
            return .post
            
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        LFTool.Log("\(self)")
        switch self {
        case var .user_login(par),
             var .user_register(par),
             var .common_checkCode(par),
             var .common_sendCode(par),
             var .user_rePwd(par),
             var .article_getArticleInfo(par),
             var .user_showBalance(par),
             var .user_setBankCard(par),
             var .user_realNameAuth(par),
             var .user_resetPhone(par),
             var .user_setWDPwd(par):
            
            
            par["token"] = Environment().token ?? ""
            return .requestParameters(parameters: par, encoding: URLEncoding.queryString)
            
        case let .user_uploadImg(par):
            let a = MultipartFormData(provider: .data(par.first!), name: "imageFront", fileName: "imageFront.png", mimeType: "image/png")
            let b = MultipartFormData(provider: .data(par.last!), name: "imageReverse", fileName: "imageReverse.png", mimeType: "image/png")
            let s = Environment().token!.data(using: String.Encoding.utf8)
            let c = MultipartFormData(provider: .data(s!), name: "token")
            return .uploadMultipart([a, b, c])
        default:
            let par = ["token" : Environment().token ?? ""]
            return .requestParameters(parameters: par, encoding: URLEncoding.queryString)

//            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
//        return nil
    }
    
    
    
//    var authorizationType: AuthorizationType {
////        switch self {
////        case .targetThatNeedsBearerAuth:
////            return .bearer
////        case .targetThatNeedsBasicAuth:
////            return .basic
////        case .targetThatNeedsCustomAuth:
////            return .custom("CustomAuthorizationType")
////        case .targetDoesNotNeedAuth:
//            return .none
////        }
//    }
    

}

class WebService {
    
    // set false when release
    static var verbose: Bool = true
    
    // session manager
    static func manager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30 // timeout
        let manager = Alamofire.SessionManager(configuration: configuration)
//        manager.adapter = CustomRequestAdapter()
        return manager
    }
    
    // request adpater to add default http header parameter
//    private class CustomRequestAdapter: RequestAdapter {
//        public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
//            var urlRequest = urlRequest
//            urlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
//            return urlRequest
//        }
//    }
    
    // response result type
//    enum Result {
//        case success(JSON)
//        case failure(String)
//    }
}

struct AuthPlugin: PluginType {
    //令牌字符串
//    let token: String
    
    //准备发起请求
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        let token = Environment().token
        //将token添加到请求头中
        request.addValue(token ?? "", forHTTPHeaderField: "token")
        return request
    }
}


public final class RequestLoadingPlugin:PluginType{
    
    public func willSend(_ request: RequestType, target: TargetType) {
        SLFHUD.showLoading()
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        SLFHUD.hide()
    }
}


func apiRequset(_ token: Any) -> Single<LFResponseModel> {
    return Single<LFResponseModel>.create(subscribe: { (se) -> Disposable in
        _ = apiProvider.rx.request(token as! Api).asObservable().mapModel(LFResponseModel.self).subscribe(onNext: { (model) in
            if model.code == 0 {
                se(.success(model))
            }else if model.code == 2 {
                Environment().remove()
                let appCoordinator = AppCoordinator(window: UIApplication.shared.keyWindow!)
                _ = appCoordinator.start()
                    .subscribe()
                SLFHUD.showHint(model.msg)
                se(.error(NSError(domain: model.msg, code: model.code, userInfo: nil)))
            }else {
                se(.success(model))
            }
        }, onError: { (e) in
            se(.error(e))
        }, onCompleted: {
            
        }) {
            
        }
        return Disposables.create{}
    })
}

func apiRequsetNo(_ token: Any) -> Single<LFResponseModel> {
    return Single<LFResponseModel>.create(subscribe: { (se) -> Disposable in
        _ = apiProviderNo.rx.request(token as! Api).asObservable().mapModel(LFResponseModel.self).subscribe(onNext: { (model) in
            if model.code == 0 {
                se(.success(model))
            }else if model.code == 2 {
                Environment().remove()
                let appCoordinator = AppCoordinator(window: UIApplication.shared.keyWindow!)
                _ = appCoordinator.start()
                    .subscribe()
                SLFHUD.showHint(model.msg)
                se(.error(NSError(domain: model.msg, code: model.code, userInfo: nil)))
            }else {
                se(.error(NSError(domain: model.msg, code: model.code, userInfo: nil)))
            }
        }, onError: { (e) in
            se(.error(e))
        }, onCompleted: {
            
        }) {
            
        }
        return Disposables.create{}
    })
}
