//
//  ExampleDataManager.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "ExampleDataManager.h"
#import "ExampleTableViewCell.h"
#import "UIScrollView+Addition.h"

@interface ExampleDataManager ()

@end

@implementation ExampleDataManager

- (void)getDataComletion:(void(^)(NSArray <RCSection *>*sections))completion {
    RCSection *section = [RCSection new];
    NSMutableArray *configs = @[].mutableCopy;
    for (int i=0; i<10; i++) {
        ExampleModel *model = [self createExampleModelWithIndex:i];
        RCCellConfig *config = [[RCCellConfig alloc]init];
        config.model = model;
        config.cellClass = [ExampleTableViewCell class];
        config.itemSize = CGSizeZero;
        [configs addObject:config];
    }
    section.configs = configs;
    if (completion) {
        completion(@[section]);
    }
}

- (ExampleModel *)createExampleModelWithIndex:(NSInteger)index {
    ExampleModel *model = [ExampleModel new];
    model.title = [NSString stringWithFormat:@"这是第%@个 title",@(index)];
    model.detail = [NSString stringWithFormat:@"这是第%@个 detail",@(index)];
    return model;
}

@end
