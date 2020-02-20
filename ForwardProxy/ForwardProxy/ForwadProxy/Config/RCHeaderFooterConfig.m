//
//  RCHeaderFooterConfig.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "RCHeaderFooterConfig.h"

@implementation RCHeaderFooterConfig

- (Class<RCHeaderFooterProtocol>)rc_headerFooterClass {
    return self.headerFooterClass;
}

- (NSString *)rc_headerFooterReuseIdentifier {
    return self.headerFooterReuseIdentifier ?: NSStringFromClass([self.headerFooterClass class]);
}

- (CGFloat)rc_height {
    return self.height;
}
@end
