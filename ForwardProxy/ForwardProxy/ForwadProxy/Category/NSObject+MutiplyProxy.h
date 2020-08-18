//
//  NSObject+MutiplyProxy.h
//  ForwardProxy
//
//  Created by linitial on 2020/08/18.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MutiplyProxy)

@property (nonatomic, strong) RCProxy *rcProxy;

- (void)bindProxies:(NSArray *)proxies;
- (void)bindProxy:(id)proxy;
- (void)removeProxy:(id)proxy;

@end

NS_ASSUME_NONNULL_END
