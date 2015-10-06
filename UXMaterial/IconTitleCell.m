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
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@.%@", self.item[@"id"], [self.delegate color], [self.delegate size], [self.delegate format]]];
}

- (NSData *)svg
{
    if (_svg == nil) {
        NSData *dt = [NSData dataWithContentsOfFile:self.fileName];
        if (dt)
            return dt;
        
        _svg = (id)[NSNull null];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = [NSString stringWithFormat:@"https://storage.googleapis.com/material-icons/external-assets/v1/icons/%@/%@_%@_%@.%@", [self.delegate format], self.item[@"id"], [self.delegate color], [self.delegate size], [self.delegate format]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            [data writeToFile:self.fileName atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                _svg = nil;
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
        self.textIcon.lineBreakMode = NSLineBreakByClipping;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
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
        }
    }
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self svg];
    //self.backgroundColor = [NSColor colorWithWhite:240/255. alpha:1.0];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    //self.backgroundColor = [NSColor whiteColor];
}

/*
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    if (context == NSDraggingContextOutsideApplication)
        return NSDragOperationCopy;
    return NSDragOperationNone;
}

- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    self.backgroundColor = [NSColor whiteColor];
}*/

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (self.svg == (id)[NSNull null])
        return;
        
    [self dragFile:self.fileName fromRect:NSMakeRect(self.bounds.size.width/2, self.bounds.size.height/2, 0, 0) slideBack:YES event:theEvent];
}

- (void)viewDidMoveToSuperview
{
    [super viewDidMoveToSuperview];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.rasterizationScale = [NSScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}

@end
