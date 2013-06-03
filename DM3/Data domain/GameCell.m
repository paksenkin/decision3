//
//  GameCell.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "GameCell.h"
#import "GamePerson.h"

@implementation GameCell

-(GameCell *)initWithX:(int)x y:(int)y
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

-(void)drawInRect:(NSRect)rect
{
    if (_hasObstacles) {
        [[NSColor blackColor] set];
        NSRectFillUsingOperation(rect, NSCompositeCopy);
    } if (_hasWater) {
        NSBezierPath *bp = [NSBezierPath bezierPathWithOvalInRect:rect];
        [[NSColor blueColor] set];
        [bp fill];
    } if (_hasCamp) {
        NSBezierPath *bp = [NSBezierPath bezierPath];
        [bp moveToPoint:NSMakePoint(NSMidX(rect), NSMinY(rect))];
        [bp lineToPoint:NSMakePoint(NSMinX(rect), NSMidY(rect))];
        [bp lineToPoint:NSMakePoint(NSMidX(rect), NSMaxY(rect))];
        [bp lineToPoint:NSMakePoint(NSMaxX(rect), NSMidY(rect))];
        [bp closePath];
        [[NSColor colorWithDeviceRed:0.81f green:0.73f blue:0.21f alpha:1.f] set];
        [bp fill];
    } if (_person) {
        [_person drawInRect:rect];
    }
    
//    NSBezierPath *bp = [NSBezierPath bezierPathWithRect:rect];
//    [[NSColor grayColor] set];
//    [bp stroke];
}

@end
