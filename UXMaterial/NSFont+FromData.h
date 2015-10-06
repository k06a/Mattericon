//
//  NSFont+FromData.h
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 @k06a. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSFont (FromData)

+ (NSFont *)fontWithData:(NSData *)data size:(CGFloat)size;

@end
