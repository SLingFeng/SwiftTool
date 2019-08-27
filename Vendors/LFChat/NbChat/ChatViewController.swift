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
import SocketRocket
import IQKeyboardManager

enum AnimateType {
    case animate1 // 键盘弹出的话不会遮挡消息
    case animate2 // 键盘弹出的话会遮挡消息，但最后一条消息距离输入框有一段距离
    case animate3 // 最后一条消息距离输入框在小范围内，这里设为 2 * fitBlank = 30
    case animate4
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
    
    var atArray = [BF_ChatUserListDataModel]()
    
    var mUserInfo: Dictionary<AnyHashable, Any>!
    var mKeyBoardAnimateDuration: Double = 0.5
    var mKeyBoardHeight: CGFloat = 0
    
    var photoGo = false
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
    
    var currentIsInBottom = true
    
    let socket = LFSocket.shared
    
    let selImgSubject = PublishSubject<UIImage>()
    
    //聊天图片上传
    let chatVM = CT_VerifiedVM()
    
    //截屏
    lazy var snapshotBtn : DragButton = {
        var snapshotBtn = DragButton(frame: CGRect(x: kScreenW - 50, y: kScreenH/2 - 50, width: 50, height: 50))
        snapshotBtn.setImage(UIImage(named: "home_icon_screenshot"), for: .normal)
        snapshotBtn.clickClosure = {
            [weak self]
            (dragBtn) in
            //单击回调
            if let _ = LFExtensionView.snapshotCurrentFullScreen() {
                SLFHUD.showHint("截屏保存到相册")
            }
        }
        snapshotBtn.draggingClosure = {_ in}
        snapshotBtn.dragDoneClosure = {_ in}
        snapshotBtn.autoDockEndClosure = {_ in}
        return snapshotBtn;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.addDelegate(self)
        
//        let b = LFTool.isToDay()
//        if !b {

//        }
        // 添加键盘弹出消失监听
        //        if fisrtLoad {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //        }
        //        fisrtLoad = false
        
        self.view.backgroundColor = UIColor.white
        
        // 消除tableview的留白
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 标题
        self.setNavTitle("聊天广场(1)")
        
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
        chatTableView.register(ChatAnnouncementCell.self, forCellReuseIdentifier: "ChatAnnouncementCell")
        
        // 点击列表使键盘消失
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(tapRemoveBottomView(recognizer:)))
        //        self.view.addGestureRecognizer(removeKeyBoardTap)
        chatTableView.addGestureRecognizer(removeKeyBoardTap)
        self.view.addSubview(chatTableView)
        //        if #available(iOS 11.0, *) {
        //            chatTableView.contentInsetAdjustmentBehavior = .never
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
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
                strongSelf.showSheet()
            }
        }).disposed(by: dig)
        
        toolBarView.sendBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
//                #if DEBUG
//                for i in 1..<501 {
//                    let m = LFSocketSendModel()
//                    m.type = "say"
//                    m.from_client_id = strongSelf.socket.model.client_id
//                    m.content = "\(i)"
//                    strongSelf.socket.send(m)
//                }
//                #endif
                strongSelf.sendSay()
            }
        }).disposed(by: dig)
        
        selImgSubject.subscribe(onNext: {[weak self] (img) in
            if let strongSelf = self {
                CT_VerifiedVM.upLoadImgMsg(api: Api.user_uploadImg(img: strongSelf.chatVM.chatImage!, name: "chatImage")).subscribe(onNext: {[weak self] (str) in
                    if let strongSelf = self {
                        if !str.empty() {
                            let m = LFSocketSendModel()
                            m.type = "say"
                            m.from_client_id = strongSelf.socket.model.client_id
                            m.pic = str
                            strongSelf.socket.send(m)
                        }
                    }
                    }, onError: {[weak self] (e) in
                        self?.photoGo = false
                    }, onCompleted: {[weak self] in
                        self?.photoGo = false
                }).disposed(by: strongSelf.dig)
                
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
        self.view.addSubview(snapshotBtn);
        
        SLFHUD.showLoadingHint("连接中", delay: 30, completion: {[weak self] in
            if self?.socket.socket?.readyState != SRReadyState.CONNECTING && self?.socket.socket?.readyState != SRReadyState.OPEN {
                SLFHUD.showHint("网络出小差了，请耐心等待")
            }
        })
        
        setItem()
        
        ChatVM.user_getChatNotice().drive(onNext: {[weak self] (str) in
            //公告
            if !str.empty() {
                //                _ = CT_MsgView(frame: kScreen, text: str)
                if let strongSelf = self {
                    let m = Message()
                    m.messageType = .announcement
                    m.text = str
                    strongSelf.msgList.insert(m, at: 0)
                    strongSelf.chatTableView.reloadData()
                }
                
            }
        }).disposed(by: dig)
    }
    
    //item
    func setItem() {
        let btn2 = UIButton(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        btn2.setImage(UIImage(named: "chat_icon_jilu"), for: .normal)
        btn2.titleLabel?.font = .systemFont(ofSize: LFTool.scale(num: 16))
        btn2.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        
        let btn3 = UIButton(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        btn3.setImage(UIImage(named: "chat_icon_people"), for: .normal)
        btn3.titleLabel?.font = .systemFont(ofSize: LFTool.scale(num: 16))
        btn3.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btn3), UIBarButtonItem(customView: btn2)]
        
        btn3.rx.tap.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.photoGo = true
                strongSelf.navigationController?.pushViewController(ChatGroupPeopleViewController(), animated: true)
            }
        }).disposed(by: dig)
        
        btn2.rx.tap.subscribe(onNext: {[weak self] (_) in
            if let strongSelf = self {
                strongSelf.photoGo = true
                strongSelf.navigationController?.pushViewController(ChatHistroyViewController(), animated: true)
            }
        }).disposed(by: dig)
        
        
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
        
        if !photoGo {
            //销毁
            socket.removeDelegate(self)
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socket.addDelegate(self)

        if photoGo {
            snapshotBtn.isHidden = true
        }
        //        // 添加键盘弹出消失监听
        //        if fisrtLoad {
        //            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //        }
        //        fisrtLoad = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let v = UIApplication.shared.keyWindow?.viewWithTag(8901)
        v?.isHidden = true
        
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        photoGo = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let v = UIApplication.shared.keyWindow?.viewWithTag(8901)
        v?.isHidden = photoGo
        
    }
    
    override func loadView() {
        super.loadView()
        IQKeyboardManager.shared().isEnabled = false
        
    }
    
    deinit {
        IQKeyboardManager.shared().isEnabled = true
        
        socket.disConnect(type: .disConnectByUser)
        
    }
    
    // MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count == 0 ? 0 : msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//
//            return cell
//        }
        let message = msgList[indexPath.row]

        if message.messageType == .announcement {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAnnouncementCell") as! ChatAnnouncementCell
            
            cell.subLabel.text = message.text
            
            return cell
        }
        
        let cell = ChatTextCell(style: .default, reuseIdentifier: "chat")
        cell.setUpWithModel(message: message)
        
//        cell.cellChange = {[weak cell] in
//            cell?.setNeedsLayout()
//            //            tableView.visibleCells.forEach({ (tc) in
//            //                if tc == cell {
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//            //                }
//            //            })
//
//        }
        return cell
    }
    
    func sendSay() {
        if !toolBarView.plainText.empty() {
            let m = LFSocketSendModel()
            m.type = "say"
            m.from_client_id = socket.model.client_id
            m.content = toolBarView.plainText
            
            if atArray.count > 0 {
                atArray.forEach { (at) in
                    m.at_user += m.at_user.empty() ? at.client_id : (at.client_id + ",")
                }
            }
            
            socket.send(m)
            
            toolBarView.textView.text = ""
            atArray.removeAll()
            self.currentIsInBottom = true
        }
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
        
        let height = scrollView.frame.size.height;
        let contentOffsetY = scrollView.contentOffset.y;
        let bottomOffset = scrollView.contentSize.height - contentOffsetY;
        if (bottomOffset <= height) {
            //在最底部
            self.currentIsInBottom = true;
        }else {
            self.currentIsInBottom = false;
        }
        
    }
    
    // MARK: textViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "@" && photoGo {
            return false
        }
        
        if text == "@" && photoGo == false {
            photoGo = true
            hideKeyboard()
            
            var indexx = toolBarView.textView.text.count

            if toolBarView.textView.isFirstResponder {
                indexx = toolBarView.textView.selectedRange.location + toolBarView.textView.selectedRange.length
                toolBarView.textView.resignFirstResponder()
            }
            
            let vc = ChatGroupPeopleSearchViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.seletItem = {[weak self] m in
                LFLog(m)
                if let strongSelf = self {
                    let textView = strongSelf.toolBarView.textView
                    let insertStr = String(format: "@%@ ", m.nick_name)
                    let str = NSMutableString(string: textView!.text)
                    str.insert(insertStr, at: indexx)
                    textView!.text = str as String
                    textView!.selectedRange = NSMakeRange(indexx + insertStr.count, 0)
                    strongSelf.atArray.append(m)
                }
                
            }
            return false
        }
        
        if (text == "") {
            let selectRange = textView.selectedRange
            if selectRange.length > 0 {
                //用户长按选择文本时不处理
                return true
            }
            
            // 判断删除的是一个@中间的字符就整体删除
            let astr = textView.attributedText?.mutableCopy() as! NSMutableAttributedString
            
            if let matches = SLFCommonTools.findAllAt(inAText: astr) {
            
            var inAt = false
            var index = range.location
            for match in matches {
                guard let match = match as? NSTextCheckingResult else {
                    continue
                }
                let newRange = NSRange(location: match.range.location + 1, length: match.range.length - 1)
                if NSLocationInRange(range.location, newRange) {
                    inAt = true
                    index = match.range.location
                    if let subRange = Range<String.Index>(match.range, in: astr.string ) {
                        let s = astr.string.nsRange(from: subRange)
////                        str!.replaceSubrange(subRange, with: [])
                        astr.mutableString.replaceOccurrences(of: astr.string, with: "", options: [.init(rawValue: 0)], range: s)
                        //查找被删除的@名字
                        delATName(name: astr.string)
                    }
    
                    break
                }
            }
            
            if inAt {
                textView.attributedText = astr
                toolBarView.refreshTextUI()
                textView.selectedRange = NSRange(location: index, length: 0)
//                toolBarView.sendBtn.isEnabled = !textView.text.empty()
                toolBarView.sendBtn.alpha = textView.text.empty() ? 0.5 : 1
                return false
            }
            }
        }
        //判断是回车键就发送出去
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
            
            sendSay()
            //7f0000010fa600000012 5s
            //7f0000010fa000000007 7
//            toolBarView.sendBtn.isHidden = textView.text.empty()
//            toolBarView.imageBtn.isHidden = !textView.text.empty()
//            toolBarView.emojiToggleButton.isHidden = !textView.text.empty()
            return false
        }
        //        toolBarView.sendBtn.isEnabled = text.count > 0 ? true : false
        return true
    }
    //查找被删除的@名字
    func delATName(name: String) {
        let name = name[1,name.count - 1]
        
        for i in 0..<atArray.count {
            let m = atArray[i]
            if m.nick_name == name {
                atArray.remove(at: i)
            }
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
//        toolBarView.sendBtn.isEnabled = !textView.text.empty()
//        toolBarView.sendBtn.isHidden = textView.text.empty()
        toolBarView.sendBtn.alpha = textView.text.empty() ? 0.5 : 1
        
//        toolBarView.imageBtn.isHidden = !textView.text.empty()
//        toolBarView.emojiToggleButton.isHidden = !textView.text.empty()
        
        
//        let selectedRange = textView.markedTextRange
//        var newText: String? = nil
//        if let selectedRange = selectedRange {
//            newText = textView.text(in: selectedRange)
//        }
//
//        if (newText?.count ?? 0) < 1 {
//            // 高亮输入框中的@
//            let range = textView.selectedRange
//
//            let string = NSMutableAttributedString(string: textView.text ?? "")
//            string.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: string.string.count))
//
//            if let matches = SLFCommonTools.findAllAt(inText: textView.text!) {
//
//                for match in matches {
//                    guard let match = match as? NSTextCheckingResult else {
//                        continue
//                    }
//                    string.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: match.range.location, length: match.range.length - 1))
//                }
//
//                textView.attributedText = string
//
//            }
//            textView.selectedRange = range
//
//        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // 光标不能点落在@词中间
        let range = textView.selectedRange
        if range.length > 0 {
            // 选择文本时可以
            return
        }
        
        if let matches = SLFCommonTools.findAllAt(inText: textView.text!) {
            
            for match in matches {
                guard let match = match as? NSTextCheckingResult else {
                    continue
                }
                let newRange = NSRange(location: match.range.location + 1, length: match.range.length - 1)
                if NSLocationInRange(range.location, newRange) {
                    textView.selectedRange = NSRange(location: match.range.location + match.range.length, length: 0)
                    break
                }
            }
        }
    }
    
    //MARK:
    func stickerInputViewDidClickEmoji(_ emojiStr: String!, inputView: PPStickerInputView!) {
//        if emojiStr.empty() {
//            return
//        }
//        let m = LFSocketSendModel()
//        m.type = "say"
//        m.from_client_id = socket.model.client_id
//        m.face = emojiStr
//        socket.send(m)
//        inputView.textView.text = ""
//        scrollToBottom()
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
        atArray.removeAll()
        self.currentIsInBottom = true
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
            self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
        }
        
        
        if msgList.count > 0 {
//            let lastIndex = IndexPath(row: msgList.count - 1, section: 0)
//            let rectCellView = chatTableView.rectForRow(at: lastIndex)
//            let rect = self.view.convert(rectCellView, to: chatTableView.superview)
//            let cellDistance = rect.origin.y + rect.height
//            let distance1 = SCREEN_HEIGHT - mKeyBoardHeight - LFTool.Height_HomeBar()
//            let distance2 = SCREEN_HEIGHT - toolBarHeight - 2 * fitBlank
//            let difY = cellDistance - distance1
            
            //            NSLog("showKeyboard:%f--", self.view.transform.ty)
            
            //            selfFrame.size.height = distance1
            
//            if cellDistance <= distance1 {
//                animate = {
//                    self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
//                    //                    var r = self.toolBarView.frame
//                    //                    r.origin.y = kScreenH - self.mKeyBoardHeight
//                    //                    self.toolBarView.frame = r
//                }
//                animateType = .animate1
//            } else if distance1 < cellDistance && cellDistance <= distance2 {
                animate = {
//                    self.toolBarView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
                                        var r = self.toolBarView.frame
                                        r.origin.y = kScreenH - self.mKeyBoardHeight - self.toolBarView.frame.height - LFTool.Height_NavBar()
                                        self.toolBarView.frame = r
//                    self.chatTableView.transform = CGAffineTransform(tran/slationX: 0, y: -difY)
                                        var r1 = self.chatTableView.frame
                                        r1.size.height = r.origin.y
                                        self.chatTableView.frame = r1

                    //                    var r2 = self.view.frame
                    //                    r2.size.height = kScreenH - self.mKeyBoardHeight//LFTool.Height_NavBar()
                    //                    self.view.frame = r2

//                    self.lastDifY = difY
                }
//                animateType = .animate2
            
//            } else {
//                animate = {
//                    //                    self.view.transform = CGAffineTransform.identity
//                    self.view.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
//                    //                    var r = self.view.frame
//                    //                    r.size.height = kScreenH - LFTool.Height_NavBar() - self.mKeyBoardHeight
//                    //                    self.view.frame = r
//                    //                    self.view.frame = selfFrame
//                }
//                animateType = .animate3
//            }
        }
        let options = UIView.AnimationOptions(rawValue: UInt((mUserInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber ?? 0).intValue << 16))
        animateOption = options
        
        UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: options, animations: animate) { (isFinished) in
            self.oldOffsetY = self.chatTableView.contentOffset.y
            self.isKeyboardShowed = true
            self.scrollToBottom(animated: true)
        }
    }
    
    func hideKeyboard() {
        
//        toolBarView.sendBtn.isHidden = toolBarView.textView.text.empty()
//
//        toolBarView.imageBtn.isHidden = !toolBarView.textView.text.empty()
//        toolBarView.emojiToggleButton.isHidden = !toolBarView.textView.text.empty()
        
        if toolBarView.textView.isFirstResponder {
            toolBarView.textView.resignFirstResponder()
            
            let options = UIView.AnimationOptions(rawValue: UInt((mUserInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            var animate: (() -> Void) = {
                //                self.toolBarView.frame = CGRect(x: 0, y: kScreenH - LFTool.Height_HomeBar() - self.toolBarHeight, width: kScreenW, height: self.toolBarHeight)//self.toolBarViewFrame()
                //                self.chatTableView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - LFTool.Height_HomeBar() - self.toolBarHeight)//self.chatTableViewFrame()
                //                self.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
            }
            NSLog("hideKeyboard:%@--", self.toolBarView)
            // 返回 view 或 toolBarView 或 chatTableView 到原有状态
//            switch animateType {
//            case .animate1:
//                animate = {
//                    self.toolBarView.transform = CGAffineTransform.identity
//                    self.chatTableView.transform = CGAffineTransform.identity
//                    //                    self.toolBarView.frame = self.toolBarViewFrame()
//                    //                    self.chatTableView.frame = self.chatTableViewFrame()
//                }
//            case .animate2:
                animate = {
                    self.toolBarView.transform = CGAffineTransform.identity
                    self.chatTableView.transform = CGAffineTransform.identity
                    self.toolBarView.frame = self.toolBarViewFrame()
                    self.chatTableView.frame = self.chatTableViewFrame()
                }
//            case .animate3:
//                animate = {
//                    self.view.transform = CGAffineTransform.identity
//                    //                    self.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
//                }
//                //                break
//            case .animate4:
//                break
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
//        let lastIndex = IndexPath(row: msgList.count - 1, section: 0)
//        let rectCellView = chatTableView.rectForRow(at: lastIndex)
//        let rect = chatTableView.convert(rectCellView, to: chatTableView.superview)
//        let cellDistance = rect.origin.y + rect.height
//        let distance1 = SCREEN_HEIGHT - toolBarHeight - mKeyBoardHeight - LFTool.Height_HomeBar() - LFTool.Height_NavBar()
//
//        // 计算键盘可能遮住的消息的长度
//        let difY = cellDistance - distance1
        
//        LFLog("lastDifY:\(lastDifY)-difY:\(difY)-cellDistance:\(cellDistance)-distance1:\(distance1)-to:\(lastDifY + difY)")
        scrollToBottom(animated: animated)
//        if animateType == .animate3 {
//            // 处于情况三时，由于之前的约束（聊天界面在输入栏上方），并且
//            // 是整个界面一起上滑，所以约束依旧成立，只需把聊天界面最后
//            // 一条消息滚动到聊天界面底部即可
//            scrollToBottom()
//        } else if (animateType == .animate1 || animateType == .animate2) && difY > 0{
//            // 在情况一和情况二中，如果聊天界面上滑的总距离小于键盘高度，则可以继续上滑
//            // 一旦聊天界面上滑的总距离 lastDifY + difY 将要超过键盘高度，则上滑总距离设为键盘高度
//            // 此时执行 trans 动画
//            // 一旦聊天界面上滑总距离为键盘高度，则变为情况三的情况，把聊天界面最后
//            // 一条消息滚动到聊天界面底部即可
//            if lastDifY + difY < mKeyBoardHeight {
//                lastDifY += difY
//                let animate: (()->Void) = {
//                    self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.lastDifY)
//                    //                    var r1 = self.chatTableView.frame
//                    //                    r1.size.height = self.chatTableViewFrame().size.height - self.lastDifY
//                    //                    self.chatTableView.frame = r1
//                }
//                UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
//
//            } else if lastDifY + difY > mKeyBoardHeight {
//                if lastDifY != mKeyBoardHeight {
//                    let animate: (()->Void) = {
//                        self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.mKeyBoardHeight)
//                        //                        var r1 = self.chatTableView.frame
//                        //                        r1.size.height = kScreenH - self.toolBarHeight - self.mKeyBoardHeight
//                        //                        self.chatTableView.frame = r1
//                    }
//                    UIView.animate(withDuration: mKeyBoardAnimateDuration, delay: 0, options: animateOption, animations: animate)
//                    lastDifY = mKeyBoardHeight
//                }
//                scrollToBottom(animated: animated)
//            }
//        }else {
//            //键盘未起，直接发图片
//
//            scrollToBottom(animated: animated)
//            self.view.transform = CGAffineTransform.identity
//            self.toolBarView.transform = CGAffineTransform.identity
//            self.chatTableView.transform = CGAffineTransform.identity
//        }
        //        LFLog("end lastDifY:\(lastDifY)")
    }
    
    // 滚动最后一条消息到列表界面底部
    func scrollToBottom(animated: Bool = true) {
        if self.currentIsInBottom == false {
            return
        }
        if msgList.count > 0 {
            //            CATransaction.begin() // 1
            //            CATransaction.setDisableActions(true) // 2 关闭layer隐式动画
            
            chatTableView.scrollToRow(at: IndexPath(row: msgList.count - 1, section: 0), at: .bottom, animated: animated)
            
            //            CATransaction.commit() // 3
        }
    }
    
    
    // 点击消息列表键盘消失
    @objc func tapRemoveBottomView(recognizer: UITapGestureRecognizer) {
        removeKeyBoard()
    }
    
    // 键盘消失
    func removeKeyBoard() {
        if toolBarView.textView.isFirstResponder {
            toolBarView.textView.resignFirstResponder()
            self.view.transform = CGAffineTransform.identity
            self.toolBarView.transform = CGAffineTransform.identity
            self.chatTableView.transform = CGAffineTransform.identity
        }
        
    }
    
    //MARK: socket
    func lfSocketDidReceiveMessage(_ message: Any?) {
        
        
        if let data = message as? NSDictionary {
            if let model = BF_ChatDataModel.deserialize(from: data) {
                switch model.type {
                case "at":
                    LFLog(model)
                    
                    let view = ChatBeAtView(frame: .init(x: kScreenW - 130, y: kScreenH - 250, width: 130, height: 34))
                    view.titleLabel.text = model.from_client_name
                    self.view.addSubview(view)
                    
                case "ping":
                    socket.send(["type":"pong"])
                    return
                case "connect":
                    let id = data["client_id"] as! String
                    LFLog("login id \(id)")
                    if let num = data["total"] as? Int {
                        self.setNavTitle("聊天广场(\(num))")
                    }
                    socket.model.client_id = id
//                    socket.model.name = data["client_name"] as! String
                    SLFHUD.hide()
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
                    SLFHUD.hide()
                case "login":
//                    ({"type":"login","client_id":"7f0000010fa200000001","client_name":"hqtzc0","nick_name":"\u54c8\u54c8\u54c8\u54c81","image_path":"http:\/\/cs.flyv888.com\/upload\/20190820\/b6d82c901177a7bdbd51546728477ce0.jpg","total":3,"time":"2019-08-23 18:09:33"})
                    if let num = data["total"] as? Int {
                        self.setNavTitle("聊天广场(\(num))")
                    }
                    
                    
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
        photoGo = true
        animateType = .animate4
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "拍照", style: .default) { [weak self](_) in
                
                if let strongSelf = self {
                    
                    UIImagePickerController.rx.createWithParent(strongSelf) { picker in
                        picker.sourceType = .camera
                        //                        picker.allowsEditing = true
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
        
        ac.addAction(UIAlertAction(title: "取消", style: .cancel) { (_) in
            
        })
        self.present(ac, animated: true) {
            
        }
    }
}
