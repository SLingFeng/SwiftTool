//
//  LFShare.swift
//  gct
//
//  Created by big on 2019/4/2.
//  Copyright © 2019 big. All rights reserved.
//

import UIKit

class LFShare: NSObject {
    //显示分享面板
    class func showShareUI(vc: UIViewController, title: String, sub: String, img: String) {
        
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 2
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageMaxItemWidth = 60
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageMaxItemHeight = 60
        UMSocialShareUIConfig.shareInstance()?.shareContainerConfig.shareContainerMarginBottom = LFTool.Height_HomeBar()
         UMSocialShareUIConfig.shareInstance()?.sharePlatformItemViewConfig.sharePlatformItemViewBGRadiusColor = .clear
        
        UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.QQ.rawValue),
                                                 NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue)])
        UMSocialUIManager.addCustomPlatformWithoutFilted(.QQ, withPlatformIcon: UIImage(named: "ic_share_qq"), withPlatformName: nil)
        UMSocialUIManager.addCustomPlatformWithoutFilted(.wechatSession, withPlatformIcon: UIImage(named: "ic_share_wechat"), withPlatformName: nil)
        UMSocialUIManager.showShareMenuViewInWindow { (type, userinfo) in

            let mo = UMSocialMessageObject()
            let io = UMShareImageObject()
            io.title = title
            io.descr = sub
            io.thumbImage = UIImage(named: img)
            io.shareImage = UIImage(named: img)
            mo.shareObject = io
            LFLog(userinfo)
            UMSocialManager.default()?.share(to: type, messageObject: mo, currentViewController: vc, completion: { (data, e) in
                if let ne = e as NSError? {
                    SLFHUD.showHint(ne.userInfo["message"] as? String)
                }
                if let a = data as? UMSocialShareResponse? {
                    LFLog("qqwwww\(a)")
                }
            })
        }
    }
    
    
    class func loginQQ() {
        UMSocialManager.default()?.auth(with: .QQ, currentViewController: nil, completion: { (r, e) in
            
            let resp = r as! UMSocialUserInfoResponse
            // 授权信息
            NSLog("QQ uid: %@", resp.uid);
            NSLog("QQ openid: %@", resp.openid);
            NSLog("QQ unionid: %@", resp.unionId);
            NSLog("QQ accessToken: %@", resp.accessToken);
//            NSLog("QQ expiration: %@", resp.expiration);
            // 用户信息
            NSLog("QQ name: %@", resp.name);
            NSLog("QQ iconurl: %@", resp.iconurl);
            NSLog("QQ gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
//            NSLog("QQ originalResponse: %@", resp.originalResponse);
        })
    }
    
    class func loginWechat() {
        UMSocialManager.default()?.auth(with: .QQ, currentViewController: nil, completion: { (r, e) in
            
            if let resp = r as? UMSocialUserInfoResponse {
            // 授权信息
            NSLog("Wechat uid: %@", resp.uid);
            NSLog("Wechat openid: %@", resp.openid);
            NSLog("Wechat unionid: %@", resp.unionId);
            NSLog("Wechat accessToken: %@", resp.accessToken);
            NSLog("Wechat refreshToken: %@", resp.refreshToken);
//            NSLog("Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog("Wechat name: %@", resp.name);
            NSLog("Wechat iconurl: %@", resp.iconurl);
            NSLog("Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            }
        })
    }
    
}
