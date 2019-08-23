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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavTitle("成员列表")
        self.needTableView(style: .plain)

        self.tableView.register(ChatGroupPeopleTableViewCell.self, forCellReuseIdentifier: "ChatGroupPeopleTableViewCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupPeopleTableViewCell")!
        
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
    
    let subLabel = UILabel(fontSize: 12, fontColor: .white, text: "")
    
    let userIcon = UIImageView(image: kPlaceholderImageUser)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
