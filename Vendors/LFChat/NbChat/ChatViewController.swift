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
import HandyJSON


enum AnimateType {
    case animate1 // 键盘弹出的话不会遮挡消息
    case animate2 // 键盘弹出的话会遮挡消息，但最后一条消息距离输入框有一段距离
    case animate3 // 最后一条消息距离输入框在小范围内，这里设为 2 * fitBlank = 30
}

class ChatViewController: LFBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, LFSocketDelegate, PPStickerInputViewDelegate {
//
    let toolBarHeight: CGFloat = 56
    let fitBlank: CGFloat = 15
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    var chatTableView: UITableView!
    var toolBarView: PPStickerInputView!//ToolBarView!
    
    var msgList = [Message]()
    
    var mUserInfo: Dictionary<AnyHashable, Any>!
    var mKeyBoardAnimateDuration: Double = 0.5
    var mKeyBoardHeight: CGFloat = 0
    
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
    var isEmojiKeyboardShowed = false

    let socket = LFSocket.shared
    
    let selImgSubject = PublishSubject<UIImage>()
    
    //聊天图片上传
    let chatVM = CT_VerifiedVM()
    
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
        toolBarView = PPStickerInputView()
        toolBarView.textView.delegate = self
        toolBarView.delegate = self
        self.view.addSubview(toolBarView)
        
        // 添加约束
//        toolBarView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view.snp.left)
//            make.right.equalTo(self.view.snp.right)
//            make.height.equalTo(toolBarHeight)
//            make.bottom.equalTo(-LFTool.Height_HomeBar())
//        }
//
//        chatTableView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view.snp.left)
//            make.right.equalTo(self.view.snp.right)
//            make.bottom.equalTo(toolBarView.snp.top)
//            make.top.equalTo(0)
//        }
        toolBarView.frame = toolBarViewFrame()
        chatTableView.frame = chatTableViewFrame()
        
        oldOffsetY = chatTableView.contentOffset.y
        
        
        toolBarView.imageBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
//                strongSelf.toolBarView.textView.resignFirstResponder()
//                strongSelf.view.endEditing(true)
//                strongSelf.hideKeyboard()
                strongSelf.showSheet()
            }
        }).disposed(by: dig)
        
        toolBarView.sendBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                if !strongSelf.toolBarView.textView.text.empty() {
//                    let s = NSAttributedString(string: strongSelf.toolBarView.textView.text!)
                    let m = LFSocketSendModel()
                    m.type = "say"
                    m.from_client_id = strongSelf.socket.model.client_id
                    m.content = strongSelf.toolBarView.textView.text
                    strongSelf.socket.send(m)

//                    strongSelf.socket.send(["type" : "say", "from_client_id" : strongSelf.socket.model.client_id, "to_client_id" : "all/client_id", "content" : s])
                    strongSelf.toolBarView.textView.text = ""
                }
            }
        }).disposed(by: dig)
        
        selImgSubject.subscribe(onNext: {[weak self] (img) in
            if let strongSelf = self {
                CT_VerifiedVM.upLoadImgMsg(api: Api.user_uploadImg(img: strongSelf.chatVM.chatImage!, name: "chatImage")).subscribe(onNext: { (str) in
                    
//                }, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
                    if let strongSelf = self {
                        if !str.empty() {
//                            strongSelf.socket.send(["type" : "say", "from_client_id" : strongSelf.socket.model.client_id, "to_client_id" : "all/client_id", "pic" : str, "content" : "", "face" : ""])
                            let m = LFSocketSendModel()
                            m.type = "say"
                            m.from_client_id = strongSelf.socket.model.client_id
                            m.pic = str
                            strongSelf.socket.send(m)
                        }
                    }
                }).disposed(by: strongSelf.dig)
                
//                let m = Message(incoming: false, image: img, avatar: GVUserDefaults.standard().image_path, name: GVUserDefaults.standard().nick_name)
//                strongSelf.msgList.append(m)
//                strongSelf.reloadTableView()
//                let second =  MessageItem(image:img,user:strongSelf.me, date:Date(), mtype:.mine)
//                strongSelf.Chats.append(second)
//                strongSelf.reloadTableView()
            }
        }).disposed(by: dig)
        
        socket.initSocket()
        
        let m = LFSocketSendModel()
        m.type = "login"
        m.from_client_id = socket.model.client_id
        m.token = Environment().token!
        m.client_name = GVUserDefaults.standard().nick_name
        socket.send(m)
//        socket.send(["type" : "login", "client_name" : GVUserDefaults.standard().nick_name, "room_id" : "1", "token" : Environment().token!])
    }
    
    func toolBarViewFrame() -> CGRect {
        return CGRect(x: 0, y: kScreenH - LFTool.Height_HomeBar() - toolBarHeight - LFTool.Height_NavBar(), width: kScreenW, height: toolBarHeight)
    }
    
    func chatTableViewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - LFTool.Height_HomeBar() - toolBarHeight - LFTool.Height_NavBar())
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let v = UIApplication.shared.keyWindow?.viewWithTag(8901)
        v?.isHidden = true
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let v = UIApplication.shared.keyWindow?.viewWithTag(8901)
        v?.isHidden = false
    }
    
    deinit {
        socket.disConnect(type: .disConnectByUser)
    }
    
    // MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatTextCell(style: .default, reuseIdentifier: "chat")
        let message = msgList[indexPath.row]
        cell.setUpWithModel(message: message)
        
        cell.cellChange = {[weak cell] in
            cell?.setNeedsLayout()
//            tableView.visibleCells.forEach({ (tc) in
//                if tc == cell {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            })
            
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView .cellHeight(for: indexPath, cellContentViewWidth: kScreenW, tableView: tableView)
//    }
    
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
//                        toolBarView.sendBtn.isEnabled = true
            let m = LFSocketSendModel()
            m.type = "say"
            m.from_client_id = socket.model.client_id
            m.content = textView.text
//            socket.send(["type" : "say", "from_client_id" : socket.model.client_id, "to_client_id" : "all/client_id", "content" : textView.text!])
            socket.send(m)
            textView.text = ""

            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.empty() {
//            toolBarView.sendBtn.isEnabled = true
            toolBarView.sendBtn.alpha = 0.5
        }else {
//            toolBarView.sendBtn.isEnabled = false
            toolBarView.sendBtn.alpha = 1
        }
    }
    //MARK:
    func stickerInputViewDidClickEmoji(_ emojiStr: String!, inputView: PPStickerInputView!) {
        if emojiStr.empty() {
            return
        }
//        socket.send(["type" : "say", "from_client_id" : socket.model.client_id, "to_client_id" : "all/client_id", "content" : emojiStr])
        let m = LFSocketSendModel()
        m.type = "say"
        m.from_client_id = socket.model.client_id
        m.face = emojiStr
        socket.send(m)
        inputView.textView.text = ""
    }
    func stickerInputViewDidClickSendButton(_ inputView: PPStickerInputView!) {

        let text = inputView.plainText
        if text?.count == 0 {
//            toolBarView.sendBtn.isEnabled = true
            toolBarView.sendBtn.alpha = 0.5
            return
        }
//        toolBarView.sendBtn.isEnabled = false
        toolBarView.sendBtn.alpha = 1
        
//        let s = NSAttributedString(string: text!)
//        LFLog(s)
//        socket.send(["type" : "say", "from_client_id" : socket.model.client_id, "to_client_id" : "all/client_id", "content" : text!])
        let m = LFSocketSendModel()
        m.type = "say"
        m.from_client_id = socket.model.client_id
        m.face = text!
        socket.send(m)
        inputView.textView.text = ""
    }
    
    func stickerInputViewDidChange(_ inputView: PPStickerInputView!) {
        LFLog(inputView.textView.inputView)
        
        isEmojiKeyboardShowed = true
        
        let keyBoardHeight = inputView.textView.inputView?.size.height ?? 0
        mKeyBoardHeight = keyBoardHeight - LFTool.Height_HomeBar()
        inputView.textView.becomeFirstResponder()
        // 得到键盘高度
        
//        let keyBoardHeight = inputView.frame.size.height - 56
//        mKeyBoardHeight = (keyBoardHeight - LFTool.Height_HomeBar())
//
//        showKeyboard()
    }
    
    // MARK: private
    @objc func keyBoardWillShow(notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        mUserInfo = userInfo
        let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyBoardRect = value.cgRectValue
        // 得到键盘高度
        let keyBoardHeight = keyBoardRect.size.height
        mKeyBoardHeight = keyBoardHeight
        
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
        mKeyBoardHeight = keyBoardHeight - LFTool.Height_HomeBar()
        // 得到键盘弹出所需时间
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        mKeyBoardAnimateDuration = duration.doubleValue
        
        hideKeyboard()
    }
    
    func showKeyboard() {
        
//        var selfFrame = self.view.frame
//        let textViewHeight = isEmojiKeyboardShowed ? self.toolBarView.heightThatFits() : mKeyBoardHeight
        
        var animate: (()->Void) = {
//            self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
        }
        
        
        if msgList.count > 0 {
            let lastIndex = IndexPath(row: msgList.count - 1, section: 0)
            let rectCellView = chatTableView.rectForRow(at: lastIndex)
            let rect = self.view.convert(rectCellView, to: chatTableView.superview)
            let cellDistance = rect.origin.y + rect.height
            let distance1 = SCREEN_HEIGHT - mKeyBoardHeight - LFTool.Height_HomeBar()
            let distance2 = SCREEN_HEIGHT - toolBarHeight - 2 * fitBlank
            let difY = cellDistance - distance1
            
//            NSLog("showKeyboard:%f--", self.view.transform.ty)
            
//            selfFrame.size.height = distance1
            
            if cellDistance <= distance1 {
                animate = {
//                    self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                    var r = self.toolBarView.frame
                    r.origin.y = kScreenH - self.mKeyBoardHeight
                    self.toolBarView.frame = r
                }
                animateType = .animate1
            } else if distance1 < cellDistance && cellDistance <= distance2 {
                animate = {
//                    self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                    var r = self.toolBarView.frame
                    r.origin.y = kScreenH - self.mKeyBoardHeight
                    self.toolBarView.frame = r
//                    self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -difY)
                    var r1 = self.chatTableView.frame
                    r1.size.height = self.chatTableViewFrame().size.height - difY
                    self.chatTableView.frame = r1
                    
                    self.lastDifY = difY
                }
                animateType = .animate2
            } else {
                animate = {
//                    self.view.transform = CGAffineTransform.identity
//                    self.view.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                    var r = self.view.frame
                    r.size.height = kScreenH - LFTool.Height_NavBar() - self.mKeyBoardHeight
                    self.view.frame = r
//                    self.view.frame = selfFrame
                }
                animateType = .animate3
            }
        }
        let options = UIView.AnimationOptions(rawValue: UInt((mUserInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber ?? 0).intValue << 16))
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
            
            let animate: (() -> Void) = {
                self.toolBarView.frame = CGRect(x: 0, y: kScreenH - LFTool.Height_HomeBar() - self.toolBarHeight, width: kScreenW, height: self.toolBarHeight)//self.toolBarViewFrame()
                self.chatTableView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - LFTool.Height_HomeBar() - self.toolBarHeight)//self.chatTableViewFrame()
                self.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
            }
            NSLog("hideKeyboard:%@--", self.toolBarView)
            // 返回 view 或 toolBarView 或 chatTableView 到原有状态
//            switch animateType {
//            case .animate1: break
////                animate = {
//////                    self.toolBarView.transform = CGAffineTransform.identity
//////                    self.chatTableView.transform = CGAffineTransform.identity
////                    self.toolBarView.frame = self.toolBarViewFrame()
////                    self.chatTableView.frame = self.chatTableViewFrame()
////                }
//            case .animate2: break
////                animate = {
////                    self.toolBarView.transform = CGAffineTransform.identity
////                    self.chatTableView.transform = CGAffineTransform.identity
////                }
//            case .animate3:
//                animate = {
////                    self.view.transform = CGAffineTransform.identity
//                    self.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
//                }
////                break
//            }
            
            UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: options, animations: animate, completion: { (finish) in
                if finish {
                    self.scrollToBottom()
                    self.oldOffsetY = self.chatTableView.contentOffset.y
                    self.isKeyboardShowed = false
                }
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
//                    self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.lastDifY)
                    var r1 = self.chatTableView.frame
                    r1.size.height = self.chatTableViewFrame().size.height - self.lastDifY
                    self.chatTableView.frame = r1
                }
                UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
                
            } else if lastDifY + difY > mKeyBoardHeight {
                if lastDifY != mKeyBoardHeight {
                     let animate: (()->Void) = {
//                        self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
//                        var r1 = self.chatTableView.frame
//                        r1.size.height = kScreenH - self.toolBarHeight - self.mKeyBoardHeight
//                        self.chatTableView.frame = r1
                    }
                    UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
                    lastDifY = mKeyBoardHeight
                }
                scrollToBottom(animated: animated)
            }
        }
//        LFLog("end lastDifY:\(lastDifY)")
    }
    
    // 滚动最后一条消息到列表界面底部
    func scrollToBottom(animated: Bool = true) {
        if msgList.count > 0 {
//            CATransaction.begin() // 1
//            CATransaction.setDisableActions(true) // 2 关闭layer隐式动画

            chatTableView.scrollToRow(at: IndexPath(row: msgList.count - 1, section: 0), at: .bottom, animated: animated)
            
//            CATransaction.commit() // 3
        }
    }
    
    // 清空消息
//    @objc func clearMessage() {
//        removeKeyBoard()
//        msgList.removeAll()
//        chatTableView.reloadData()
//        animateType = .animate1
//        lastDifY = 0
//    }
    
    // 点击消息列表键盘消失
    @objc func tapRemoveBottomView(recognizer: UITapGestureRecognizer) {
        removeKeyBoard()
    }
    
    // 键盘消失
    func removeKeyBoard() {
        if toolBarView.textView.isFirstResponder {
            toolBarView.textView.resignFirstResponder()
//            toolBarView.transform = CGAffineTransform.identity
            self.toolBarView.frame = self.toolBarViewFrame()
            self.chatTableView.frame = self.chatTableViewFrame()
        }

    }
    
    //MARK: socket
    func lfSocketDidReceiveMessage(_ message: Any?) {
        //        LFLog(message)
        
        
        if let data = message as? NSDictionary {
            if let model = BF_ChatDataModel.deserialize(from: data) {
                switch model.type {
                case "ping":
                    //socket.send(["type":"pong"])
                    return
                case "connect":
                    let id = data["client_id"] as! String
                    LFLog("login id \(id)")
                    socket.model.client_id = id
                    
                    //                case "login":
                    //                    let id = data["client_id"] as! String
                    //                    LFLog("login id \(id)")
                //                    socket.model.client_id = id
                case "say":
                    //                    {"type":"say","from_client_id":"7f0000010fa100000001","from_client_name":"lyl123456","to_client_id":"all","content":"\u5404\u4f4d\u597d","time":"2019-07-04 09:47:02"}
//                    let from_client_id = data["from_client_id"] as! String
//                    let name = (data["from_client_name"] as? String) ?? ""
//                    let text = (data["content"] as? String) ?? ""
//                    let time = (data["time"] as? String) ?? ""
                    let who = model.from_client_id == socket.model.client_id ? false : true
//                    let userImage = model.from_client_id == socket.model.client_id ? GVUserDefaults.standard().image_path : model
                    //                    LFLog("sayid \(from_client_id)")
                    var m: Message?
                    if !model.content.empty() {
                        //内容
                        m = Message(incoming: who, text: model.content, avatar: model.image_path, name: model.nick_name)
                    }
                    if !model.face.empty() {
                        //内容
                        m = Message(incoming: who, text: model.face, avatar: model.image_path, name: model.nick_name)
                    }
                    if !model.pic.empty() {
                        //内容
                        
                        m = Message(incoming: who, imageUrl: URL(string: model.pic), avatar: model.image_path, name: model.nick_name)
                    }
                    if m != nil {
                        m!.time = model.time
                        msgList.append(m!)
                        reloadTableView()
                    }
                    
                    //                    {"type":"say","from_client_id":"7f0000010fa200000008","from_client_name":"lyl123456","to_client_id":"all","nick_name":"\u5bd3\u610f\u6df1\u957f\u7684\u540d\u5b57","image_path":"http:\/\/cs.flyv888.com\/upload\/20190720\/be6d9cf9a026ca086269203a00664d08.png","content":"","face":"","pic":"http:\/\/cs.flyv888.com\/upload\/20190720\/d7865df701f75a4a777720058f5bb018.jpg","time":"2019-07-20 16:22:26"}
                    
                case "history":
                    let x: Array<Any> = (data["data"]) as! Array<Any>
                    if x.count != 0 {
                        if let m = BF_ChatModel.deserialize(from: data) {
                            m.data.forEach { (model) in
                                let who = model.from_user_id == GVUserDefaults.standard().uid ? false : true
                                
//                                let m = Message(incoming: who, text: model.content, avatar: model.image_path, name: model.nick_name)
//                                msgList.insert(m, at: 0)
//                                let who = model.from_client_id == socket.model.client_id ? false : true
                                //                    let userImage = model.from_client_id == socket.model.client_id ? GVUserDefaults.standard().image_path : model
                                //                    LFLog("sayid \(from_client_id)")
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
//                                    msgList.append(message!)
//                                    reloadTableView()
                                }
                            }
                        }
                        reloadTableView(animated: false)
                    }
                default:
                    break
                }
            }
            //{"code":0,"msg":"connected","data":{"client_id":"7f0000010fa000000001"}}//自己登录
//            let my = data["msg"] as? String
//            if my == "connected" {
//                let id = (data["data"] as! NSDictionary)["client_id"] as! String
//                socket.model.client_id = id
//            }
            //{"type":"login","client_id":"7f0000010fa700000002","client_name":"ch","time":"2019-07-03 18:25:20","client_list":{"7f0000010fa600000001":"ch","7f0000010fa600000002":"lf","7f0000010fa700000002":"ch"}}
//            if let type = data["type"] as? String {
//
//
//
//            }
            
            
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
                        picker.sourceType = .camera
                        //picker.allowsEditing = true
                        }
                        .flatMap { $0.rx.didFinishPickingMediaWithInfo }.map { info -> UIImage in
                            let img = info["UIImagePickerControllerOriginalImage"] as! UIImage
                            if let strongSelf = self {
                                strongSelf.chatVM.chatImage = img.jpegData(compressionQuality: 0.1)
                            }
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
                        if let strongSelf = self {
                            strongSelf.chatVM.chatImage = img.jpegData(compressionQuality: 0.5)
                        }
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

//class ChatModel: LFBaseModel {
//    ///Optional()
//    var face : String = ""
//    
//    ///Optional(2019-07-20 16:22:26)
//    var time : String = ""
//    
//    ///Optional(7f0000010fa200000008)
//    var from_client_id : String = ""
//    
//    ///Optional(all)
//    var to_client_id : String = ""
//    
//    ///Optional(say)
//    var type : String = ""
//    
//    ///Optional(http://cs.flyv888.com/upload/20190720/d7865df701f75a4a777720058f5bb018.jpg)
//    var pic : String = ""
//    
//    ///Optional(http://cs.flyv888.com/upload/20190720/be6d9cf9a026ca086269203a00664d08.png)
//    var image_path : String = ""
//    
//    ///Optional()
//    var content : String = ""
//    
//    ///Optional(寓意深长的名字)
//    var nick_name : String = ""
//    
//    ///Optional(lyl123456)
//    var from_client_name : String = ""
//}
