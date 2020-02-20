//
//  NSObject+Next.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Next)

- (id)then:(void(^)(id v))next;

@end

NS_ASSUME_NONNULL_END
