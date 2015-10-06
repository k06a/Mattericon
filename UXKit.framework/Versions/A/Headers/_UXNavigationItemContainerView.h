//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Oct  5 2015 02:41:00).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <UXKit/UXView.h>

#import <UXKit/_UXBarItemsContainer-Protocol.h>

@class NSLayoutConstraint, NSMutableArray, NSMutableDictionary, NSString, NSView, UXImageView, UXNavigationBar, UXNavigationItem;

@interface _UXNavigationItemContainerView : UXView <_UXBarItemsContainer>
{
    UXImageView *_snaphotView;
    UXNavigationItem *_item;
    UXNavigationBar *_navigationBar;
    unsigned long long _state;
    double _minimumWidthForExpandedTitle;
    double _minimumWidthForExpandedItems;
    NSView *_leftView;
    NSMutableArray *_leftItemViews;
    NSView *_titleView;
    NSMutableArray *_rightItemViews;
    NSView *_rightView;
    NSMutableArray *_itemsSortedByPriority;
    NSMutableDictionary *_overflowItemsByMinimumWidth;
    NSMutableArray *_addedConstraints;
    NSLayoutConstraint *_titleCenteringConstraint;
    NSView *_titleCenteringConstrainedTitleView;
    NSView *_titleCenteringTrackedView;
    NSView *_titleCenteringConstraintOwnerView;
}

+ (id)layoutContainerForItem:(id)arg1 navigationBar:(id)arg2;
@property(nonatomic) __weak NSView *titleCenteringConstraintOwnerView; // @synthesize titleCenteringConstraintOwnerView=_titleCenteringConstraintOwnerView;
@property(nonatomic) __weak NSView *titleCenteringTrackedView; // @synthesize titleCenteringTrackedView=_titleCenteringTrackedView;
@property(nonatomic) __weak NSView *titleCenteringConstrainedTitleView; // @synthesize titleCenteringConstrainedTitleView=_titleCenteringConstrainedTitleView;
@property(retain, nonatomic) NSLayoutConstraint *titleCenteringConstraint; // @synthesize titleCenteringConstraint=_titleCenteringConstraint;
@property(retain, nonatomic) NSMutableArray *addedConstraints; // @synthesize addedConstraints=_addedConstraints;
@property(retain, nonatomic) NSMutableDictionary *overflowItemsByMinimumWidth; // @synthesize overflowItemsByMinimumWidth=_overflowItemsByMinimumWidth;
@property(retain, nonatomic) NSMutableArray *itemsSortedByPriority; // @synthesize itemsSortedByPriority=_itemsSortedByPriority;
@property(retain, nonatomic) NSView *rightView; // @synthesize rightView=_rightView;
@property(retain, nonatomic) NSMutableArray *rightItemViews; // @synthesize rightItemViews=_rightItemViews;
@property(retain, nonatomic) NSView *titleView; // @synthesize titleView=_titleView;
@property(retain, nonatomic) NSMutableArray *leftItemViews; // @synthesize leftItemViews=_leftItemViews;
@property(retain, nonatomic) NSView *leftView; // @synthesize leftView=_leftView;
@property(nonatomic) double minimumWidthForExpandedItems; // @synthesize minimumWidthForExpandedItems=_minimumWidthForExpandedItems;
@property(nonatomic) double minimumWidthForExpandedTitle; // @synthesize minimumWidthForExpandedTitle=_minimumWidthForExpandedTitle;
@property(nonatomic) unsigned long long state; // @synthesize state=_state;
@property(readonly, nonatomic) __weak UXNavigationBar *navigationBar; // @synthesize navigationBar=_navigationBar;
@property(readonly, nonatomic) UXNavigationItem *item; // @synthesize item=_item;

- (void)_updateItemsViews:(id)arg1 withNewViews:(id)arg2;
- (void)setTitleCenteringTrackedView:(id)arg1 updateConstraints:(BOOL)arg2;
- (void)layout;
- (void)updateConstraints;
- (id)hitTest:(struct CGPoint)arg1;
- (void)viewDidMoveToWindow;
- (void)viewWillMoveToWindow:(id)arg1;
- (id)subviewsIntersectedWithViews:(id)arg1 excludingHidden:(BOOL)arg2;
- (void)updateRightItemViewsAnimated:(BOOL)arg1;
- (void)updateLeftItemViewsAnimated:(BOOL)arg1;
- (void)_updateItemViews;
- (void)_updateItemsSortedByPriority;
- (void)_updateTitleView;
- (void)cancelTransistion;
- (void)prepareForTransistion;
- (id)init;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
@property(readonly) Class superclass;

@end
