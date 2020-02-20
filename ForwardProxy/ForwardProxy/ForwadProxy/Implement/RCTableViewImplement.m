//
//  RCTableViewImplement.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "RCTableViewImplement.h"
#import "UIScrollView+Addition.h"

@interface RCTableViewImplement () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RCTableViewImplement

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections[section].configs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sections.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    }
    
    RCSection *section = self.sections[indexPath.section];
    id<RCCellConfigProtocol> config = section.configs[indexPath.row];
    
    NSString *reuseIdentifier = [self reuseIdentifierForCellConfig:config];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UIView<RCCellProtocol> *rc_cell = (UIView<RCCellProtocol> *)cell;
        if ([rc_cell respondsToSelector:@selector(rc_indexPath)]) {
            rc_cell.rc_indexPath = indexPath;
        }
        if ([rc_cell respondsToSelector:@selector(rc_cellConifg)]) {
            rc_cell.rc_cellConifg = config;
        }
        if ([rc_cell respondsToSelector:@selector(rc_delegate)]) {
            rc_cell.rc_delegate = self.cellDelegate;
        }
        if ([rc_cell respondsToSelector:@selector(rc_setCellConfig:)]) {
            [rc_cell rc_setCellConfig:config];
        }
    }
    
    if (tableView.rc_refreshCellBlock) {
        tableView.rc_refreshCellBlock(cell, indexPath);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCSection *section = self.sections[indexPath.section];
    id<RCCellConfigProtocol> config = section.configs[indexPath.row];
    if (config && [config respondsToSelector:@selector(rc_itemSize)]) {
        if (config.rc_itemSize.height > 0) {
            return config.rc_itemSize.height;
        }
    }
    if ([config.rc_cellClass respondsToSelector:@selector(rc_sizeForCellWithConfig:atIndexPath:)]) {
        return [config.rc_cellClass rc_sizeForCellWithConfig:config atIndexPath:indexPath].height;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<RCHeaderFooterConfigProtocol> headerConfig = self.sections[section].header;
    if (headerConfig && [headerConfig respondsToSelector:@selector(rc_height)]) {
        if (headerConfig.rc_height > 0) {
            return headerConfig.rc_height;
        }
    }
    if ([headerConfig.rc_headerFooterClass respondsToSelector:@selector(rc_heightForHeaderFooterWithConfig:inSection:)]) {
        return [headerConfig.rc_headerFooterClass rc_heightForHeaderFooterWithConfig:headerConfig inSection:section];
    }
    return tableView.style == UITableViewStylePlain ? 0 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id<RCHeaderFooterConfigProtocol> footerConfig = self.sections[section].footer;
    if (footerConfig && [footerConfig respondsToSelector:@selector(rc_height)]) {
        if (footerConfig.rc_height > 0) {
            return footerConfig.rc_height;
        }
    }
    if ([footerConfig.rc_headerFooterClass respondsToSelector:@selector(rc_heightForHeaderFooterWithConfig:inSection:)]) {
        return [footerConfig.rc_headerFooterClass rc_heightForHeaderFooterWithConfig:footerConfig inSection:section];
    }
    return tableView.style == UITableViewStylePlain ? 0 : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<RCHeaderFooterConfigProtocol> headerConfig = self.sections[section].header;
    UIView *header = [self viewForHeaderFooterWithTableView:tableView config:headerConfig section:section];
    if (tableView.rc_refreshHeaderBlock) {
        tableView.rc_refreshHeaderBlock(header, [NSIndexPath indexPathForRow:0 inSection:section]);
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id<RCHeaderFooterConfigProtocol> footerConfig = self.sections[section].footer;
    UIView *footer = [self viewForHeaderFooterWithTableView:tableView config:footerConfig section:section];
    if (tableView.rc_refresrcooterBlock) {
        tableView.rc_refresrcooterBlock(footer, [NSIndexPath indexPathForRow:0 inSection:section]);
    }
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UIView<RCCellProtocol> *rc_cell = (UIView<RCCellProtocol> *)cell;
        if ([rc_cell respondsToSelector:@selector(rc_didSelectCellAtIndexPath:)]) {
            [rc_cell rc_didSelectCellAtIndexPath:indexPath];
        }
    }
    if (tableView.rc_didSelectCellBlock) {
        tableView.rc_didSelectCellBlock(cell, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UIView<RCCellProtocol> *rc_cell = (UIView<RCCellProtocol> *)cell;
        if ([rc_cell respondsToSelector:@selector(rc_willDisplayCellAtIndexPath:)]) {
            [rc_cell rc_willDisplayCellAtIndexPath:indexPath];
        }
    }
    if (tableView.rc_willDisplayCellBlock) {
        tableView.rc_willDisplayCellBlock(cell, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UIView<RCCellProtocol> *rc_cell = (UIView<RCCellProtocol> *)cell;
        if ([rc_cell respondsToSelector:@selector(rc_didEndDisplayingCellAtIndexPath:)]) {
            [rc_cell rc_didEndDisplayingCellAtIndexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)view;
        if ([rc_view respondsToSelector:@selector(rc_willDisplayHeaderFooterInSection:)]) {
            [rc_view rc_willDisplayHeaderFooterInSection:section];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)view;
        if ([rc_view respondsToSelector:@selector(rc_didEndDisplayingHeaderFooterInSection:)]) {
            [rc_view rc_didEndDisplayingHeaderFooterInSection:section];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([view conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)view;
        if ([rc_view respondsToSelector:@selector(rc_willDisplayHeaderFooterInSection:)]) {
            [rc_view rc_willDisplayHeaderFooterInSection:section];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([view conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)view;
        if ([rc_view respondsToSelector:@selector(rc_didEndDisplayingHeaderFooterInSection:)]) {
            [rc_view rc_didEndDisplayingHeaderFooterInSection:section];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) return;
    UITableView *tableView = (UITableView *)scrollView;
    for (UITableViewCell *cell in tableView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UITableViewCell<RCCellProtocol> *rc_cell = (UITableViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(rc_scrollViewWillBeginDragging:)]) {
                [rc_cell rc_scrollViewWillBeginDragging:scrollView];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) return;
    UITableView *tableView = (UITableView *)scrollView;
    for (UITableViewCell *cell in tableView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UITableViewCell<RCCellProtocol> *rc_cell = (UITableViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(rc_scrollViewDidScroll:)]) {
                [rc_cell rc_scrollViewDidScroll:scrollView];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isKindOfClass:[UITableView class]]) return;
    UITableView *tableView = (UITableView *)scrollView;
    for (UITableViewCell *cell in tableView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UITableViewCell<RCCellProtocol> *rc_cell = (UITableViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(rc_scrollViewDidEndDragging:willDecelerate:)]) {
                [rc_cell rc_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) return;
    UITableView *tableView = (UITableView *)scrollView;
    for (UITableViewCell *cell in tableView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UITableViewCell<RCCellProtocol> *rc_cell = (UITableViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
                [rc_cell rc_scrollViewDidEndDecelerating:scrollView];
            }
        }
    }
}

#pragma mark - Private
- (NSString *)reuseIdentifierForCellConfig:(id<RCCellConfigProtocol>)config{
    NSString *identifier;
    if (config && [config respondsToSelector:@selector(rc_cellReuseIdentifier)]) {
        identifier = config.rc_cellReuseIdentifier;
    }
    return identifier ?: NSStringFromClass(config.rc_cellClass);
}

- (NSString *)reuseIdentifierForHeaderFooterConfig:(id<RCHeaderFooterConfigProtocol>)config {
    NSString *identifier;
    if (config && [config respondsToSelector:@selector(rc_headerFooterReuseIdentifier)]) {
        identifier = config.rc_headerFooterReuseIdentifier;
    }
    return identifier ?: NSStringFromClass(config.rc_headerFooterClass);
}

- (UIView *)viewForHeaderFooterWithTableView:(UITableView *)tableView config:(id<RCHeaderFooterConfigProtocol>)config section:(NSInteger)section {
    if (!config) return nil;
    
    NSString *reuseIdentifier = [self reuseIdentifierForHeaderFooterConfig:config];
    UIView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if ([headerFooterView conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)headerFooterView;
        if ([rc_view respondsToSelector:@selector(rc_setHeaderFooterConfig:)]) {
            if ([rc_view respondsToSelector:@selector(rc_section)]) {
                rc_view.rc_section = section;
            }
            if ([rc_view respondsToSelector:@selector(rc_headerFooterConifg)]) {
                rc_view.rc_headerFooterConifg = config;
            }
            if ([rc_view respondsToSelector:@selector(rc_delegate)]) {
                rc_view.rc_delegate = self.cellDelegate;
            }
            [rc_view rc_setHeaderFooterConfig:config];
        }
    }
    return headerFooterView;
}


@end
