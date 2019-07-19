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
///0普通用户 1专家
@property (nonatomic, assign) NSInteger userType;

@property (nonatomic, copy) NSString *edition_number;

@property (nonatomic, assign) NSInteger expertStatus;
//积分
@property (nonatomic, copy) NSString *integral;
//提现须知
@property (nonatomic, copy) NSString *withdraw_konw;

@property (nonatomic, copy) NSString * integral_to_rmb;
@property (nonatomic, copy) NSString * least_withdraw_integral;
@property (nonatomic, copy) NSString * look_integral_level3;
@property (nonatomic, copy) NSString * look_integral_level2;
@property (nonatomic, copy) NSString * look_integral_level1;
@property (nonatomic, copy) NSString * level2_level3_winrate;
@property (nonatomic, copy) NSString * level2_level3_integral;
@property (nonatomic, copy) NSString * level1_level2_winrate;
@property (nonatomic, copy) NSString * apply_win_probability;
@property (nonatomic, copy) NSString * apply_guess_num;
@property (nonatomic, copy) NSString * expert_recommend_integral_3;
@property (nonatomic, copy) NSString * expert_recommend_integral_2;
@property (nonatomic, copy) NSString * expert_recommend_integral_1;
@property (nonatomic, copy) NSString * level1_level2_integral;
@property (nonatomic, copy) NSString * ordinary_recommend_integral;
@property (nonatomic, copy) NSString * kefu_online;


@property (nonatomic, copy) NSString *auditStatusStr;
//@property (nonatomic, copy) NSString *qqStatusStr;
//@property (nonatomic, copy) NSString *weichatStatusStr;
/////0:未认证, 1:审核中，2:已认证，3:认证失败
@property (nonatomic, assign) NSInteger auditStatus;
/////0未提交
@property (nonatomic, assign) NSInteger bankCardStatus;
@property (nonatomic, copy) NSString *bankCardNumUser;
@property (nonatomic, copy) NSString *bankNameUser;
////是否设置：0、已设置 1、未设置
@property (nonatomic, assign) NSInteger pwdStatus;
//
//@property (nonatomic, assign) BOOL isShowLoginVC;
    @property (nonatomic, copy) NSString *user_phone;
//@property (nonatomic, copy) NSString *user_auth;
    @property (nonatomic, copy) NSString *username;
    @property (nonatomic, copy) NSString *nick_name;
    @property (nonatomic, copy) NSString *image_path;
    @property (nonatomic, copy) NSString *uid;
//
//    
//
//@property (nonatomic, copy) NSString *web_title;
//@property (nonatomic, copy) NSString *service_hotline;
//@property (nonatomic, copy) NSString *work_time;
@property (nonatomic, copy) NSString *app_logo;
//@property (nonatomic, copy) NSString *trade_code;
//@property (nonatomic, copy) NSString *flat_line;
//@property (nonatomic, copy) NSString *notice_line;
//@property (nonatomic, copy) NSString *fee_experience;
//@property (nonatomic, copy) NSString *fee_day;
//@property (nonatomic, copy) NSString *bank;
//@property (nonatomic, copy) NSString *fastpay;
////@property (nonatomic, copy) NSString *commiss_rate;
////@property (nonatomic, copy) NSString *transfer_fee;
//@property (nonatomic, copy) NSString *stamp_tax;
//@property (nonatomic, copy) NSString *gague_fee;
@property (nonatomic, copy) NSString *app_name;
@property (nonatomic, copy) NSString *home_banner1;
@property (nonatomic, copy) NSString *home_banner2;
@property (nonatomic, copy) NSString *home_banner3;
//@property (nonatomic, copy) NSString *android_app_down;
//@property (nonatomic, copy) NSString *ios_app_down;
//@property (nonatomic, copy) NSString *weixin_pay;
//@property (nonatomic, copy) NSString *zhifubao_pay;
//@property (nonatomic, copy) NSString *bank_logo;
//@property (nonatomic, copy) NSString *bank_account;
//@property (nonatomic, copy) NSString *bank_name;
//@property (nonatomic, copy) NSString *bank_deposit;
//@property (nonatomic, copy) NSString *fin_day_pic;
//@property (nonatomic, copy) NSString *fin_week_pic;
//@property (nonatomic, copy) NSString *fin_month_pic;
//@property (nonatomic, copy) NSString *fin_fee_pic;

//@property (nonatomic, copy) NSString *h5_login_logo;
//
//
////@property (nonatomic, copy) NSString *activity_home1;
////@property (nonatomic, copy) NSString *activity_home2;
////@property (nonatomic, copy) NSString *activity_home3;
//
//
/////操盘余额
//- (NSString *)chaopanyuer;
/////配资账户余额=操盘金额-保证金余额
//- (NSString *)peziyuer;

- (void)removeUserInfo;

@end

NS_ASSUME_NONNULL_END
