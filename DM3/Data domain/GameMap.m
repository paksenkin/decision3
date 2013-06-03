//
//  GameMap.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "GameMap.h"

static GameMap *_instance;

@implementation GameMap

+(GameMap *)instance
{
    if (!_instance) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self regenerate];
    }
    return self;
}

-(void)removeEnemy:(GameEnemy *)enemy
{
    [_enemies removeObject:enemy];
}

-(void)regenerate
{
    const NSUInteger count = kFieldWidth * kFieldHeight;
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:count];
    for(int i=0; i<count; ++i) {
        [cells addObject:[[GameCell alloc] initWithX:i%kFieldWidth y:i/kFieldWidth]];
    }
    _cells = cells;
    
    _character = [[GameCharacter alloc] init];
    _character.health = 100.f;
    GameCell *cell = [self cellAtX:kFieldWidth/2 y:kFieldHeight/2];
    [_character setCell:cell];
    [cell setPerson:_character];
    
    [self explore:cell];
    
        // TODO: Рандомное заполнение
    for(NSUInteger i=0; i < kBlockingCount; ++i) {
        GameCell *cell = cells[[self randomIndex]];
        cell.hasObstacles = YES;
    }
    for(NSUInteger i=0; i < kWaterCount; ++i) {
        GameCell *cell = cells[[self randomIndex]];
        cell.hasWater = YES;
    }
    
    NSMutableArray *enemies = [NSMutableArray arrayWithCapacity:kEnemyCount];
    for(NSUInteger i=0; i<kEnemyCount; ++i) {
        GameCell *cell = cells[[self randomIndex]];
        GameEnemy *enemy = [[GameEnemy alloc] init];
        [enemy setCell:cell];
        [enemies addObject:enemy];
        [cell setPerson:enemy];
    }
    _enemies = enemies;
    
    cell = cells[[self randomIndex]];
    cell.hasCamp = YES;
}
-(void)explore:(GameCell*)cell
{
    for(int y = cell.y-kCharacterSightRange; y <= cell.y+kCharacterSightRange; ++y) {
        for(int x = cell.x-kCharacterSightRange; x <= cell.x+kCharacterSightRange; ++x) {
            if ([self distanceToCharAtX:x y:y] <= kCharacterSightRange) {
                [[self cellAtX:x y:y] setIsExplored:YES];
            }
        }
    }
}
-(NSUInteger)randomIndex
{
    const NSUInteger count = kFieldWidth * kFieldHeight;
    
    int result;
    BOOL accepted = NO;
    do {
        result = arc4random() % count;
        int x = result % kFieldWidth;
        int y = result / kFieldWidth;
        if ([self distanceToCharAtX:x y:y] <= kCharacterSightRange) {
        } else {
            GameCell *cell = _cells[result];
            if ([cell hasObstacles] || [cell hasWater] || [cell person] || [cell hasCamp]) {
            } else {
                accepted = YES;
            }
        }
    } while (!accepted);
    
    return result;
}

-(GameCell *)cellAtX:(int)x y:(int)y
{
    if (x < 0 || x >= kFieldWidth || y < 0 || y >= kFieldHeight) {
        return nil;
    }
    NSInteger index = y*kFieldWidth + x;
    return _cells[index];
}
-(int)distanceToCharAtX:(int)x y:(int)y
{
    return abs(x-_character.cell.x) + abs(y-_character.cell.y);
}

@end
