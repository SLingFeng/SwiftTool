//
//  ChatGroupPeopleViewController.swift
//  jsbf
//
//  Created by big on 2019/8/23.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit
///成员列表
class ChatGroupPeopleViewController: LFBaseTableViewController {

    var data: [BF_ChatUserListDataModel] = [] {
        didSet {
            self.tableView.tState = data.count == 0 ? MyTableViewStatusImage : MyTableViewStatusNormal
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavTitle("成员列表")
        self.needTableView(style: .plain)

        self.tableView.register(ChatGroupPeopleTableViewCell.self, forCellReuseIdentifier: "ChatGroupPeopleTableViewCell")
        
        ChatVM.user_getChatUserList().drive(onNext: {[weak self] (data) in
            if let strongSelf = self {
                strongSelf.data = data
            }
        }).disposed(by: dig)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupPeopleTableViewCell") as! ChatGroupPeopleTableViewCell
        
        let m = data[indexPath.row]
        
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

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

class ChatGroupPeopleTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel(fontSize: 15, fontColor: k1A1A1A, text: "")
    
    let subLabel = UILabel(fontSize: 12, fontColor: .white, text: "管理员")
    
    let userIcon = UIImageView(image: kPlaceholderImageUser)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userIcon.cornerRadius = 20
        
        subLabel.cornerRadius = 2
        subLabel.backgroundColor = UIColor("#F4BF20")
        
        self.contentView.sd_addSubviews([titleLabel, subLabel, userIcon])
        
        userIcon.snp_makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalTo(15)
            make.centerY.equalTo(self.contentView)
        })
        
        titleLabel.snp_makeConstraints({ (make) in
            make.left.equalTo(subLabel.snp_right).offset(5)
            make.centerY.equalTo(self.contentView)
        })
        
        subLabel.snp_makeConstraints({ (make) in
            make.left.equalTo(userIcon.snp_right).offset(5)
            make.centerY.equalTo(self.contentView)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
