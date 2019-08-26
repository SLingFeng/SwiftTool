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

class ChatVM: LFBaseVM {
    
    
    //表格数据序列
    var tableData = BehaviorRelay<[Message]>(value: [])
    
    //ViewModel初始化（根据输入实现对应的输出）
    init(input: (
        headerRefresh: Driver<Void>,
        footerRefresh: Driver<Void>,
        par: [String : Any]),
         disposeBag:DisposeBag ) {
        super.init()
        
        var p = input.par
        //下拉结果序列
        let headerRefreshData = input.headerRefresh
            .startWith(()) //初始化时会先自动加载一次数据
            .flatMapLatest({_ -> SharedSequence<DriverSharingStrategy, [Message]> in
                self.page = 1
                p["page"] = "\(self.page)"
                return ChatVM.user_getChatHistory(p as! [String : String])
            })
        
        //上拉结果序列
        let footerRefreshData = input.footerRefresh
            .flatMapLatest{ _ -> SharedSequence<DriverSharingStrategy, [Message]> in  //也可考虑使用flatMapFirst
                self.page += 1
                p["page"] = "\(self.page)"
                return ChatVM.user_getChatHistory(p as! [String : String])
        }
        
        //生成停止头部刷新状态序列
        self.endHeaderRefreshing = headerRefreshData.map{ _ in true }
        
        //生成停止尾部刷新状态序列
        self.endFooterRefreshing = footerRefreshData.map{ _ in true }
        
        let w = Driver.of(headerRefreshData, footerRefreshData).merge()
        self.status = w.map { (a) in
            if a.count == 0 {
                return MyTableViewStatusImage
            }else {
                return MyTableViewStatusNormal
            }
        }
        
        self.footerStatus = headerRefreshData.map({a in
            return a.count == 0 ? 1 : 0
        })
        
        //下拉刷新时，直接将查询到的结果替换原数据
        headerRefreshData.drive(onNext: { items in
            self.tableData.accept(items)
        }).disposed(by: disposeBag)
        
        //上拉加载时，将查询到的结果拼接到原数据底部
        footerRefreshData.drive(onNext: { items in
            self.tableData.accept(items + self.tableData.value)
        }).disposed(by:
            disposeBag)
    }
    class func user_getChatHistory(_ par: [String : String]) -> Driver<[Message]> {
        
        return Observable<[Message]>.create({ (ob) -> Disposable in
            let x = apiRequset(Api.user_getChatHistory(par)).asObservable().subscribe(onNext: { (model) in
                if model.code == 0 {
                    var msgList: [Message] = []
                    if let m = BF_ChatModel.deserialize(from: model.data["chat_list"] as? Dictionary) {
                        m.data.forEach { (model) in
                            let who = model.from_user_id == GVUserDefaults.standard().uid ? false : true
                            
                            var message: Message?
                            if !model.content.empty() {
                                //内容
                                message = Message(incoming: who, text: model.content, avatar: model.image_path, name: model.nick_name)
                            }
                            if !model.face.empty() {
                                //内容
                                message = Message(incoming: who, text: model.face, avatar: model.image_path, name: model.nick_name)
                            }
                            if !model.pic.empty() {
                                //内容
                                
                                message = Message(incoming: who, imageUrl: URL(string: model.pic), avatar: model.image_path, name: model.nick_name)
                            }
                            if message != nil {
                                message!.time = SLFCommonTools.timestamp(Double(model.create_time) ?? 0, formart: "YYYY-MM-dd hh:mm:ss")
                                msgList.insert(message!, at: 0)
                            }
                        }
                        ob.onNext(msgList)
                    }
                }else {
                    ob.onNext([])
                }
                ob.onCompleted()
            }, onError: { (error) in
                SLFHUD.showHint(error.localizedDescription)
                ob.onError(error)
            })
            return Disposables.create{
                x.dispose()
            }
        }).asDriver(onErrorJustReturn: [])
    }
    
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
    
    class func user_getChatUserList() -> Driver<[BF_ChatUserListDataModel]> {
        
        return Observable<[BF_ChatUserListDataModel]>.create({ (ob) -> Disposable in
            let x = apiRequsetArray(Api.user_getChatUserList, no: true).asObservable().subscribe(onNext: { (model) in
                if model.code == 0 {
                    if let m = BF_ChatUserListModel.deserialize(from: ["data" : model.data]) {
                        m.data.sort(by: { (m, m1) -> Bool in
                            return m.chat_admin > m1.chat_admin
                        })
                        ob.onNext(m.data)
                    }else {
                        ob.onNext([])
                    }
                }else {
                    ob.onNext([])
                }
                ob.onCompleted()
            }, onError: { (error) in
                SLFHUD.showHint(error.localizedDescription)
                ob.onError(error)
            })
            return Disposables.create{
                x.dispose()
            }
        }).asDriver(onErrorJustReturn: [])
    }
    
    
}
