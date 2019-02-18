//
//  BaseTextField.m
//  NaHu
//
//  Created by SADF on 16/12/14.
//  Copyright © 2016年 SADF. All rights reserved.
//

#import "BaseTextField.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface BaseTextField ()<UITextFieldDelegate> {
    UIKeyboardType _oldKeyboardType;
}
@end

@implementation BaseTextField

-(void)awakeFromNib {
    [super awakeFromNib];
    [self set];
}

-(instancetype)init {
    if (self = [super init]) {
        [self set];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self set];
    }
    return self;
}

-(void)set {
    self.enterType = BaseTextFieldEnterAll;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.delegate = self;
    [self addTarget:self action:@selector(returnKeyClick:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
    [self addTarget:self action:@selector(begin) forControlEvents:(UIControlEventEditingDidBegin)];
    [self addTarget:self action:@selector(TextFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
//    [self addTarget:self action:@selector(TextFieldChange:) forControlEvents:(UIControlEventAllEditingEvents)];

//    [self addTarget:self action:@selector(editingDidEnd) forControlEvents:(UIControlEventEditingDidEnd)];
//    self addTarget:self action:@selector(shouldRrturnKeyClick:) forControlEvents:(UIControlEvent)
}

//- (void)editingDidEnd {
//    if (self.textFieldEditingDidEnd) {
//        self.textFieldEditingDidEnd(self);
//    }
//}

- (void)begin {
    if (!self.window.isKeyWindow){
        [self.window makeKeyAndVisible];
        
    }
    if (self.textFieldBegin) {
        self.textFieldBegin();
    }
}

-(void)returnKeyClick:(BaseTextField *)tf {
    if (_returnNext != nil) {
        [_returnNext becomeFirstResponder];
    }
    if (self.returnKeyClick) {
        self.returnKeyClick(tf);
    }
}

-(void)TextFieldChange:(BaseTextField *)textField {
    if (textField == self) {
        
        if (self.enterNumber != 0) {
            NSString *aString = textField.text;
            UITextRange *selectedRange = [textField markedTextRange];
            // 獲取被選取的文字區域（在打注音時，還沒選字以前注音會被選起來）
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 沒有被選取的字才限制文字的輸入字數
            if (!position) {
                if (aString.length > _enterNumber) {
                    textField.text = [aString substringToIndex:_enterNumber];
                }
            }
        }
        if (self.textFieldChange) {
            self.textFieldChange(self);
        }
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    switch (self.enterType) {
//        case BaseTextFieldEnterAll:{
//            return [SLFCommonTools stringContainsEmoji:string];
//        }
//            break;
//        case BaseTextFieldEnterNumber:{
////            BOOL res = YES;
////            NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
////            int i = 0;
////            while (i < string.length) {
////                NSString * string = [string substringWithRange:NSMakeRange(i, 1)];
////                NSRange range = [string rangeOfCharacterFromSet:tmpSet];
////                if (range.length == 0) {
////                    res = NO;
////                    break;
////                }
////                i++;
////            }
//            return [SLFCommonTools matchStringNumber:string];
//        }
//            break;
//        case BaseTextFieldEnterCNEN:{
//            return [SLFCommonTools matchStringFormat:string];
//        }
//            break;
//        case BaseTextFieldEnterNumberAndCN:{
//            return [SLFCommonTools matchStringNumberAndCN:string];
//        }
//            break;
//        case BaseTextFieldEnterNumberAndEN:{
//            return [SLFCommonTools matchStringNumberAndEN:string];
//        }
//            break;
//        case BaseTextFieldEnterNumberD5:{
//            // 判断是否输入内容，或者用户点击的是键盘的删除按钮
//            if (![string isEqualToString:@""]) {
//                NSCharacterSet *cs;
//                // 小数点在字符串中的位置 第一个数字从0位置开始
//
//                NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
//
//                // 判断字符串中是否有小数点，并且小数点不在第一位
//
//                // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
//
//                // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
//
//                if (dotLocation == NSNotFound && range.location != 0) {
//
//                    // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
//
//                    /* [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
//                     */
//                    cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
//                    if (range.location >= 9) {
//                        NSLog(@"单笔金额不能超过亿位");
//                        if ([string isEqualToString:@"."] && range.location == 9) {
//                            return YES;
//                        }
//                        return NO;
//                    }
//                }else {
//
//                    cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
//
//                }
//                // 按cs分离出数组,数组按@""分离出字符串
//
//                NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//
//                BOOL basicTest = [string isEqualToString:filtered];
//
//                if (!basicTest) {
//
//                    NSLog(@"只能输入数字和小数点");
//
//                    return NO;
//
//                }
//
//                if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
//
//                    NSLog(@"小数点后最多两位");
//
//                    return NO;
//                }
//                if (textField.text.length > 11) {
//
//                    return NO;
//
//                }
//            }
//
//            return YES;
//        }
//            break;
//
//
//        default:
//            return YES;
//            break;
//    }
//
//}

- (void)setEnterType:(BaseTextFieldEnterType)enterType {
    if (_enterType != enterType) {
        _enterType = enterType;
        
        _oldKeyboardType = self.keyboardType;
        if (enterType == BaseTextFieldEnterNumberAndEN) {
            self.keyboardType = UIKeyboardTypeASCIICapable;
        }else {
            self.keyboardType = _oldKeyboardType;
        }
    }
    
    
    
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += self.leftViewX; //像右边偏15
    return iconRect;
}
//
//作者：Originalee
//链接：https://www.jianshu.com/p/f93b005dc9d4
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。

- (void)enterSpace:(CGFloat)left {
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, left, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setupPlaceholderColor:(UIColor *)placeholderColor {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName : placeholderColor}];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
