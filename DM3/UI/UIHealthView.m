//
//  UIHealthView.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "UIHealthView.h"
#import "GameMap.h"

@implementation UIHealthView

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
    CGFloat health = [[[GameMap instance] character] health];
    NSRect lineRect = NSMakeRect(0, 0, 0.7*NSWidth(self.bounds), NSHeight(self.bounds));
    NSRect lifeRect = NSMakeRect(0, 0, health/100.f * NSWidth(lineRect), NSHeight(self.bounds));
    NSRect textRect = NSMakeRect(0.7*NSWidth(self.bounds)+5, 0, 0.3*NSWidth(self.bounds)-5, NSHeight(self.bounds));
    
    [[NSColor darkGrayColor] set];
    NSRectFill(lineRect);
    NSColor *carmin = [NSColor colorWithDeviceRed:0.59f green:0.f blue:0.09f alpha:1.f];
    [carmin set];
    NSRectFill(lifeRect);
    
    NSDictionary *attrs = @{
                            NSForegroundColorAttributeName: carmin,
                            NSFontAttributeName : [NSFont fontWithName:@"Tahoma-Bold" size:16.f]
                            };
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", (int)round(health)] attributes:attrs];
    textRect.origin.y += (NSHeight(textRect) - astr.size.height)/2 + 2;
    textRect.size.height =  astr.size.height;
    [astr drawInRect:textRect];
}

@end
