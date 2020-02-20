//
//  RCCellConfig.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "RCCellConfig.h"

@implementation RCCellConfig

- (Class<RCCellProtocol>)rc_cellClass {
    return self.cellClass;
}

- (NSString *)rc_cellReuseIdentifier {
    return self.cellReuseIdentifier ?: NSStringFromClass([self.cellClass class]);
}

- (CGSize)rc_itemSize {
    return self.itemSize;
}


@end
