//
//  UIScrollView+Addition.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCCellProtocol.h"
#import "RCCellConfig.h"
#import "RCHeaderFooterConfig.h"
#import "RCHeaderFooterConfigProtocol.h"
#import "RCSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Addition)

// 配置数组
@property (nonatomic, copy, nullable) NSArray<RCSection *> *rc_sections;

// 只有一个section的情况可以用
@property (nonatomic, copy, nullable) NSArray<id<RCCellConfigProtocol>> *rc_singleConfigs;

// cellForItemAtIndexPath 回调
@property (nonatomic, copy, nullable) void(^rc_refreshCellBlock)(UIView *cell, NSIndexPath *indexPath);

// didSelectItemAtIndexPath 回调
@property (nonatomic, copy, nullable) void(^rc_didSelectCellBlock)(UIView *cell, NSIndexPath *indexPath);

// 刷新头部 回调
@property (nonatomic, copy, nullable) void(^rc_refreshHeaderBlock)(UIView *header, NSIndexPath *indexPath);

// 刷新尾部 回调
@property (nonatomic, copy, nullable) void(^rc_refresrcooterBlock)(UIView *footer, NSIndexPath *indexPath);

// willDisplayCell 回调
@property (nonatomic, copy, nullable) void(^rc_willDisplayCellBlock)(UIView *cell, NSIndexPath *indexPath);

// didEndDisplayingCell 回调
@property (nonatomic, copy, nullable) void(^rc_didEndDisplayingCellBlock)(UIView *cell, NSIndexPath *indexPath);

- (void)rc_addDelegate:(id)delegate;
- (void)rc_addDataSource:(id)dataSource;

@end

NS_ASSUME_NONNULL_END
