//
//  RCProxy.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCProxy : NSProxy

@property (nonatomic, strong, readonly) NSPointerArray *targets;

- (instancetype)initProxy;

- (void)addTarget:(id)target;

- (void)removeTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
