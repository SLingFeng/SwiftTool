//
//  SLFCommonTools.m
//
//  Created by mac on 16/5/31.
//  Copyright © 2016年 LingFeng. All rights reserved.
//

#import "SLFCommonTools.h"
#import <sys/utsname.h>



static SLFCommonTools * tools = nil;
@implementation SLFCommonTools

+(SLFCommonTools *)shareTools{
    @synchronized(self){
        if (tools == nil) {
            //重写 alloc
            tools = [[super allocWithZone:NULL]init];
        }
        return tools;
    }
}
//重写 alloc
+(id)allocWithZone:(struct _NSZone *)zone{
    return [self shareTools];
}
//重写 copy
+(id)copyWithZone:(struct _NSZone *)zone{
    return self;
}

+ (CGFloat)jgg_Y:(CGFloat)yl height:(CGFloat)height h:(CGFloat)h i:(CGFloat)i count:(CGFloat)count {
    return yl+(height+h)*(i/(count));
}

//查找当前vc
+(UIViewController*)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [SLFCommonTools findBestViewController:viewController];
}
+(UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+(void)changeBadge:(NSInteger)number vc:(UIViewController *)vc index:(NSInteger)index {
//    CustomBadgeType type;
//    if (number == -1) {
//        type = kCustomBadgeStyleRedDot;
//        number = 0;
//    }else if (number == 0) {
//        type = kCustomBadgeStyleNone;
//    }else {
//        type = kCustomBadgeStyleNumber;
//    }
//    [vc.tabBarController.tabBar setBadgeStyle:type value:number atIndex:index];
}

//（3）判断字体是否加载
+ (BOOL)isFontDownloaded:(NSString *)fontName
{
    UIFont* aFont = [UIFont fontWithName:fontName size:17.0];
    BOOL isDownloaded = (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame));
    return isDownloaded;
}

+(BOOL)isUserData {
    NSDictionary * user = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"];
    if (nil == user) {
        return NO;
    }else {
        return YES;
    }
}
#pragma mark - 对比版本号
+(BOOL)isCurrentVersionChange {
    // 上一次的使用版本（存储在沙盒中的版本号）
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kIsOne];
    // 当前软件的版本号（从Info.plist中获得）
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
//    if (![currentVersion isEqualToString:lastVersion]) {
////        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:kIsOne];
//    }
    
//    return [currentVersion isEqualToString:lastVersion];
    return 0;
}

#pragma mark - 生成不重复随机数
+(NSArray *)getUniqueRandomNumberGeneration:(NSInteger)count {
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    int num = 0;
    while (num <= count) {
        [tempArray addObject:[NSNumber numberWithInt:num]];
        num += 1;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        int index = arc4random() % (count - i);
        [resultArray addObject:[tempArray objectAtIndex:index]];
//        NSLog(@"index:%d,xx:%@",index,[tempArray objectAtIndex:index]);
        [tempArray removeObjectAtIndex:index];
        
    }
//    NSLog(@"resultArray is %@",resultArray);
    return resultArray;
}

+(CGSize)textSize:(NSString *)text font:(UIFont *)font {
    NSString * s = [text copy];
    return [s sizeWithAttributes:@{NSFontAttributeName:font}];
}

#pragma mark - 行高
+(CGFloat)textHight:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
//    UIFont * font = [SLFCommonTools pxFont:fontSize];
    NSDictionary * dic = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize :CGSizeMake(width, MAXFLOAT)
                                      options:option
                                   attributes:dic
                                      context:nil].size;
    return size.height;
}
#pragma mark - 自适应宽高
+(CGFloat)adaptiveWidth:(CGFloat)width {
//        return width*(kScreenW/375);
    if (IS_IPHONE_Xs_Max || IS_IPHONE_Xr || IS_IPHONE_X || IS_IPHONE_Xs || kiPhone6Plus) {
        return width/2;
    }else if (kiPhone5 || kiPhone6) {
        return width/3;
    }else {
        return width/2;
    }
}

+(CGFloat)adaptiveHeight:(CGFloat)height {
//    if (IS_IPHONEX) {
//        return height*(kScreenH/812);
//    }else if (IS_IPHONE_Xs_Max) {
//        return height*(kScreenH/896);
//    }else {
//        return height*(kScreenH/667);
//    }
//    if (IS_IPHONE_Xs_Max || IS_IPHONE_Xr || IS_IPHONE_X || IS_IPHONE_Xs || kiPhone6Plus) {
//        return height/2;
//    }else if (kiPhone5 || kiPhone6) {
        return height/2;
//    }else {
//        return height;
//    }
}

#pragma mark - 比例
+(CGFloat)heightScale4_3:(CGFloat)width {
    return width/4*3;
}

+(CGFloat)widthScale4_3:(CGFloat)height {
    return height/3*4;
}

+(CGFloat)heightScale16_9:(CGFloat)width {
    CGFloat h = width/16*9;
    return h;
}

+(CGFloat)heightScaleTo:(CGFloat)scale width:(CGFloat)width {
    return width/scale;
}

#pragma mark - 颜色
+(UIColor *)getTitleColor {
    UIColor * color = [UIColor blackColor];
    return color;
}

+(UIColor *)getSecondaryTitleColor {
    UIColor * color = [UIColor whiteColor];
    return color;
}

+(UIColor *)getNavBarColor {
    return [UIColor whiteColor];
}

+(UIColor *)getNavTintTextColor {
    UIColor * color = [UIColor blackColor];
    return color;
}

+(UIColor *)getTextLightColor {
    UIColor * color = [UIColor lightGrayColor];
    return color;
}

+(UIColor *)getTextHColor {
    UIColor * color = [UIColor whiteColor];
    return color;
}

+(UIColor *)getBackgroundColor {
    UIColor * color = [UIColor whiteColor];//[SLFCommonTools colorHex:@"f2f2f2"];
    return color;
}
+(UIColor *)getBackgroundDarkColor {
    UIColor * color = [UIColor whiteColor];//RGBCOLOR(175, 182, 187);
    return color;
}

+(UIColor *)getBackgroundLightColor {
    UIColor * color = [SLFCommonTools colorHex:@"f2f2f2"];
    return color;
}

+(UIColor *)getMainColor {
    return [SLFCommonTools colorHex:@"ff0000"];
}

+(UIColor *)getFont33Color {
//kCOLOR_WITH_RBG(51, 51, 51);
    return [SLFCommonTools colorHex:@"333333"];
}

+(UIColor *)getFont66Color {
//kCOLOR_WITH_RBG(102, 102, 102);
    return [SLFCommonTools colorHex:@"666666"];
}

+(UIColor *)getFont99Color {
//kCOLOR_WITH_RBG(153, 153, 153);
    return [SLFCommonTools colorHex:@"999999"];
}
///颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorHex:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+ (UIColor *)colorHex:(NSInteger)color alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:alpha];
//    return HEXCOLORA(<#rgbValue#>, a)
//    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
//
//    // String should be 6 or 8 characters
//    if ([cString length] < 6) {
//        return [UIColor clearColor];
//    }
//
//    // strip 0X if it appears
//    if ([cString hasPrefix:@"0X"])
//        cString = [cString substringFromIndex:2];
//    if ([cString hasPrefix:@"#"])
//        cString = [cString substringFromIndex:1];
//    if ([cString length] != 6)
//        return [UIColor clearColor];
//    // Separate into r, g, b substrings
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//    //r
//    NSString *rString = [cString substringWithRange:range];
//    //g
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//    //b
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//    // Scan values
//    unsigned int r, g, b;
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//
//    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
#pragma mark - tableViewCell下面的线位置
+(void)tableCellSeparator:(UITableView *)table left:(CGFloat)left right:(CGFloat)right {
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        table.separatorInset = UIEdgeInsetsMake(0, left, 0, right);
    }
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        [table setLayoutMargins:UIEdgeInsetsMake(0, left, 0, right)];
    }
}
#pragma mark - 画线
+(void)drawLineToHight:(float)hight spaceForRightAndLetf:(float)space {
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置画图相关样式参数
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);//设置颜色有很多方法，我觉得这个方法最好用
    //设置笔触宽度
    CGContextSetLineWidth(ctx, 0.3);
    //设置拐点样式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //Line cap 线的两端的样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //画一条简单的线
    CGPoint points1[] = {CGPointMake(space, hight),CGPointMake([UIScreen mainScreen].bounds.size.width-space, hight)};
    CGContextAddLines(ctx,points1, 2);
    //描出笔触
    CGContextStrokePath(ctx);
    //描出笔触
    CGContextFillPath(ctx);
}

+(void)drawLineToX:(float)X topSpace:(float)topSpace bottomSpace:(float)bottomSpace {
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置画图相关样式参数
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);//设置颜色有很多方法，我觉得这个方法最好用
    //设置笔触宽度
    CGContextSetLineWidth(ctx, 0.3);
    //设置拐点样式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //Line cap 线的两端的样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //画一条简单的线
    CGPoint points1[] = {CGPointMake(X, topSpace),CGPointMake(X, bottomSpace)};
    CGContextAddLines(ctx,points1, 2);
    //描出笔触
    CGContextStrokePath(ctx);
    //描出笔触
    CGContextFillPath(ctx);
}

+(void)drawDashLineToHight:(float)hight spaceForRightAndLetf:(float)space {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    //设置虚线绘制起点
//    CGContextMoveToPoint(currentContext, 0, 0);
//    //设置虚线绘制终点
//    CGContextAddLineToPoint(currentContext, self.frame.origin.x + [UIScreen mainScreen].bounds.size.width-space, 0);
    CGPoint points1[] = {CGPointMake(space, hight), CGPointMake([UIScreen mainScreen].bounds.size.width-space, hight)};
    CGContextAddLines(currentContext,points1, 2);
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {3,1};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}

+(void)drawLineToY:(CGFloat)y spaceForRightAndLetf:(CGFloat)space color:(UIColor *)color lineW:(CGFloat)lineW {
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置画图相关样式参数
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);//设置颜色有很多方法，我觉得这个方法最好用
    //设置笔触宽度
    CGContextSetLineWidth(ctx, lineW);
    //设置拐点样式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //Line cap 线的两端的样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //画一条简单的线
    CGPoint points1[] = {CGPointMake(space, y),CGPointMake([UIScreen mainScreen].bounds.size.width-space, y)};
    CGContextAddLines(ctx,points1, 2);
    //描出笔触
    CGContextStrokePath(ctx);
    //描出笔触
    CGContextFillPath(ctx);
}

+ (void)line:(UIView *)view y:(CGFloat)y color:(NSString *)color {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[SLFCommonTools colorHex:color].CGColor];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, y);
    CGPathAddLineToPoint(path, NULL, kScreenW, y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[view layer] addSublayer:shapeLayer];
    
}

+(void)line:(UIView *)view y:(CGFloat)y space:(CGFloat)space color:(NSString *)color {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[SLFCommonTools colorHex:color].CGColor];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:0.33f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    //    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, space, y);
    CGPathAddLineToPoint(path, NULL, kScreenW-space, y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[view layer] addSublayer:shapeLayer];
    
}

+(void)line:(UIView *)view y:(CGFloat)y space:(CGFloat)space color:(NSString *)color lineW:(CGFloat)lineW {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[SLFCommonTools colorHex:color].CGColor];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:lineW];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    //    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, space, y);
    CGPathAddLineToPoint(path, NULL, kScreenW-space, y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[view layer] addSublayer:shapeLayer];
    
}

+(void)lineDash:(UIView *)view hight:(CGFloat)hight x:(CGFloat)x y:(CGFloat)y color:(NSString *)color lineW:(CGFloat)lineW {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[SLFCommonTools colorHex:color].CGColor];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:lineW];
    [shapeLayer setLineJoin:kCALineJoinMiter];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, y);
    CGPathAddLineToPoint(path, NULL, x, y+hight);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[view layer] addSublayer:shapeLayer];
    
}

+(void)line:(UIView *)view y:(CGFloat)y leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace color:(NSString *)color lineW:(CGFloat)lineW {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[SLFCommonTools colorHex:color].CGColor];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:lineW];
    [shapeLayer setLineJoin:kCALineJoinRound];

    // 3=线的宽度 1=每条线的间距
    //    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, leftSpace, y);
    CGPathAddLineToPoint(path, NULL, rightSpace, y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[view layer] addSublayer:shapeLayer];
    
}

//虚线
+(void)dottedLine:(UIView *)view y:(CGFloat)y leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace color:(NSString *)color lineW:(CGFloat)lineW {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[SLFCommonTools colorHex:color].CGColor];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:lineW];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
//    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil]];
    shapeLayer.lineDashPattern = @[@4, @4];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, leftSpace, y);
    CGPathAddLineToPoint(path, NULL, rightSpace, y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[view layer] addSublayer:shapeLayer];
    
}

+(UIView *)lineViewToHight:(float)hight spaceForRightAndLetf:(float)space {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(space, hight, kScreenW-space*2, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

#pragma mark - 清除缓存
+(NSString *)clearMsg {
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    if (tmpSize == 0) {
        return @"0M";
    }
    return [NSString stringWithFormat:@"%@", tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fM",tmpSize/1024.0/1024.0] : [NSString stringWithFormat:@"%.1fK",tmpSize/1024.0/1024.0/1024.0]];
}

+(void)clearAll:(UIViewController *)vc block:(void(^)(BOOL a))block {
    NSString * tt = [NSString stringWithFormat:@"%@%@", @"确定要清除缓存?\n当前有", [SLFCommonTools clearMsg]];

    [SLFAlert showSystemAlertWithTitle:@"清除缓存" text:tt determineTitle:@"清除" cancelTitle:@"取消" alertClick:^(BOOL rightClick) {
        if (rightClick) {
            [SLFHUD showLoadingHint:@"清除中..."];
            //所有缓存 包括过期的
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [SLFHUD hideHud];
                [SLFHUD showHint:@"清除成功"];
                block(YES);
            }];
            [[SDImageCache sharedImageCache] clearMemory];
        }
    }];
//    [SLFCommonTools showAlertViewTo:vc title:@"清除缓存" text:tt cancel:1];
//    [SLFCommonTools shareTools].alertClick = ^() {
//
////        [[SDImageCache sharedImageCache] cle];
//    };
    
}

#pragma mark - 转换 字体
+(NSString *)strToInt:(NSInteger)intt {
    return [NSString stringWithFormat:@"%ld", (long)intt];
}

+(NSString *)strToFloat:(CGFloat)floatt {
    return [NSString stringWithFormat:@"%f", floatt];
}

+(UIFont *)pxFont:(CGFloat)size {
    //    CGFloat font = (size/96)*72;
    //    CGFloat font = (size*3)/4;
    //    if (414 == kScreenW) {
    //        return [UIFont systemFontOfSize:size/3.0f];
    //    }else{
    return [UIFont systemFontOfSize:[SLFCommonTools adaptiveHeight:(size)]];//[UIFont systemFontOfSize:size/2.0f];
    //    }
}

+(UIFont *)pxBoldFont:(CGFloat)size {
//    if (ISiPhone5) {
//        return [UIFont boldSystemFontOfSize:size/2.0f-1];
//    }
    return [UIFont boldSystemFontOfSize:[SLFCommonTools adaptiveHeight:(size)]];
}

+(NSString *)hiddenPhone:(NSString *)phone {
    if (phone == nil) {
        return [NSMutableString stringWithFormat:@""];
    }
    NSMutableString * str = [NSMutableString stringWithString:phone];
    if (str.length == 11) {
        [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else if (str.length == 14) {
        [str replaceCharactersInRange:NSMakeRange(6, 4) withString:@"****"];
    }
    return str;
}

#pragma mark - 判断 转换
+(BOOL)kongGe:(NSString *)text {
    NSCharacterSet *set=[NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString * trimedString = [text stringByTrimmingCharactersInSet:set];
    if (trimedString.length == 0) {
        return YES;
    }else {
        return NO;
    }
}

//性别
+(NSString *)Gender:(NSString *)sex {
    if ([sex isEqualToString:@"1"]) {
        return @"男";
    }else {
        return @"女";
    }
}

//时间显示
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime{
    
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    
    double distanceTime = now - beTime;
    
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"HH:mm"];
    
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }else if (distanceTime < 60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
        
    }else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }else{
            
            [df setDateFormat:@"MM-dd HH:mm"];
            
            distanceStr = [df stringFromDate:beDate];
            
        }
        
    }else if(distanceTime < 24*60*60*365){
        
        [df setDateFormat:@"MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    return distanceStr;
}
///时间戳转换
+(NSString *)timestamp:(NSString *)timeStr {
    NSInteger time = 0;
    if (timeStr.length == 13) {
        time = [timeStr integerValue]/1000;
    }else {
        time = [timeStr integerValue];
    }
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [df stringFromDate:beDate];
}
//#pragma mark - 截取图片中间部分
//+(void)jieQuZhongJianTuPianToImageView:(UIImageView *)imageView url:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
//    kWeakObj(weakOBJ, imageView);
//    [imageView sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        CGFloat width = CGImageGetWidth(image.CGImage);
//        CGFloat height = CGImageGetHeight(image.CGImage);
//        NSLog(@"截取%f,%f 比例%f", width, height, width/height);
//        if (width < height) {
//            weakOBJ.image = [image getSubImage:CGRectMake(0, height/3, width, height/2)];
//        }else {
//            if (width/height > 1.6) {
//                weakOBJ.image = [image getSubImage:CGRectMake(width/3, 0, width/2, height)];
//            }else {
//                weakOBJ.image = image;
//            }
//        }
//    }];
//}

#pragma mark - 字体大小
+(UIFont *)getTextFieldFontSize {

    CGFloat font = 0;
    if (568 < kScreenH) {
        font = 15;
    }else {
        font = 13;
    }
    return [UIFont systemFontOfSize:font];
}
+(UIFont *)getTextFontSize {
    CGFloat font = 0;
    if (568 < kScreenH) {
        font = 17;
    }else {
        font = 15;
    }
    return [UIFont systemFontOfSize:font];
}

+(UIFont *)getTextBigFontSize {
    
    CGFloat font = 0;
    if (568 < kScreenH) {
        font = 19;
    }else {
        font = 18;
    }
    return [UIFont systemFontOfSize:font];
}



#pragma mark - 用户信息
+(void)setUserInfo:(int)idd name:(NSString *)name {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:name forKey:@"userName"];
    [dic setObject:[SLFCommonTools strToInt:idd] forKey:@"userid"];
    //    [dic setObject:[SLFCommonTools getNSStringForInt:user.sessionId] forKey:@"sessionId"];
    //    [dic setObject:user.logoUrl forKey:@"logoUrl"];
    //    [dic setObject:user.mINickName forKey:@"mINickName"];
    //    [dic setObject:kContext(user.jobExp) forKey:@"jobExp"];
    
    [defaults setObject:dic forKey:@"USER"];
    [defaults synchronize];
}
+(NSString *)getUserName {
    return [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"] [@"userName"]];
}

+(NSString *)getUserID {
    return [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"] [@"userid"]];
}

+(void)setUserKey:(NSString *)key value:(NSString *)value {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER"] copyItems:1];
    [dic setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"USER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeUserKey:(NSString *)key {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER"] copyItems:1];
    [dic removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"USER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getUserKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"] [key]];
}

#pragma mark -   去掉返回按钮文字
+(void)setupNavBackBtn:(BOOL)bai {

    if (!(IS_IOS11)) {
        //自定义返回按钮
        UIImage *backButtonImage = nil;
        if (bai) {
            backButtonImage = [[UIImage imageNamed:@"header_back_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        }else {
            backButtonImage = [[UIImage imageNamed:@"header_back_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
        
        //将返回按钮的文字position设置不在屏幕上显示
        //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                             forBarMetrics:UIBarMetricsDefault];
    }
}

+(void)setupSatuts:(UIViewController *)weak bai:(BOOL)bai {
    if (bai) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        [weak.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//        [weak.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//        [weak.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], UITextAttributeTextColor : [UIColor blackColor]}];
//        [weak.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [SLFCommonTools pxFont:44]}];
        
//        [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor blackColor]];
//        [weak wr_setNavBarTitleColor:[UIColor blackColor]];
//        [weak wr_setNavBarBarTintColor:[UIColor whiteColor]];
//        [weak wr_setStatusBarStyle:UIStatusBarStyleDefault];
//
//        weak.hbd_barTintColor = [UIColor whiteColor];
//        weak.hbd_tintColor = [UIColor blackColor];
    }else {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        [weak.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//        [weak.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//        [weak.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], UITextAttributeTextColor : [UIColor whiteColor]}];
//        [weak.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [SLFCommonTools getNavTintTextColor], NSFontAttributeName : [SLFCommonTools pxFont:44]}];
//        [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
//        [weak wr_setNavBarTitleColor:[UIColor whiteColor]];
//        [weak wr_setNavBarBarTintColor:[UIColor blackColor]];
//        [weak wr_setStatusBarStyle:UIStatusBarStyleLightContent];
//        weak.hbd_barTintColor = [UIColor blackColor];
//        weak.hbd_tintColor = [UIColor whiteColor];


    }
//    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
//    weak.hbd_barShadowHidden = YES;
//    weak.navigationController.navigationBar.translucent = NO;
}

-(void)setupNavRightShareBtn:(UIViewController *)weakSelf bai:(BOOL)bai {
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW, 0, 30, 30)];
    if (bai) {
        [btn setImage:[UIImage imageNamed:@"白色分享"] forState:(UIControlStateNormal)];
    }else {
        [btn setImage:[UIImage imageNamed:@"分享"] forState:(UIControlStateNormal)];
    }
    [btn addTarget:self action:@selector(NavRightShareClick) forControlEvents:(UIControlEventTouchUpInside)];
//    UIBarButtonItem * barBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(NavRightShareClick)];
    UIBarButtonItem * barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    weakSelf.navigationItem.rightBarButtonItem = barBtn;
}
-(void)NavRightShareClick {
    if (self.NavRightShareBtnClick) {
        self.NavRightShareBtnClick();
    }
    
}
//alertView
+(void)showAlertViewTo:(UIViewController *)weakSelf title:(NSString *)title text:(NSString *)text cancel:(BOOL)cancel {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:(UIAlertControllerStyleAlert)];
    if (cancel) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        if ([SLFCommonTools shareTools].alertClick) {
            [SLFCommonTools shareTools].alertClick();
        }
    }]];
    //title
    if (nil != title) {
        NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
        [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, title.length)];
        [alertController setValue:alertTitleStr forKey:@"attributedTitle"];
    }
    
    //message
    if (nil != text) {
        NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:text];
        [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, text.length)];
        [alertController setValue:alertMessageStr forKey:@"attributedMessage"];
    }
    
    
    [weakSelf presentViewController:alertController animated:YES completion:nil];
}

//+(NSString *)getEduCational:(NSString *)type {
//    if ([@"1" isEqualToString:type]) {
//        return kLang(@"學歷不限");
//    }else if ([@"2" isEqualToString:type]) {
//        return @"小学";
//    }else if ([@"3" isEqualToString:type]) {
//        return @"初中";
//    }else if ([@"4" isEqualToString:type]) {
//        return @"高中";
//    }else if ([@"5" isEqualToString:type]) {
//        return @"中专";
//    }else if ([@"6" isEqualToString:type]) {
//        return @"大专";
//    }else if ([@"7" isEqualToString:type]) {
//        return @"本科";
//    }else if ([@"8" isEqualToString:type]) {
//        return kLang(@"碩士研究生");
//    }else if ([@"9" isEqualToString:type]) {
//        return @"博士研究生";
//    }else {
//        return kLang(@"學歷不限");
//    }
//}

//+(NSString *)getCompanyType:(NSString *)type {
//#pragma mark -     公司类型 单位类型：1私营股份制.2民营/私营公司.3上市公司.4国营企业.5合资.6外资.7事业单位.8其他
//    if ([@"1" isEqualToString:type]) {
//        return kLang(@"私營股份制");
//    }else if ([@"2" isEqualToString:type]) {
//        return kLang(@"民營/私營公司");
//    }else if ([@"3" isEqualToString:type]) {
//        return kLang(@"上市公司");
//    }else if ([@"4" isEqualToString:type]) {
//        return kLang(@"國營企業");
//    }else if ([@"5" isEqualToString:type]) {
//        return kLang(@"合資");
//    }else if ([@"6" isEqualToString:type]) {
//        return kLang(@"外資");
//    }else if ([@"7" isEqualToString:type]) {
//        return kLang(@"事業單位");
//    }else {
//        return @"其他";
//    }
//}
#pragma mark - 提示
+(NSString *)isUserTiShi:(NSString *)text {
    
    if ([text isEqualToString:@""]) {
        return @"请输入手机号或";
    }else if ([SLFCommonTools isMobileNumber:text] || [SLFCommonTools isValidateEmail:text]) {
        return @"go";
    }else {
        return @"请输入手机号";
    }
    
}

+(NSString *)isUserPasswordTiShi:(NSString *)text {
    
    if ([text isEqualToString:@""]) {
        return @"請輸入密碼";
    }else if ([SLFCommonTools isValidatePassword:text]) {
        return @"go";
    }else {
        return @"密碼格式不正確";
    }
    
}

+(NSString *)isUserCode:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return @"请输入短信验证码";
    }
    return @"go";
}

+(NSString *)isUserPasswordAgainTiShiLast:(NSString *)lastText first:(NSString *)firstText {
    
    if ([lastText isEqualToString:@""]) {
        return @"请输入确认密码";
    }else if ([lastText isEqualToString:firstText]) {
        return @"go";
    }else {
        return @"两次密码不一致";
    }
}
#pragma mark - 创建日期格式化对象
+(NSString *)getTimeIntervalIsCreateTime:(NSString *)date {

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    if (date.length <= 10) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else {
        date = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        date = [date substringWithRange:NSMakeRange(0, 16)];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
   
    //创建了两个日期对象
//    [mJCreatTime]: 2016-03-28T10:35:17.930
//    NSDate *oldDate=[dateFormatter dateFromString:date];//@"2016-6-11 9:30"
//    NSDate *nowDate=[NSDate date];
    //NSDate *date=[NSDate date];
    //NSString *curdate=[dateFormatter stringFromDate:date];
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
//    NSTimeInterval time=[nowDate timeIntervalSinceDate:oldDate];
    
//    int days=((int)time)/(3600*24);
//    int hours=((int)time)%(3600*24)/3600;
//    int minute = ((int)time)%(3600*24)/60;
    if (5 >= date.length) {
        return 0;
    }
//    if (1 <= days) {
        return [date substringWithRange:NSMakeRange(5, 5)];
//    }else if (1 > hours) {
//        return [date substringWithRange:NSMakeRange(5, 5)];
//    }else {
//        NSString *dateContent=[[NSString alloc] initWithFormat:@"%i小时前", hours];
//        return dateContent;
//    }
}
#pragma mark - 时间
+ (NSTimeInterval)timeStart:(NSString *)one timeEnd:(NSString *)two {
    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    //然后创建日期对象
    //    NSTimeInterval end = [[dateFormatter dateFromString:one] timeIntervalSinceDate:[dateFormatter dateFromString:two]];
    //
    //    NSTimeInterval start = [[dateFormatter dateFromString:one] timeIntervalSinceDate:[dateFormatter dateFromString:one]];
    return [[dateFormatter dateFromString:two] timeIntervalSinceDate:[dateFormatter dateFromString:one]];
}
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
}

///计算2天 天数
+(NSString *)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    if (dayComponents.day < 0) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%ld", (long)dayComponents.day];
}

+(NSString *)getYearMonthDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:[NSDate date]]];
}
+(NSString *)getYearMonth {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    return [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:[NSDate date]]];
}

//时间戳 转 时间
+(NSString *)timestamp:(NSTimeInterval)timeTemp formart:(NSString *)mart {
    NSString * str = [NSString stringWithFormat:@"%f", timeTemp];
    NSDate * beDate;
    if (str.length > 11) {
        beDate = [SLFCommonTools dateWithTimeIntervalInMilliSecondSince1970:timeTemp];
    }else {
        beDate = [NSDate dateWithTimeIntervalSince1970:timeTemp];
    }
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:mart];
    return [df stringFromDate:beDate];
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}
//dat e 转 时间
+(NSString *)timeWithData:(NSDate*)data formart:(NSString *)mart {
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:mart];
    return [df stringFromDate:data];
}
//时间 转 时间戳
+ (NSTimeInterval)timeDataToStamp:(NSString *)time {
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *beginDate=[formatter dateFromString:time];
    //转换生时间戳
    return [beginDate timeIntervalSince1970];
}
//时间 转 时间戳
+ (NSTimeInterval)timeDataToStamp:(NSString *)time format:(NSString *)format {
    return 0;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//    NSMutableString * tTime = [[NSMutableString alloc] initWithString:[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:[GVUserDefaults standardUserDefaults].lyServiceHours/1000]]];
//
//    [tTime replaceCharactersInRange:NSMakeRange(11, 5) withString:time];
//
//    NSDate *beginDate=[formatter dateFromString:tTime];
//    //转换生时间戳
//    return [beginDate timeIntervalSince1970];
}

#pragma mark - 检查上一次更新时间
+(NSInteger)checkLastTimeUpApp {
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *NowDate=[NSDate date];
    NSString *curdate=[dateFormatter stringFromDate:NowDate];
    
    NSString * last = [[NSUserDefaults standardUserDefaults] objectForKey:@"checkLastTime"];
    if (last == nil) {
        //储存当前更新时间
        [[NSUserDefaults standardUserDefaults] setObject:curdate forKey:@"checkLastTime"];
        return 2;
    }
    //创建了两个日期对象
    NSDate *lastDate=[dateFormatter dateFromString:last];
    //    储存当前更新时间
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[lastDate timeIntervalSinceDate:NowDate];
    
    int days=((int)time)/(3600*24);
    //    int hours=((int)time)%(3600*24)/3600;
    //    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    //    NSLog(@"%@", dateContent);
    if (days >= 2) {
        [[NSUserDefaults standardUserDefaults] setObject:curdate forKey:@"checkLastTime"];
    }
    return days;
}

#pragma mark - 是否是有效的正则表达式
+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression {
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
        return [predicate evaluateWithObject:strDestination];
    
}

+ (BOOL) isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateCustomize:(NSString *)customize text:(NSString *)text {
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", customize];
    
    return [emailTest evaluateWithObject:text];
}

+ (BOOL)isValidateUserName:(NSString *)userName {
    NSString *emailRegex = @"/^[\u4E00-\u9FA5A-Za-z0-9_]{1,7}$/";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:userName];
}

+(BOOL)isMobileNumber:(NSString *)mobileNum {
    //    移动号段：
    //    134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
    //    联通号段：
    //    130 131 132 145 155 156 171 175 176 185 186
    //    电信号段：
    //    133 149 153 173 177 180 181 189
    //    虚拟运营商:
    //    170
    /**
     * 手机号码
     * 移动：134[08],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[09]|5[0359]|70|8[0259])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[08],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-9]|(3[56789]|5[012789]|47|78|8[234578])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[012]|45|5[256]|7[156]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[019]|49|7[37])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[05789]|\\d{3})\\d{7,8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        
        if([regextestcm evaluateWithObject:mobileNum] == YES) {
            //            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
            //            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
            //            NSLog(@"China Unicom");
        } else {
//            NSLog(@"号码错误");
        }
        return YES;
    }else {
        return NO;
    }
    
}

+ (BOOL)isValidatePassword:(NSString *)passWord {
//    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{8,20}$";
    //    NSString *passWordRegex = @"^[a-zA-Z0-9._%+-]{8,20}+$";
    //    NSString *passWordRegex = @"^[a-zA-Z0-9]{8,20}$";
    NSString *passWordRegex = @"^[a-zA-Z0-9._%+-]{6,16}+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:passWord];
}

//身份证
+ (BOOL)IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";//@"(^[0-9]{15}$)|([0-9]{17}([0-9]|xX)$)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

//银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber
{
    if ((int)cardNumber.length < 13 || (int)cardNumber.length > 19) return NO;
    NSString *str = [cardNumber substringWithRange:NSMakeRange(0, cardNumber.length - 1)];
    int luhmSum = 0;
    for(int i = (int)str.length - 1, j = 0; i >= 0; i--, j++) {
        int k = [str characterAtIndex:i] - '0';
        if(j % 2 == 0) {
            k *= 2;
            k = k / 10 + k % 10;
        }
        luhmSum += k;
    }
    char bit = (luhmSum % 10 == 0) ? '0' : (char)((10 - luhmSum % 10) + '0');
    if(bit == 'N'){
        return false;
    }
    return [cardNumber characterAtIndex:cardNumber.length - 1] == bit;
}
//判断是否是中文
#pragma mark - 正则判断
+ (BOOL)matchStringFormat:(NSString *)str {
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\u4e00-\u9fa5a-zA-Z]*$"];
    
    NSArray * jggArr = @[@"➋", @"➌", @"➍", @"➎", @"➏", @"➐", @"➑", @"➒"];
    BOOL isGo = NO;
    for (NSString *str1 in jggArr) {
        if ([str isEqualToString:str1]) {
            isGo = YES;
            break;
        }
    }
    if (isGo) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++)
        {
            unichar a = [str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
    }
    return [predicate evaluateWithObject:str];
}

+ (BOOL)matchStringNumber:(NSString *)str {
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    return [predicate evaluateWithObject:str];
}
//数字 中文
+ (BOOL)matchStringNumberAndCN:(NSString *)str {
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9\u4e00-\u9fa5]*$"];
    
    NSArray * jggArr = @[@"➋", @"➌", @"➍", @"➎", @"➏", @"➐", @"➑", @"➒"];
    BOOL isGo = NO;
    for (NSString *str1 in jggArr) {
        if ([str isEqualToString:str1]) {
            isGo = YES;
            break;
        }
    }
    if (isGo) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
    }
    return [predicate evaluateWithObject:str];
}
//数字 字母
+ (BOOL)matchStringNumberAndEN:(NSString *)str {
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([0-9A-Za-z]*$)"];

    return [predicate evaluateWithObject:str];
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
//    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    return [str isEqualToString:filtered];
}

+ (BOOL)matchStringIdentityCard:(NSString *)str {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([0-9]*$+^[X]*$)"];
//    return [predicate evaluateWithObject:str];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"Xx0123456789"] invertedSet];
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [str isEqualToString:filtered];
}

/**
 *  iOS中Emoji表情的判断
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    if ([string isEqualToString:@"➋"]|[string isEqualToString:@"➌"]|[string isEqualToString:@"➍"]|[string isEqualToString:@"➎"]|[string isEqualToString:@"➏"]|[string isEqualToString:@"➐"]|[string isEqualToString:@"➑"]|[string isEqualToString:@"➒"]) {
        return YES;
    }
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
//    NSLog(@"%d",returnValue);
    if (returnValue == YES) {
//        [SLFHUD showHint:@"请不要输入表情"];
    }
    return !returnValue;
}

// 需要#import <sys/utsname.h>
+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}


+ (UIImage *)startColor:(UIColor *)startColor endColor:(UIColor *)endColor rect:(CGRect)rect {
    //创建CGContextRef
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
//    CGRect rect = CGRectMake(0, 0, kAW(33), kAH(18));
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [SLFCommonTools drawLinearGradient:gc path:path startColor:startColor.CGColor endColor:endColor.CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,22}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

+ (NSURL *)judgeUrlImage:(NSString *)urlStr {
//    NSLog(@"judgeUrlImage:%@", urlStr);
//    return [NSURL URLWithString:@"http://cc.cocimg.com/api/uploads/181130/1ba979efea55db8d71973bdbacc3c8be.jpg"];
    if ([urlStr hasPrefix:@"http://"]) {
        return [NSURL URLWithString:urlStr];
    }else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://new.ganxu.wang%@", urlStr]];
    }
}

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i>2&&i<mutableStr.length - 3) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return bankNum;
    
}

+(NSString *)getNewBankSpace:(NSString *)bankNum
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
//        for (int i = 0 ; i < mutableStr.length; i ++) {
//            if (i>2&&i<mutableStr.length - 3) {
//                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
//            }
//        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return bankNum;
    
}

+ (NSString *)chang:(NSMutableString *)responseString {
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
//    NSLog(@"%@",responseString);
    return responseString;
}
//判断当前时间是否在某个时间段if ([self isBetweenFromHour:9 toHour:10]) {} 原文：https://blog.csdn.net/dylan_lwb_/article/details/49510293
/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour {
    
    NSDate *dateFrom = [SLFCommonTools getCustomDateWithHour:fromHour];
    NSDate *dateTo = [SLFCommonTools getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending) {
        // 当前时间在9点和10点之间
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}



+ (NSString *)_859ToUTF8:(NSString *)oldStr {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
//    const char * s = [oldStr cStringUsingEncoding:enc];
    return [NSString stringWithUTF8String:[oldStr cStringUsingEncoding:enc]];
}

@end
