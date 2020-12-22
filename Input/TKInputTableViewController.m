//
//  TKInputTableViewController.m
//  TaoKe
//
//  Created by 孙凌锋 on 2020/2/24.
//  Copyright © 2020 MostOne. All rights reserved.
//

#import "TKInputTableViewController.h"

@interface TKInputTableViewController ()

@end

@implementation TKInputTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addModelArr = [NSMutableArray arrayWithCapacity:10];

    
}

- (void)setUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = assist_viewBg_color;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.estimatedSectionHeaderHeight = 0.01;
//        self.tableView.estimatedSectionFooterHeight = 0.01;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.addModelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.addModelArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
//    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKInputModel *model = self.addModelArr[indexPath.section][indexPath.row];
    return model.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    TKInputModel * model = self.addModelArr[indexPath.section][indexPath.row];
    if (model.cellDidClick) {
        model.cellDidClick([tableView cellForRowAtIndexPath:indexPath]);
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    TKInputModel * model = self.addModelArr[indexPath.section][indexPath.row];
    if (model.cellDidClick) {
        return 1;
    }
    return 0;
}

@end

//@implementation TKInputBtnViewController
//
//- (void)setUI {
//    [super setUI];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    
//    self.tableView.separatorColor = assist_line_color;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
//
//
//    [self.tableView registerClass:[TKInputTableViewCell class] forCellReuseIdentifier:@"TKInputTableViewCell"];
//    
//    UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 66))];
//
//    self.doneBtn = [[TKGradientButton alloc] initWithFontSize:17 fontColor:[UIColor whiteColor] fontText:@"提交"];
//    [view addSubview:self.doneBtn];
//    ViewRadius(self.doneBtn, 23);
//    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.mas_equalTo(0);
//        make.left.offset(16).priorityMedium();
//        make.right.offset(-16).priorityMedium();
//        make.height.mas_equalTo(46);
//        make.top.offset(20);
//    }];
////    line.backgroundColor = ;
//    self.tableView.tableFooterView = view;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    TKInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKInputTableViewCell"];
//    TKInputModel * model = self.addModelArr[indexPath.section][indexPath.row];
//    
//    cell.model = model;
//    
//    return cell;
//}
/////最后一行加上线
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    if (section == self.addModelArr.count - 1) {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor whiteColor];
//
//        UIView *line = [[UIView alloc] initWithFrame:(CGRectMake(16, 0, SCREEN_WIDTH - 32, 0.5))];
//        line.backgroundColor = assist_line_color;
//        [view addSubview:line];
//        return view;
//    }
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == self.addModelArr.count - 1) {
//        return 10;
//    }
//    return 0;
//}
//
//@end
