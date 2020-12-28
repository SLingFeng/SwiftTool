//
//  TKInputTableViewCell.m
//  TaoKe
//
//  Created by 孙凌锋 on 2020/2/25.
//  Copyright © 2020 MostOne. All rights reserved.
//

#import "TKInputTableViewCell.h"

@implementation TKInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//
//        self.titleLabel = [[[UILabel alloc] init] fontSize:16 fontColor:main_text_color setText:@"标题"];
//        [self.contentView addSubview:self.titleLabel];
//        self.titleLabel.textAlignment = NSTextAlignmentJustified;
//
//
//        self.tf = [[BaseTextField alloc] init];
//        [self.contentView addSubview:self.tf];
//        self.tf.font = [UIFont systemFontOfSize:16];
//        self.tf.textColor = main_text_color;
//
//        self.line = [[UIView alloc] init];
//        self.line.backgroundColor = assist_line_color;
//        [self addSubview:self.line];
//        self.line.hidden = 1;
//
//        self.rightIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
//        [self addSubview:self.rightIV];
//        self.rightIV.hidden = 1;
//
//        [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(15, 15));
//            make.right.equalTo(self.contentView.mas_right).offset(-16);
//            make.centerY.equalTo(self.contentView);
//
//        }];
//
//
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.left.offset(16);
//            make.width.lessThanOrEqualTo(@(34)).priority(998);
//            make.width.greaterThanOrEqualTo(@(70));
//        }];
//
//        [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLabel.mas_right).offset(10).priorityMedium();
//            make.top.bottom.offset(0);
//            make.right.equalTo(self.contentView).offset(-16);
//        }];
//
//        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(10);
//            make.right.offset(-10);
//            make.height.mas_equalTo(0.5);
//            make.bottom.offset(0);
//        }];
//    }
//    return self;
//}


//- (void)setModel:(TKInputModel *)model {
//    _model = model;
//
//    NSDictionary * style = @{@"font" : [UIFont systemFontOfSize:14],
//                             //                             @"font2" : [SLFCommonTools pxFont:30],
//                             @"color" : [UIColor grayColor],
//                             @"plColor" : [UIColor colorWithHexString:@"AFB2B9"],
//                             //                             @"color3" : HEXCOLOR(0xFF0000)
//
//    };
//    self.tf.attributedPlaceholder = [model.placeholder attributedStringWithStyleBook:style];
//
//    self.tf.textFieldChange = model.textFieldChange;
//    self.tf.keyboardType = model.keyboardType;
//    self.tf.enterNumber = model.enterNumber;
//    self.tf.userInteractionEnabled = 1;
//
//    self.titleLabel.attributedText = [model.title attributedStringWithStyleBook:style];
//
//    [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (model.type == 31) {
//            make.left.equalTo(self.contentView).offset(16);
//        }else {
//            make.left.equalTo(self.titleLabel.mas_right).offset(10).priorityMedium();
//        }
//    }];
//
//    self.tf.textAlignment = _model.tfTextAlignment;
//
//    if (model.type == 30) {
//        self.titleLabel.hidden = 0;
//    }else if (model.type == 31) {
//        self.titleLabel.attributedText = nil;
//        self.titleLabel.hidden = 1;
//    }else if (model.type == 33) {
//
//
//        if (_model.codeView) {
//            [self.contentView addSubview:model.codeView];
//
//            [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.contentView).offset(-(model.codeView.frame.size.width + 16 + 10));
//
//            }];
//
//            [model.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.offset(-16);
//                make.centerY.equalTo(self.contentView);
//                make.size.mas_equalTo(model.codeView.frame.size);
//            }];
//        }
//    }
//
//
//    self.rightIV.hidden = _model.rightIVHidden;
//    if (_model.rightSpace > 0) {
//        [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).offset(-model.rightSpace);
//        }];
//    }
//
//    if (!kStringIsEmpty(model.userEnterText)) {
//        self.tf.text = model.userEnterText;
//    }else {
//        self.tf.text = nil;
//    }
//
//    if (model.maxLeftSpace > 0) {
//        [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(model.maxLeftSpace);
//        }];
//
//        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.left.offset(16);
//        }];
//
//    }else {
//        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.left.offset(16);
//            make.width.lessThanOrEqualTo(@(34)).priority(998);
//            make.width.greaterThanOrEqualTo(@(70));
//        }];
//
//    }
//}


@end
#pragma mark - 标题  副标题 箭头
@implementation TKInputItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.leftIV = [[UIImageView alloc] init];
//        [self.contentView addSubview:self.leftIV];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.font = [UIFont systemFontOfSize:(16)];
        [self.contentView addSubview:self.titleLabel];
        
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.textColor = UIColor.text66Color;
        self.subLabel.font = [UIFont systemFontOfSize:(15)];
        [self.contentView addSubview:self.subLabel];
        self.subLabel.textAlignment = 2;
        self.subLabel.numberOfLines = 2;
        
        self.rightIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rightIV];
        
        self.arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_d"]];
        [self.contentView addSubview:self.arrowIV];
        
//        [self.leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//            make.left.offset(15);
//            make.centerY.offset(0);
//        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.leftIV.mas_right).offset(11);
            make.left.offset(15);
            make.centerY.offset(0);
        }];
        
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowIV.mas_left).offset(-6).priorityMedium();
            make.centerY.offset(0);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
        }];
        
        [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowIV.mas_left).offset(-6).priorityMedium();
            make.centerY.offset(0);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
        }];
        
        [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7, 10.6));
            make.right.offset(-15);
            make.centerY.offset(0);
        }];
        
    }
    return self;
}

- (void)setModel:(TKInputModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.subLabel.text = model.rightText;
    
    if (model.rightTextColor) {
        self.subLabel.textColor = model.rightTextColor;
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self.titleLabel.text sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(200, 30)]);
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    self.arrowIV.hidden = _model.arrowHidden;
    if (_model.rightSpace > 0) {
        [self.subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-model.rightSpace);
//            make.width.mas_lessThanOrEqualTo(kScreenW - model.maxLeftSpace - model.rightSpace - self.titleLabel.frame.size.width - 5);
        }];
    }
    
    if (kStringIsEmpty(_model.leftImageName)) {
        self.rightIV.hidden = 1;
        self.subLabel.hidden = 0;
    }else {
        self.rightIV.hidden = 0;
        self.subLabel.hidden = 1;
        self.rightIV.image = [UIImage imageNamed:_model.leftImageName];
        [self.rightIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(model.leftImageSize);
            if (model.rightSpace > 0) {
                make.right.equalTo(self.contentView.mas_right).offset(-model.rightSpace);
            }else {
                make.right.equalTo(self.arrowIV.mas_left).offset(-6);
            }

        }];
    }
    
}

@end

//@implementation TKInputTitleTableViewCell
//
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        
//        self.titleLabel = [[[UILabel alloc] init] fontSize:14 fontColor:main_text_color setText:@"标题"];
//        [self.contentView addSubview:self.titleLabel];
//        self.titleLabel.textAlignment = NSTextAlignmentJustified;
//        
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.offset(-2);
//            make.left.offset(10);
//        }];
//        
//    }
//    return self;
//}
//
//
//
//- (void)setModel:(TKInputModel *)model {
//    _model = model;
//    
//    NSDictionary * style = @{@"font" : [UIFont systemFontOfSize:14],
//                             //                             @"font2" : [SLFCommonTools pxFont:30],
//                             @"color" : [UIColor grayColor],
//                             @"plColor" : [UIColor colorWithHexString:@"AFB2B9"],
//                             //                             @"color3" : HEXCOLOR(0xFF0000)
//                             
//    };
//    
//    self.titleLabel.attributedText = [model.title attributedStringWithStyleBook:style];
//    
//}
//@end
//
//@implementation TKInputTextViewTableViewCell
//
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//        FSTextView *textView = [[FSTextView alloc] init];
//        textView.placeholder = @"请输入";
//        textView.textColor = main_text_color;
//        [textView setFont:[UIFont systemFontOfSize:14]];
//        [textView setPlaceholderColor:[UIColor colorWithHexString:@"AFB2B9"]];
//        textView.maxLength = 500;
//        [self.contentView addSubview:textView];
//        self.textView = textView;
//        textView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
//        
//        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(15);
//            make.right.offset(-16);
//            make.left.offset(16);
//            make.height.offset(100);
//        }];
//        
//        ViewRadius(textView, 8);
//
//    }
//    return self;
//}
//
//- (void)setModel:(TKInputModel *)model {
//    _model = model;
//    
//    self.textView.placeholder = _model.placeholder;
//    _model.textView = self.textView;
//    
//}
//
//@end

@implementation InputSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.leftIV = [[UIImageView alloc] init];
//        [self.contentView addSubview:self.leftIV];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.font = [UIFont systemFontOfSize:(16)];
        [self.contentView addSubview:self.titleLabel];
        
        self.sh = [[UISwitch alloc] init];
        [self.contentView addSubview:self.sh];
        [self.sh addTarget:self action:@selector(switchClick:) forControlEvents:(UIControlEventValueChanged)];
        self.sh.onTintColor = [UIColor colorWithHexString:@"22aec1"];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.leftIV.mas_right).offset(11);
            make.left.offset(15);
            make.centerY.offset(0);
        }];
        
        [self.sh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.offset(0);
        }];
        
        
    }
    return self;
}

- (void)setModel:(TKInputModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.sh.on = model.switchOn;
    
//    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo([self.titleLabel.text sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(200, 30)]);
//        make.left.offset(15);
//        make.centerY.offset(0);
//    }];
    
//    self.arrowIV.hidden = _model.rightIVHidden;
//    if (_model.rightSpace > 0) {
//        [self.subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).offset(-model.rightSpace);
////            make.width.mas_lessThanOrEqualTo(kScreenW - model.maxLeftSpace - model.rightSpace - self.titleLabel.frame.size.width - 5);
//        }];
//    }
    
}

- (void)switchClick:(UISwitch *)sh {
    if (self.model.switchChange) {
        self.model.switchChange(sh);
    }
}

@end
