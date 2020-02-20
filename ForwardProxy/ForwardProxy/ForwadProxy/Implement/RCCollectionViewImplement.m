//
//  RCCollectionViewImplement.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "RCCollectionViewImplement.h"
#import "UIScrollView+Addition.h"

@implementation RCCollectionViewImplement

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sections[section].configs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections.count == 0) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    }
    RCSection *section = self.sections[indexPath.section];
    id<RCCellConfigProtocol> config = section.configs[indexPath.item];
    
    NSString *reuseIdentifier = [self reuseIdentifierForCellConfig:config];
    
    UICollectionViewCell *cell;
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UICollectionViewCell<RCCellProtocol> *rc_cell = (UICollectionViewCell<RCCellProtocol> *)cell;
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
    
    if (collectionView.rc_refreshCellBlock) {
        collectionView.rc_refreshCellBlock(cell, indexPath);
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    id<RCHeaderFooterConfigProtocol> config;
    if (kind == UICollectionElementKindSectionHeader) {
        config = self.sections[indexPath.section].header;
    } else if (kind == UICollectionElementKindSectionFooter){
        config = self.sections[indexPath.section].footer;
    }
    if (!config) return nil;
    
    NSString *reuseIdentifier = [self reuseIdentifierForHeaderFooterConfig:config];
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([view conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)view;
        if ([rc_view respondsToSelector:@selector(rc_section)]) {
            rc_view.rc_section = indexPath.section;
        }
        if ([rc_view respondsToSelector:@selector(rc_headerFooterConifg)]) {
            rc_view.rc_headerFooterConifg = config;
        }
        if ([rc_view respondsToSelector:@selector(rc_delegate)]) {
            rc_view.rc_delegate = self.cellDelegate;
        }
        if ([rc_view respondsToSelector:@selector(rc_setHeaderFooterConfig:)]) {
            [rc_view rc_setHeaderFooterConfig:config];
        }
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (collectionView.rc_refreshHeaderBlock) {
            collectionView.rc_refreshHeaderBlock(view, indexPath);
        }
    } else if (kind == UICollectionElementKindSectionFooter){
        if (collectionView.rc_refresrcooterBlock) {
            collectionView.rc_refresrcooterBlock(view, indexPath);
        }
    }
    
    return view;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UIView<RCCellProtocol> *rc_cell = (UIView<RCCellProtocol> *)cell;
        if ([rc_cell respondsToSelector:@selector(rc_didSelectCellAtIndexPath:)]) {
            [rc_cell rc_didSelectCellAtIndexPath:indexPath];
        }
    }
    if (collectionView.rc_didSelectCellBlock) {
        collectionView.rc_didSelectCellBlock(cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UIView<RCCellProtocol> *rc_cell = (UIView<RCCellProtocol> *)cell;
        if ([rc_cell respondsToSelector:@selector(rc_willDisplayCellAtIndexPath:)]) {
            [rc_cell rc_willDisplayCellAtIndexPath:indexPath];
        }
    }
    if (collectionView.rc_willDisplayCellBlock) {
        collectionView.rc_willDisplayCellBlock(cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
        UIView<RCCellProtocol> *rc_cell = (UIView<RCCellProtocol> *)cell;
        if ([rc_cell respondsToSelector:@selector(rc_didEndDisplayingCellAtIndexPath:)]) {
            [rc_cell rc_didEndDisplayingCellAtIndexPath:indexPath];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([view conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)view;
        if ([rc_view respondsToSelector:@selector(rc_willDisplayHeaderFooterInSection:)]) {
            [rc_view rc_willDisplayHeaderFooterInSection:indexPath.section];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([view conformsToProtocol:@protocol(RCHeaderFooterProtocol)]) {
        UIView<RCHeaderFooterProtocol> *rc_view = (UIView<RCHeaderFooterProtocol> *)view;
        if ([rc_view respondsToSelector:@selector(rc_didEndDisplayingHeaderFooterInSection:)]) {
            [rc_view rc_didEndDisplayingHeaderFooterInSection:indexPath.section];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.sections.count) return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.1);
    RCSection *section = self.sections[indexPath.section];
    
    if (indexPath.item >= section.configs.count) return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.1);
    id<RCCellConfigProtocol> config = section.configs[indexPath.item];
    
    if (config && [config respondsToSelector:@selector(rc_itemSize)]) {
        if (!CGSizeEqualToSize(config.rc_itemSize, CGSizeZero) ) {
            return config.rc_itemSize;
        }
    }
    if ([config.rc_cellClass respondsToSelector:@selector(rc_sizeForCellWithConfig:atIndexPath:)]) {
        return [config.rc_cellClass rc_sizeForCellWithConfig:config atIndexPath:indexPath];
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    id<RCHeaderFooterConfigProtocol> config = self.sections[section].header;
    if (config && [config respondsToSelector:@selector(rc_height)]) {
        if (config.rc_height > 0) {
            return CGSizeMake(MAXFLOAT, config.rc_height);
        }
    }
    if ([config.rc_headerFooterClass respondsToSelector:@selector(rc_heightForHeaderFooterWithConfig:inSection:)]) {
        return CGSizeMake(MAXFLOAT, [config.rc_headerFooterClass rc_heightForHeaderFooterWithConfig:config inSection:section]);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    id<RCHeaderFooterConfigProtocol> config = self.sections[section].footer;
    if (config && [config respondsToSelector:@selector(rc_height)]) {
        if (config.rc_height > 0) {
            return CGSizeMake(MAXFLOAT, config.rc_height);
        }
    }
    if ([config.rc_headerFooterClass respondsToSelector:@selector(rc_heightForHeaderFooterWithConfig:inSection:)]) {
        return CGSizeMake(MAXFLOAT, [config.rc_headerFooterClass rc_heightForHeaderFooterWithConfig:config inSection:section]);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    RCSection *rc_section = self.sections[section];
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
        if (!UIEdgeInsetsEqualToEdgeInsets(flowLayout.sectionInset, UIEdgeInsetsZero)) {
            return flowLayout.sectionInset;
        }
    }
    return rc_section.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    RCSection *rc_section = self.sections[section];
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
        if (flowLayout.minimumLineSpacing != 0) {
            return flowLayout.minimumLineSpacing;
        }
    }
    return rc_section.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    RCSection *rc_section = self.sections[section];
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
        if (flowLayout.minimumInteritemSpacing != 0) {
            return flowLayout.minimumInteritemSpacing;
        }
    }
    return rc_section.minimumInteritemSpacing;
}

#pragma nark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UICollectionViewCell<RCCellProtocol> *rc_cell = (UICollectionViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(rc_scrollViewWillBeginDragging:)]) {
                [rc_cell rc_scrollViewWillBeginDragging:scrollView];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UICollectionViewCell<RCCellProtocol> *rc_cell = (UICollectionViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(rc_scrollViewDidScroll:)]) {
                [rc_cell rc_scrollViewDidScroll:scrollView];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UICollectionViewCell<RCCellProtocol> *rc_cell = (UICollectionViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(rc_scrollViewDidEndDragging:willDecelerate:)]) {
                [rc_cell rc_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        if ([cell conformsToProtocol:@protocol(RCCellProtocol)]) {
            UICollectionViewCell<RCCellProtocol> *rc_cell = (UICollectionViewCell<RCCellProtocol> *)cell;
            if ([rc_cell respondsToSelector:@selector(rc_scrollViewDidEndDecelerating:)]) {
                [rc_cell rc_scrollViewDidEndDecelerating:scrollView];
            }
        }
    }
}

#pragma mark - Private Method

- (NSString *)reuseIdentifierForCellConfig:(id<RCCellConfigProtocol>)config
{
    NSString *identifier;
    if (config && [config respondsToSelector:@selector(rc_cellReuseIdentifier)]) {
        identifier = config.rc_cellReuseIdentifier;
    }
    return identifier ?: NSStringFromClass(config.rc_cellClass);
}

- (NSString *)reuseIdentifierForHeaderFooterConfig:(id<RCHeaderFooterConfigProtocol>)config
{
    NSString *identifier;
    if (config && [config respondsToSelector:@selector(rc_headerFooterReuseIdentifier)]) {
        identifier = config.rc_headerFooterReuseIdentifier;
    }
    return identifier ?: NSStringFromClass(config.rc_headerFooterClass);
}


@end
