//
//  GameCell.h
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GamePerson;

@interface GameCell : NSObject

@property int x;
@property int y;

@property (assign) GamePerson *person;
@property BOOL hasWater;
@property BOOL hasObstacles;
@property BOOL hasCamp;
@property BOOL isExplored;

-(GameCell*)initWithX:(int)x y:(int)y;

-(void)drawInRect:(NSRect)rect;

@end

