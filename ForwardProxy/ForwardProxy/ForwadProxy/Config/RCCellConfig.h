//
//  RCCellConfig.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCCellProtocol.h"
#import "RCCellConfigProtocol.h"
#import "RCSection.h"


NS_ASSUME_NONNULL_BEGIN

@interface RCCellConfig : NSObject <RCCellConfigProtocol>

@property (nonatomic, strong, nullable) id model;

// Cell类类型
@property (nonatomic, strong, nonnull) Class<RCCellProtocol> cellClass;

// Cell缓存
@property (nonatomic, strong, nullable) UICollectionViewCell *cacheCell;

// 复用Identifier
@property (nonatomic, strong, nullable) NSString *cellReuseIdentifier;

// CollectionViewCell itemSize
// TableViewCell height
@property (nonatomic, assign) CGSize itemSize;

// 子配置数据, cell里面又有一个表
@property (nonatomic, copy) NSArray<id<RCCellConfigProtocol>> *subConfigs;
@property (nonatomic, copy) NSArray<RCSection *> *subSections;

@end

NS_ASSUME_NONNULL_END
