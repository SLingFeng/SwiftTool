//
//  ChatTextCell.swift
//  NbChatView-swift
//
//  Created by xiuxiong ding on 2017/4/19.
//  Copyright © 2017年 xiuxiongding. All rights reserved.
//

import UIKit

class ChatTextCell: ChatBaseCell, SDPhotoBrowserDelegate {
    
    var messageLabel: UILabel!
    var textBackgroundImageView: UIImageView!
    
    var imageV: UIImageView?
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageLabel = UILabel()
        messageLabel.isUserInteractionEnabled = false
        messageLabel.numberOfLines = 0
        
        
        textBackgroundImageView = UIImageView()
        //        textBackgroundImageView.isUserInteractionEnabled = true
        //        textBackgroundImageView.layer.cornerRadius = 10
        //        textBackgroundImageView.layer.masksToBounds = true
        
//        imageV = UIImageView()
//        imageV.layer.cornerRadius = 7.0
//        imageV.layer.masksToBounds = true
//        imageV.contentMode = .scaleAspectFit
        
        self.addSubview(textBackgroundImageView)
        self.addSubview(messageLabel)
        

    }
    
    override func setUpWithModel(message: Message) {
        super.setUpWithModel(message: message)
//        LFLog(self)

        let attributedMessage = NSMutableAttributedString(string: message.text, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
            ])
        PPStickerDataManager.sharedInstance().replaceEmoji(for: attributedMessage, font: UIFont.systemFont(ofSize: 16.0))
        messageLabel.attributedText = attributedMessage
        
        if message.incoming {
            //            textBackgroundImageView.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xFFC95B)
            self.textBackgroundImageView.image = UIImage(named:("home_chat_white"))
            messageLabel.textColor = k1A1A1A
        } else {
            //            textBackgroundImageView.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xB0C4DE)
            self.textBackgroundImageView.image = UIImage(named:"home_chat_green")
            messageLabel.textColor = .white
        }
        
        let imageHeight: CGFloat = 120.0

        if message.image != nil || message.imageUrl != nil || message.imageView != nil {
            textBackgroundImageView.isHidden = true
            messageLabel.isHidden = true
            imageV = message.imageView
            self.addSubview(imageV!)
            imageV!.isUserInteractionEnabled = true;
            imageV!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(show)))
            
            imageV?.snp_makeConstraints { (make) in
//                LFLog("基本")
                make.height.equalTo(imageHeight)
                make.top.equalTo(avatarImageView.snp_top).offset(30)
                make.bottom.equalTo(-20)
                if message.incoming {
                    make.left.equalTo(avatarImageView.snp.right).offset(20)
                } else {
                    make.right.equalTo(avatarImageView.snp.left).offset(-20)
                }
            }
            
            if message.image != nil {
                var size = message.image?.size ?? CGSize.zero

                size.width = size.width / size.height * imageHeight
                size.height = imageHeight
                imageV?.image = message.image

                imageV?.snp.remakeConstraints { (make) in
                    make.size.equalTo(size).priority(998)
                    make.top.equalTo(avatarImageView).offset(30)
                    make.bottom.equalTo(-20)
                    if message.incoming {
                        make.left.equalTo(avatarImageView.snp.right).offset(10)
                    } else {
                        make.right.equalTo(avatarImageView.snp.left).offset(-10)
                    }
                }
//                setNeedsLayout()
            }else {
            
//            if message.image == nil {
                imageV?.sd_setImage(with: message.imageUrl) {[weak self] (image, e, type, url) in
                    var size = image?.size ?? CGSize.zero

                    size.width = size.width / size.height * imageHeight
                    size.height = imageHeight
                    self?.imageV?.image = image
                    message.image = image
                    
                    self?.imageV?.snp_remakeConstraints { (make) in
                        if let strongSelf = self {
//                            LFLog("网络")
                            make.size.equalTo(size)
                            make.top.equalTo(strongSelf.avatarImageView.snp_top).offset(30)
//                            make.width.lessThanOrEqualTo(220)
                            make.bottom.equalTo(-20)
                            if message.incoming {
                                make.left.equalTo(strongSelf.avatarImageView.snp.right).offset(10)
                            } else {
                                make.right.equalTo(strongSelf.avatarImageView.snp.left).offset(-10)
                            }
//                            strongSelf.setNeedsLayout()
                        }
                    }
//                    if self?.cellChange != nil {
//                        self?.cellChange!()
//                    }
//                    self?.setNeedsLayout()
                }
//            }
            }
        }else {
            imageV?.isHidden = true
            textBackgroundImageView.isHidden = false
            messageLabel.isHidden = false
            
            messageLabel.snp.makeConstraints { (make) in
                make.top.equalTo(avatarImageView).offset(30)
                make.width.lessThanOrEqualTo(220)
                make.bottom.equalTo(-20)
                if message.incoming {
                    make.left.equalTo(avatarImageView.snp.right).offset(20)
                } else {
                    make.right.equalTo(avatarImageView.snp.left).offset(-20)
                }
            }
            
            textBackgroundImageView.snp.makeConstraints { (make) in
                make.top.equalTo(messageLabel).offset(-8)
                make.left.equalTo(messageLabel).offset(-15)
                make.right.equalTo(messageLabel).offset(15)
                make.bottom.equalTo(messageLabel).offset(12)
            }
        }
    }
    
    @objc func show() {
        
        if imageV?.image != nil {
        
        let sdBrowser = SDPhotoBrowser()
            sdBrowser.sourceImagesContainerView = self;
            sdBrowser.imageCount = 1
            sdBrowser.currentImageIndex = 0
            sdBrowser.delegate = self
            sdBrowser.show()
        }
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return imageV?.image!
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if imageV.image != nil {
//        var size = imageV.image?.size ?? CGSize.zero
//        //等比缩放
//        if (size.width > 220) {
//            size.height /= (size.width / 220);
//            size.width = 220;
//        }
//        
//        imageV.snp.remakeConstraints { (make) in
//            make.size.equalTo(CGSize(width: size.width, height: size.height))
//            make.top.equalTo(avatarImageView).offset(30)
//            make.width.lessThanOrEqualTo(220)
//            make.bottom.equalTo(-20)
////            if message.incoming {
////                make.left.equalTo(avatarImageView.snp.right).offset(20)
////            } else {
////                make.right.equalTo(avatarImageView.snp.left).offset(-20)
////            }
//        }
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatNoMoreCell: UITableViewCell {
    
    let titleLabel = UILabel(fontSize: 14, fontColor: k1A1A1A, text: "最多展示500条")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xF7F5F9)
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.cornerRadius = 2
        titleLabel.backgroundColor = UIColor("#E2E2E2")

        titleLabel.snp_makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(5)
            make.height.equalTo(25)
            make.bottom.equalTo(-5)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
///公告
class ChatAnnouncementCell: BF_BaseTableViewCell {
    
    let titleLabel = UILabel(fontSize: 15, fontColor: k1A1A1A, text: "公告")
    
    let subLabel = UILabel(fontSize: 14, fontColor: k858585, text: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xF7F5F9)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subLabel)
        subLabel.numberOfLines = 0
        
        
        titleLabel.snp_makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(8)
            make.height.equalTo(30)
        })
        
        subLabel.snp_makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(8)
            make.centerX.equalTo(self.contentView)
            make.bottom.equalTo(-20)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
