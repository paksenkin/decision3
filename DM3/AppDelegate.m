//
//  AppDelegate.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "AppDelegate.h"
#import "CharacterAI.h"
#import "EnemyAI.h"

@implementation AppDelegate

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}



-(void)autoMakeStep
{
    @try {
        [CharacterAI makeStep];
        [EnemyAI makeStep];
        
        [_mapView setNeedsDisplay:YES];
        [_healthView setNeedsDisplay:YES];
    }
    @catch (NSException *exception) {
        [_timer invalidate];
        _timer = nil;
        [_repeatButton setTitle:@"Start"];
        
        [_mapView setNeedsDisplay:YES];
        [_healthView setNeedsDisplay:YES];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setInformativeText:exception.description];
        [alert runModal];
    }
}
-(IBAction)checkProbability:(id)sender
{
    int wins = 0;
    int losses = 0;
    for(NSUInteger i=0; i<1000; ++i)
        {
        @try {
            [[GameMap instance] regenerate];
            while (true) {
                [CharacterAI makeStep];
                [EnemyAI makeStep];
            }
        }
        @catch (NSException *exception) {
            if (i%100 == 0) {
                NSLog(@"%lu...", i/10);
            }
//            NSLog(@"Exception name: %@", exception.name);
            if ([exception.name isEqualToString:@"Dead"]) {
                ++losses;
            } else {
                ++wins;
            }
        }
    }
    NSLog(@"All:%d (won %d/lost %d)\n Probability: %f", wins + losses, wins, losses, ((CGFloat)wins)/(wins + losses));
    
    [self refresh:nil];
}

-(IBAction)startStop:(id)sender
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        [(NSButton*)sender setTitle:@"Start"];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(autoMakeStep) userInfo:nil repeats:YES];
        [(NSButton*)sender setTitle:@"Stop"];
    }
}
-(IBAction)makeStep:(id)sender
{
    @try {
        [CharacterAI makeStep];
        [EnemyAI makeStep];
        
        [_mapView setNeedsDisplay:YES];
        [_healthView setNeedsDisplay:YES];
    }
    @catch (NSException *exception) {
        [_mapView setNeedsDisplay:YES];
        [_healthView setNeedsDisplay:YES];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setInformativeText:exception.description];
        [alert runModal];
    }
}
-(IBAction)refresh:(id)sender
{
    @try {
        [[GameMap instance] regenerate];
        
        [_mapView setNeedsDisplay:YES];
        [_healthView setNeedsDisplay:YES];
    }
    @catch (NSException *exception) {
        [_mapView setNeedsDisplay:YES];
        [_healthView setNeedsDisplay:YES];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setInformativeText:exception.description];
        [alert runModal];
    }
    
    
}

@end
