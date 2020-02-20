//
//  RCCellProtocol.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RCCellConfigProtocol;
@protocol RCCellProtocol <NSObject>

@optional;

@property (nonatomic, strong) NSIndexPath *rc_indexPath;

@property (nonatomic, strong) id rc_delegate;

@property (nonatomic, strong) id<RCCellConfigProtocol> rc_cellConifg;

- (void)rc_setCellConfig:(id<RCCellConfigProtocol>)cellConfig;

+ (CGSize)rc_sizeForCellWithConfig:(id<RCCellConfigProtocol>)cellConfig atIndexPath:(nullable NSIndexPath *)indexPath;

- (void)rc_didSelectCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)rc_willDisplayCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)rc_didEndDisplayingCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)rc_scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)rc_scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)rc_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)rc_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;


@end

NS_ASSUME_NONNULL_END
