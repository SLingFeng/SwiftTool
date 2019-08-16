//
//  BaseTextField.h
//  NaHu
//
//  Created by SADF on 16/12/14.
//  Copyright © 2016年 SADF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LF_OCHead.h"

typedef enum : NSUInteger {
    BaseTextFieldEnterAll,
    BaseTextFieldEnterNumber,
    BaseTextFieldEnterCNEN,
    BaseTextFieldEnterCN,
    BaseTextFieldEnterNumberAndCN,
    BaseTextFieldEnterNumberAndEN,
    BaseTextFieldEnterNumberD5,
    BaseTextFieldEnterCustomize,
    BaseTextFieldEnterNumberCNEN,
} BaseTextFieldEnterType;

@interface BaseTextField : UITextField

/**
 输入的字符数量
 */
@property (assign, nonatomic) NSInteger enterNumber;

@property (assign, nonatomic) BaseTextFieldEnterType enterType;

@property (retain, nonatomic) UITextField * returnNext;
///设置leftview x轴距
@property (assign, nonatomic) NSInteger leftViewX;
//设置开始输入间距
@property (assign, nonatomic) NSInteger enterSpace;

@property (copy, nonatomic) void(^textFieldBegin)(BaseTextField *tf);

@property (nonatomic, copy) void(^returnKeyClick)(BaseTextField *tf);
/**
 输入改变时
 */
@property (nonatomic, copy) void(^textFieldChange)(BaseTextField *tf);

@property (nonatomic, copy) void(^textFieldEditingDidEnd)(BaseTextField *tf);

@property (nonatomic, copy) NSString* regex;

//Placeholder文字颜色
- (void)setupPlaceholderColor:(UIColor *)placeholderColor;


@end
