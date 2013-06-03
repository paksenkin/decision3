//
//  GameEvemy.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "GameEvemy.h"

@implementation GameEnemy

-(void)drawInRect:(NSRect)rect
{
    NSBezierPath *bp = [NSBezierPath bezierPath];
    [bp moveToPoint:rect.origin];
    [bp lineToPoint:NSMakePoint(NSMidX(rect), NSMaxY(rect))];
    [bp lineToPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect))];
    [bp closePath];
    [[NSColor colorWithDeviceRed:0.95f green:0.2f blue:0.37f alpha:1.f] set];
    [bp fill];
}

@end
