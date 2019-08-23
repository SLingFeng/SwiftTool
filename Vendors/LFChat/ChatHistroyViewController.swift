//
//  ChatHistroyViewController.swift
//  jsbf
//
//  Created by big on 2019/8/23.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChatHistroyViewController: LFBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var msgList = [Message]()

    var chatTableView: UITableView!

    let fitBlank: CGFloat = 15

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavTitle("聊天记录")
        self.view.backgroundColor = UIColor.white

        // 聊天界面
        chatTableView = UITableView()
        chatTableView.backgroundColor = UIColor.clear
        // 自动布局
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.estimatedRowHeight = 110
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = UIColor("#F7F5F9")
        // 让列表最后一条消息和底部工具栏有一定距离
        chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: fitBlank, right: 0)
        chatTableView.separatorStyle = .none
        chatTableView.register(ChatBaseCell.self, forCellReuseIdentifier: "chat")
        chatTableView.register(ChatNoMoreCell.self, forCellReuseIdentifier: "cell")
        chatTableView.frame = chatTableViewFrame()
        self.view.addSubview(chatTableView)
        
        user_getChatHistory().drive(onNext: {[weak self] (data) in
            if let strongSelf = self {
                strongSelf.msgList = data
                strongSelf.chatTableView.reloadData()
                strongSelf.chatTableView.layoutIfNeeded()
                strongSelf.chatTableView.scrollToRow(at: IndexPath(row: strongSelf.msgList.count, section: 0), at: .bottom, animated: false)
            }
        }).disposed(by: dig)
    }
    
    func chatTableViewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - LFTool.Height_HomeBar() - LFTool.Height_NavBar())
    }
    
    // MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count == 0 ? 0 : msgList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            
            return cell
        }
        let cell = ChatTextCell(style: .default, reuseIdentifier: "chat")
        let message = msgList[indexPath.row - 1]
        cell.setUpWithModel(message: message)
        
        cell.cellChange = {[weak cell] in
            cell?.setNeedsLayout()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    
    func user_getChatHistory() -> Driver<[Message]> {
        
        return Observable<[Message]>.create({ (ob) -> Disposable in
            let x = apiRequsetArray(Api.user_getChatHistory).asObservable().subscribe(onNext: { (model) in
                if model.code == 0 {
                    var msgList: [Message] = []
                    if let m = BF_ChatModel.deserialize(from: ["data" : model.data]) {
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
    
}
