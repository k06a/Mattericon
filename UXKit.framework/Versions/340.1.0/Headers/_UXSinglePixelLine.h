//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Oct  5 2015 02:41:00).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <AppKit/NSView.h>

@class NSColor;

@interface _UXSinglePixelLine : NSView
{
    NSColor *_color;
}

@property(retain, nonatomic) NSColor *color; // @synthesize color=_color;

- (void)drawRect:(struct CGRect)arg1;
- (void)viewDidChangeBackingProperties;
- (void)viewDidMoveToSuperview;
- (void)updateHeight;

@end
