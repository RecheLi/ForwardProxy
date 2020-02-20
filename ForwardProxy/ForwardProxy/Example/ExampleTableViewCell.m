//
//  ExampleTableViewCell.m
//  ForwardProxy
//
//  Created by linitial on 2019/10/20.
//  Copyright © 2019 linitial. All rights reserved.
//

#import "ExampleTableViewCell.h"
#import "ExampleModel.h"
#import "RCCellConfig.h"

@interface ExampleTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) ExampleModel *exampleModel;

@end

@implementation ExampleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExampleModel:(ExampleModel *)exampleModel {
    _exampleModel = exampleModel;
    _detailLabel.text = _exampleModel.detail;
    _titleLabel.text = _exampleModel.title;
}

#pragma mark - RCCellProtocol
- (void)rc_setCellConfig:(id<RCCellConfigProtocol>)cellConfig {
    RCCellConfig *config = (RCCellConfig *)cellConfig;
    self.exampleModel = (ExampleModel *)config.model;
}

+ (CGSize)rc_sizeForCellWithConfig:(id<RCCellConfigProtocol>)cellConfig atIndexPath:(nullable NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.25);
}

- (void)rc_didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked indexpath : %@",indexPath);
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.frame = CGRectMake(10, 0, 200, 100);
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.frame = CGRectMake(10, 110, 200, 100);
    }
    return _detailLabel;
}

@end
