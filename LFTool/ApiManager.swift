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

let apiProvider = MoyaProvider<Api>(plugins: [RequestLoadingPlugin()])

enum Api {
    case getList(Parameters)
    case postData
}

extension Api: TargetType {
    var baseURL: URL {
        switch self {
        case .getList:
            return URL(string: "https://itunes.apple.com/")!
        case .postData:
            return URL(string: "https://httpbin.org/")!
        }
    }
    
    var path: String {
        switch self {
        case .getList:
            return "search"
        case .postData:
            return "post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getList:
            return .post
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .getList(par):
            return .requestParameters(parameters: par, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
//        return nil
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

