//
//  TKInputModel.h
//  TaoKe
//
//  Created by 孙凌锋 on 2020/2/21.
//  Copyright © 2020 MostOne. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BaseTextField.h"
//#import "TKButton.h"
//#import "TKInputAngleTableViewCell.h"
//#import "FSTextView.h"

NS_ASSUME_NONNULL_BEGIN
@class TKInputAngleTableViewCell;

@interface TKInputModel : NSObject

/**
cell的状态
 0:TKInputAngleTableViewCell 选择
 1:TKInputAngleTableViewCell 输入
 
 2:TKInputTitleTableViewCell 标题
 -- 没有圆角 ⬇️--
 30:TKInputTableViewCell 标题 输入
 31:TKInputTableViewCell 只有输入 没有标题
 32:TKInputTableViewCell 有标题 tf不可输入
 33:TKInputTableViewCell 放获取验证码
 
 
 -- textview --
 4:
 -- 选择 --
 41:
 
 //我的-设置
 5
 
 */

#pragma mark - 通用
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *title;
///可以把 id 改 相应的 cell
@property (nonatomic, copy) void(^cellDidClick)(id cell);
///默认0titlelabel左边 \\ 大于0是距离cell.mas_left的距离
@property (nonatomic, assign) CGFloat maxLeftSpace;

@property (nonatomic, assign) CGFloat rightSpace;

@property (nonatomic, assign) CGFloat cellHeight;

#pragma mark - 输入cell

//
//@property (nonatomic, copy) NSString *placeholder;
//
//
//@property (nonatomic, copy) void(^textFieldChange)(BaseTextField *tf);
////用户输入文字保存起来
//@property (nonatomic, copy) NSString *userEnterText;
//
//@property (assign, nonatomic) NSInteger enterNumber;
//
//@property (nonatomic) UIKeyboardType keyboardType;
//
//@property(nonatomic) NSTextAlignment tfTextAlignment;
//
//
//
//@property (nonatomic, retain) FSTextView *textView;



#pragma mark - 我的-设置

@property (nonatomic, copy) NSString *subText;

@property (nonatomic, copy) NSString *rightText;

@property (nonatomic, retain) UIColor *rightTextColor;

///右边箭头显示，默认NO显示
@property (nonatomic, assign) BOOL rightIVHidden;

@property (nonatomic, copy) void(^switchChange)(UISwitch *sh);

///放获取验证码
@property (nonatomic, retain) UIView *codeView;

@property (nonatomic, retain) UIView *customView;

#pragma mark -

@property (nonatomic, copy) NSString *leftImageName;

//@property (nonatomic, copy) void(^FSTextViewHandler)(FSTextView *textView);

//@property (nonatomic, copy) void(^selectIDBlock)(NSString *ids);

//@property (nonatomic, copy) void(^onClickBlock)(TKButton *sender);


//@property (assign, nonatomic) BaseTextFieldEnterType enterType;

//@property (nonatomic, retain) NSMutableArray *mulitpleData;
//@property (nonatomic, copy) NSString *btnTitle;
@end

NS_ASSUME_NONNULL_END
