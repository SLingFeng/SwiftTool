//
//  LFChatViewController.swift
//  jsbf
//
//  Created by big on 2019/6/19.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LFChatViewController: LFBaseViewController, ChatDataSource, UITextFieldDelegate, UITextViewDelegate, LFSocketDelegate {
    
    //UITableViewDelegate, UITableViewDataSource
    
    let toolBarHeight: CGFloat = 56
    let fitBlank: CGFloat = 15
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    let me = UserInfo(name:"Xiaoming" ,logo:("xiaoming.png"))

    let socket = LFSocket.shared
    
    enum AnimateType {
        case animate1 // 键盘弹出的话不会遮挡消息
        case animate2 // 键盘弹出的话会遮挡消息，但最后一条消息距离输入框有一段距离
        case animate3 // 最后一条消息距离输入框在小范围内，这里设为 2 * fitBlank = 30
    }
    
    var tableView: TableView!
//    var chatTableView: UITableView!
    var toolBarView: ToolBarView!
    
//    var msgList = [Message]()
    
    var mUserInfo: Dictionary<AnyHashable, Any>!
    var mKeyBoardAnimateDuration: Double!
    var mKeyBoardHeight: CGFloat = LFTool.Height_HomeBar()
    
    var fisrtLoad = true
    var animateType = AnimateType.animate1
    var lastDifY: CGFloat = 0
    var animateOption: UIView.AnimationOptions!
    var oldOffsetY: CGFloat = 0
    var isKeyboardShowed = false
    
    //hangge
    var Chats: [MessageItem] = []

    let selImgSubject = PublishSubject<UIImage>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // 消除tableview的留白
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        // 标题
        self.setNavTitle("聊天广场")
        
        self.tableView = TableView(frame:CGRect.zero, style: .plain)
        self.view.addSubview(tableView)
        self.tableView.chatDataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor("#F7F5F9")
        // 让列表最后一条消息和底部工具栏有一定距离
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: fitBlank, right: 0)
        
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")

        
        // 底部工具栏界面
        toolBarView = ToolBarView()
        toolBarView.textView.delegate = self
//        toolBarView.refreshButton.addTarget(self, action: #selector(clearMessage), for: .touchUpInside)
        self.view.addSubview(toolBarView)
        
        // 添加约束
        toolBarView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(toolBarHeight)
            make.bottom.equalTo(-LFTool.Height_HomeBar())
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(toolBarView.snp.top)
            make.top.equalTo(0)
        }
        
        oldOffsetY = tableView.contentOffset.y
        
        toolBarView.imageBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.showSheet()
            }
        }).disposed(by: dig)
        
        selImgSubject.subscribe(onNext: {[weak self] (img) in
            if let strongSelf = self {
                let second =  MessageItem(image:img,user:strongSelf.me, date:Date(), mtype:.mine)
                strongSelf.Chats.append(second)
                strongSelf.reloadTableView()
            }
        }).disposed(by: dig)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyBoard()
        tableView.reloadData()
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
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row]
    }
    
//    // MARK: tableViewDelegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return msgList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = ChatTextCell(style: .default, reuseIdentifier: "chat")
//        let message = msgList[indexPath.row]
//        cell.setUpWithModel(message: message)
//        return cell
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > oldOffsetY {
            // 向上滑动
        } else if scrollView.contentOffset.y < oldOffsetY {
            // 向下滑动
            if isKeyboardShowed {
                hideKeyboard()
            }
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
            
            let you = UserInfo(name:"Xiaohua", logo:("xiaohua.png"))
//            let messageOut = Message(incoming: false, text: msgText, avatar: "newbeeee")
//            msgList.append(messageOut)
//            let messageIn = Message(incoming: true, text: msgText, avatar: "chris")
//            msgList.append(messageIn)
            let sender = textView
            let thisChat = MessageItem(body:sender.text! as NSString, user:me, date:Date(), mtype:ChatType.mine)
            let thatChat = MessageItem(body:"你说的是：\(sender.text!)" as NSString, user:you, date:Date(), mtype:ChatType.someone)
            
            Chats.append(thisChat)
            Chats.append(thatChat)
            
            reloadTableView()
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
        
        
        if Chats.count > 0 {
            let lastIndex = IndexPath(row: Chats.count, section: 0)
            let rectCellView = tableView.rectForRow(at: lastIndex)
            let rect = tableView.convert(rectCellView, to: tableView.superview)
            let cellDistance = rect.origin.y + rect.height
            let distance1 = SCREEN_HEIGHT - toolBarHeight - mKeyBoardHeight
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
                    self.tableView.transform = CGAffineTransform(translationX: 0, y: -difY)
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
            self.oldOffsetY = self.tableView.contentOffset.y
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
                    self.tableView.transform = CGAffineTransform.identity
                }
            case .animate2:
                animate = {
                    self.toolBarView.transform = CGAffineTransform.identity
                    self.tableView.transform = CGAffineTransform.identity
                }
            case .animate3:
                animate = {
                    self.self.view.transform = CGAffineTransform.identity
                }
            }
            
            UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: options, animations: animate, completion: { (finish) in
                self.scrollToBottom()
                self.oldOffsetY = self.tableView.contentOffset.y
                self.isKeyboardShowed = false
            })
        }
    }
    
    // 刷新列表
    func reloadTableView() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        // 得到最后一条消息在view中的位置
        let lastIndex = IndexPath(row: Chats.count, section: 0)
        let rectCellView = tableView.rectForRow(at: lastIndex)
        let rect = tableView.convert(rectCellView, to: tableView.superview)
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
                    self.tableView.transform = CGAffineTransform(translationX: 0, y: -self.lastDifY)
                }
                UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
                
            } else if lastDifY + difY > mKeyBoardHeight {
                if lastDifY != mKeyBoardHeight {
                    let animate: (()->Void) = {
                        self.tableView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                    }
                    UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
                    lastDifY = mKeyBoardHeight
                }
                scrollToBottom()
            }
        }
        LFLog("end lastDifY:\(lastDifY)")
    }
    
    // 滚动最后一条消息到列表界面底部
    func scrollToBottom() {
        if Chats.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: Chats.count, section: 0), at: .bottom, animated: true)
        }
    }
    
    // 清空消息
    @objc func clearMessage() {
        removeKeyBoard()
        Chats.removeAll()
        tableView.reloadData()
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
        LFLog(message)
    }

    func lfSocketDidFailWithError(_ error: Error?) {
        LFLog(error)
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
    
    deinit {
        LFLog("chat")
    }
}
