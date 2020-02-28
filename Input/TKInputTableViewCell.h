//
//  TKInputTableViewCell.h
//  TaoKe
//
//  Created by 孙凌锋 on 2020/2/25.
//  Copyright © 2020 MostOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"
#import "TKInputModel.h"
#import "FSTextView.h"

NS_ASSUME_NONNULL_BEGIN
/// 我的-修改昵称、密码之类输入
@interface TKInputTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) BaseTextField *tf;

@property (nonatomic, retain) UIView *line;

@property (nonatomic, retain) UIImageView *rightIV;

@property (nonatomic, retain) TKInputModel *model;


@end


@interface TKInputTitleTableViewCell : TKAngleTableViewCell
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) TKInputModel *model;

@end

@interface TKInputTextViewTableViewCell : UITableViewCell
@property (nonatomic, retain) FSTextView *textView;
@property (nonatomic, retain) TKInputModel *model;

@end


NS_ASSUME_NONNULL_END
