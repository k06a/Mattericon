//
//  JMKMainViewController.m
//  UXMaterial
//
//  Created by Anton Bukov on 05.10.2015.
//  Copyright (c) 2015 @k06a. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <Masonry/Masonry.h>
#import <BOString/BOString.h>
#import "NSFont+FromData.h"

#import "IconTitleCell.h"
#import "TitleHeader.h"
#import "ABFloatingTabs.h"
#import "ABMainViewController.h"

@interface ABMainViewController () <UXCollectionViewDataSource, UXCollectionViewDelegate, NSSearchFieldDelegate, FormatDelegate, ABFloatingTabsDelegate>

@property (nonatomic, strong) NSSearchField *searchField;
@property (nonatomic, strong) UXCollectionView *collectionView;
@property (nonatomic, strong) ABFloatingTabs *floatingTabs;

@property (nonatomic, strong) NSData *fontData;
@property (nonatomic, strong) NSFont *font;

@property (nonatomic, strong) NSArray<NSDictionary*> *groups;
@property (nonatomic, strong) NSArray<NSDictionary*> *items;
@property (nonatomic, strong) NSArray<NSArray<NSDictionary*>*> *groupedItems;
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<NSValue*>*> *itemsHighlights;

@property (nonatomic, strong) NSPopUpButton *colorButton;
@property (nonatomic, strong) NSPopUpButton *sizeButton;
@property (nonatomic, strong) NSPopUpButton *formatButton;

@end

@implementation ABMainViewController

- (NSString *)color
{
    return @[@"black",@"white"][self.colorButton.indexOfSelectedItem];
}

- (NSString *)size
{
    NSString *str = self.sizeButton.titleOfSelectedItem;
    if (self.formatButton.indexOfSelectedItem == 0)
        str = [str stringByReplacingOccurrencesOfString:@"dp" withString:@"px"];
    return str;
}

- (NSString *)format
{
    return @[@"svg",@"zip"][self.formatButton.indexOfSelectedItem];
}

- (NSArray<NSArray<NSDictionary *> *> *)groupedItems
{
    if (_groupedItems == nil) {
        NSMutableArray *result = [NSMutableArray array];
        NSMutableDictionary *itemsHighlights = [NSMutableDictionary dictionary];
        
        NSArray *searchTokens = [[self.searchField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
        for (NSDictionary *group in self.groups)
        {
            NSArray *arr = [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary * _Nonnull item, NSDictionary<NSString *,id> * _Nullable bindings)
            {
                if (![item[@"group_id"] isEqualToString:group[@"data"][@"id"]])
                    return NO;
                if (self.searchField.text.length == 0)
                    return YES;
                
                NSMutableArray *foundRanges = [NSMutableArray array];
                NSArray<NSString *> *tokens = [[item[@"name"] componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
                NSMutableArray<NSNumber *> *tokensHidden = [[tokens valueForKey:@"length"] mutableCopy];
                for (NSString *searchToken in searchTokens)
                {
                    NSInteger tokenPosition = 0;
                    for (NSInteger i = 0; i < tokens.count; i++)
                    {
                        NSString *token = tokens[i];
                        if ([tokensHidden[i] integerValue])
                        {
                            NSRange range = [token rangeOfString:searchToken options:NSCaseInsensitiveSearch];
                            if (range.location != NSNotFound) {
                                range.location += tokenPosition;
                                [foundRanges addObject:[NSValue valueWithRange:range]];
                                tokensHidden[i] = @0;
                                break;
                            }
                        }
                        
                        if (i + 1 < tokens.count) {
                            tokenPosition = [item[@"name"] rangeOfString:tokens[i+1] options:NSCaseInsensitiveSearch range:NSMakeRange(tokenPosition + token.length, [item[@"name"] length] - tokenPosition - token.length)].location;
                        }
                    }
                }
                
                BOOL ret = (foundRanges.count == searchTokens.count);
                
                if (ret) {
                    itemsHighlights[item[@"ligature"]] = foundRanges;
                }
                
                return ret;
            }]];
            
            [result addObject:arr];
        }
        _groupedItems = result;
        _itemsHighlights = itemsHighlights;
    }
    return _groupedItems;
}

- (void)loadFont
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSString *css = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://fonts.googleapis.com/icon?family=Material+Icons"] encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            return dispatch_async(dispatch_get_main_queue(), ^{
                [[NSAlert alertWithError:error] runModal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadFont];
                });
            });
        }
        
        NSInteger begin = [css rangeOfString:@"url("].location + 4;
        NSInteger end =  [css rangeOfString:@")" options:0 range:NSMakeRange(begin, css.length-begin)].location;
        NSString *fontPath = [css substringWithRange:NSMakeRange(begin, end - begin)];
        self.fontData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fontPath] options:0 error:&error];
        if (error) {
            return dispatch_async(dispatch_get_main_queue(), ^{
                [[NSAlert alertWithError:error] runModal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadFont];
                });
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.font = [NSFont fontWithData:self.fontData size:48];
            [self.collectionView reloadData];
        });
    });
}

- (void)loadItems
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.google.com/design/icons/data/grid.json"]];
        if (data == nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadItems];
            });
            return;
        }
        
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            return dispatch_async(dispatch_get_main_queue(), ^{
                [[NSAlert alertWithError:error] runModal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadItems];
                });
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groups = json[@"groups"];
            self.items = json[@"icons"];
            self.groupedItems = nil;
            self.floatingTabs.titles = [self.groups valueForKeyPath:@"data.name"];
            [self.collectionView reloadData];
        });
    });
}

- (void)popUpValueChanged:(NSPopUpButton *)sender
{
    if (sender == self.colorButton)
        [[NSUserDefaults standardUserDefaults] setInteger:sender.indexOfSelectedItem forKey:@"colorIndex"];
    if (sender == self.formatButton)
        [[NSUserDefaults standardUserDefaults] setInteger:sender.indexOfSelectedItem forKey:@"formatIndex"];
    if (sender == self.sizeButton)
        [[NSUserDefaults standardUserDefaults] setInteger:sender.indexOfSelectedItem forKey:@"sizeIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)navBarClicked:(UXClickEventTracker *)tracker
{
    if (!CGRectContainsPoint(self.searchField.bounds, [tracker locationInView:self.searchField]))
        [self.collectionView setContentOffset:CGPointZero animated:YES];
}

- (void)getFontTapped:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"Save Material Font";
    panel.nameFieldStringValue = @"MaterialFont.ttf";
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result != NSModalResponseOK)
            return;
        [self.fontData writeToURL:panel.URL atomically:YES];
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[panel.URL]];
    }];
}

#pragma mark - Actions

- (void)search:(id)sender
{
    [[self.searchField window] makeFirstResponder:self.searchField];
}

- (void)getFont:(id)sender
{
    [self getFontTapped:sender];
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadFont];
    [self loadItems];
    
    // Nav Bar
    self.title = @"Material Icons";
    [self.navigationController.navigationBar addEventTracker:[[UXClickEventTracker alloc] initWithTarget:self action:@selector(navBarClicked:)]];
    
    // Search Field
    self.searchField = [[NSSearchField alloc] init];
    self.searchField.delegate = self;
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
    }];
    UXBarButtonItem *searchItem = [[UXBarButtonItem alloc] initWithCustomView:self.searchField];
    searchItem.keyEquivalent = @"f";
    searchItem.keyEquivalentModifierMask = NSCommandKeyMask;
    self.navigationItem.rightBarButtonItems = @[searchItem];
    
    // Toolbar
    UXBarButtonItem *colorButtonItem = [[UXBarButtonItem alloc] initWithCustomView:^{
        self.colorButton = [[NSPopUpButton alloc] init];
        [self.colorButton setTarget:self action:@selector(popUpValueChanged:)];
        [self.colorButton addItemsWithTitles:@[@"Black",@"White"]];
        [self.colorButton selectItemAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"colorIndex"]];
        [self.colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
        }];
        return self.colorButton;
    }()];
    UXBarButtonItem *formatButtonItem = [[UXBarButtonItem alloc] initWithCustomView:^{
        self.formatButton = [[NSPopUpButton alloc] init];
        [self.formatButton setTarget:self action:@selector(popUpValueChanged:)];
        [self.formatButton addItemsWithTitles:@[@"SVG",@"PNGs"]];
        [self.formatButton selectItemAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"formatIndex"]];
        [self.formatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@75);
        }];
        return self.formatButton;
    }()];
    UXBarButtonItem *sizeButtonItem = [[UXBarButtonItem alloc] initWithCustomView:^{
        self.sizeButton = [[NSPopUpButton alloc] init];
        [self.sizeButton setTarget:self action:@selector(popUpValueChanged:)];
        [self.sizeButton addItemsWithTitles:@[@"48dp",@"36dp",@"24dp",@"18dp"]];
        [self.sizeButton selectItemAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"sizeIndex"]];
        [self.sizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@75);
        }];
        return self.sizeButton;
    }()];
    UXBarButtonItem *flexibleSpace = [[UXBarButtonItem alloc] initWithBarButtonSystemItem:13 target:nil action:nil];
    UXBarButtonItem *fontButton = [[UXBarButtonItem alloc] initWithTitle:@"Get Material Font" style:1 target:self action:@selector(getFontTapped:)];
    self.toolbarItems = @[colorButtonItem, formatButtonItem, sizeButtonItem, flexibleSpace, fontButton];
    self.navigationController.toolbarHidden = NO;
    
    // Collection View
    UXCollectionViewFlowLayout *layout = [[UXCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100,100);
    layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 38);
    self.collectionView = [[UXCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[IconTitleCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[TitleHeader class] forSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView reloadData];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(NSEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height + 24.5, 0, self.navigationController.toolbar.bounds.size.height, 0));
    }];
    
    // Floating tabs
    self.floatingTabs = [[ABFloatingTabs alloc] init];
    self.floatingTabs.delegate = self;
    self.floatingTabs.backgroundColor = [NSColor colorWithWhite:222/255. alpha:1.0];
    [self.view addSubview:self.floatingTabs];
    [self.floatingTabs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.navigationController.navigationBar.bounds.size.height));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@24);
    }];
    
    self.view.backgroundColor = [NSColor grayColor];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    // Center of screen
    NSRect frame = self.view.window.frame;
    frame.size = NSMakeSize(800, 600);
    frame.origin.x = (self.view.window.screen.frame.size.width - frame.size.width)/2;
    frame.origin.y = (self.view.window.screen.frame.size.height - frame.size.height)/2;
    [self.view.window setFrame:frame display:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Move toolbar to bottom
    for (NSLayoutConstraint *con in self.navigationController.toolbar.superview.constraints) {
        if (con.firstAttribute == NSLayoutAttributeTop &&
            con.firstItem == self.navigationController.toolbar)
        {
            [self.navigationController.toolbar.superview removeConstraint:con];
            [self.navigationController.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.navigationController.toolbar.superview.mas_bottom);
            }];
            [self.view layoutIfNeeded];
            break;
        }
    }
}

#pragma mark - Floating Tabs

- (void)clickedTabAtIndex:(NSInteger)index
{
    UXCollectionViewLayoutAttributes *attrs = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index]];
    [self.collectionView setContentOffset:CGPointMake(0, attrs.frame.origin.y-38) animated:YES];
}

#pragma mark - Search Field

- (void)controlTextDidChange:(NSNotification *)obj
{
    self.groupedItems = nil;
    [self.collectionView reloadData];
}

#pragma mark - Collection View

- (CGFloat)heightOfCollection
{
    NSInteger section = self.collectionView.numberOfSections - 1;
    NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1;
    if (section < 0 || item < 0)
        return self.collectionView.bounds.size.height;

    UXCollectionViewLayoutAttributes *attrs = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
    return attrs.frame.origin.y + attrs.frame.size.height;
}

- (CGFloat)progressForContentOffset:(CGFloat)offsetY section:(NSInteger *)sectionOutput
{
    CGFloat headerHeight = ((UXCollectionViewFlowLayout *)self.collectionView.collectionViewLayout).headerReferenceSize.height;
    CGFloat prevY = self.collectionView.contentSize.height;
    for (NSInteger section = self.collectionView.numberOfSections-1; section >= 0; section--)
    {
        if (![self.collectionView numberOfItemsInSection:section])
            continue;
        UXCollectionViewLayoutAttributes *attrs = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        CGFloat y = attrs.frame.origin.y - headerHeight;
        if (y <= offsetY)
        {
            if (sectionOutput)
                *sectionOutput = section;
            if (y <= offsetY && offsetY <= y + headerHeight)
                return 0.0;
            return (offsetY - headerHeight - y)/(prevY - y - headerHeight);
        }
        prevY = y;
    }
    
    if (sectionOutput)
        *sectionOutput = 0;
    return 0.0;
}

- (void)collectionViewDidScroll:(UXCollectionView *)collectionView
{
    if ([self.collectionView numberOfSections] == 0)
        return;
    
    NSInteger section;
    CGFloat progress = [self progressForContentOffset:collectionView.contentOffset.y section:&section];
    
    CGFloat diff = collectionView.contentOffset.y + collectionView.frame.size.height - [self heightOfCollection];
    if (diff + 100 > 0)
    {
        NSInteger maxSection;
        CGFloat maxProgress = [self progressForContentOffset:[self heightOfCollection] - collectionView.frame.size.height section:&maxSection];
        section = collectionView.numberOfSections - 2;
        progress += (1-maxProgress)*((diff + 100)/100);
    }
    
    self.floatingTabs.selectedIndex = section;
    self.floatingTabs.progress = MIN(1.0, progress);
}

- (NSInteger)numberOfSectionsInCollectionView:(UXCollectionView *)collectionView
{
    if (self.font == nil)
        return 0;
    return self.groups.count;
}

- (NSInteger)collectionView:(UXCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.font == nil)
        return 0;
    return self.groupedItems[section].count;
}

- (UXCollectionReusableView *)collectionView:(UXCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:@"UXCollectionViewElementKindSectionHeader"])
    {
        TitleHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        //headerView.isFloatingPinned = YES;
        NSString *title = self.groups[indexPath.section][@"data"][@"name"];
        headerView.titleLabel.text = title;
        return headerView;
    }
    
    return nil;
}

- (UXCollectionViewCell *)collectionView:(UXCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IconTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.item = self.groupedItems[indexPath.section][indexPath.item];
    cell.textIcon.font = self.font;
    cell.textIcon.text = cell.item[@"ligature"];
    
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:cell.item[@"name"]];
    astr = [astr bos_makeString:^(BOStringMaker *make) {
        for (NSValue *value in self.itemsHighlights[cell.item[@"ligature"]]) {
            make.with.range(value.rangeValue, ^{
                make.backgroundColor([NSColor yellowColor]);
            });
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        make.paragraphStyle(paragraphStyle);
    }];
    cell.textLabel.attributedText = astr;
    [cell setNeedsDisplay];
    
    return cell;
}

@end
