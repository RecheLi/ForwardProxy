//
//  RCTableViewImplement.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTableViewImplement : NSObject

@property (nonatomic, weak, nullable) id cellDelegate;

@property (nonatomic, copy) NSArray <RCSection *>*sections;

@end

NS_ASSUME_NONNULL_END
