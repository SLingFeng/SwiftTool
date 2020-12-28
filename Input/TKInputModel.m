//
//  TKInputModel.m
//  TaoKe
//
//  Created by 孙凌锋 on 2020/2/21.
//  Copyright © 2020 MostOne. All rights reserved.
//

#import "TKInputModel.h"

@implementation TKInputModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxLeftSpace = 0;
        self.cellHeight = 60;
        self.leftImageSize = CGSizeMake(15, 15);
//        self.tfTextAlignment = NSTextAlignmentLeft;
    }
    return self;
}

@end
