//
//  LF_OCHead.h
//  SADF
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

#ifndef LF_OCHead_h
#define LF_OCHead_h

#ifdef __OBJC__
#import <DZNEmptyDataSet/DZNEmptyDataSet-umbrella.h>
#import <MJRefresh/MJRefresh.h>
#import "SLFCommonTools.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SLFHUD.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import <SDImageCache.h>
#import "SLFAlert.h"
#import <Masonry/Masonry.h>
// U-Share核心SDK
//#import <UMShare/UMShare.h>
// U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
//#import <UShareUI/UShareUI.h>

#import <HelpDeskLite/HelpDeskLite.h>
#import <HyphenateLite/HyphenateLite.h>
#import "HelpDeskUI.h"



#pragma mark - 宽高
#define kScreenW \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

#define kScreenH \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

#define kScreen ([UIScreen mainScreen].bounds)


#define kWeakSelf(weakSelf) __weak __typeof(&*self) weakSelf = self
#define kWeakObj(weakObj, _obj) __weak __typeof(&*_obj) weakObj = _obj

//strong
#define kStrongSelf(strongSelf) __strong __typeof(&*self) strongSelf = self
#define kStrongObj(strongOBJ, _obj) __strong __typeof(&*_obj) strongOBJ = _obj

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

#pragma mark - 宽高
#define kScreenW \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

#define kScreenH \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
#define IS_IOS11 [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0

#define JGG_Y(yl,height,h,i,count) yl+(height+h)*(i/(count))


// 判断iPhone5
#define ISiPhone5       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 1136))

// 判断iPhone4s
#define ISiPhone4S      CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 960))

// 判断iPhone6
#define ISiPhone6      CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(750, 1334))

// 判断iPhone6P
#define ISiPhone6Plus  CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(1242, 2208))

// 判断iPhone X
//#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height == 812) ? YES : NO)

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

// 判断iPad
#define     ISIPAD          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif /* LF_OCHead_h */
