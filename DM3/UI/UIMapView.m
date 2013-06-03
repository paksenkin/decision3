//
//  UIMapView.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "UIMapView.h"
#import "GameMap.h"

@implementation UIMapView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    NSRect f = self.bounds;
        // Сетка
    CGFloat heightStep = NSHeight(f)/kFieldHeight;
    CGFloat height = heightStep;
    for(int y=1; y < kFieldHeight; ++y, height += heightStep) {
        [[NSColor grayColor] set];
        NSRectFillUsingOperation(NSMakeRect(0, round(height), NSWidth(f), 1), NSCompositeCopy);
    }
    
    CGFloat widthStep = NSWidth(f)/kFieldWidth;
    CGFloat width = widthStep;
    for(int x=1; x < kFieldWidth; ++x, width += widthStep) {
        [[NSColor grayColor] set];
        NSRectFillUsingOperation(NSMakeRect(round(width), 0, 1, NSHeight(f)), NSCompositeCopy);
    }
    
        // Ячейки
    NSColor *fadeColor = [NSColor colorWithDeviceRed:0.2f green:0.1f blue:0.23f alpha:0.3f];
    GameMap *gm = [GameMap instance];
    height = 0;
    for(int y=0; y < kFieldHeight; ++y, height += heightStep) {
        width = 0;
        for(int x=0; x < kFieldWidth; ++x, width += widthStep) {
            NSRect cr = NSMakeRect(round(width), round(height), round(widthStep), round(heightStep));
            GameCell *gc = [gm cellAtX:x y:y];
            [gc drawInRect:cr];
            if (![gc isExplored]) {
                [fadeColor set];
                NSRectFillUsingOperation(cr, NSCompositeSourceOver);
            }
        }
    }
}

@end
