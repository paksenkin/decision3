//
//  GameCharacter.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "GameCharacter.h"

@implementation GameCharacter

-(void)setHealth:(CGFloat)health
{
    _health = health;
    if (_health < 0) _health = 0.f;
    if (_health > 100) _health = 100.f;
}

-(void)drawInRect:(NSRect)rect
{
    NSBezierPath *bp = [NSBezierPath bezierPath];
    [bp moveToPoint:rect.origin];
    [bp lineToPoint:NSMakePoint(NSMidX(rect), NSMaxY(rect))];
    [bp lineToPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect))];
    [bp closePath];
    [[NSColor greenColor] set];
    [bp fill];
}

@end
