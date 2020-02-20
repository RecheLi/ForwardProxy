//
//  RCHeaderFooterConfig.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCHeaderFooterProtocol.h"
#import "RCHeaderFooterConfigProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCHeaderFooterConfig : NSObject <RCHeaderFooterConfigProtocol>

@property (nonatomic, strong, nullable) id model;

// header/footer 类类型
@property (nonatomic, strong, nonnull) Class<RCHeaderFooterProtocol> headerFooterClass;

#pragma mark - optional

// 复用Identifier
@property (nonatomic, strong, nullable) NSString *headerFooterReuseIdentifier;

// header/footer height
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
