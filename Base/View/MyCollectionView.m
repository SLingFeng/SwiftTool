//
//  MyCollectionView.m
//
//  Created by SADF on 16/12/6.
//  Copyright © 2016年 SADF. All rights reserved.
//

#import "MyCollectionView.h"

@interface MyCollectionView ()<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource> {
    NSDictionary *_attributes;
}
@end

@implementation MyCollectionView


-(void)awakeFromNib {
    [super awakeFromNib];
    [self setCollection];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setCollection];
    }
    return self;
}

-(void)setCollection {
    self.emptyDataSetDelegate = self;
    self.emptyDataSetSource = self;

    //状态颜色字体
    _attributes = @{NSFontAttributeName : [SLFCommonTools pxFont:34], NSForegroundColorAttributeName : [SLFCommonTools colorHex:@"333333"]};

}

-(MJRefreshNormalHeader *)headerSetup {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerR)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    self.mj_header = header;
    return header;
}

-(MJRefreshAutoNormalFooter *)footerSetup {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerR)];
    footer.automaticallyChangeAlpha = YES;
//    footer.automaticallyHidden = YES;
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
    
    switch (self.cState) {
            case MyTableViewStateNormal:
            return nil;
            break;
            case MyTableViewStateNoData: {
                text = @"暂无数据";
            }
            break;
            case MyTableViewStateFailedLoad: {
                text = @"加载失败";
            }
            break;
            case MyTableViewStateError: {
                text = @"加载出错";
            }
            break;
            case MyTableViewStateUnknownError: {
                text = @"未知错误";
            }
            break;
            case MyTableViewStateCustomize:
            case MyCollectionViewStateImage: {
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
    return [[NSMutableAttributedString alloc] initWithString:text attributes:_attributes];
}
//正文内容
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = nil;
    
    switch (self.cState) {
            case MyTableViewStateNormal:
            return nil;
            break;
            case MyTableViewStateNoData: {
                //            text = @"暂无数据";
            }
            break;
            case MyTableViewStateFailedLoad: {
                //            text = @"加载失败";
            }
            break;
            case MyTableViewStateError: {
                //            text = @"加载出错";
            }
            break;
            case MyTableViewStateUnknownError: {
                text = @"未知错误";
            }
            break;
            case MyTableViewStateCustomize: {
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
    switch (self.cState) {
            case MyTableViewStateNormal:
            return nil;
            break;
            case MyTableViewStateNoData: {
                text = @"点击刷新";
            }
            break;
            case MyTableViewStateFailedLoad: {
                text = @"点击刷新";
            }
            break;
            case MyTableViewStateError: {
                text = @"点击刷新";
            }
            break;
            case MyTableViewStateUnknownError: {
                text = @"点击刷新";
            }
            break;
            case MyTableViewStateCustomize:
            case MyTableViewStateImage: {
                if (kStringIsEmpty(_loadButtonTitle)) {
                    //                text = @"点击刷新";
                }else {
                    text = _loadButtonTitle;
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
    NSDictionary * attributes = @{NSFontAttributeName : [SLFCommonTools pxFont:32], NSForegroundColorAttributeName : [SLFCommonTools colorHex:@"666666"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -150;
}
//-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
//    return -300;
//}

//图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    switch (self.cState) {
        case MyCollectionViewStateCustomize:
        case MyCollectionViewStateImage:
            return self.loadImage;
            break;
            
        default:
            return nil;
            break;
    }
}

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

- (void)setCState:(MyTableViewState)cState {
    _cState = cState;
    [self reloadEmptyDataSet];
    [self reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
