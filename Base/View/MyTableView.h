//
//  MyTableView.h
//
//  Copyright © 2016年 孙凌锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LF_OCHead.h"

typedef enum : NSUInteger {
    MyTableViewStatusNormal,//正常状态
    MyTableViewStatusNoData,//没有数据
    MyTableViewStatusFailedLoad,//加载失败
    MyTableViewStatusError,//加载错误
    MyTableViewStatusUnknownError,//未知错误
    /**
     自定义的状态
     需要设置 
     必须：loadTitle
     可选：loadButtonTitle loadDescription
     */
    MyTableViewStatusCustomize,
    MyTableViewStatusImage,//图片显示
} MyTableViewStatus;

@interface MyTableView : UITableView

/**
 * @author LingFeng, 2016-08-17 14:08:02
 *
 * 自定义加载的文字 标题
 */
@property (copy, nonatomic) NSString * loadTitle;
/**
 正文内容
 */
@property (copy, nonatomic) NSString * loadDescription;
/**
 btn 自定义加载的文字
 */
@property (copy, nonatomic) NSString * loadButtonTitle;
@property (retain, nonatomic) UIColor * loadTitleFontColor;
@property (retain, nonatomic) UIColor * loadButtonFontColorNormal;
@property (retain, nonatomic) UIColor * loadButtonFontColorHighlight;

/**
 按钮 的背景图片
 */
@property (copy, nonatomic) NSString * loadButtonBackgroundImageNormal;
@property (copy, nonatomic) NSString * loadButtonBackgroundImageHighlight;
/**
 自定义加载 图片
 */
@property (retain, nonatomic) UIImage * loadImage;
/**
 自定义加载 按钮方法
 */
@property (copy, nonatomic) void(^stateOnClickBlock)(void);

@property (assign, nonatomic) MyTableViewStatus tState;
#pragma mark -
/**
 设置头刷新（必须先调用
 
 @return MJRefreshNormalHeader
 */
-(MJRefreshNormalHeader *)headerSetup;
/**
 设置尾部加载（必须先调用
 
 @return MJRefreshAutoNormalFooter
 */
-(MJRefreshAutoNormalFooter *)footerSetup;
/**
 * @author LingFeng, 2016-06-30 14:06:26
 *
 * 下拉刷新方法
 */
@property (copy, nonatomic) void (^headerRefresh)(void);
/**
 * @author LingFeng, 2016-06-30 14:06:36
 *
 * 上拉加载方法
 */
@property (copy, nonatomic) void (^footerRefresh)(void);


@end
