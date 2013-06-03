//
//  AppDelegate.h
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (retain) NSTimer *timer;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *mapView;
@property (assign) IBOutlet NSView *healthView;
@property (assign) IBOutlet NSButton *repeatButton;

@end
