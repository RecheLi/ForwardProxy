//
//  RCCellConfigProtocol.h
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RCCellProtocol;
@protocol RCCellConfigProtocol <NSObject>
@required
// cell类类型
- (Class<RCCellProtocol>)rc_cellClass;

@optional
- (NSString *)rc_cellReuseIdentifier;

// collectionView itemSize
// tableView height
- (CGSize)rc_itemSize;
@end

NS_ASSUME_NONNULL_END
