//
//  RCHeaderFooterConfigProtocol.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCHeaderFooterProtocol;

@protocol RCHeaderFooterConfigProtocol <NSObject>

@required
// header/footer类类型
- (Class<RCHeaderFooterProtocol>)rc_headerFooterClass;

@optional
// 复用Identifier
- (NSString *)rc_headerFooterReuseIdentifier;

// header/footer 高度
- (CGFloat)rc_height;

@end

NS_ASSUME_NONNULL_END
