//
//  NSTextField+Antialiasing.m
//  UXMaterial
//
//  Created by Anton Bukov on 05.10.15.
//  Copyright © 2015 @k06a. All rights reserved.
//

#import <JRSwizzle/JRSwizzle.h>
#import "NSTextField+Antialiasing.h"

@implementation NSTextField (Antialiasing)

+ (void)load
{
    [NSTextField jr_swizzleMethod:@selector(drawRect:) withMethod:@selector(xxx_drawRect:) error:NULL];
}

- (void)xxx_drawRect:(NSRect)dirtyRect
{
    CGContextRef context = NSGraphicsContext.currentContext.graphicsPort;
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    CGContextSetAllowsFontSubpixelPositioning(context, YES);
    CGContextSetAllowsFontSubpixelQuantization(context, YES);
    
    [self xxx_drawRect:dirtyRect];
}

@end
