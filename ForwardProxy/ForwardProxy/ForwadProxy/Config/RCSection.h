//
//  RCSection.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCHeaderFooterConfigProtocol.h"
#import "RCCellConfigProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSection : NSObject

@property (nonatomic, copy) NSArray<id<RCCellConfigProtocol>> *configs;

@property (nonatomic, strong, nullable) id<RCHeaderFooterConfigProtocol> header;

@property (nonatomic, strong, nullable) id<RCHeaderFooterConfigProtocol> footer;

@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@end

NS_ASSUME_NONNULL_END
