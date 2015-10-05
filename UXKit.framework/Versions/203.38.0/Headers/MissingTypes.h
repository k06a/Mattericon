//
//  MissingTypes.h
//  UXKitTest
//
//  Created by Michał Kałużny on 06.02.2015.
//  Copyright (c) 2015 justmaku. All rights reserved.
//

#ifndef UXKitTest_MissingTypes_h
#define UXKitTest_MissingTypes_h

#import <UXKit/UXBarPositioningDelegate-Protocol.h>

@protocol UXNavigationBarDelegate <UXBarPositioningDelegate>
@optional
-(BOOL)navigationBar:(id)arg1 shouldPushItem:(id)arg2;
-(void)navigationBar:(id)arg1 didPushItem:(id)arg2;
-(BOOL)navigationBar:(id)arg1 shouldPopItem:(id)arg2;
-(void)navigationBar:(id)arg1 didPopItem:(id)arg2;
@end

@protocol UXTableViewDataSource <NSObject>
@optional
-(NSInteger)numberOfSectionsInTableView:(id)arg1;
-(id)tableView:(id)arg1 titleForHeaderInSection:(NSInteger)arg2;
-(id)tableView:(id)arg1 titleForFooterInSection:(NSInteger)arg2;
-(BOOL)tableView:(id)arg1 canEditRowAtIndexPath:(id)arg2;
-(BOOL)tableView:(id)arg1 canMoveRowAtIndexPath:(id)arg2;
-(id)sectionIndexTitlesForTableView:(id)arg1;
-(NSInteger)tableView:(id)arg1 sectionForSectionIndexTitle:(id)arg2 atIndex:(NSInteger)arg3;
-(void)tableView:(id)arg1 commitEditingStyle:(NSInteger)arg2 forRowAtIndexPath:(id)arg3;
-(void)tableView:(id)arg1 moveRowAtIndexPath:(id)arg2 toIndexPath:(id)arg3;

@required
-(NSInteger)tableView:(id)arg1 numberOfRowsInSection:(NSInteger)arg2;
-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
@end

@protocol UXTableViewDelegate <NSObject>
@optional
-(void)tableView:(id)arg1 willDisplayCell:(id)arg2 forRowAtIndexPath:(id)arg3;
-(void)tableView:(id)arg1 willDisplayHeaderView:(id)arg2 forSection:(NSInteger)arg3;
-(void)tableView:(id)arg1 willDisplayFooterView:(id)arg2 forSection:(NSInteger)arg3;
-(void)tableView:(id)arg1 didEndDisplayingCell:(id)arg2 forRowAtIndexPath:(id)arg3;
-(void)tableView:(id)arg1 didEndDisplayingHeaderView:(id)arg2 forSection:(NSInteger)arg3;
-(void)tableView:(id)arg1 didEndDisplayingFooterView:(id)arg2 forSection:(NSInteger)arg3;
-(double)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2;
-(double)tableView:(id)arg1 heightForHeaderInSection:(NSInteger)arg2;
-(double)tableView:(id)arg1 heightForFooterInSection:(NSInteger)arg2;
-(double)tableView:(id)arg1 estimatedHeightForRowAtIndexPath:(id)arg2;
-(double)tableView:(id)arg1 estimatedHeightForHeaderInSection:(NSInteger)arg2;
-(double)tableView:(id)arg1 estimatedHeightForFooterInSection:(NSInteger)arg2;
-(id)tableView:(id)arg1 viewForHeaderInSection:(NSInteger)arg2;
-(id)tableView:(id)arg1 viewForFooterInSection:(NSInteger)arg2;
-(NSInteger)tableView:(id)arg1 accessoryTypeForRowWithIndexPath:(id)arg2;
-(void)tableView:(id)arg1 accessoryButtonTappedForRowWithIndexPath:(id)arg2;
-(BOOL)tableView:(id)arg1 shouldHighlightRowAtIndexPath:(id)arg2;
-(void)tableView:(id)arg1 didHighlightRowAtIndexPath:(id)arg2;
-(void)tableView:(id)arg1 didUnhighlightRowAtIndexPath:(id)arg2;
-(id)tableView:(id)arg1 willSelectRowAtIndexPath:(id)arg2;
-(id)tableView:(id)arg1 willDeselectRowAtIndexPath:(id)arg2;
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;
-(void)tableView:(id)arg1 didDeselectRowAtIndexPath:(id)arg2;
-(NSInteger)tableView:(id)arg1 editingStyleForRowAtIndexPath:(id)arg2;
-(id)tableView:(id)arg1 titleForDeleteConfirmationButtonForRowAtIndexPath:(id)arg2;
-(id)tableView:(id)arg1 editActionsForRowAtIndexPath:(id)arg2;
-(BOOL)tableView:(id)arg1 shouldIndentWhileEditingRowAtIndexPath:(id)arg2;
-(void)tableView:(id)arg1 willBeginEditingRowAtIndexPath:(id)arg2;
-(void)tableView:(id)arg1 didEndEditingRowAtIndexPath:(id)arg2;
-(id)tableView:(id)arg1 targetIndexPathForMoveFromRowAtIndexPath:(id)arg2 toProposedIndexPath:(id)arg3;
-(NSInteger)tableView:(id)arg1 indentationLevelForRowAtIndexPath:(id)arg2;
-(BOOL)tableView:(id)arg1 shouldShowMenuForRowAtIndexPath:(id)arg2;
-(BOOL)tableView:(id)arg1 canPerformAction:(SEL)arg2 forRowAtIndexPath:(id)arg3 withSender:(id)arg4;
-(void)tableView:(id)arg1 performAction:(SEL)arg2 forRowAtIndexPath:(id)arg3 withSender:(id)arg4;

@end


#endif
