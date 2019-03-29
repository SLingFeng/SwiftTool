//
//  GVUserDefaults+CT_UserInfo.m
//  gct
//
//  Created by big on 2019/3/13.
//  Copyright © 2019 big. All rights reserved.
//

#import "GVUserDefaults+CT_UserInfo.h"

@implementation GVUserDefaults (CT_UserInfo)

- (NSString *)chaopanyuer {
    return [NSString stringWithFormat:@"%.2f", self.margin.doubleValue - self.tradeMoney.doubleValue];
}

- (void)removeUserInfo {
    self.balance = @"0";
    self.tradeMoney = @"0";
    self.margin = @"0";
    self.auditStatusStr = @"0";
    self.auditStatus = 0;
    self.bankCardStatus = 0;
    self.pwdStatus = 0;
}

@end
