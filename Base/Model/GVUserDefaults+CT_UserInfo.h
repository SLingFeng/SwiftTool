//
//  GVUserDefaults+CT_UserInfo.h
//  gct
//
//  Created by big on 2019/3/13.
//  Copyright © 2019 big. All rights reserved.
//

#import "GVUserDefaults.h"

NS_ASSUME_NONNULL_BEGIN

@interface GVUserDefaults (CT_UserInfo)
@property (nonatomic, copy) NSString *balance;
///操盘金额
@property (nonatomic, copy) NSString *tradeMoney;
///保证金
@property (nonatomic, copy) NSString *margin;

@property (nonatomic, copy) NSString *auditStatusStr;
//0:未认证, 1:审核中，2:已认证，3:认证失败
@property (nonatomic, assign) NSInteger auditStatus;
///0未提交 
@property (nonatomic, assign) NSInteger bankCardStatus;
//是否设置：0、已设置 1、未设置
@property (nonatomic, assign) NSInteger pwdStatus;


@property (nonatomic, copy) NSString *web_title;
@property (nonatomic, copy) NSString *service_hotline;
@property (nonatomic, copy) NSString *work_time;
@property (nonatomic, copy) NSString *web_logo;
@property (nonatomic, copy) NSString *trade_code;
@property (nonatomic, copy) NSString *flat_line;
@property (nonatomic, copy) NSString *notice_line;
@property (nonatomic, copy) NSString *fee_experience;
@property (nonatomic, copy) NSString *fee_day;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *fastpay;
@property (nonatomic, copy) NSString *commiss_rate;
@property (nonatomic, copy) NSString *transfer_fee;
@property (nonatomic, copy) NSString *stamp_tax;
@property (nonatomic, copy) NSString *gague_fee;
@property (nonatomic, copy) NSString *service_qq;
@property (nonatomic, copy) NSString *home_banner1;
@property (nonatomic, copy) NSString *home_banner2;
@property (nonatomic, copy) NSString *home_banner3;
@property (nonatomic, copy) NSString *android_app_down;
@property (nonatomic, copy) NSString *ios_app_down;
@property (nonatomic, copy) NSString *weixin_pay;
@property (nonatomic, copy) NSString *zhifubao_pay;
@property (nonatomic, copy) NSString *bank_logo;
@property (nonatomic, copy) NSString *bank_account;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *bank_deposit;
@property (nonatomic, copy) NSString *fin_day_pic;
@property (nonatomic, copy) NSString *fin_week_pic;
@property (nonatomic, copy) NSString *fin_month_pic;
@property (nonatomic, copy) NSString *fin_fee_pic;
///操盘余额 /配资账户余额=操盘金额-保证金余额
- (NSString *)chaopanyuer;
- (void)removeUserInfo;

@end

NS_ASSUME_NONNULL_END
