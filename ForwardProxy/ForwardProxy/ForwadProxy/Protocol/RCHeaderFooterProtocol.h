//
//  RCHeaderFooterProtocol.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RCHeaderFooterConfigProtocol;

@protocol RCHeaderFooterProtocol <NSObject>

@property (nonatomic, assign) NSInteger rc_section;
@property (nonatomic, strong) id rc_delegate;
@property (nonatomic, strong) id<RCHeaderFooterConfigProtocol> rc_headerFooterConifg;

- (void)rc_setHeaderFooterConfig:(id<RCHeaderFooterConfigProtocol>)headerFooterConfig;

+ (CGFloat)rc_heightForHeaderFooterWithConfig:(id<RCHeaderFooterConfigProtocol>)headerFooterConfig
                                    inSection:(NSInteger)section;

- (void)rc_willDisplayHeaderFooterInSection:(NSInteger)section;

- (void)rc_didEndDisplayingHeaderFooterInSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
