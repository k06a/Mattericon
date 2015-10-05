//
//  AppDelegate.m
//  UXMaterial
//
//  Created by Anton Bukov on 05.10.2015.
//  Copyright (c) 2015 @k06a. All rights reserved.
//

#import "AppDelegate.h"
#import "ABMainViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UXNavigationController *rootViewController;
@property (strong, nonatomic) UXWindowController *windowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.rootViewController = [[UXNavigationController alloc] initWithRootViewController:[ABMainViewController new]];
    self.windowController = [[UXWindowController alloc] initWithRootViewController:self.rootViewController];
    
    [self.windowController.window setContentSize:NSMakeSize(505, 700)];
    [self.windowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
