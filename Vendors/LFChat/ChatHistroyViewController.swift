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
    
    var vm: ChatVM!
    
    var msgList = [Message]()
    
    var chatTableView: MyTableView!
    
    let fitBlank: CGFloat = 15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavTitle("聊天记录")
        self.view.backgroundColor = UIColor.white
        
        // 聊天界面
        chatTableView = MyTableView(frame: .zero, style: .plain)
        chatTableView.backgroundColor = UIColor.clear
        // 自动布局
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.estimatedRowHeight = 110
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = UIColor("#F7F5F9")
        // 让列表最后一条消息和底部工具栏有一定距离
//        chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: fitBlank, right: 0)
        chatTableView.separatorStyle = .none
        chatTableView.register(ChatBaseCell.self, forCellReuseIdentifier: "chat")
        chatTableView.register(ChatNoMoreCell.self, forCellReuseIdentifier: "cell")
//        chatTableView.frame = chatTableViewFrame()
        self.view.addSubview(chatTableView)
        chatTableView.isTB = true
        
        chatTableView.snp_makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        
        let header = MJRefreshStateHeader(refreshingBlock: {[weak self] in
            self?.getData(next: true)
        })
        header?.setTitle("最多展示500条", for: .noMoreData)
        chatTableView.mj_header = header
//        chatTableView.footerSetup()
//        chatTableView.headerRefresh = {[weak self] in
//            self?.getData(next: true)
//        }
        getData(next: false)
//        MJRefreshStateHeader
        
//        vm = ChatVM(
//            input: (
//                headerRefresh: self.chatTableView.mj_header.rx.refreshing.asDriver(),
//                footerRefresh: self.chatTableView.mj_footer.rx.refreshing.asDriver(),
//                par: ["page" : "1", "pagenum" : "20"]),
//            disposeBag: self.dig
//        )
//        //单元格数据的绑定
//        vm.tableData.subscribe(onNext: {[weak self] (data) in
//
//            if let strongSelf = self {
//                strongSelf.msgList = data
//
//                if data.count > 0 {
//                    strongSelf.chatTableView.reloadData()
//                    strongSelf.chatTableView.layoutIfNeeded()
//                    strongSelf.chatTableView.scrollToRow(at: IndexPath(row: data.count > 500 ? strongSelf.msgList.count : strongSelf.msgList.count - 1, section: 0), at: .bottom, animated: false)
//                }
//            }        }).disposed(by: dig)
//
//        //下拉刷新状态结束的绑定
//        vm.endHeaderRefreshing
//            .drive(self.chatTableView.mj_header.rx.endRefreshing)
//            .disposed(by: dig)
//
//        //上拉刷新状态结束的绑定
//        vm.endFooterRefreshing.drive(self.chatTableView.mj_footer.rx.endRefreshing).disposed(by: dig)
//
//        vm.status.drive(self.chatTableView.rx.toState).disposed(by: dig)
//        vm.footerStatus.drive(self.chatTableView.rx.toFooterState).disposed(by: dig)
//        chatTableView.mj_footer.resetNoMoreData()
        //        user_getChatHistory().drive(onNext: {[weak self] (data) in
        //            if let strongSelf = self {
        //                strongSelf.msgList = data
        //                if data.count > 0 {
        //                strongSelf.chatTableView.reloadData()
        //                strongSelf.chatTableView.layoutIfNeeded()
        //                    strongSelf.chatTableView.scrollToRow(at: IndexPath(row: data.count > 500 ? strongSelf.msgList.count : strongSelf.msgList.count - 1, section: 0), at: .bottom, animated: false)
        //                }
        //            }
        //        }).disposed(by: dig)
    }
    
    func getData(next: Bool) {
        if msgList.count >= 500 {
            return
        }
        index = next ? index + 1 : 1
        
        ChatVM.user_getChatHistory(["page" : "\(index)", "pagenum" : "20"])
//            .asObservable().subscribe(onNext: {[weak self] (data) in
//            if let strongSelf = self {
//                strongSelf.msgList = next ? data + strongSelf.msgList : data
//                strongSelf.chatTableView.mj_header.endRefreshing()
//                strongSelf.chatTableView.reloadData()
//                if strongSelf.msgList.count > 0 && strongSelf.msgList.count < 500 {
//                    strongSelf.toRow()
//                }
//            }
//        }).disposed(by: dig)
            .drive(onNext: {[weak self] (data) in
            if let strongSelf = self {
//                let num = strongSelf.msgList.count == 0 ? data.count : strongSelf.msgList.count
                if data.count == 0 {
                    strongSelf.chatTableView.mj_header.state = .noMoreData
                }else {
                strongSelf.msgList = next ? data + strongSelf.msgList : data
                strongSelf.chatTableView.reloadData()
                    strongSelf.chatTableView.mj_header.endRefreshing()

//                strongSelf.chatTableView.layoutIfNeeded()
//                strongSelf.toRow()
                
                
                
                if strongSelf.msgList.count >= 500 {
                    strongSelf.chatTableView.mj_header = nil
                }
                }
////                    strongSelf.chatTableView.scrollToRow(at: IndexPath(row: strongSelf.msgList.count <= 20  ? 19 : strongSelf.msgList.count - 21, section: 0), at: .bottom, animated: false)
//                }else {
////                    strongSelf.chatTableView.mj_header.state = .noMoreData
//                }
            }
        }).disposed(by: dig)
        
        
    }
    
    func toRow() {
        LFLog(msgList.count)
        chatTableView.scrollToRow(at: IndexPath(row: msgList.count - 20, section: 0), at: .top, animated: false)
    }
    
    func chatTableViewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - LFTool.Height_HomeBar() - LFTool.Height_NavBar())
    }
    
    // MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if msgList.count >= 500 {
            return msgList.count + 1
        }
        return msgList.count == 0 ? 0 : msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row = indexPath.row
        if msgList.count >= 500 {
            row = indexPath.row - 1
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                
                return cell
            }
        }
        let cell = ChatTextCell(style: .default, reuseIdentifier: "chat")
        let message = msgList[row]
        cell.setUpWithModel(message: message)
        
        return cell
    }
    
    
}

//class ChatTableView: MyTableView {
//
////    private var contentOffsetForRestore = CGPoint.zero
////
////    func reloadDataWithoutScrollToTop() {
////        reloadData()
////        contentOffset = contentOffsetForRestore
////    }
////
////    func setContentSize(_ contentSize: CGSize) {
////        let previousContentHeight = self.contentSize.height
////        super.contentSize = contentSize
////        let currentContentHeight = self.contentSize.height
////        contentOffsetForRestore = CGPoint(x: 0, y: currentContentHeight - previousContentHeight - contentInset.top)
////    }
//
//    override var contentSize: CGSize {
//        get {
//            return super.contentSize
//        }
//        set(contentSize) {
//            if !__CGSizeEqualToSize(self.contentSize, CGSize.zero) {//!self.contentSize.equalTo(CGSize.zero) {
//                if contentSize.height > self.contentSize.height {
//                    var offset = contentOffset
//                    offset.y += contentSize.height - self.contentSize.height
//                    contentOffset = offset
//                }
//            }
//            super.contentSize = contentSize
//        }
//    }
//
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
