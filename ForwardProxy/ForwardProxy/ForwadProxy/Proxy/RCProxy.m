//
//  RCProxy.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "RCProxy.h"

@interface RCProxy ()
{
    dispatch_semaphore_t _lock;
}

@end

@implementation RCProxy

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s",__PRETTY_FUNCTION__);
#endif
}


- (instancetype)initProxy {
    _lock = dispatch_semaphore_create(1);
    _targets = [NSPointerArray weakObjectsPointerArray];
    return self;
}

- (void)addTarget:(id)target {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_targets addPointer:NULL];
    [_targets compact];
    for (id t in _targets) {
        if (t == target) {
            dispatch_semaphore_signal(_lock);
            return;
        }
    }
    [_targets addPointer:(__bridge void * _Nullable)(target)];
    dispatch_semaphore_signal(_lock);
}

- (void)removeTarget:(id)target {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_targets addPointer:NULL];
    [_targets compact];
    for (NSUInteger i = 0; i < _targets.count; i++) {
        if ([_targets pointerAtIndex:i] == (__bridge void * _Nullable)(target)) {
            [_targets removePointerAtIndex:i];
            dispatch_semaphore_signal(_lock);
            return;
        }
    }
    dispatch_semaphore_signal(_lock);

}

#pragma mark - Forward
- (BOOL)respondsToSelector:(SEL)aSelector {
    for (id target in _targets) {
        if ([target respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature;
    for (id target in _targets) {
        signature = [target methodSignatureForSelector:aSelector];
        if (signature) break;
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id target in _targets) {
        if ([target respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:target];
        }
    }
}

@end
