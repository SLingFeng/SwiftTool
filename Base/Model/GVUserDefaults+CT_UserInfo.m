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

@end
