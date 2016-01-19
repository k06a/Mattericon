//
//  AppDelegate.m
//  UXMaterial
//
//  Created by Anton Bukov on 05.10.2015.
//  Copyright (c) 2015 @k06a. All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Answers.h>
#import <Crashlytics/Crashlytics.h>
#import "AppDelegate.h"
#import "ABMainViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) ABMainViewController *mainController;
@property (strong, nonatomic) UXNavigationController *rootViewController;
@property (strong, nonatomic) UXWindowController *windowController;

@end

@implementation AppDelegate

- (IBAction)search:(id)sender
{
    [self.mainController search:sender];
}

- (IBAction)getFont:(id)sender
{
    [self.mainController getFont:sender];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"NSApplicationCrashOnExceptions":@YES}];
    [Fabric with:@[[Crashlytics class], [Answers class]]];

    self.mainController = [[ABMainViewController alloc] init];
    self.rootViewController = [[UXNavigationController alloc] initWithRootViewController:self.mainController];
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
