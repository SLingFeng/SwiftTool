//
//  ChatGroupPeopleSearchViewController.swift
//  jsbf
//
//  Created by big on 2019/8/26.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class ChatGroupPeopleSearchViewController: LFBaseTableViewController {
    
    var vm : ChatVM!

//    let searchVC = UISearchController(searchResultsController: nil)
    
    let searchBar = UISearchBar(frame: .init(x: 50, y: 4, width: kScreenW - 55, height: 37))

    
    var seletItem : ((BF_ChatUserListDataModel) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.needTableView(style: .plain)
        
        self.tableView.register(ChatGroupPeopleTableViewCell.self, forCellReuseIdentifier: "ChatGroupPeopleTableViewCell")

//        searchVC.searchResultsUpdater = self
//        // 因为在当前控制器展示结果, 所以不需要这个透明视图
//        searchVC.dimsBackgroundDuringPresentation = false;
//
//        searchVC.hidesNavigationBarDuringPresentation = false;
        

        
        self.navigationController?.navigationBar.addSubview(searchBar)

        
        tableView.headerSetup()
        
        
        vm = ChatVM.init(inputSearch: (headerRefresh: self.tableView.mj_header.rx.refreshing.asDriver(),
//                                           footerRefresh: self.tableView.mj_footer.rx.refreshing.asDriver(),
                                           searchKeyword: searchBar.rx.text.asDriver(),
                                           par: ["page" : "1", "pagenum" : "10", "search" : ""]),
                             disposeBag: dig)
        
        vm.endHeaderRefreshing
            .drive(self.tableView.mj_header.rx.endRefreshing)
            .disposed(by: dig)
        
        vm.status.drive(self.tableView.rx.toState).disposed(by: dig)
        
        //单元格数据的绑定
        vm.tableSearchData.subscribe(onNext: {[weak self] (_) in
            self?.tableView.reloadData()
        }).disposed(by: dig)
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableSearchData.value.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupPeopleTableViewCell") as! ChatGroupPeopleTableViewCell
        
        var m: BF_ChatUserListDataModel!
        
        if indexPath.row == 0 {
            m = BF_ChatUserListDataModel()
            m.chat_admin = "0"
            m.nick_name = "所有人"
            m.client_id = "all"
        }else {
            m = vm.tableSearchData.value[indexPath.row - 1]
        }
        
        cell.titleLabel.text = m.nick_name
        cell.userIcon.sd_setImage(with: URL(string: m.image_path), placeholderImage: kPlaceholderImageUser)
        
        cell.subLabel.isHidden = m.chat_admin == "1" ? false : true
        
        cell.titleLabel.snp_remakeConstraints { (make) in
            if m.chat_admin != "1" {
                make.left.equalTo(cell.userIcon.snp_right).offset(5)
            }else {
                make.left.equalTo(cell.subLabel.snp_right).offset(5)
            }
            make.centerY.equalTo(cell.contentView)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var m: BF_ChatUserListDataModel!
        
        if indexPath.row == 0 {
            m = BF_ChatUserListDataModel()
            m.chat_admin = "0"
            m.nick_name = "所有人"
            m.client_id = "all"
        }else {
            m = vm.tableSearchData.value[indexPath.row - 1]
        }
        
        self.seletItem?(m)
        
        self.navigationController?.popViewController(animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }

    deinit {
        searchBar.removeFromSuperview()
    }
    
}
