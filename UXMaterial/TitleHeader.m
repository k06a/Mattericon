//
//  HeaderView.m
//  UXMaterial
//
//  Created by Anton Bukov on 05.10.15.
//  Copyright © 2015 @k06a. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "TitleHeader.h"

@implementation TitleHeader

- (UXLabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UXLabel alloc] init];
        _titleLabel.textColor = [NSColor colorWithWhite:0x75/255. alpha:1.0];
        _titleLabel.centerVertically = YES;
        _titleLabel.font = [NSFont systemFontOfSize:20];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(NSEdgeInsetsMake(0, 8, 0, 0));
        }];
        
        self.backgroundColor = [NSColor colorWithWhite:220/255. alpha:1.0];
    }
    return _titleLabel;
}

@end
