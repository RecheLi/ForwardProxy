//
//  NSObject+Next.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "NSObject+Next.h"

@implementation NSObject (Next)

- (id)then:(void(^)(id v))next {
    next(self);
    return self;
}

@end
