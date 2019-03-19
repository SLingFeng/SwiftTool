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

@property (nonatomic, copy) NSString *auditStatusStr;
@property (nonatomic, assign) NSInteger auditStatus;
///0未提交 
@property (nonatomic, assign) NSInteger bankCardStatus;
///0设置了
@property (nonatomic, assign) NSInteger pwdStatus;

@property (nonatomic, copy) NSString *service_qq;

@end

NS_ASSUME_NONNULL_END
