//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Oct  5 2015 02:41:00).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <UXKit/UXEventTracker.h>

@interface UXDragEventTracker : UXEventTracker
{
    struct CGPoint _currentPoint;
    struct CGPoint _previousPoint;
    BOOL _didBegin;
    double _trackingThreshold;
    struct CGPoint _initialPoint;
}

@property(readonly, nonatomic) struct CGPoint initialPoint; // @synthesize initialPoint=_initialPoint;
@property(nonatomic) double trackingThreshold; // @synthesize trackingThreshold=_trackingThreshold;
@property(readonly, nonatomic) struct CGPoint zeroingDelta;
@property(readonly, nonatomic) struct CGPoint delta;
- (void)mouseUp:(id)arg1;
- (void)mouseDragged:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)reset;
- (id)init;

@end

