//
//  BaseTextField.h
//  NaHu
//
//  Created by SADF on 16/12/14.
//  Copyright © 2016年 SADF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BaseTextFieldEnterAll,
    BaseTextFieldEnterNumber,
    BaseTextFieldEnterCNEN,
    BaseTextFieldEnterNumberAndCN,
    BaseTextFieldEnterNumberAndEN,
    BaseTextFieldEnterNumberD5,
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
/**
 输入改变时
 */
//@property (copy, nonatomic) void(^textFieldChange)(NSString *);

@property (copy, nonatomic) void(^textFieldBegin)();

@property (nonatomic, copy) void(^returnKeyClick)(BaseTextField *tf);

@property (nonatomic, copy) void(^textFieldChange)(BaseTextField *tf);

//Placeholder文字颜色
- (void)setupPlaceholderColor:(UIColor *)placeholderColor;

//设置开始输入间距
- (void)enterSpace:(CGFloat)left;
@end
