//
//  CHRLoopViewCell.m
//
//  Created by  on 15/6/14.
//  Copyright © 2015年 chenhongrong. All rights reserved.
//


#import "CHRLoopViewCell.h"
#import "UIImageView+WebCache.h"

@interface CHRLoopViewCell()

@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation CHRLoopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
    }
    return self;
}

- (void)setURL:(NSURL *)URL {
    _URL = URL;
    [self.iconView sd_setImageWithURL:URL];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.frame = self.bounds;
}

@end
