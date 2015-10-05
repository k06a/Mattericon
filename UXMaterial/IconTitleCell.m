//
//  ABCollectionViewCell.m
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 k06a. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "IconTitleCell.h"

@interface IconTitleCell ()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSData *svg;

@end

@implementation IconTitleCell

- (void)setItem:(id)item
{
    if (item == _item)
        return;
    
    _item = item;
    _svg = nil;
}

- (NSString *)fileName
{
    if (_fileName == nil)
        _fileName = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_black_48px.svg", self.item[@"id"]]];
    return _fileName;
}

- (NSData *)svg
{
    if (_svg == nil) {
        _svg = [NSData dataWithContentsOfFile:self.fileName];
        if (_svg)
            return _svg;
        
        _svg = (id)[NSNull null];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = [NSString stringWithFormat:@"https://storage.googleapis.com/material-icons/external-assets/v1/icons/svg/%@_black_48px.svg", self.item[@"id"]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            [data writeToFile:self.fileName atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                _svg = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            });
        });
    }
    return _svg;
}

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
            make.center.equalTo(self).centerOffset(CGPointMake(0,-12));
            make.size.mas_equalTo(CGSizeMake(60,60));
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.height.equalTo(@36);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
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

- (void)mouseDown:(NSEvent *)theEvent
{
    [self svg];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (self.svg == (id)[NSNull null])
        return;
        
    [self dragFile:self.fileName fromRect:NSMakeRect(self.bounds.size.width/2, self.bounds.size.height/2, 0, 0) slideBack:YES event:theEvent];
}

@end
