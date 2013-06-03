//
//  GamePerson.h
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "GameCell.h"

@interface GamePerson : NSObject

@property (assign) GameCell *cell;

-(void)drawInRect:(NSRect)rect;

@end
