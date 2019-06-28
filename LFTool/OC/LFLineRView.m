//
//  LFLineRView.m
//  testOC
//
//  Created by big on 2019/6/25.
//  Copyright © 2019 big. All rights reserved.
//

#import "LFLineRView.h"

@implementation LFLineRView


- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}
-(instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithBtns:(NSArray *)btns vc:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        //[self Btns:btns vc:vc];
    }
    return self;
}

/**
 *  设置默认值
 */
-(void)commonInit{
    self.BD = BorderDirectionLeft | BorderDirectionTop | BorderDirectionRight;
    self.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    self.radius = 5;
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 1;
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [LFLineRView setVariableRoundedBorder:rect view:self
                                                     BD:self.BD
                                                corners:self.corners
                                                 radius:self.radius
                                            borderWidth:self.borderWidth
                                            borderColor:self.borderColor];
}

/**
 *  设置可变的圆角和边框
 *
 *  @param rect
 *  @param view
 *  @param BD          需要显示边框的方向
 *  @param corners     需要设置圆角的方向
 *  @param radius      圆角角度
 *  @param borderWidth 边框的宽度
 *  @param borderColor 边框的颜色
 */
+(void)setVariableRoundedBorder:(CGRect)rect view:(UIView *)view  BD:(BorderDirection)BD corners:(UIRectCorner)corners radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    if (corners != 0) {
        [self setRounded:rect view:view corners:corners];
    }
    if (BD != 0) {
        [self drawInContext:UIGraphicsGetCurrentContext() view:view BD:BD corners:corners radius:radius borderWidth:borderWidth borderColor:borderColor];
    }
    
}

/**
 *  设置圆角
 *
 *  @param rect
 *  @param view
 *  @param corners 需要设置圆角的方向
 */
+(void)setRounded:(CGRect)rect view:(UIView *)view corners:(UIRectCorner)corners{
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(6, 6)];
    maskPath.lineWidth     = 0.f;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+(void)drawInContext:(CGContextRef)context view:(UIView *)view BD:(BorderDirection)BD corners:(UIRectCorner)corners radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    CGContextSetLineWidth(context, borderWidth);
    CGRect rrect = view.bounds;
    CGFloat height = rrect.size.height;
    CGFloat width = rrect.size.width;
    [borderColor set];
    NSInteger BorderDirectionNumber = 0;
    
    if (BD & BorderDirectionLeft) {
        BorderDirectionNumber++;
    }
    if (BD & BorderDirectionRight) {
        BorderDirectionNumber++;
    }
    if (BD & BorderDirectionBottom) {
        BorderDirectionNumber++;
    }
    if (BD & BorderDirectionTop) {
        BorderDirectionNumber++;
    }
    if (BorderDirectionNumber == 4) {
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddArcToPoint(context, 0, height, width, height, (corners & UIRectCornerBottomLeft) ? radius : 0);
        CGContextAddArcToPoint(context, width, height, width, 0, (corners & UIRectCornerBottomRight) ? radius : 0);
        CGContextAddArcToPoint(context,  width, 0, 0, 0, (corners & UIRectCornerTopLeft) ? radius : 0);
        CGContextAddArcToPoint(context,  0, 0, 0, height, (corners & UIRectCornerTopRight) ? radius : 0);
//        CGContextAddArcToPoint(context,  width, 0, 0, 0, radius);
//        CGContextAddArcToPoint(context,  0, 0, 0, height, radius);
        CGContextStrokePath(context);
    }else if (BorderDirectionNumber == 3){
        if (BD & BorderDirectionLeft && BD & BorderDirectionBottom && BD & BorderDirectionRight) {
            [self drawThreeSide:context radius:radius oneX:0 oneY:0 twoX:0 twoY:height threeX:width threeY:height foruX:width foruY:0];
            
        }else if (BD & BorderDirectionLeft && BD & BorderDirectionBottom && BD & BorderDirectionTop){
            [self drawThreeSide:context radius:radius oneX:width oneY:0 twoX:0 twoY:0 threeX:0 threeY:height foruX:width foruY:height];
            
        }else if (BD & BorderDirectionBottom && BD & BorderDirectionRight && BD & BorderDirectionTop){
            [self drawThreeSide:context radius:radius oneX:0 oneY:height twoX:width twoY:height threeX:width threeY:0 foruX:0 foruY:0];
            
        }else if (BD & BorderDirectionLeft && BD & BorderDirectionRight && BD & BorderDirectionTop){
            [self drawThreeSide:context radius:radius oneX:0 oneY:height twoX:0 twoY:0 threeX:width threeY:0 foruX:width foruY:height];
            
        }
    }else if (BorderDirectionNumber == 2){
        if (BD & BorderDirectionLeft && BD & BorderDirectionBottom) {
            [self drawTwoSide:context radius:radius oneX:0 oneY:0 twoX:0 twoY:height threeX:width threeY:height foruX:width foruY:0];
        }else if (BD & BorderDirectionLeft && BD & BorderDirectionRight){
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, height);
            CGContextStrokePath(context);
            CGContextMoveToPoint(context, width, 0);
            CGContextAddLineToPoint(context, width, height);
            CGContextStrokePath(context);
        }else if (BD & BorderDirectionLeft && BD & BorderDirectionTop){
            [self drawTwoSide:context radius:radius oneX:0 oneY:height twoX:0 twoY:0 threeX:width threeY:0 foruX:width foruY:height];
        }else if (BD & BorderDirectionBottom && BD & BorderDirectionRight){
            [self drawTwoSide:context radius:radius oneX:0 oneY:height twoX:width twoY:height threeX:width threeY:0 foruX:0 foruY:0];
        }else if (BD & BorderDirectionBottom && BD & BorderDirectionTop){
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, width, 0);
            CGContextStrokePath(context);
            CGContextMoveToPoint(context, 0, height);
            CGContextAddLineToPoint(context, width, height);
            CGContextStrokePath(context);
        }else if (BD & BorderDirectionRight && BD & BorderDirectionTop){
            [self drawTwoSide:context radius:radius oneX:0 oneY:0 twoX:width twoY:height threeX:width threeY:height foruX:0 foruY:height];
        }
    }else if (BorderDirectionNumber == 1){
        if (BD & BorderDirectionLeft) {
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, height);
            CGContextStrokePath(context);
        }else if (BD & BorderDirectionRight){
            CGContextMoveToPoint(context, width, 0);
            CGContextAddLineToPoint(context, width, height);
            CGContextStrokePath(context);
        }else if (BD & BorderDirectionTop){
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, width, 0);
            CGContextStrokePath(context);
        }else if (BD & BorderDirectionBottom){
            CGContextMoveToPoint(context, 0, height);
            CGContextAddLineToPoint(context, width, height);
            CGContextStrokePath(context);
        }
    }
}

+(void)drawThreeSide:(CGContextRef)context radius:(CGFloat)radius oneX:(CGFloat)oneX  oneY:(CGFloat)oneY twoX:(CGFloat)twoX  twoY:(CGFloat)twoY threeX:(CGFloat)threeX threeY:(CGFloat)threeY foruX:(CGFloat)foruX foruY:(CGFloat)foruY{
    CGContextMoveToPoint(context, oneX, oneY);
    CGContextAddArcToPoint(context, twoX, twoY, threeX, threeY, radius);
    CGContextAddArcToPoint(context, threeX, threeY, foruX, foruY, radius);
    CGContextAddArcToPoint(context,  foruX, foruY, oneX, oneY, 0);
    CGContextStrokePath(context);
}

+(void)drawTwoSide:(CGContextRef)context radius:(CGFloat)radius oneX:(CGFloat)oneX  oneY:(CGFloat)oneY twoX:(CGFloat)twoX  twoY:(CGFloat)twoY threeX:(CGFloat)threeX threeY:(CGFloat)threeY foruX:(CGFloat)foruX foruY:(CGFloat)foruY{
    CGContextMoveToPoint(context, oneX, oneY);
    CGContextAddArcToPoint(context, twoX, twoY, threeX, threeY, radius);
    CGContextAddArcToPoint(context, threeX, threeY, foruX, foruY, 0);
    CGContextStrokePath(context);
}


//作者：杨克进
//来源：CSDN
//原文：https://blog.csdn.net/dashenid/article/details/77651059
//版权声明：本文为博主原创文章，转载请附上博文链接！

@end
