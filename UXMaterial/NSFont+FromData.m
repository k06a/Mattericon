//
//  NSFont+FromData.m
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 justmaku. All rights reserved.
//

#import "NSFont+FromData.h"

@implementation NSFont (FromData)

+ (NSFont *)fontWithData:(NSData *)data size:(CGFloat)size
{
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    NSString *newFontName = (__bridge NSString *)CGFontCopyPostScriptName(newFont);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    CGFontRelease(newFont);
    return [NSFont fontWithName:newFontName size:size];
}

@end
