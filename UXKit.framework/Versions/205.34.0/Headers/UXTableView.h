//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <UXKit/UXCollectionView.h>
#import <UXKit/UXTableViewCell.h>

@class UXCollectionViewLayout;
@class UXTableView;

@protocol UXTableViewDataSource <NSObject>

- (NSInteger)tableView:(UXTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UXTableViewCell *)tableView:(UXTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInTableView:(UXTableView *)tableView;

- (BOOL)tableView:(UXTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UXTableView *)tableView commitEditingStyle:(NSInteger)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath; // TODO: enum

@end

@protocol UXTableViewDelegate <NSObject>
@optional
- (NSString *)tableView:(UXTableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSView *)tableView:(UXTableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (CGFloat)tableView:(UXTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UXTableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (BOOL)tableView:(UXTableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UXTableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UXTableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UXTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UXTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableView:(UXTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath; // TODO: enum
@end

@interface UXTableView : UXCollectionView

+ (NSUInteger)collectionViewScrollPositionFromScrollPosition:(NSInteger)arg1; // TODO: enums
@property (nonatomic) NSEdgeInsets separatorInset;
@property (nonatomic, copy) NSColor *separatorColor;
@property (nonatomic) NSInteger separatorStyle; // TODO: enum
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, weak) id <UXTableViewDelegate> tableViewDelegate;
@property (nonatomic, weak) id <UXTableViewDataSource> tableViewDataSource;
- (void)collectionView:(id)arg1 layout:(id)arg2 supplementaryViewDidEndFloatingAtIndexPath:(id)arg3 kind:(id)arg4;
- (void)collectionView:(id)arg1 layout:(id)arg2 supplementaryViewDidBeginFloatingAtIndexPath:(id)arg3 kind:(id)arg4;
- (CGSize)collectionView:(id)arg1 layout:(id)arg2 sizeForItemAtIndexPath:(id)arg3;
- (CGSize)collectionView:(id)arg1 layout:(id)arg2 referenceSizeForFooterInSection:(NSInteger)arg3;
- (CGSize)collectionView:(id)arg1 layout:(id)arg2 referenceSizeForHeaderInSection:(NSInteger)arg3;
- (void)collectionView:(id)arg1 itemWasRightClickedAtIndexPath:(id)arg2 withEvent:(id)arg3;
- (NSInteger)numberOfSectionsInCollectionView:(id)arg1;
- (id)collectionView:(id)arg1 cellForItemAtIndexPath:(id)arg2;
- (NSInteger)collectionView:(id)arg1 numberOfItemsInSection:(NSInteger)arg2;
- (id)collectionView:(id)arg1 viewForSupplementaryElementOfKind:(id)arg2 atIndexPath:(id)arg3;
- (void)deselectRowAtIndexPath:(id)arg1 animated:(BOOL)arg2;
- (void)selectRowAtIndexPath:(id)arg1 animated:(BOOL)arg2 scrollPosition:(NSInteger)arg3; // TODO: enum
- (id)indexPathForSelectedRow;
- (id)indexPathForClickedRow;
- (void)moveRowAtIndexPath:(id)arg1 toIndexPath:(id)arg2;
- (void)reloadRowsAtIndexPaths:(id)arg1 withRowAnimation:(NSInteger)arg2; // TODO: enum
- (void)deleteRowsAtIndexPaths:(id)arg1 withRowAnimation:(NSInteger)arg2; // TODO: enum
- (void)insertRowsAtIndexPaths:(id)arg1 withRowAnimation:(NSInteger)arg2; // TODO: enum
- (void)deleteSections:(id)arg1 withRowAnimation:(NSInteger)arg2; // TODO: enum
- (void)insertSections:(id)arg1 withRowAnimation:(NSInteger)arg2; // TODO: enum
- (void)endUpdates;
- (void)beginUpdates;
- (id)indexPathsForVisibleRows;
- (NSInteger)numberOfRowsInSection:(NSInteger)arg1;
- (id)dequeueReusableHeaderFooterViewWithReuseIdentifier:(id)arg1 forSection:(NSInteger)arg2;
- (id)dequeueReusableCellWithReuseIdentifier:(id)arg1 forIndexPath:(id)arg2;
- (id)dequeueReusableCellWithIdentifier:(id)arg1 forIndexPath:(id)arg2;
- (void)registerClass:(Class)arg1 forCellReuseIdentifier:(id)arg2;
- (id)cellForRowAtIndexPath:(id)arg1;
- (BOOL)overdrawEnabled;
- (void)setOverdrawEnabled:(BOOL)arg1;
@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

- (instancetype)initWithFrame:(CGRect)arg1 NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)arg1 style:(NSInteger)arg2; // TODO: enum
- (instancetype)initWithFrame:(CGRect)arg1 collectionViewLayout:(UXCollectionViewLayout *)arg2;

@end
