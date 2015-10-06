//
//  NSFont+FromData.m
//  UXMaterial
//
//  Created by Антон Буков on 05.10.15.
//  Copyright © 2015 @k06a. All rights reserved.
//

#import "NSFont+FromData.h"

@implementation NSFont (FromData)

+ (NSFont *)fontWithData:(NSData *)data size:(CGFloat)size
{
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CFStringRef newFontNameRef = CGFontCopyPostScriptName(newFont);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    NSFont *font = [NSFont fontWithName:(__bridge NSString *)newFontNameRef size:size];
    CGFontRelease(newFont);
    CFRelease(newFontNameRef);
    return font;
}

@end
