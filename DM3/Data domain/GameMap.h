//
//  GameMap.h
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "GameCharacter.h"
#import "GameEvemy.h"
#import "GameCell.h"
#import "GameConstants.h"

@interface GameMap : NSObject
{
    NSArray *_cells;
}

+(GameMap*)instance;

@property (readonly, retain) NSMutableArray *enemies;
@property (retain) GameCharacter *character;

-(void)removeEnemy:(GameEnemy*)enemy;
-(void)regenerate;
-(void)explore:(GameCell*)cell;
-(GameCell*)cellAtX:(int)x y:(int)y;
-(int)distanceToCharAtX:(int)x y:(int)y;



@end
