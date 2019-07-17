//
//  SLFHUD.h
//
//  Created by 孙凌锋 on 16/5/31.
//
//  Copyright © 2017年 孙凌锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LF_OCHead.h"

typedef void (^completionBlock)(void);

@interface SLFHUD : NSObject <MBProgressHUDDelegate>

@property (nonatomic, copy) completionBlock completion;

@property (nonatomic, retain) MBProgressHUD * lastHud;

/**
 单例

 @return SLFHUD
 */
+ (SLFHUD *)share;

+ (void)showHudInView:(UIView *)view hint:(NSString *)hint;
/**
 隐藏Windows和所有hud
 */
+ (void)hideHud;

/**
 一直显示风火轮
 */
+ (void)showLoading;
/**
 一直显示风火轮

 @param hint 提示文字
 */
+ (void)showLoadingHint:(NSString *)hint;
/**
 带文字的hud 2s消失

 @param hint 文字
 */
+ (void)showHint:(NSString *)hint;
//+ (void)showHint:(NSString *)hint mode:(MBProgressHUDMode)mode;
/**
 带文字的hud
 
 @param hint 文字
 @param delay 消失时间
 */
+ (void)showHint:(NSString *)hint delay:(NSTimeInterval)delay;

+ (void)showHint:(NSString *)hint yOffset:(float)yOffset;
/**
 hud隐藏后调用

 @param hint 文字
 @param delay 显示秒数
 @param block 隐藏后调用
 */
+ (void)showHint:(NSString *)hint delay:(NSTimeInterval)delay completion:(completionBlock)block;

/**
 上一次的hud，空的重新创建一个

 @return hud
 */
+ (MBProgressHUD *)Hud;
/**
 空心进度圈

 @param hint 文字
 @return hud
 */
+ (MBProgressHUD *)showAnnularHint:(NSString *)hint;
/**
 自定义等待加载动图

 @param hint 文字
 @return hud
 */
+ (MBProgressHUD *)showLoadingImageHint:(NSString *)hint;
@end
