//
//  ABFloatingTabs.m
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 @k06a. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "ABFloatingTabs.h"

@interface ABFloatingTabs ()

@property (nonatomic, strong) UXView *backImageView;

@end

@implementation ABFloatingTabs

- (void)labelClicked:(UXClickEventTracker *)tracker
{
    NSInteger index = [self.subviews indexOfObject:tracker.view] - 1;
    [self.delegate clickedTabAtIndex:index];
}

- (UXView *)backImageView
{
    if (_backImageView == nil) {
        _backImageView = [[UXView alloc] init];
        _backImageView.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.1];
        _backImageView.layer.cornerRadius = 8;
        _backImageView.layer.masksToBounds = YES;
        _backImageView.layer.borderColor = [NSColor grayColor].CGColor;
        _backImageView.layer.borderWidth = 0.2;
        
        [self addSubview:_backImageView];
    }
    return _backImageView;
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    
    self.backImageView = nil;
    for (NSView *view in self.subviews)
        [view removeFromSuperview];
    [self backImageView];
    
    UXLabel *prevLabel;
    for (NSString *title in titles) {
        UXLabel *label = [[UXLabel alloc] init];
        label.font = [NSFont systemFontOfSize:10];
        label.textColor = [NSColor colorWithWhite:88/255. alpha:0.75];
        [label addEventTracker:[[UXClickEventTracker alloc] initWithTarget:self action:@selector(labelClicked:)]];
        label.textColor = [NSColor blackColor];
        label.text = title;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (prevLabel == nil)
                make.leading.equalTo(@8);
            else
                make.left.equalTo(prevLabel.mas_right).with.offset(8);
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
        }];
        prevLabel = label;
    }
    [prevLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.lessThanOrEqualTo(@(-8));
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    //NSLog(@"index = %@", @(selectedIndex));
    _selectedIndex = selectedIndex;
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress
{
    //NSLog(@"progress = %@", @(progress));
    _progress = progress;
    [self setNeedsLayout];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    [self letsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self letsLayout];
}

- (void)letsLayout
{
    if (self.subviews.count <= 1)
        return;
    
    NSInteger fromIndex = self.selectedIndex+1;
    CGFloat fromOrigin = self.subviews[fromIndex].frame.origin.x - 4;
    CGFloat fromSize = self.subviews[fromIndex].frame.size.width + 8;
    
    NSInteger toIndex = fromIndex + (self.progress > 0 ? 1 : -1);
    CGFloat toOrigin = self.subviews[toIndex].frame.origin.x - 4;
    CGFloat toSize = self.subviews[toIndex].frame.size.width + 8;
    
    CGFloat moveOrigin = (toOrigin - fromOrigin)*self.progress;
    CGFloat moveSize = (toSize - fromSize)*self.progress;
    
    self.backImageView.frame = NSMakeRect(fromOrigin + moveOrigin, 4, fromSize + moveSize, self.bounds.size.height - 8);
}

@end
