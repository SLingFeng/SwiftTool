//
//  LFSocket.swift
//  jsbf
//
//  Created by big on 2019/6/29.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import SocketRocket
import HandyJSON

enum LFConnectType : Int {
    case disConnectByUser = 1
    case disConnectByServer = 2
}

typealias DidReceiveMessage = (LFResponseModel) -> Void
typealias DidFailWithError = (Error?) -> Void

//消息代理
protocol LFSocketDelegate: AnyObject {
    func lfSocketDidReceiveMessage(_ message: Any?)
    
    func lfSocketDidFailWithError(_ error: Error?)
}

class LFSocket: NSObject, SRWebSocketDelegate {
    
    static let shared = LFSocket()
    
    let apiws = "ws://cs.flyv888.com:8284"
    
    var heartBeat: Timer!
    var reConnecTime: TimeInterval = TimeInterval(floatLiteral: 0)
    
    var socket: SRWebSocket!
    
    var delegates: NSMutableArray = NSMutableArray(capacity: 1)
    
    var model = LFSocketModel()
    //未发送的
    var noSendArray: [String] = []
    
    var connectType = LFConnectType.disConnectByServer
    
    private override init() {
        super.init()
        
        initSocket()
        
    }
    
    func initSocket() {
        if (socket != nil) {
            return
        }
        if let url = URL(string: apiws) {
            socket = SRWebSocket(url: url)
        }
        socket.delegate = self
        //  设置代理线程queue
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        socket.setDelegateOperationQueue(queue)
        
        //  连接
        socket.open()
        connectType = LFConnectType.disConnectByServer
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
//        LFLog(message)
            let data = LFSocket.dictionaryWithJsonString(message as? String)
            self.delegates.forEach { (delegate) in
                if let dg = delegate as? LFSocketDelegate {
                    DispatchQueue.main.async {
                        dg.lfSocketDidReceiveMessage(data)
                    }
                }
            }
        
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        initHearBeat()
        LFLog("open")
//        noSendArray.forEach { (jsonString) in
//            webSocket.send(jsonString)
//        }
        for jsonString in noSendArray {
            webSocket.send(jsonString)
        }
        noSendArray.removeAll()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        reConnect()
        DispatchQueue.main.async {[weak self] in
            self?.delegates.forEach { (delegate) in
                if let dg = delegate as? LFSocketDelegate {
                    dg.lfSocketDidFailWithError(error)
                }
            }
            LFLog(error)
        }
        
//        SLFHUD.showHint(error.localizedDescription)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        //如果是被用户自己中断的那么直接断开连接，否则开始重连
        if connectType == LFConnectType.disConnectByUser {
            disConnect()
        }else {
            reConnect()
        }
        destoryHeartBeat()
//        reConnect()
        LFLog(reason)
    }
    
    
    
    
    
    /// 发送消息
    ///
    /// - Parameters:
    ///   - parameters: 需要的参数
    ///   - message: 返回数据
    ///   - fail: 返回失败
    func send(_ parameters: [String : Any]) {
//        , didReceive message: DidReceiveMessage, fail: DidFailWithError
        LFLog(parameters)
        var par = parameters
        
        par["time"] = SLFCommonTools.timestamp(Date().timeIntervalSince1970, formart: "YYYY-MM-dd HH:mm:ss")
        
        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            
        }
        
        if let jsonData = jsonData {
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                
                
                if (socket != nil) {
                    
                    if socket.readyState == .OPEN {
                        self.socket.send(jsonString)
                    }else if socket.readyState == .CONNECTING {
                        noSendArray.append(jsonString)
//                        self.socket.send(jsonString)
                        
//                        reConnect()
                    }else if socket.readyState == .CLOSING || socket.readyState == .CLOSED {
                        //断开了，调用 reConnect 方法重连
                        reConnect()
                    }
                    
                }else {
//                    NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
//                    NSLog(@"其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网");
                    destoryHeartBeat()
                    reConnect()
                }
                
                
            }
            
            
            
        }
        
//        let jsonData = JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
//
//        }
        
    }
    func send(_ m: LFSocketSendModel) {
    
        let jsonString = m.toJSONString()
        if let jsonString = jsonString {
            if (socket != nil) {
                
                if socket.readyState == .OPEN {
                    self.socket.send(jsonString)
                }else if socket.readyState == .CONNECTING {
                    noSendArray.append(jsonString)
                    //                        self.socket.send(jsonString)
                    
                    //                        reConnect()
                }else if socket.readyState == .CLOSING || socket.readyState == .CLOSED {
                    //断开了，调用 reConnect 方法重连
                    reConnect()
                }
                
            }else {
                //                    NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
                //                    NSLog(@"其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网");
                destoryHeartBeat()
                reConnect()
            }
        }
        
    }
//    - (void)sendForParameters:(NSDictionary *)parameters didReceive:(DidReceiveMessage)message fail:(DidFailWithError)fail {
//    
//    kWeakSelf(weakSelf);
//    
//    //    dispatch_queue_t queue = dispatch_queue_create("com.dcyy.LFWS", NULL);
//    
//    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//    NSLog(@"Send:------------\n%@\n", parameters);
//    //        LFWS.receive = nil;
//    //        LFWS.fail = nil;
//    DCSocketBlock *sb = [[DCSocketBlock alloc] init];
//    
//    
//    NSError *error;
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
//    
//    if (error) {
//    fail(error);
//    }else {
//    sb.receive = message;
//    sb.fail = fail;
//    }
//    
//    if (!kStringIsEmpty(parameters[@"type"])) {
//    [weakSelf.blockDic setValue:sb forKey:parameters[@"type"]];
//    }
//    
//    
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    //        weakSelf.socket.delegate = weakSelf;
//    if (weakSelf.socket != nil) {
//    // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
//    if (weakSelf.socket.readyState == SR_OPEN) {
//    [weakSelf.socket send:jsonString];    // 发送数据
//    
//    } else if (weakSelf.socket.readyState == SR_CONNECTING) {
//    NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
//    // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
//    // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
//    // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
//    
//    
//    
//    } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
//    // websocket 断开了，调用 reConnect 方法重连
//    [weakSelf reConnect];
//    //                [weakSelf res:^(BOOL success) {
//    //                    NSLog(@"重连成功，继续发送刚刚的数据");
//    //                    [weakSelf.socket send:jsonString];
//    //                }];
//    }
//    } else {
//    //            [weakSelf res:^(BOOL success) {
//    [weakSelf.socket send:jsonString];
//    //            }];
//    NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
//    NSLog(@"其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网");
//    }
//    //        if (LFWS.socket.delegate == nil) {
//    //            [LFWS res:^(BOOL success) {
//    //                [LFWS.socket send:jsonString];
//    //            }];
//    //        }else {
//    //            [LFWS.socket send:jsonString];
//    //        }
//    
//    
//    });
//    
//    
//    }
    
    func addDelegate(_ delegate: LFSocketDelegate) {
//        self.delegates.append(delegate)
        //查找
        let vc = delegate as? UIViewController
//        delegates.forEach { (dg) in
//            if let dg = dg as? UIViewController {
//                if dg == vc {
//                    return
//                }
//            }
//        }
        for dg in delegates {
            if let dg = dg as? UIViewController {
                if dg == vc {
                    return
                }
            }
        }
        
        //没有在添加
        weak var dg = delegate
        if let dg = dg {
            delegates.add(dg)
        }
    }
    
    func removeDelegate(_ delegate: LFSocketDelegate) {
        delegates.remove(delegate)
    }
    
    //MARK: 心跳
    func initHearBeat() {
        weak var weakSelf = self
        
        DispatchQueue.main.async(execute: {[weak self] in
            if let strongSelf = self {
                strongSelf.destoryHeartBeat()
                
                //心跳设置为3分钟，NAT超时一般为5分钟
                strongSelf.heartBeat = Timer.scheduledTimer(timeInterval: 3 * 60, target: strongSelf, selector: #selector(strongSelf.sendHeart(time:)), userInfo: nil, repeats: true)
                
                //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
                if let heartBeat = weakSelf?.heartBeat {
                    RunLoop.current.add(heartBeat, forMode: .common)
                }
            }
        })
    }
    //   取消心跳
    func destoryHeartBeat() {
        DispatchQueue.main.async(execute: {[weak self] in
            if let strongSelf = self {
                if (strongSelf.heartBeat != nil) {
                    strongSelf.heartBeat.invalidate()
                    strongSelf.heartBeat = nil
                }
            }
        })
    }
    //   建立连接
    func connect() {
        initSocket()
    }
    //   断开连接
    func disConnect(type:LFConnectType = LFConnectType.disConnectByServer) {
        self.connectType = type
        if (socket != nil) {
            socket.close()
            socket = nil
        }
    }
    //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
    @objc func sendHeart(time: Timer) {
        socket.send("heart")
    }
    //  重连机制
    func reConnect() {
        disConnect()
        
        if reConnecTime > 64 {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(reConnecTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[weak self] in
            if let strongSelf = self {
                strongSelf.socket = nil
                strongSelf.initSocket()
            }
        })
        
        //   重连时间2的指数级增长
        if reConnecTime == 0 {
            reConnecTime = 2
        }else {
            reConnecTime *= 2
        }
    }
    func ping() {
        socket.sendPing(nil)
    }
    
    class func dictionaryWithJsonString(_ jsonString: String?) -> NSDictionary {
        
        if jsonString?.isEmpty ?? true {
            return [:]
        }
        
        let jsonData = jsonString?.data(using: .utf8)
        var err: Error?
        var dic: NSDictionary = [:]
        do {
            if let jsonData = jsonData {
                if let d = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary {
                    dic = d
                }
            }
        } catch let e {
            err = e
        }
        if err != nil {
//                print("json解析失败：\(err)")
            return [:]
        }
        return dic
    }
    
//    func safeAsync(_ execute: @escaping () -> Void) {
//        DispatchQueue.main. ? execute() : DispatchQueue.main.async(execute: execute)
//    }
}

extension DispatchQueue {
    
    struct DispachQueueSafety {
        
        private init() {
            DispatchQueue.main.setSpecific(key: specificKey, value: specificValue)
        }
        
        var isMainQueue: Bool {
            return DispatchQueue.getSpecific(key: specificKey) == specificValue
        }
        
        func async(execute: @escaping () -> Void) {
            isMainQueue ? execute() : DispatchQueue.main.async(execute: execute)
        }
        
        let specificKey = DispatchSpecificKey<String>()
        let specificValue = "com.sadf.mainQueue.specific"
        static let `default` = DispachQueueSafety()
    }
    
    var safe: DispachQueueSafety {
        return DispachQueueSafety.default
    }
}


class LFSocketModel: NSObject {
    
    var client_id = ""
    
    var userIcon = ""
    
    var name = ""
}

class LFSocketSendModel: NSObject, HandyJSON {
    
    var type: String?// "say"
    var from_client_id: String?// strongSelf.socket.model.client_id
    var from_client_name: String?
    var at_user: String = ""
    var to_client_id = "1"//String?// "all/client_id"
    var to_client_name: String?
    var pic: String = ""
    var content: String = ""
    var face: String = ""
    var client_name: String?// GVUserDefaults.standard().nick_name
    var room_id: String = "1"
    var token: String?// Environment().token!
    var time = SLFCommonTools.timestamp(Date().timeIntervalSince1970, formart: "YYYY-MM-dd HH:mm:ss")
    
    required override init() {
        super.init()
    }
}
