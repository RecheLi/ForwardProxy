//
//  NSObject+MutiplyProxy.h
//  ForwardProxy
//
//  Created by linitial on 2020/08/18.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "NSObject+MutiplyProxy.h"
#import <objc/runtime.h>

static void bind_proxy_in_main_thread_safely(dispatch_block_t block) {
    if (![[NSThread currentThread]isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),^{
            block();
        });
        return;
    }
    block();
}

@interface NSObject ()

@end

static void *kMutiplyProxy = &kMutiplyProxy;

@implementation NSObject (MutiplyProxy)

- (void)bindProxies:(NSArray *)proxies {
    bind_proxy_in_main_thread_safely(^{
        if (proxies.count==0) return;
        for (id proxy in proxies) {
            [self.rcProxy addTarget:proxy];
        }
    });
}

- (void)bindProxy:(id)proxy {
    bind_proxy_in_main_thread_safely(^{
        [self.rcProxy addTarget:proxy];
    });
}

- (void)removeProxy:(id)proxy {
    bind_proxy_in_main_thread_safely(^{
        [self.rcProxy removeTarget:proxy];
    });
}

- (void)setRcProxy:(RCProxy *)rcProxy {
    objc_setAssociatedObject(self, kMutiplyProxy, rcProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RCProxy *)rcProxy {
    RCProxy *proxy = objc_getAssociatedObject(self, kMutiplyProxy);
    if (!proxy) {
        proxy = [[RCProxy alloc]initProxy];
        self.rcProxy = proxy;
    }
    return proxy;
}

@end
