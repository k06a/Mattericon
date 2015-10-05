//
//  ABCollectionViewCell.h
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 k06a. All rights reserved.
//

#import <UXKit/UXKit.h>

@protocol FormatDelegate <NSObject>

@property (nonatomic, readonly) NSString *color;
@property (nonatomic, readonly) NSString *size;
@property (nonatomic, readonly) NSString *format;

@end

//

@interface IconTitleCell : UXCollectionViewCell

@property (nonatomic, strong) UXLabel *textIcon;
@property (nonatomic, strong) UXLabel *textLabel;
@property (nonatomic, strong) id item;
@property (nonatomic, weak) id<FormatDelegate> delegate;

@end
