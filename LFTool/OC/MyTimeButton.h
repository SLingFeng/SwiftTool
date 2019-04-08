//
//  MyTimeButton.h
//
//  Copyright © 2016年 孙凌锋. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyButton.h"
#import "LF_OCHead.h"

@interface MyTimeButton : UIButton
/**
 禁用时间
 */
@property (assign, nonatomic) NSInteger timeNum;
///大于禁用时间为发送过 必须先设置
@property (assign, nonatomic) NSInteger oldTime;

@property (assign, nonatomic) NSInteger status;
/**
 * @author LingFeng, 2016-08-11 09:08:40
 *
 * 点击按钮开始倒计时方法 点击完成后有回调 btn.onClickStartTiming();
 */
@property (copy, nonatomic) void(^onClickStartTiming)(void);
//从上次开始
- (void)reStartTime;
/**
 * @author LingFeng, 2016-09-07 11:09:38
 *
 * 重置时间
 */
-(void)resetTime;
/**
 * @author LingFeng, 2016-08-11 09:08:46
 *
 * 停止时间（放在视图控制器中viewDidDisappear中\如果不是控制器放在dealloc中）
 */
-(void)stopTime;
@end
