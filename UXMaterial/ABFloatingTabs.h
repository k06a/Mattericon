//
//  ABFloatingTabs.h
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 @k06a. All rights reserved.
//

#import <UXKit/UXKit.h>

@interface ABFloatingTabs : UXBar

@property (nonatomic, strong) NSArray<NSString*> *titles;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat progress;

@end
