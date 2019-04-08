//
//  LF_OCHead.h
//  SADF
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

#ifndef LF_OCHead_h
#define LF_OCHead_h

#import <DZNEmptyDataSet/DZNEmptyDataSet-umbrella.h>
#import <MJRefresh/MJRefresh.h>
#import "SLFCommonTools.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SLFHUD.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import <SDImageCache.h>
#import "SLFAlert.h"
// U-Share核心SDK
#import <UMShare/UMShare.h>
// U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
#import <UShareUI/UShareUI.h>

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



#endif /* LF_OCHead_h */
