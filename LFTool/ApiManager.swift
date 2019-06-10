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
import HandyJSON
import MBProgressHUD

//let token = Environment().token
//let authPlugin = AccessTokenPlugin { token ?? "" }

//let apiProvider = MoyaProvider<Api>(manager: WebService.manager(), plugins: [RequestLoadingPlugin(), AuthPlugin()])
//let apiProviderNo = MoyaProvider<Api>(manager: WebService.manager(), plugins: [AuthPlugin()])

let apiProvider = MoyaProvider<Api>(plugins: [RequestLoadingPlugin(), AuthPlugin()])
let apiProviderNo = MoyaProvider<Api>(plugins: [AuthPlugin()])


enum Api {
    //股票分时
    case fenshi([String : String])
    case sinaInfo([String : String])
    
    case commonverify
    case user_login([String : String])
    case user_register([String : String])
    case common_checkCode([String : String])
    case common_sendCode([String : String])
    case user_rePwd([String : String])
    case article_getArticleInfo([String : String])
    case user_showBalance
    case user_uploadImg(img: Data, name: String)
    case user_realNameAuth([String : String])
    case user_getRealNameStatus
    case user_setBankCard([String : String])
    case user_bankCardInfo
    case user_setWDPwd([String : String])
    case user_issetWDPwd
    case user_resetPhone([String : String])
    case user_checkOldPhone([String : String])
    case user_getUserCapital([String : String])
    case user_getWithdrawList([String : String])
    case pay_userPay([String : String])
    case user_getDepositList([String : String])
    case config_getConfigData
    case trade_searchTradeOrder([String : String])
    case trade_submitTrade([String : String])
    case pay_userWithdraw([String : String])
    case fin_getFinOrderList([String : String])
    case fin_applySettlement([String : String])
    case fin_addMoney([String : String])
    case fin_getFinOrderInfo([String : String])
    case trade_getTradeOrder([String : String])
    case fin_finType
    case fin_getFinSpecs([String : String])
    case fin_getLines
    case fin_applyFin([String : String])
    case trade_selectTradeInfo([String : String])
    case user_showMargin
    case user_showTradeMoney
    case ws_getKlineHistory([String : String])
    case trade_getPromptOrder([String : String])
    case fin_addMargin([String : String])
    case trade_delTradeOrder([String : String])
    case fin_fOList
    case trade_countCommissCharge([String : String])
    case config_getConfigValue([String : String])
    case article_getArticleDetail([String : String])
    case fin_getFinSpeFromId([String : String])
    case fin_enLargeFin([String : String])
    case user_reLoginPwd([String : String])
    case user_getUserMessage([String : String])
    case user_isNewMessage
    case fin_getApplyFinFee([String : String])
    case article_getColumnInfo([String : String])
    case user_getInvitationInfo
    case user_getInvitationList([String : String])
    case user_getUnderFinOrderList([String : String])
    case fin_getEnFinFee([String : String])
    case common_sendCodeWithPic([String : String])
    case user_creatqrcode([String : String])
    case user_loginOut_token
    case user_searchTrade([String : String])
    case user_addMyChoose([String : String])
    case user_delMyChoose([String : String])
    case user_myChooseList([String : String])
    case trade_getTradeInfo([String : String])
    case user_windowClose
    case user_windowOpen
    case user_applyAgentIncome
}
//cs.flyy789.com
let ApiUrl = "http://cs.flyy789.com"
let WsUrl = "wss://w.sinajs.cn/wskt"

extension Api: TargetType {
    var baseURL: URL {
        switch self {
        case .fenshi:
            return URL(string: "http://118.190.104.207/www_eastmoney_com/api/js")!
        case .sinaInfo:
            return URL(string: "http://w.sinajs.cn/wskt")!
        default:
            return URL(string: ApiUrl)!
        }
        
    }
    
    var path: String {
        switch self {
            ///配置
        case .config_getConfigData:
            return "/api/config/getConfigData"
            //登录图形验证码
        case .commonverify:
            return "/api/common/verify"
            //登录
        case .user_login:
            return "/api/user/login"
            //注册接口
        case .user_register:
            return "/api/user/register"
            //检验图形验证码
        case .common_checkCode:
            return "/api/common/checkCode"
            //短信验证码
        case .common_sendCode:
            return "/api/common/sendCode"
            ///重制密码
        case .user_rePwd(_):
            return "/api/user/rePwd"
            ///资讯 共用
        case .article_getArticleInfo(_):
            return "/api/article/getArticleInfo"
            ///显示余额
        case .user_showBalance:
            return "/api/user/showBalance"
            ///上传身份证
        case .user_uploadImg(_):
            return "/api/user/uploadImg"
            ///实名认证
        case .user_realNameAuth(_):
            return "/api/user/realNameAuth"
            ///实名认证状态
        case .user_getRealNameStatus:
            return "/api/user/getRealNameStatus"
            ///设置银行卡
        case .user_setBankCard:
            return "/api/user/setBankCard"
            ///检查银行卡
        case .user_bankCardInfo:
            return "/api/user/bankCardInfo"
            ///设置密码
        case .user_setWDPwd:
            return "/api/user/setWDPwd"
            ///查询密码设置状态
        case .user_issetWDPwd:
            return "/api/user/issetWDPwd"
            ///重新设置手机号
        case .user_resetPhone:
            return "/api/user/resetPhone"
        case .user_checkOldPhone:
            return "/api/user/checkOldPhone"
            
            ///用户资金流水接口
        case .user_getUserCapital:
            return "/api/user/getUserCapital"
            ///提现记录
        case .user_getWithdrawList:
            return "/api/user/getWithdrawList"
            ///支付
        case .pay_userPay:
            return "/api/pay/userPay"
            ///充值记录
        case .user_getDepositList:
            return "/api/user/getDepositList"
            ///我的持仓 position_data持仓中数据 /获取用户股票订单信息-撤单 commission_data委托中数据
        case .trade_searchTradeOrder:
            return "/api/trade/searchTradeOrder"
            /// 买入/卖出
        case .trade_submitTrade:
            return "/api/trade/submitTrade"
            ///申请提现
        case .pay_userWithdraw:
            return "/api/pay/userWithdraw"
            ///合约
        case .fin_getFinOrderList:
            return "/api/fin/getFinOrderList"
            ///用户申请结算接口
        case .fin_applySettlement:
            return "/api/fin/applySettlement"
            ///追加资金
        case .fin_addMoney:
            return "/api/fin/addMoney"
            ///股票详情
        case .fin_getFinOrderInfo:
            return "/api/fin/getFinOrderInfo"
            ///综合查询
        case .trade_getTradeOrder:
            return "/api/trade/getTradeOrder"
            ///配资方式
        case .fin_finType:
            return "/api/fin/finType"
            ///配资规格
        case .fin_getFinSpecs:
            return "/api/fin/getFinSpecs"
            ///平仓线&&预警线
        case .fin_getLines:
            return "/api/fin/getLines"
            ///配资申请
        case .fin_applyFin:
            return "/api/fin/applyFin"
            ///模糊查询获取股票行情数据
        case .trade_selectTradeInfo:
            return "/api/trade/selectTradeInfo"
            
            ///配资账户余额=操盘金额-保证金余额
            ///保证金
        case .user_showMargin:
            return "/api/user/showMargin"
            ///操盘金额
        case .user_showTradeMoney:
            return "/api/user/showTradeMoney"
        ///获取历史K线
        case .ws_getKlineHistory:
            return "/api/ws/getKlineHistory"
          ///交割单接口
        case .trade_getPromptOrder:
            return "/api/trade/getPromptOrder"
            ///追加保证金
        case .fin_addMargin:
            return "/api/fin/addMargin"
            ///删除交易订单
        case .trade_delTradeOrder:
            return "/api/trade/delTradeOrder"
        ///合约列表
        case .fin_fOList:
            return "/api/fin/fOList"
        ///计算股票交易手续费
        case .trade_countCommissCharge:
            return "/api/trade/countCommissCharge"
            ///重要通知
        case .config_getConfigValue:
            return "/api/config/getConfigValue"
            ///文章详情
        case .article_getArticleDetail:
            return "/api/article/getArticleDetail"
             ///获取配资规格
        case .fin_getFinSpeFromId:
            return "/api/fin/getFinSpeFromId"
        ///扩大配资
        case .fin_enLargeFin:
            return "/api/fin/enLargeFin"
        ///重置登录密码
        case .user_reLoginPwd:
            return "/api/user/reLoginPwd"
        ///获取消息通知
        case .user_getUserMessage:
            return "/api/user/getUserMessage"
            ///新消息
        case .user_isNewMessage:
            return "/api/user/isNewMessage"
        ///配资利息
        case .fin_getApplyFinFee:
            return "/api/fin/getApplyFinFee"
            ///获取栏目列表
        case .article_getColumnInfo:
            return "/api/article/getColumnInfo"
        ///推广
        case .user_getInvitationInfo:
            return "/api/user/getInvitationInfo"
            ///推广人员列表
        case .user_getInvitationList:
            return "/api/user/getInvitationList"
            ///查看邀请人员的合约列表
        case .user_getUnderFinOrderList:
            return "/api/user/getUnderFinOrderList"
        ///扩大利息
        case .fin_getEnFinFee:
            return "/api/fin/getEnFinFee"
        ///获取验证码（账号安全
        case .common_sendCodeWithPic:
            return "/api/common/sendCodeWithPic"
            ///生成二维码
        case .user_creatqrcode:
            return "/api/user/creatqrcode"
            ///推出登录
        case .user_loginOut_token:
            return "/api/user/loginOut/token"
        ///模糊查询股票
        case .user_searchTrade:
            return "/api/user/searchTrade"
        ///添加自选股
        case .user_addMyChoose:
            return "/api/user/addMyChoose"
        ///删除自选股
        case .user_delMyChoose:
            return "/api/user/delMyChoose"
        ///会员自选股列表
        case .user_myChooseList:
            return "/api/user/myChooseList"
            ///股票信息
        case .trade_getTradeInfo:
            return "/api/trade/getTradeInfo"
            ///离线状态 关闭
        case .user_windowClose:
            return "/api/user/windowClose"
            ///离线状态 开启
        case .user_windowOpen:
            return "/api/user/windowOpen"
        ///申请代理提成
        case .user_applyAgentIncome:
            return "/api/user/applyAgentIncome"
            
            
        default: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fenshi:
            return .get

        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        LFLog("\(self)")
        switch self {
        case var .user_login(par),
             var .user_register(par),
             var .common_checkCode(par),
             var .common_sendCode(par),
             var .user_rePwd(par),
             var .article_getArticleInfo(par),
             var .user_setBankCard(par),
             var .user_realNameAuth(par),
             var .user_resetPhone(par),
             var .user_setWDPwd(par),
             var .user_getUserCapital(par),
             var .user_getWithdrawList(par),
             var .pay_userPay(par),
             var .user_getDepositList(par),
             var .trade_submitTrade(par),
             var .pay_userWithdraw(par),
             var .fin_getFinOrderList(par),
             var .fin_applySettlement(par),
             var .fin_addMoney(par),
             var .fin_getFinOrderInfo(par),
             var .trade_getTradeOrder(par),
             var .fin_getFinSpecs(par),
             var .fin_applyFin(par),
             var .trade_selectTradeInfo(par),
             var .ws_getKlineHistory(par),
             var .trade_getPromptOrder(par),
             var .fin_addMargin(par),
             var .trade_delTradeOrder(par),
             var .user_checkOldPhone(par),
             var .trade_searchTradeOrder(par),
             var .trade_countCommissCharge(par),
             var .config_getConfigValue(par),
             var .article_getArticleDetail(par),
             var .fin_getFinSpeFromId(par),
             var .fin_enLargeFin(par),
             var .user_reLoginPwd(par),
             var .fin_getApplyFinFee(par),
             var .article_getColumnInfo(par),
             var .user_getInvitationList(par),
             var .user_getUnderFinOrderList(par),
             var .fin_getEnFinFee(par),
             var .user_getUserMessage(par),
             var .common_sendCodeWithPic(par),
             var .user_creatqrcode(par),
             var .user_searchTrade(par),
             var .user_addMyChoose(par),
             var .user_delMyChoose(par),
             var .user_myChooseList(par),
             var .trade_getTradeInfo(par):
            
            par["token"] = Environment().token ?? ""
            return .requestParameters(parameters: par, encoding: URLEncoding.queryString)
            
        case let .user_uploadImg(img, name):
            let a = MultipartFormData(provider: .data(img), name: name, fileName: "imageFront.png", mimeType: "image/png")
//            let b = MultipartFormData(provider: .data(par.last!), name: "imageReverse", fileName: "imageReverse.png", mimeType: "image/png")//imageFront
            let s = Environment().token!
//            let c = MultipartFormData(provider: .data(s!), name: "token")
            return .uploadCompositeMultipart([a], urlParameters: ["token" : s])
            
        case let .fenshi(par),
             let .sinaInfo(par):
            return .requestParameters(parameters: par, encoding: URLEncoding.queryString)
            
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
        configuration.timeoutIntervalForRequest = 5 // timeout
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
//        LFLog("will+\(target)")
        if Environment().tokenExists {
            SLFHUD.showLoading()
        }
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
//        LFLog("didReceive+\(target)")
        SLFHUD.hide()
    }
    
    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        SLFHUD.hide()
        return result
    }
}


func apiRequset(_ a: Any) -> Single<LFResponseModel> {
    
    return Single<LFResponseModel>.create(subscribe: { (se) -> Disposable in
        let api = apiProvider.rx.request(a as! Api).asObservable().share(replay: 1, scope: .forever).mapModel(LFResponseModel.self).subscribe(onNext: { (model) in
            if model.code == 0 {
                se(.success(model))
            }else if model.code == 2 {
//                SLFHUD.showHint(model.msg)
                SLFHUD.hide()
                Environment.shared.remove()
                GVUserDefaults.standard().removeUserInfo()
                _ = LoginCoordinator(str: model.msg).start().subscribe()
//                let appCoordinator = AppCoordinator(window: UIApplication.shared.keyWindow!)
//                _ = appCoordinator.start()
//                    .subscribe()
                se(.error(NSError(domain: model.msg, code: model.code, userInfo: nil)))
//                SLFHUD.hide()
            }else {
                se(.success(model))
            }
        }, onError: { (e) in
            let ne = e as NSError
            SLFHUD.hide()
            se(.error(e))
            var str = e.localizedDescription
            if ne.code == 6 {
                str = "请检查您的网络设置"
            }
            SLFHUD.showHint(str)
        }, onCompleted: {
//            SLFHUD.hide()
        }) {
            
        }
        return Disposables.create{
            api.dispose()
        }
    })
}

func apiRequsetNo(_ a: Any) -> Single<LFResponseModel> {
    
    return Single<LFResponseModel>.create(subscribe: { (se) -> Disposable in
        let api = apiProviderNo.rx.request(a as! Api).asObservable().share(replay: 1, scope: .forever).mapModel(LFResponseModel.self).subscribe(onNext: { (model) in
            if model.code == 0 {
                se(.success(model))
            }else if model.code == 2 {
//                SLFHUD.showHint(model.msg)
                SLFHUD.hide()
                Environment.shared.remove()
                GVUserDefaults.standard().removeUserInfo()
                _ = LoginCoordinator(str: model.msg).start().subscribe()
                se(.error(NSError(domain: model.msg, code: model.code, userInfo: nil)))
            }else {
                se(.error(NSError(domain: model.msg, code: model.code, userInfo: nil)))
            }
        }, onError: { (e) in
            let ne = e as NSError
            SLFHUD.hide()
            se(.error(e))
            var str = e.localizedDescription
            if ne.code == 6 {
                str = "请检查您的网络设置"
            }
            SLFHUD.showHint(str)
        }, onCompleted: {
//            SLFHUD.hide()
        }) {
            
        }
        return Disposables.create{
            api.dispose()
        }
    })
}
//MARK: - 网络状态
let NetworkStatus = NSNotification.Name.init(rawValue:"networkStatus")

//https://www.jianshu.com/p/9ee53bfa7862
//class ServerCheck {
//    private static let sharedInstance = ServerCheck()
//    var manager = NetworkReachabilityManager(host:"www.baidu.com")
//    init() {
//        manager?.listener = { status in
////            print("\(status)")
////            if status == .reachable(.ethernetOrWiFi) { //WIFI
////                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue:"networkStatus"), object: true)
////                debugPrint("wifi")
////            } else if status == .reachable(.wwan) { // 蜂窝网络
////                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue:"networkStatus"), object: true)
////                debugPrint("4G")
////            } else if status == .notReachable { // 无网络
////                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue:"networkStatus"), object: false)
////
////                debugPrint("无网络")
////            } else { // 其他
////
////            }
//        }
//        //开始监听
//        manager?.startListening()
//    }
//    class var sharedManager:ServerCheck {
//        let instance = self.sharedInstance
//        return instance
//    }
//    func networkReachabilityStatus() -> Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus {
//        let status:Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus = (manager?.networkReachabilityStatus)!
//        print("当前网络状态:\(status)")
//        return status
//    }
//}
//
//class SerVer {
//    enum CustomNetStatus {
//        case NONET //无网络
//        case WIFI  //WiFi
//        case WWAN  // 3G 或 4G
//    }
//    class open func netWorkState()->CustomNetStatus{
//        var status:CustomNetStatus = .NONET
//        let serVerS:NetworkReachabilityManager.NetworkReachabilityStatus = ServerCheck.sharedManager.networkReachabilityStatus()
//        switch serVerS {
//        case .notReachable:
//            status = .NONET
//            break
//        case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
//            status = .WIFI
//            break
//        case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
//            status = .WWAN
//            break
//            
//        default:
//            status = .NONET
//            break
//        }
//        return status
//    }
//}
let manager = NetworkReachabilityManager(host: "www.baidu.com")
func AlamofiremonitorNet() {
    manager?.listener = { status in
//        debugPrint("网络状态: \(status)")
        if status == .reachable(.ethernetOrWiFi) { //WIFI
            NotificationCenter.default.post(name: NetworkStatus, object: true)
//            debugPrint("wifi")
        } else if status == .reachable(.wwan) { // 蜂窝网络
            NotificationCenter.default.post(name: NetworkStatus, object: true)
//            debugPrint("4G")
        } else if status == .notReachable { // 无网络
            NotificationCenter.default.post(name: NetworkStatus, object: false)

//            debugPrint("无网络")
        } else { // 其他

        }

    }
    manager?.startListening()//开始监听网络
}
