//
//  MyTableView.m
//
//  Copyright © 2016年 孙凌锋. All rights reserved.
//

#import "MyTableView.h"



@interface MyTableView ()<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource> {
    NSMutableDictionary *_attributes;
}


@end

@implementation MyTableView

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setMyTableView];
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setMyTableView];
    }
    return self;
}

-(void)setMyTableView {
    self.emptyDataSetDelegate = self;
    self.emptyDataSetSource = self;
    self.tableFooterView = [[UIView alloc] init];
    //状态颜色字体
    _attributes = [NSMutableDictionary dictionaryWithDictionary:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [SLFCommonTools colorHex:@"#333333"]}];

    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerR)];
//    footer.automaticallyChangeAlpha = YES;
//    footer.automaticallyHidden = YES;
//    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
//    [footer setTitle:@"正在加载更多的数据" forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"沒有了" forState:MJRefreshStateNoMoreData];
//    self.mj_footer = footer;
}

-(MJRefreshNormalHeader *)headerSetup {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerR)];
//    header.automaticallyChangeAlpha = YES;
//    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    self.mj_header = header;
    return header;
}

-(MJRefreshAutoNormalFooter *)footerSetup {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerR)];
//    footer.automaticallyChangeAlpha = YES;
    footer.automaticallyHidden = YES;
    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多的数据" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
    return footer;
}

-(void)headerR {
    if (self.headerRefresh) {
        self.headerRefresh();
    }
}

-(void)footerR {
    if (self.footerRefresh) {
        self.footerRefresh();
    }
}

#pragma mark - 空白页
//标题
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {

    NSString *text;

    switch (self.tState) {
        case MyTableViewStatusNormal:
            return nil;
            break;
        case MyTableViewStatusNoData: {
            text = @"暂无数据";
        }
            break;
        case MyTableViewStatusFailedLoad: {
            text = @"加载失败";
        }
            break;
        case MyTableViewStatusError: {
            text = @"加载出错";
        }
            break;
        case MyTableViewStatusUnknownError: {
            text = @"未知错误";
        }
            break;
        case MyTableViewStatusCustomize:
        case MyTableViewStatusImage: {
            text = _loadTitle;
        }
            break;
            
        default:
            return nil;
            break;
    }
    if (kStringIsEmpty(text)) {
        return nil;
    }
    
    if (self.loadTitleFontColor) [_attributes setObject:self.loadTitleFontColor forKey:NSForegroundColorAttributeName];
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:_attributes];
}
//正文内容
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = nil;
    
    switch (self.tState) {
        case MyTableViewStatusNormal:
            return nil;
            break;
        case MyTableViewStatusNoData: {
//            text = @"暂无数据";
        }
            break;
        case MyTableViewStatusFailedLoad: {
//            text = @"加载失败";
        }
            break;
        case MyTableViewStatusError: {
//            text = @"加载出错";
        }
            break;
        case MyTableViewStatusUnknownError: {
            text = @"未知错误";
        }
            break;
        case MyTableViewStatusCustomize:
        case MyTableViewStatusImage: {
            if (!kStringIsEmpty(_loadDescription)) {
                text = _loadDescription;
            }
            return nil;
        }
            break;
            
        default:
            return nil;
            break;
    }
    if (kStringIsEmpty(text)) {
        return nil;
    }
    return [[NSAttributedString alloc] initWithString:text attributes:_attributes];

}
//按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = [SLFCommonTools colorHex:@"666666"];
    
    switch (self.tState) {
        case MyTableViewStatusNormal:
//            return nil;
//            break;
        case MyTableViewStatusNoData:
//        {
//            text = @"点击刷新";
//        }
//            break;
        case MyTableViewStatusFailedLoad:
//        {
//            text = @"点击刷新";
//        }
//            break;
        case MyTableViewStatusError:
//        {
//            text = @"点击刷新";
//        }
//            break;
        case MyTableViewStatusUnknownError:
//        {
//            text = @"点击刷新";
//        }
//            break;
            return nil;
            break;
        case MyTableViewStatusCustomize:
        case MyTableViewStatusImage: {
            if (kStringIsEmpty(_loadButtonTitle)) {
//                text = @"点击刷新";
            }else {
                text = _loadButtonTitle;
                font = [UIFont boldSystemFontOfSize:14.0];
                textColor = (state == UIControlStateNormal) ? self.loadButtonFontColorNormal : self.loadButtonFontColorHighlight;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
    if (kStringIsEmpty(text)) {
        return nil;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:[SLFCommonTools pxFont:32] forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *imageName = @"";
    
    if (state == UIControlStateNormal) imageName = self.loadButtonBackgroundImageNormal;
    if (state == UIControlStateHighlighted) imageName = self.loadButtonBackgroundImageHighlight;
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    rectInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10);
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor clearColor];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    switch (self.tState) {
        case MyTableViewStatusCustomize:
        case MyTableViewStatusImage:
            return self.loadImage;
            break;
            
        default:
            return nil;
            break;
    }
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    CGFloat h = -((kScreenH - self.height) / 2);//150;
//    if (IS_IPHONE_Xs_Max || IS_IPHONE_Xr || IS_IPHONE_X || IS_IPHONE_Xs || kiPhone6Plus) {
//
//    }else if (kiPhone5 || kiPhone6) {
//        h = -80;
//    }else {
//        
//    }
//    return h;
//}
//-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
//    return -300;
//}

//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
//    return 10;
//}
//source
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if (self.stateOnClickBlock) {
        self.stateOnClickBlock();
    }
}
-(BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)setTState:(MyTableViewStatus)tState {
    _tState = tState;
    [self reloadEmptyDataSet];
    [self reloadData];
//    [self beginUpdates];
//    [self endUpdates];
}
//- (void)setLoading:(BOOL)loading{
//    if (_loading != loading) {
//        _loading = loading;
//    }
//    [self reloadEmptyDataSet];
//}

- (void)setContentSize:(CGSize)contentSize
{
    if (_isTB == YES) {
        if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
        {
            if (contentSize.height > self.contentSize.height)
            {
                CGPoint offset = self.contentOffset;
                offset.y = (contentSize.height - self.contentSize.height);
                self.contentOffset = offset;
            }
        }
    }
    [super setContentSize:contentSize];
//    if (!CGSizeEqualToSize(contentSize, CGSizeZero)) {
//    if (contentSize.height != _lastContentSize.height) {
//        contentSize = _lastContentSize;
//    }
//    }
}

@end
