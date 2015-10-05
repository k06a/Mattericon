//
//  ABCollectionViewCell.m
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 k06a. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "IconTitleCell.h"

@implementation IconTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Create
        self.textIcon = [[UXLabel alloc] init];
        self.textLabel = [[UXLabel alloc] init];
        [self.contentView addSubview:self.textIcon];
        [self.contentView addSubview:self.textLabel];
        
        // Layout
        [self.textIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self).centerOffset(CGPointMake(0,-10));
            make.size.mas_equalTo(CGSizeMake(60,60));
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-3));
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.height.equalTo(@30);
        }];
        
        // Configure
        for (UXLabel *label in @[self.textIcon,self.textLabel]) {
            label.centerVertically = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [NSColor colorWithWhite:0x75/255. alpha:1.0];
            label.lineBreakMode = NSLineBreakByWordWrapping;
        }
    }
    return self;
}

@end
