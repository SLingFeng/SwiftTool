//
//  SLFAlert.h
//
//  Copyright © 2017年 孙凌锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LF_OCHead.h"

typedef void(^alertClick)(BOOL rightClick);
typedef void(^alertClickIndex)(NSInteger index);
typedef void(^alertClickText)(NSString *text);

@interface SLFAlert : NSObject

@property (nonatomic, retain) UIAlertController *alertC;
@property (nonatomic, copy) NSString *text;

+(SLFAlert *)shareSLFAlert;


/**
 系统alert只有确定

 @param title 标题
 @param text 副标题
 @param determine 确认
 @param alertClick 点击左边返回NO 右边YES
 */
+ (void)showSystemAlertWithTitle:(NSString *)title text:(NSString *)text determineTitle:(NSString *)determine alertClick:(alertClick)alertClick;
/**
 系统alert

 @param title 标题
 @param text 副标题
 @param determine 右边 确认
 @param cancelTitle 左边 取消
 @param alertClick 点击左边返回NO 右边YES
 */
+ (void)showSystemAlertWithTitle:(NSString *)title text:(NSString *)text determineTitle:(NSString *)determine cancelTitle:(NSString *)cancelTitle alertClick:(alertClick)alertClick;
/**
 系统alert

 @param weakSelf vc
 @param title 标题
 @param text 副标题
 @param determine 右边 确认
 @param cancelTitle 左边 取消
 @param alertClick 点击左边返回NO 右边YES
 */
+(void)showSystemAlertWithVC:(UIViewController *)weakSelf title:(NSString *)title text:(NSString *)text determineTitle:(NSString *)determine cancelTitle:(NSString *)cancelTitle alertClick:(alertClick)alertClick;
/**
 系统alert

 @param weakSelf vc
 @param title 标题
 @param text 副标题
 @param determine 右边 确认
 @param cancelTitle 左边 取消
 @param cancel 是否要 取消
 @param alertClick 点击左边返回NO 右边YES
 */
+(void)showSystemAlertWithVC:(UIViewController *)weakSelf title:(NSString *)title text:(NSString *)text determineTitle:(NSString *)determine cancelTitle:(NSString *)cancelTitle cancel:(BOOL)cancel alertClick:(alertClick)alertClick;
/**
  Sheet 2个按钮

 @param title 标题
 @param text 副标题
 @param determine 上面按钮
 @param cancelTitle 取消按钮
 @param cancel 是否需要取消按钮
 @param alertClick 取消返回NO 确定返回YES
 */
+(void)showSystemActionSheetWithTitle:(NSString *)title text:(NSString *)text determineTitle:(NSString *)determine cancelTitle:(NSString *)cancelTitle cancel:(BOOL)cancel alertClick:(alertClick)alertClick;
/**
 Sheet 2个按钮

 @param weakSelf vc
 @param title 标题
 @param text 副标题
 @param determine 上面按钮
 @param cancelTitle 取消按钮
 @param cancel 是否需要取消按钮
 @param alertClick 取消返回NO 确定返回YES
 */
+(void)showSystemActionSheetWithVC:(UIViewController *)weakSelf title:(NSString *)title text:(NSString *)text determineTitle:(NSString *)determine cancelTitle:(NSString *)cancelTitle cancel:(BOOL)cancel alertClick:(alertClick)alertClick;
/**
 展示多个选择 Sheet
 
 @param title 标题
 @param text 副标题
 @param textArr 需要展示多个的文字
 @param alertClickIndex 选择的个数 取消是0 从上到下1，2，3，4，+
 */
+(void)showSystemActionSheetWithTitle:(NSString *)title text:(NSString *)text cancelText:(NSString *)cancelText textArr:(NSArray<NSString *> *)textArr alertClickIndex:(alertClickIndex)alertClickIndex;

/**
 单个输入框
 
 @param ws vc
 @param title 标题
 @param text 副标题
 @param determine 右边 确认
 @param cancelTitle 左边 取消
 @param placeholder 等待文字
 @param alertClick 回掉返回输入文字
 */
+ (void)alertTextFView:(UIViewController *)ws title:(NSString *)title text:(NSString *)text determineTitle:(NSString *)determine cancelTitle:(NSString *)cancelTitle placeholder:(NSString *)placeholder alertClick:(alertClickText)alertClick;

#pragma mark - ----------上面是系统的

/**
 提示框 只有确定
 
 @param title 标题
 @param checkTitle 确定按钮 红色
 @param block 点击回调 左0 右1
 @return SLFAlert
 */
//+ (instancetype)showAlertWithTitle:(NSString *)title checkTitle:(NSString *)checkTitle block:(alertClickIndex)block;

/**
 提示框

 @param title 标题
 @param leftTitle 左边按钮 标题
 @param rightTitle 右边按钮 标题
 @param block 点击回调 左0 右1
 @return SLFAlert
 */
//+ (instancetype)showAlertWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle block:(alertClickIndex)block;
//改变颜色
//+ (instancetype)showAlertWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle change:(BOOL)change block:(alertClickIndex)block;

//+ (instancetype)showAlertWithTitle:(NSString *)title subTitle:(NSString *)subTitle leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle change:(BOOL)change block:(alertClickIndex)block;
#pragma mark - 图片
//+ (instancetype)showAlertWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageName:(NSString *)imageName leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle change:(BOOL)change block:(alertClickIndex)block;
@end
