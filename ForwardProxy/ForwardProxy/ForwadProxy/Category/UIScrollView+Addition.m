//
//  UIScrollView+Addition.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "UIScrollView+Addition.h"
#import <objc/runtime.h>
#import "RCTableViewImplement.h"
#import "RCCollectionViewImplement.h"
#import "RCProxy.h"

static const void *kRCSectionsKey = &kRCSectionsKey;
static const void *kTVBForwardProxyKey = &kTVBForwardProxyKey;
static const void *kRCIMPKey = &kRCIMPKey;
static const void *kRCRefreshCellBlockKey = &kRCRefreshCellBlockKey;
static const void *kRCDidSelectCellBlockKey = &kRCDidSelectCellBlockKey;
static const void *kRCRefreshHeaderBlockKey = &kRCRefreshHeaderBlockKey;
static const void *kRCRefresrcooterBlockKey = &kRCRefresrcooterBlockKey;
static const void *kRCWillDispalyCellBlockKey = &kRCWillDispalyCellBlockKey;
static const void *kRCDidEndDispalyingCellBlockKey = &kRCDidEndDispalyingCellBlockKey;

@interface UIScrollView ()

@property (nonatomic, strong) RCProxy *rcProxy;

@property (nonatomic, strong) RCTableViewImplement *tableViewImp;

@property (nonatomic, strong) RCCollectionViewImplement *collectionViewImp;
@end

@implementation UIScrollView (Addition)

static void rc_dispatch_main_async_safely(dispatch_block_t block) {
    if ([[NSThread currentThread]isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)rc_asycBuildSections:(NSArray<RCSection *> *(^)(void))buildBlock
        onMainLoopCompletion:(void(^)(void))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *sections = buildBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rc_sections = sections;
            if (completion) {
                completion();
            }
        });
    });
}

- (void)rc_addObjectsFromSections:(NSArray<RCSection *> *)sections {
    rc_dispatch_main_async_safely(^{
        [self rc_registerClassForSections:sections];
        NSMutableArray *rc_sections = [NSMutableArray arrayWithArray:self.rc_sections];
        [rc_sections addObjectsFromArray:sections];
        NSArray *rc_arr = [rc_sections copy];
        objc_setAssociatedObject(self, kRCSectionsKey, rc_arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if ([self isKindOfClass:[UITableView class]]) {
            self.tableViewImp.sections = rc_arr;
        }
        if ([self isKindOfClass:[UICollectionView class]]) {
            self.collectionViewImp.sections = rc_arr;
        }
    });
}

- (void)rc_deleteSectionAtIndex:(NSInteger)index {
    rc_dispatch_main_async_safely(^{
        NSMutableArray *rc_sections = [NSMutableArray arrayWithArray:self.rc_sections];
        [rc_sections removeObjectAtIndex:index];
        NSArray *rc_arr = [rc_sections copy];
        objc_setAssociatedObject(self, kRCSectionsKey, rc_arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if ([self isKindOfClass:[UITableView class]]) {
            self.tableViewImp.sections = rc_arr;
        }
        if ([self isKindOfClass:[UICollectionView class]]) {
            self.collectionViewImp.sections = rc_arr;
        }
    });
}

- (void)rc_insertSection:(RCSection *)secton atIndex:(NSInteger)index {
    rc_dispatch_main_async_safely(^{
        [self rc_registerClassForSections:@[secton]];
        NSMutableArray *rc_sections = [NSMutableArray arrayWithArray:self.rc_sections];
        [rc_sections insertObject:secton atIndex:index];
        NSArray *rc_arr = [rc_sections copy];
        objc_setAssociatedObject(self, kRCSectionsKey, rc_arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if ([self isKindOfClass:[UITableView class]]) {
            self.tableViewImp.sections = rc_arr;
        }
        if ([self isKindOfClass:[UICollectionView class]]) {
            self.collectionViewImp.sections = rc_arr;
        }
    });
}

- (void)rc_replaceSection:(RCSection *)secton atIndex:(NSInteger)index {
    rc_dispatch_main_async_safely(^{
        [self rc_registerClassForSections:@[secton]];
        NSMutableArray *rc_sections = [NSMutableArray arrayWithArray:self.rc_sections];
        [rc_sections replaceObjectAtIndex:index withObject:secton];
        NSArray *rc_arr = [rc_sections copy];
        objc_setAssociatedObject(self, kRCSectionsKey, rc_arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if ([self isKindOfClass:[UITableView class]]) {
            self.tableViewImp.sections = rc_arr;
        }
        if ([self isKindOfClass:[UICollectionView class]]) {
            self.collectionViewImp.sections = rc_arr;
        }
    });
}

- (void)rc_addDelegate:(id)delegate {
    [self.rcProxy addTarget:delegate];
}

- (void)rc_addDataSource:(id)dataSource {
    [self.rcProxy addTarget:dataSource];
}

- (void)rc_bindCellDelegate:(id)cellDelegate {
    if ([self isKindOfClass:[UITableView class]]) {
        self.tableViewImp.cellDelegate = cellDelegate;
    }
    if ([self isKindOfClass:[UICollectionView class]]) {
        self.collectionViewImp.cellDelegate = cellDelegate;
    }
}

- (void)rc_registerClassForSections:(NSArray *)sections {
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableViewSelf = (UITableView *)self;
        for (RCSection *section in sections) {
            for (id<RCCellConfigProtocol> config in section.configs) {
                [tableViewSelf registerClass:config.rc_cellClass forCellReuseIdentifier:[self reuseIdentifierForCellConfig:config]];
            }
            id<RCHeaderFooterConfigProtocol> headerConfig = section.header;
            if (headerConfig) {
                [tableViewSelf registerClass:headerConfig.rc_headerFooterClass forHeaderFooterViewReuseIdentifier:[self reuseIdentifierForHeaderFooterConfig:headerConfig]];
            }
            id<RCHeaderFooterConfigProtocol> footerConfig = section.footer;
            if (footerConfig) {
                [tableViewSelf registerClass:footerConfig.rc_headerFooterClass forHeaderFooterViewReuseIdentifier:[self reuseIdentifierForHeaderFooterConfig:footerConfig]];
            }
        }
        [tableViewSelf registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionViewSelf = (UICollectionView *)self;
        for (RCSection *section in sections) {
            for (id<RCCellConfigProtocol> config in section.configs) {
                [collectionViewSelf registerClass:config.rc_cellClass forCellWithReuseIdentifier:[self reuseIdentifierForCellConfig:config]];
            }
            id<RCHeaderFooterConfigProtocol> headerConfig = section.header;
            if (headerConfig) {
                [collectionViewSelf registerClass:headerConfig.rc_headerFooterClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[self reuseIdentifierForHeaderFooterConfig:headerConfig]];
            }
            
            id<RCHeaderFooterConfigProtocol> footerConfig = section.footer;
            if (footerConfig) {
                [collectionViewSelf registerClass:footerConfig.rc_headerFooterClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[self reuseIdentifierForHeaderFooterConfig:footerConfig]];
            }
        }
        [collectionViewSelf registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
}

#pragma mark - Getter & Setter

- (void)setRc_singleConfigs:(NSArray<id<RCCellConfigProtocol>> *)rc_singleConfigs {
    RCSection *section = [[RCSection alloc] init];
    section.configs = rc_singleConfigs;
    
    self.rc_sections = @[section];
}

- (NSArray<id<RCCellConfigProtocol>> *)rc_singleConfigs {
    return self.rc_sections.firstObject.configs;
}

- (void)setRc_sections:(NSArray<RCSection *> *)rc_sections {
    if (!rc_sections) {
           rc_sections = @[];
       }
       objc_setAssociatedObject(self, kRCSectionsKey, rc_sections, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       __weak typeof(self) weakSelf =self;
       rc_dispatch_main_async_safely(^{
           __strong typeof(weakSelf) strongSelf = weakSelf;
           if ([strongSelf isKindOfClass:[UITableView class]]) {
               strongSelf.tableViewImp.sections = rc_sections;
               [strongSelf.rcProxy addTarget:strongSelf.tableViewImp];
               UITableView *tableViewSelf = (UITableView *)strongSelf;
               tableViewSelf.delegate = (id<UITableViewDelegate>)strongSelf.rcProxy;
               tableViewSelf.dataSource = (id<UITableViewDataSource>)strongSelf.rcProxy;
           }
           if ([strongSelf isKindOfClass:[UICollectionView class]]) {
               strongSelf.collectionViewImp.sections = rc_sections;
               [strongSelf.rcProxy addTarget:strongSelf.collectionViewImp];
               UICollectionView *collectionViewSelf = (UICollectionView *)strongSelf;
               collectionViewSelf.delegate = (id<UICollectionViewDelegate>)strongSelf.rcProxy;
               collectionViewSelf.dataSource = (id<UICollectionViewDataSource>)strongSelf.rcProxy;
           }
           [self rc_registerClassForSections:rc_sections];
       });
}

- (NSArray<RCSection *> *)rc_sections {
    return objc_getAssociatedObject(self, kRCSectionsKey);
}

- (void)setRcProxy:(RCProxy *)rcProxy {
    objc_setAssociatedObject(self, kTVBForwardProxyKey, rcProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RCProxy *)rcProxy {
    RCProxy *proxy = objc_getAssociatedObject(self, kTVBForwardProxyKey);
    if (!proxy) {
        proxy = [[RCProxy alloc]initProxy];
        self.rcProxy = proxy;
    }
    return proxy;
}

- (void)setTableViewIMP:(RCTableViewImplement *)tableViewImp {
    objc_setAssociatedObject(self, kRCIMPKey, tableViewImp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RCTableViewImplement *)tableViewImp {
    RCTableViewImplement *imp = objc_getAssociatedObject(self, kRCIMPKey);
    if (!imp) {
        imp = [[RCTableViewImplement alloc] init];
        self.tableViewIMP = imp;
    }
    return imp;
}

- (void)setCollectionViewIMP:(RCCollectionViewImplement *)collectionViewImp {
    objc_setAssociatedObject(self, kRCIMPKey, collectionViewImp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RCCollectionViewImplement *)collectionViewImp {
    RCCollectionViewImplement *imp = objc_getAssociatedObject(self, kRCIMPKey);
    if (!imp) {
        imp = [[RCCollectionViewImplement alloc] init];
        self.collectionViewImp = imp;
    }
    return imp;
}

- (void)setRc_refreshCellBlock:(void (^)(UIView * _Nonnull, NSIndexPath * _Nonnull))rc_refreshCellBlock {
    objc_setAssociatedObject(self, kRCRefreshCellBlockKey, rc_refreshCellBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView *, NSIndexPath *))rc_refreshCellBlock {
    return objc_getAssociatedObject(self, kRCRefreshCellBlockKey);
}

- (void)setRc_didSelectCellBlock:(void (^)(UIView *, NSIndexPath *))rc_didSelectCellBlock {
    objc_setAssociatedObject(self, kRCDidSelectCellBlockKey, rc_didSelectCellBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView *, NSIndexPath *))rc_didSelectCellBlock {
    return objc_getAssociatedObject(self, kRCDidSelectCellBlockKey);
}

- (void)setRc_refreshHeaderBlock:(void (^)(UIView *, NSIndexPath *))rc_refreshHeaderBlock {
    objc_setAssociatedObject(self, kRCRefreshHeaderBlockKey, rc_refreshHeaderBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView *, NSIndexPath *))rc_refreshHeaderBlock {
    return objc_getAssociatedObject(self, kRCRefreshHeaderBlockKey);
}

- (void)setRc_refresrcooterBlock:(void (^)(UIView *, NSIndexPath *))rc_refresrcooterBlock {
    objc_setAssociatedObject(self, kRCRefresrcooterBlockKey, rc_refresrcooterBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView *, NSIndexPath *))rc_refresrcooterBlock {
    return objc_getAssociatedObject(self, kRCRefresrcooterBlockKey);
}

- (void)setRc_willDisplayCellBlock:(void (^)(UIView *, NSIndexPath *))rc_willDisplayCellBlock {
    objc_setAssociatedObject(self, kRCWillDispalyCellBlockKey, rc_willDisplayCellBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView *, NSIndexPath *))rc_willDisplayCellBlock {
    return objc_getAssociatedObject(self, kRCWillDispalyCellBlockKey);
}

- (void)setRc_didEndDisplayingCellBlock:(void (^)(UIView *, NSIndexPath *))rc_didEndDisplayingCellBlock {
    objc_setAssociatedObject(self, kRCDidEndDispalyingCellBlockKey, rc_didEndDisplayingCellBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView *, NSIndexPath *))rc_didEndDisplayingCellBlock {
    return objc_getAssociatedObject(self, kRCDidEndDispalyingCellBlockKey);
}

#pragma mark - Private
- (NSString *)reuseIdentifierForCellConfig:(id<RCCellConfigProtocol>)config {
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

@end
