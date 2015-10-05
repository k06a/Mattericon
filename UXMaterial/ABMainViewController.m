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
#import "ABMainViewController.h"

@interface ABMainViewController () <UXCollectionViewDataSource, UXCollectionViewDelegate, NSSearchFieldDelegate>

@property (nonatomic, strong) NSSearchField *searchField;
@property (nonatomic, strong) UXCollectionView *collectionView;

@property (nonatomic, strong) NSFont *font;

@property (nonatomic, strong) NSArray<NSDictionary*> *groups;
@property (nonatomic, strong) NSArray<NSDictionary*> *items;
@property (nonatomic, strong) NSArray<NSArray<NSDictionary*>*> *groupedItems;
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<NSValue*>*> *itemsHighlights;


@end

@implementation ABMainViewController

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
                NSInteger tokenPosition = 0;
                NSInteger searchTokenIndex = 0;
                for (NSInteger i = 0; i < tokens.count && searchTokenIndex < searchTokens.count; i++)
                {
                    NSString *token = tokens[i];
                    NSRange range = [token rangeOfString:searchTokens[searchTokenIndex]];
                    if (range.location != NSNotFound) {
                        searchTokenIndex++;
                        range.location += tokenPosition;
                        [foundRanges addObject:[NSValue valueWithRange:range]];
                        continue;
                    }
                    if (i + 1 < tokens.count) {
                        tokenPosition = [item[@"name"] rangeOfString:tokens[i+1] options:NSCaseInsensitiveSearch range:NSMakeRange(tokenPosition + token.length, [item[@"name"] length] - tokenPosition - token.length)].location;
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
            });
        }
        
        NSInteger begin = [css rangeOfString:@"url("].location + 4;
        NSInteger end =  [css rangeOfString:@")" options:0 range:NSMakeRange(begin, css.length-begin)].location;
        NSString *fontPath = [css substringWithRange:NSMakeRange(begin, end - begin)];
        NSData *fontData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fontPath] options:0 error:&error];
        if (error) {
            return dispatch_async(dispatch_get_main_queue(), ^{
                [[NSAlert alertWithError:error] runModal];
            });
        }
        
        self.font = [NSFont fontWithData:fontData size:48];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

- (void)loadItems
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.google.com/design/icons/data/grid.json"]];
        
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            return dispatch_async(dispatch_get_main_queue(), ^{
                [[NSAlert alertWithError:error] runModal];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groups = json[@"groups"];
            self.items = json[@"icons"];
            self.groupedItems = nil;
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadFont];
    [self loadItems];
    
    self.title = @"Material Icons";
    
    // Search Field
    self.searchField = [[NSSearchField alloc] init];
    self.searchField.delegate = self;
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
    }];
    UXBarButtonItem *searchItem = [[UXBarButtonItem alloc] initWithCustomView:self.searchField];
    self.navigationItem.rightBarButtonItems = @[searchItem];
    
    // Toolbar
    NSButton *radioButton = [[NSButton alloc] init];
    [radioButton setButtonType:NSSwitchButton];
    radioButton.title = @"Test";
    [radioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@100);
    }];
    UXBarButtonItem *radioButtonItem = [[UXBarButtonItem alloc] initWithCustomView:radioButton];
    NSButton *radioButton2 = [[NSButton alloc] init];
    [radioButton2 setButtonType:NSSwitchButton];
    radioButton2.title = @"Test2";
    [radioButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@100);
    }];
    UXBarButtonItem *radioButtonItem2 = [[UXBarButtonItem alloc] initWithCustomView:radioButton2];
    UXBarButtonItem *flexibleSpace = [[UXBarButtonItem alloc] initWithBarButtonSystemItem:13 target:nil action:nil];
    UXBarButtonItem *toolbarButton = [[UXBarButtonItem alloc] initWithTitle:@"Test there!" style:1 target:self action:nil];
    [self setToolbarItems:@[radioButtonItem, radioButtonItem2, flexibleSpace, toolbarButton]];
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
        make.edges.equalTo(self.view).with.insets(NSEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height + self.navigationController.toolbar.bounds.size.height, 0, 0, 0));
    }];
}

#pragma mark - Search Field

- (void)controlTextDidChange:(NSNotification *)obj
{
    self.groupedItems = nil;
    [self.collectionView reloadData];
}

#pragma mark - Collection View

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
        NSString *title = self.groups[indexPath.section][@"data"][@"name"];
        headerView.titleLabel.text = title;
        return headerView;
    }
    
    return nil;
}

- (UXCollectionViewCell *)collectionView:(UXCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IconTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    id item = self.groupedItems[indexPath.section][indexPath.item];
    cell.textIcon.font = self.font;
    cell.textIcon.text = item[@"ligature"];
    
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:item[@"name"]];
    astr = [astr bos_makeString:^(BOStringMaker *make) {
        for (NSValue *value in self.itemsHighlights[item[@"ligature"]]) {
            make.with.range(value.rangeValue, ^{
                make.backgroundColor([NSColor yellowColor]);
            });
        }
    }];
    cell.textLabel.attributedText = astr;
    //cell.textLabel.textColor = nil;
    
    return cell;
}

@end
