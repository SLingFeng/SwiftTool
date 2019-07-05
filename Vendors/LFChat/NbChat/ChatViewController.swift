//
//  ViewController.swift
//  NbChatView-swift
//
//  Created by xiuxiong ding on 2017/4/19.
//  Copyright © 2017年 xiuxiongding. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift



enum AnimateType {
    case animate1 // 键盘弹出的话不会遮挡消息
    case animate2 // 键盘弹出的话会遮挡消息，但最后一条消息距离输入框有一段距离
    case animate3 // 最后一条消息距离输入框在小范围内，这里设为 2 * fitBlank = 30
}

class ChatViewController: LFBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, LFSocketDelegate {
    
    let toolBarHeight: CGFloat = 56
    let fitBlank: CGFloat = 15
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    var chatTableView: UITableView!
    var toolBarView: ToolBarView!
    
    var msgList = [Message]()
    
    var mUserInfo: Dictionary<AnyHashable, Any>!
    var mKeyBoardAnimateDuration: Double = 0.5
    var mKeyBoardHeight: CGFloat = LFTool.Height_HomeBar()
    
    var fisrtLoad = true
    var animateType = AnimateType.animate1 {
        didSet {
            LFLog(animateType)
        }
    }
    var lastDifY: CGFloat = 0
    var animateOption: UIView.AnimationOptions = []
    var oldOffsetY: CGFloat = 0
    var isKeyboardShowed = false

    let socket = LFSocket.shared
    
    let selImgSubject = PublishSubject<UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.addDelegate(self)
        
        self.view.backgroundColor = UIColor.white
        
        // 消除tableview的留白
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 标题
        self.setNavTitle("聊天广场")
        
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
        // 点击列表使键盘消失
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(tapRemoveBottomView(recognizer:)))
        chatTableView.addGestureRecognizer(removeKeyBoardTap)
        self.view.addSubview(chatTableView)
        
        // 底部工具栏界面
        toolBarView = ToolBarView()
        toolBarView.textView.delegate = self
        self.view.addSubview(toolBarView)
        
        // 添加约束
        toolBarView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(toolBarHeight)
            make.bottom.equalTo(-LFTool.Height_HomeBar())
        }
        
        chatTableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(toolBarView.snp.top)
            make.top.equalTo(0)
        }
        
        oldOffsetY = chatTableView.contentOffset.y
        
        toolBarView.imageBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.showSheet()
            }
        }).disposed(by: dig)
        
        selImgSubject.subscribe(onNext: {[weak self] (img) in
            if let strongSelf = self {
//                let second =  MessageItem(image:img,user:strongSelf.me, date:Date(), mtype:.mine)
//                strongSelf.Chats.append(second)
//                strongSelf.reloadTableView()
            }
        }).disposed(by: dig)
        
        socket.send(["type" : "login", "client_name" : GVUserDefaults.standard().nick_name, "room_id" : "1", "token" : Environment().token!])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyBoard()
        chatTableView.reloadData()
        animateType = .animate1
        lastDifY = 0
        NotificationCenter.default.removeObserver(self)
        socket.removeDelegate(self)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socket.addDelegate(self)

        // 添加键盘弹出消失监听
        if fisrtLoad {
            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        fisrtLoad = false
    }
    
    // MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatTextCell(style: .default, reuseIdentifier: "chat")
        let message = msgList[indexPath.row]
        cell.setUpWithModel(message: message)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > oldOffsetY {
            // 向上滑动
        } else if scrollView.contentOffset.y < oldOffsetY {
            // 向下滑动
//            if isKeyboardShowed {
//                hideKeyboard()
//            }
        }
        
        oldOffsetY = scrollView.contentOffset.y
    }
    
    // MARK: textViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let msgText = textView.text.trimmingCharacters(in: .whitespaces)

            if msgText.lengthOfBytes(using: .utf8) == 0 {
                return true
            }
//            if text != "" && text != "\n" {
//                return true
//            }
//            if text == "\n" {
//                return false
//            }
            //            let messageOut = Message(incoming: false, text: msgText, avatar: "newbeeee")
            //            msgList.append(messageOut)
            //            let messageIn = Message(incoming: true, text: msgText, avatar: "chris")
            //            msgList.append(messageIn)
            socket.send(["type" : "say", "from_client_id" : socket.model.client_id, "to_client_id" : "all/client_id", "content" : textView.text!])
            textView.text = ""
            return false
        }
        
        return true
    }
    
    // MARK: private
    @objc func keyBoardWillShow(notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        mUserInfo = userInfo
        let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyBoardRect = value.cgRectValue
        // 得到键盘高度
        let keyBoardHeight = keyBoardRect.size.height
        mKeyBoardHeight = LFTool.isIPHONEXLAST() ? (keyBoardHeight - LFTool.Height_HomeBar()) : keyBoardHeight
        
        // 得到键盘弹出所需时间
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        mKeyBoardAnimateDuration = duration.doubleValue
        showKeyboard()
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        mUserInfo = userInfo
        let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyBoardRect = value.cgRectValue
        // 得到键盘高度
        let keyBoardHeight = keyBoardRect.size.height
        mKeyBoardHeight = LFTool.isIPHONEXLAST() ? (keyBoardHeight - LFTool.Height_HomeBar()) : keyBoardHeight
        // 得到键盘弹出所需时间
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        mKeyBoardAnimateDuration = duration.doubleValue
        
        hideKeyboard()
    }
    
    func showKeyboard() {
        var animate: (()->Void) = {
            self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
        }
        
        
        if msgList.count > 0 {
            let lastIndex = IndexPath(row: msgList.count - 1, section: 0)
            let rectCellView = chatTableView.rectForRow(at: lastIndex)
            let rect = chatTableView.convert(rectCellView, to: chatTableView.superview)
            let cellDistance = rect.origin.y + rect.height
            let distance1 = SCREEN_HEIGHT - toolBarHeight - mKeyBoardHeight - LFTool.Height_NavBar()
            let distance2 = SCREEN_HEIGHT - toolBarHeight - 2 * fitBlank
            let difY = cellDistance - distance1
            
            if cellDistance <= distance1 {
                animate = {
                    self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                }
                animateType = .animate1
            } else if distance1 < cellDistance && cellDistance <= distance2 {
                animate = {
                    self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                    self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -difY)
                    self.lastDifY = difY
                }
                animateType = .animate2
            } else {
                animate = {
                    self.self.view.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                }
                animateType = .animate3
            }
        }
        let options = UIView.AnimationOptions(rawValue: UInt((mUserInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        animateOption = options
        
        UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: options, animations: animate) { (isFinished) in
            self.oldOffsetY = self.chatTableView.contentOffset.y
            self.isKeyboardShowed = true
        }
    }
    
    func hideKeyboard() {
        
        if toolBarView.textView.isFirstResponder {
            toolBarView.textView.resignFirstResponder()
            
            let options = UIView.AnimationOptions(rawValue: UInt((mUserInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            var animate: (() -> Void) = {
                
            }
            
            // 返回 view 或 toolBarView 或 chatTableView 到原有状态
            switch animateType {
            case .animate1:
                animate = {
                    self.toolBarView.transform = CGAffineTransform.identity
                    self.chatTableView.transform = CGAffineTransform.identity
                }
            case .animate2:
                animate = {
                    self.toolBarView.transform = CGAffineTransform.identity
                    self.chatTableView.transform = CGAffineTransform.identity
                }
            case .animate3:
                animate = {
                    self.self.view.transform = CGAffineTransform.identity
                }
            }
            
            UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: options, animations: animate, completion: { (finish) in
                self.scrollToBottom()
                self.oldOffsetY = self.chatTableView.contentOffset.y
                self.isKeyboardShowed = false
            })
        }
    }
    
    // 刷新列表
    func reloadTableView(animated: Bool = true) {
        chatTableView.reloadData()
        chatTableView.layoutIfNeeded()
        
        // 得到最后一条消息在view中的位置
        let lastIndex = IndexPath(row: msgList.count - 1, section: 0)
        let rectCellView = chatTableView.rectForRow(at: lastIndex)
        let rect = chatTableView.convert(rectCellView, to: chatTableView.superview)
        let cellDistance = rect.origin.y + rect.height
        let distance1 = SCREEN_HEIGHT - toolBarHeight - mKeyBoardHeight - LFTool.Height_HomeBar() - LFTool.Height_NavBar()
        
        // 计算键盘可能遮住的消息的长度
        let difY = cellDistance - distance1
        
        LFLog("lastDifY:\(lastDifY)-difY:\(difY)-cellDistance:\(cellDistance)-distance1:\(distance1)-to:\(lastDifY + difY)")
        
        if animateType == .animate3 {
            // 处于情况三时，由于之前的约束（聊天界面在输入栏上方），并且
            // 是整个界面一起上滑，所以约束依旧成立，只需把聊天界面最后
            // 一条消息滚动到聊天界面底部即可
            scrollToBottom()
        } else if (animateType == .animate1 || animateType == .animate2) && difY > 0{
            // 在情况一和情况二中，如果聊天界面上滑的总距离小于键盘高度，则可以继续上滑
            // 一旦聊天界面上滑的总距离 lastDifY + difY 将要超过键盘高度，则上滑总距离设为键盘高度
            // 此时执行 trans 动画
            // 一旦聊天界面上滑总距离为键盘高度，则变为情况三的情况，把聊天界面最后
            // 一条消息滚动到聊天界面底部即可
            if lastDifY + difY < mKeyBoardHeight {
                lastDifY += difY
                let animate: (()->Void) = {
                    self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.lastDifY)
                }
                UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
                
            } else if lastDifY + difY > mKeyBoardHeight {
                if lastDifY != mKeyBoardHeight {
                     let animate: (()->Void) = {
                        self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                    }
                    UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
                    lastDifY = mKeyBoardHeight
                }
                scrollToBottom(animated: animated)
            }
        }
        LFLog("end lastDifY:\(lastDifY)")
    }
    
    // 滚动最后一条消息到列表界面底部
    func scrollToBottom(animated: Bool = true) {
        if msgList.count > 0 {
            chatTableView.scrollToRow(at: IndexPath(row: msgList.count - 1, section: 0), at: .bottom, animated: animated)
        }
    }
    
    // 清空消息
    @objc func clearMessage() {
        removeKeyBoard()
        msgList.removeAll()
        chatTableView.reloadData()
        animateType = .animate1
        lastDifY = 0
    }
    
    // 点击消息列表键盘消失
    @objc func tapRemoveBottomView(recognizer: UITapGestureRecognizer) {
        removeKeyBoard()
    }
    
    // 键盘消失
    func removeKeyBoard() {
        if toolBarView.textView.isFirstResponder {
            toolBarView.textView.resignFirstResponder()
            toolBarView.transform = CGAffineTransform.identity
        }

    }
    
    //MARK: socket
    func lfSocketDidReceiveMessage(_ message: Any?) {
        //        LFLog(message)
        
        if let data = message as? NSDictionary {
            //{"code":0,"msg":"connected","data":{"client_id":"7f0000010fa000000001"}}//自己登录
            let my = data["msg"] as? String
            if my == "connected" {
                let id = (data["data"] as! NSDictionary)["client_id"] as! String
                socket.model.client_id = id
            }
            //{"type":"login","client_id":"7f0000010fa700000002","client_name":"ch","time":"2019-07-03 18:25:20","client_list":{"7f0000010fa600000001":"ch","7f0000010fa600000002":"lf","7f0000010fa700000002":"ch"}}
            if let type = data["type"] as? String {
                
                switch type {
                case "ping":
                    //                    socket.send(["type":"pong"])
                    return
                case "login":
                    let id = data["client_id"] as! String
                    LFLog("login id \(id)")
                    socket.model.client_id = id
                case "say":
                    //                    {"type":"say","from_client_id":"7f0000010fa100000001","from_client_name":"lyl123456","to_client_id":"all","content":"\u5404\u4f4d\u597d","time":"2019-07-04 09:47:02"}
                    let from_client_id = data["from_client_id"] as! String
                    let name = (data["from_client_name"] as? String) ?? ""
                    let text = (data["content"] as? String) ?? ""
                    let time = (data["time"] as? String) ?? ""
                    let who = from_client_id == socket.model.client_id ? false : true
                    //                    LFLog("sayid \(from_client_id)")
                    let m = Message(incoming: who, text: text, avatar: GVUserDefaults.standard().image_path, name: name)
                    m.time = time
                    msgList.append(m)
                    reloadTableView()
                    
                case "history":
                    if let m = BF_ChatModel.deserialize(from: data) {
                        m.data.forEach { (model) in
                            let who = model.from_user_id == GVUserDefaults.standard().uid ? false : true
                            
                            let m = Message(incoming: who, text: model.content, avatar: model.image_path, name: model.nick_name)
                            m.time = SLFCommonTools.timestamp(Double(model.create_time) ?? 0, formart: "YYYY-dd-MM hh:mm:ss")
                            msgList.insert(m, at: 0)
                        }
                    }
                    reloadTableView(animated: false)
                    
                default:
                    break
                }
                
            }
            
            
        }
        
        
        
        
    }
    
    func lfSocketDidFailWithError(_ error: Error?) {
        //        LFLog(error)
    }
    
    //MARK: - 图片
    func showSheet() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "拍照", style: .default) { [weak self](_) in
                if let strongSelf = self {
                    UIImagePickerController.rx.createWithParent(strongSelf) { picker in
                        picker.sourceType = .photoLibrary
                        //picker.allowsEditing = true
                        }
                        .flatMap { $0.rx.didFinishPickingMediaWithInfo }.map { info -> UIImage in
                            let img = info["UIImagePickerControllerOriginalImage"] as! UIImage
                            return img
                        }
                        .subscribe(onNext: { (img) in
                            if let strongSelf = self {
                                strongSelf.selImgSubject.onNext(img)
                            }
                        }).disposed(by: strongSelf.dig)
                }
            })
            
        }
        
        ac.addAction(UIAlertAction(title: "从手机相册选", style: .default) { [weak self](_) in
            if let strongSelf = self {
                UIImagePickerController.rx.createWithParent(strongSelf) { picker in
                    picker.sourceType = .photoLibrary
                    //                picker.allowsEditing = true
                    }
                    .flatMap { $0.rx.didFinishPickingMediaWithInfo }.map { info -> UIImage in
                        let img = info["UIImagePickerControllerOriginalImage"] as! UIImage
                        return img
                    }
                    .subscribe(onNext: { (img) in
                        if let strongSelf = self {
                            strongSelf.selImgSubject.onNext(img)
                        }
                    }).disposed(by: strongSelf.dig)
                //                    .bind(to: strongSelf.selImgSubject)
                //                    .disposed(by: strongSelf.dig)
            }
        })
        
        ac.addAction(UIAlertAction(title: "取消", style: .cancel) { (_) in
            
        })
        self.present(ac, animated: true) {
            
        }
    }
    
}

