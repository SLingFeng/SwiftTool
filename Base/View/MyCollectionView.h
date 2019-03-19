//
//  MyCollectionView.h
//
//  Created by SADF on 16/12/6.
//  Copyright © 2016年 SADF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LF_OCHead.h"
#import "MyTableView.h"

typedef enum : NSUInteger {
    MyCollectionViewStateNormal,//正常状态
    MyCollectionViewStateNoData,//没有数据
    MyCollectionViewStateFailedLoad,//加载失败
    MyCollectionViewStateError,//加载错误
    MyCollectionViewStateUnknownError,//未知错误
    /**
     自定义的状态
     需要设置
     必须：loadTitle
     可选：loadButtonTitle loadDescription
     */
    MyCollectionViewStateCustomize,
    MyCollectionViewStateImage,//自定义图片
} MyCollectionViewState;

@interface MyCollectionView : UICollectionView
/**
 * @author LingFeng, 2016-08-17 14:08:02
 *
 * 加载失败的文字 标题
 */
@property (copy, nonatomic) NSString * loadTitle;
/**
 正文内容
 */
@property (copy, nonatomic) NSString * loadDescription;
/**
 btn 加载失败的文字
 */
@property (copy, nonatomic) NSString * loadButtonTitle;
/**
 自定义加载 图片
 */
@property (retain, nonatomic) UIImage * loadImage;
/**
 按钮方法
 */
@property (copy, nonatomic) void(^stateOnClickBlock)(void);

@property (assign, nonatomic) MyTableViewStatus cState;
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
