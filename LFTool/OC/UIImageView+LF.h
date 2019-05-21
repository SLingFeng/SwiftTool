//
//  UIImageView+LF.h
//  gct
//
//  Created by big on 2019/5/20.
//  Copyright © 2019 big. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (LF)
/** 解析gif文件数据的方法 block中会将解析的数据传递出来 */
-(void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray,NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths, NSArray<NSNumber *>* heights))dataBlock;

/** 为UIImageView加入一个设置gif图内容的方法： */
-(void)yh_setImage:(NSURL *)imageUrl;
@end

NS_ASSUME_NONNULL_END
