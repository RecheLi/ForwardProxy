//
//  ViewController.m
//  ForwardProxy
//
//  Created by linitial on 2020/01/20.
//  Copyright © 2020 linitial. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+Addition.h"
#import "ExampleDataManager.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ExampleDataManager *dataManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView rc_addDelegate:self];
    [self _getData];
}

- (void)_getData {
    __weak typeof(self)weakSelf = self;
    [self.dataManager getDataComletion:^(NSArray<RCSection *> * _Nonnull sections) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tableView.rc_sections = sections;
    }];
}

#pragma mark - Getter
- (ExampleDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [ExampleDataManager new];
    }
    return _dataManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
