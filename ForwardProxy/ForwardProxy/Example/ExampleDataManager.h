//
//  ExampleDataManager.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExampleModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RCSection;

@interface ExampleDataManager : NSObject

- (void)getDataComletion:(void(^)(NSArray <RCSection *>*sections))completion;

@end

NS_ASSUME_NONNULL_END
