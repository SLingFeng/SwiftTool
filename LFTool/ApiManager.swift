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
    case user_getMyInfo
    case user_getUserImg
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
    case config_getConfigData
    case pay_applyWithdraw([String : String])
    case config_getConfigValue([String : String])
    case article_getArticleDetail([String : String])
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
    case user_loginOut
    case user_searchTrade([String : String])
    case user_addMyChoose([String : String])
    case user_delMyChoose([String : String])
    case user_myChooseList([String : String])
    case trade_getTradeInfo([String : String])
    case user_windowClose
    case user_windowOpen
    case user_applyAgentIncome
    
    //2019-6-25
    case user_myFollowList([String : String])
    case user_applyExpert
    //27
    case user_editMyInfo([String : String])
    case user_delMyFollow([String : String])
    //29
    case match_getMatchList([String : String])
    case user_addRecommend([String : String])
    
    case user_getRecommOrder([String : String])
    case user_getRecommList([String : String])
    case user_getRecommInfo([String : String])
    case user_addMyFollow([String : String])
    case user_getMyRecomm([String : String])
    case user_applyExpertStatus
    case user_getFollowInfo([String : String])
    
    case Score_ongoing([String : Any])
    case Score_schedule([String : Any])
    case Score_afterGame([String : Any])
    case Score_focus([String : Any])
    case match_getTeamInfo([String : String])
    
    case match_getPlayerInfo([String : String])
    case match_getPlayerStatInfo([String : String])
    case match_countTeamStat([String : String])
    case match_getCwayList([String : String])
    case match_countAE([String : String])
    case match_getShooterList([String : String])
    case Score_recommendEvent([String : String])
    case match_getTeamStatInfo([String : String])
    case Score_integral([String : String])
    case Score_dynamic([String : String])
    case match_countHomeAE([String : String])
    case match_countAEInfo([String : String])
    case match_getCompetitionList([String : String])
    case match_getAEScoreList([String : String])
    case match_getGrList([String : String])
    case match_getGameInfo([String : String])
    case Score_scheduleDb([String : String])
    case score_leagueSelect([String : String])
    case match_teamScoreOrder([String : String])
    case Score_companyIndex([String : String])
    case match_getNextDayMatch([String : String])
    case match_getRAEScore([String : String])
    case Score_getFocusStatus([String : String])
    
}
//cs.flyy789.com
let ApiUrl = "http://cs.flyv888.com"
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
        //注册接口
        case .user_register:
            return "/api/user/register"
        //登录
        case .user_login:
            return "/api/user/login"
        //登录图形验证码
        case .commonverify:
            return "/api/common/verify"
        //检验图形验证码
        case .common_checkCode:
            return "/api/common/checkCode"
        ///重制密码
        case .user_rePwd:
            return "/api/user/rePwd"
        ///个人资料
        case .user_getMyInfo:
            return "/api/user/getMyInfo"
        ///上传身份证
        case .user_uploadImg:
            return "/api/user/uploadImg"
        ///获取身份证图片
        case .user_getUserImg:
            return "/api/user/getUserImg"
        ///实名认证
        case .user_realNameAuth(_):
            return "/api/user/realNameAuth"
        ///实名认证状态
        case .user_getRealNameStatus:
            return "/api/user/getRealNameStatus"
            ///验证旧手机
        case .user_checkOldPhone:
            return "/api/user/checkOldPhone"
        ///重新设置手机号
        case .user_resetPhone:
            return "/api/user/resetPhone"
        ///重置登录密码
        case .user_reLoginPwd:
            return "/api/user/reLoginPwd"
        ///设置密码
        case .user_setWDPwd:
            return "/api/user/setWDPwd"
        ///查询密码设置状态
        case .user_issetWDPwd:
            return "/api/user/issetWDPwd"
        ///设置银行卡
        case .user_setBankCard:
            return "/api/user/setBankCard"
        ///检查银行卡
        case .user_bankCardInfo:
            return "/api/user/bankCardInfo"
            //MARK: 2019-6-25
        ///申请提现
        case .pay_applyWithdraw:
            return "/api/pay/applyWithdraw"
        ///获取我的关注列表
        case .user_myFollowList:
            return "/api/user/myFollowList"
        ///获取消息通知
        case .user_getUserMessage:
            return "/api/user/getUserMessage"
        ///获取新闻资讯 共用
        case .article_getArticleInfo(_):
            return "/api/article/getArticleInfo"
        ///新闻详情
        case .article_getArticleDetail:
            return "/api/article/getArticleDetail"
        ///申请专家
        case .user_applyExpert:
            return "/api/user/applyExpert"
        ///推广
        case .user_getInvitationInfo:
            return "/api/user/getInvitationInfo"
            
        ///获取验证码（账户安全
        case .common_sendCodeWithPic:
            return "/api/common/sendCodeWithPic"
            //2019-06-27
            
        ///修改个人资料
        case .user_editMyInfo:
            return "/api/user/editMyInfo"
        ///删除我的关注
        case .user_delMyFollow:
            return "/api/user/delMyFollow"
            //2019-06-29
        ///我要推介的赛事列表
        case .match_getMatchList:
            return "/api/match/getMatchList"
        ///申请推介
        case .user_addRecommend:
            return "/api/user/addRecommend"
        ///退出登录
        case .user_loginOut:
            return "/api/user/loginOut"
            
            //7-1
            
        ///推介列表 排行 首页
        case .user_getRecommOrder:
            return "/api/user/getRecommOrder"
        ///推介列表
        case .user_getRecommList:
            return "/api/user/getRecommList"
        ///推介详情
        case .user_getRecommInfo:
            return "/api/user/getRecommInfo"
            
            //7-7
        ///添加我的关注
        case .user_addMyFollow:
            return "/api/user/addMyFollow"
        ///我的推介
        case .user_getMyRecomm:
            return "/api/user/getMyRecomm"
           //7-5
        ///申请专家的状态0申请中 2 失败
        case .user_applyExpertStatus:
            return "/api/user/applyExpertStatus"
        ///我的关注-个人信息
        case .user_getFollowInfo:
            return "/api/user/getFollowInfo"
            //7-9
        ///即时比分
        case .Score_ongoing:
            return "/api/Score/ongoing"
        ///赛程
        case .Score_schedule:
            return "/api/Score/schedule"
        ///完场
        case .Score_afterGame:
            return "/api/Score/afterGame"
        ///关注赛事和关注赛事展示
        case .Score_focus:
            return "/api/Score/focus"
        ///球队信息
        case .match_getTeamInfo:
            return "/api/match/getTeamInfo"
            //7-10
        ///球员信息
        case .match_getPlayerInfo:
            return "/api/match/getPlayerInfo"
        ///获取球员数据统计
        case .match_getPlayerStatInfo:
            return "/api/match/getPlayerStatInfo"
        ///获取球队统计
        case .match_countTeamStat:
            return "/api/match/countTeamStat"
        ///盘路统计
        case .match_getCwayList:
            return "/api/Match/getCwayList"
        ///比分-统计
        case .match_countAE:
            return "/api/match/countAE"
        ///资料库的射手榜
        case .match_getShooterList:
            return "/api/match/getShooterList"
            
            //7-11
        ///资料库 赛区+地区
        case .Score_recommendEvent:
            return "/api/Score/recommendEvent"
        ///球队往绩
        case .match_getTeamStatInfo:
            return "/api/match/getTeamStatInfo"
        ///资料库 积分表
        case .Score_integral:
            return "/api/Score/integral"
        ///获取比赛动态
        case .Score_dynamic:
            return "/api/Score/dynamic"
        ///实时数据
        case .match_countHomeAE:
            return "/api/match/countHomeAE"
        ///走地数据
        case .match_countAEInfo:
            return "/api/match/countAEInfo"
        ///球队-赛程
        case .match_getCompetitionList:
            return "/api/match/getCompetitionList"
            //7-12
        ///球队-赛程
        case .match_getAEScoreList:
            return "/api/match/getAEScoreList"
        ///球队-推介
        case .match_getGrList:
            return "/api/match/getGrList"
        ///比赛信息
        case .match_getGameInfo:
            return "/api/match/getGameInfo"
//            7-13
        ///资料库 赛程
        case .Score_scheduleDb:
            return "/api/Score/scheduleDb"
        ///联赛筛选
        case .score_leagueSelect:
            return "/api/Score/leagueSelect"
//            7-15
        ///比赛详情-数据分析
        case .match_teamScoreOrder:
            return "/api/match/teamScoreOrder"
        ///筛选指数
        case .Score_companyIndex:
            return "/api/Score/companyIndex"
            
        ///统计 赛程
        case .match_getNextDayMatch:
            return "/api/match/getNextDayMatch"
        ///我要推介 获取
        case .match_getRAEScore:
            return "/api/match/getRAEScore"
        ///获取关注状态
        case .Score_getFocusStatus:
            return "/api/Score/getFocusStatus"
            //MARK: - 暂无
            
           
            
            
            
            //短信验证码
        case .common_sendCode:
            return "/api/common/sendCode"
            
            
            ///显示余额
        case .user_showBalance:
            return "/api/user/showBalance"
            
            
            
            
            
        
            
            ///重要通知
        case .config_getConfigValue:
            return "/api/config/getConfigValue"
            
        
        
            ///新消息
        case .user_isNewMessage:
            return "/api/user/isNewMessage"
        ///配资利息
        case .fin_getApplyFinFee:
            return "/api/fin/getApplyFinFee"
            ///获取栏目列表
        case .article_getColumnInfo:
            return "/api/article/getColumnInfo"
        
            ///推广人员列表
        case .user_getInvitationList:
            return "/api/user/getInvitationList"
            ///查看邀请人员的合约列表
        case .user_getUnderFinOrderList:
            return "/api/user/getUnderFinOrderList"
        ///扩大利息
        case .fin_getEnFinFee:
            return "/api/fin/getEnFinFee"
            ///生成二维码
        case .user_creatqrcode:
            return "/api/user/creatqrcode"
            
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
             var .pay_applyWithdraw(par),
             var .user_checkOldPhone(par),
             var .config_getConfigValue(par),
             var .article_getArticleDetail(par),
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
             var .trade_getTradeInfo(par),
            //2019-6-25
            var .user_myFollowList(par),
            var .user_editMyInfo(par),
            var .user_delMyFollow(par),
            var .user_addRecommend(par),
            var .match_getMatchList(par),
            var .user_getRecommOrder(par),
            var .user_getRecommInfo(par),
            var .user_getRecommList(par),
            var .user_addMyFollow(par),
            var .user_getMyRecomm(par),
            var .user_getFollowInfo(par),
            var .match_getTeamInfo(par),
            var .match_getPlayerInfo(par),
            var .match_getPlayerStatInfo(par),
            var .match_countTeamStat(par),
            var .match_getCwayList(par),
            var .match_countAE(par),
            var .match_getShooterList(par),
            var .Score_recommendEvent(par),
            var .match_getTeamStatInfo(par),
            var .Score_integral(par),
            var .Score_dynamic(par),
            var .match_countHomeAE(par),
            var .match_countAEInfo(par),
            var .match_getCompetitionList(par),
            var .match_getAEScoreList(par),
            var .match_getGrList(par),
            var .match_getGameInfo(par),
            var .Score_scheduleDb(par),
            var .score_leagueSelect(par),
            var .match_teamScoreOrder(par),
            var .Score_companyIndex(par),
            var .match_getNextDayMatch(par),
            var .match_getRAEScore(par),
            var .Score_getFocusStatus(par)
            :
            
            par["token"] = Environment().token ?? ""
            return .requestParameters(parameters: par, encoding: URLEncoding.queryString)
            
        case var .Score_ongoing(par),
             var .Score_schedule(par),
             var .Score_afterGame(par),
             var .Score_focus(par):
            
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


func apiRequset<T: LFResponseModel>(_ a: Api, modelType: T.Type = T.self) -> Single<T> {

    return Single<T>.create(subscribe: { (se) -> Disposable in
        let api = apiProvider.rx.request(a).asObservable().share(replay: 1, scope: .forever).mapModel(modelType).subscribe(onNext: { (model) in
            LFLog("\(model.msg)+\(a)")
            if model.code == 0 {
                se(.success(model))
            }else if model.code == 2 || model.msg == "令牌不能为空" {
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
                str = "当前网络不稳定，请稍后重试"
            }
            SLFHUD.showHint(str)
        }, onCompleted: {
//            SLFHUD.hide()
        }) {
            
        }
        return Disposables.create{
            api.dispose()
//            SLFHUD.hide()
        }
    })
}

func apiRequsetNo(_ a: Api) -> Single<LFResponseModel> {
    
    return Single<LFResponseModel>.create(subscribe: { (se) -> Disposable in
        let api = apiProviderNo.rx.request(a).asObservable().share(replay: 1, scope: .forever).mapModel(LFResponseModel.self).subscribe(onNext: { (model) in
            if model.code == 0 {
                se(.success(model))
            }else if model.code == 2 || model.msg == "令牌不能为空" {
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
                str = "当前网络不稳定，请稍后重试"
            }
            SLFHUD.showHint(str)
        }, onCompleted: {
//            SLFHUD.hide()
        }) {
            
        }
        return Disposables.create{
            api.dispose()
//            SLFHUD.hide()
        }
    })
}
//数组
func apiRequsetArray<T: LFResponseArrayModel>(_ a: Api, modelType: T.Type = T.self, no: Bool = false) -> Single<T> {
    
    let nowApiProvider = no ? apiProvider : apiProviderNo
    
    return Single<T>.create(subscribe: { (se) -> Disposable in
        let api = nowApiProvider.rx.request(a).asObservable().share(replay: 1, scope: .forever).mapModel(modelType).subscribe(onNext: { (model) in
            if model.code == 0 {
                se(.success(model))
            }else if model.code == 2 || model.msg == "令牌不能为空" {
                SLFHUD.hide()
                Environment.shared.remove()
                GVUserDefaults.standard().removeUserInfo()
                _ = LoginCoordinator(str: model.msg).start().subscribe()
                se(.error(NSError(domain: model.msg, code: model.code, userInfo: nil)))
            }else {
                se(.success(model))
            }
        }, onError: { (e) in
            let ne = e as NSError
            SLFHUD.hide()
            se(.error(e))
            var str = e.localizedDescription
            if ne.code == 6 {
                str = "当前网络不稳定，请稍后重试"
            }
            SLFHUD.showHint(str)
        }, onCompleted: {
            //            SLFHUD.hide()
        }) {
            
        }
        return Disposables.create{
            api.dispose()
            //            SLFHUD.hide()
        }
    })
}
func apiRequsetArrayNo<T: LFResponseArrayModel>(_ a: Api, modelType: T.Type = T.self) -> Single<T> {
    return apiRequsetArray(a, modelType: modelType, no: true)
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
