//
//  CharacterAI.m
//  DM3
//
//  Created by Pavel Aksenkin on 02.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "CharacterAI.h"

@implementation CharacterAI

static NSSize _prev;
const CGFloat kBarrier = 200;

+(void)reset
{
    _prev = (NSSize){0, 0};
}

+(void)makeStep
{
    GameMap *gm = [GameMap instance];
    GameCharacter *gc = [gm character];
    if (gc.health == 0) {
        @throw [NSException exceptionWithName:@"Dead" reason:@"You're already dead" userInfo:nil];
    }
    if ([gc.cell hasCamp]) {
        @throw [NSException exceptionWithName:@"Won" reason:@"You've already won" userInfo:nil];
    }
    
    CGFloat left = [self cellValue:[gm cellAtX:gc.cell.x-1 y:gc.cell.y]];
    CGFloat right = [self cellValue:[gm cellAtX:gc.cell.x+1 y:gc.cell.y]];
    CGFloat top = [self cellValue:[gm cellAtX:gc.cell.x y:gc.cell.y+1]];
    CGFloat bottom = [self cellValue:[gm cellAtX:gc.cell.x y:gc.cell.y-1]];
    
    if (_prev.width == 1) {
        right += kBarrier;
    } else if (_prev.width == -1) {
        left += kBarrier;
    } else if (_prev.height == -1) {
        bottom += kBarrier;
    } else if (_prev.height == 1) {
        top += kBarrier;
    }
    
    if (left <= right) {
        if (left <= top) {
            if (left <= bottom) {
                [self goLeft];
            } else {
                [self goBottom];
            }
        } else {
            if (top <= bottom) {
                [self goTop];
            } else {
                [self goBottom];
            }
        }
    } else {
        if (right <= top) {
            if (right <= bottom) {
                [self goRight];
            } else {
                [self goBottom];
            }
        } else {
            if (top <= bottom) {
                [self goTop];
            } else {
                [self goBottom];
            }
        }
    }
    
    if (gc.cell.hasCamp) {
        @throw [NSException exceptionWithName:@"Won" reason:@"You won" userInfo:nil];
    } else if (gc.health <= 0) {
        @throw [NSException exceptionWithName:@"Dead" reason:@"You're dead" userInfo:nil];
    }
    
}
+(void)goLeft
{
    _prev = (NSSize){1, 0};
    GameMap *gm = [GameMap instance];
    GameCharacter *gc = gm.character;
    GameCell *oldCell = gc.cell;
    GameCell *newCell = [gm cellAtX:oldCell.x-1 y:oldCell.y];
    [self goTo:newCell];
}
+(void)goRight
{
    _prev = (NSSize){-1, 0};
    GameMap *gm = [GameMap instance];
    GameCharacter *gc = gm.character;
    GameCell *oldCell = gc.cell;
    GameCell *newCell = [gm cellAtX:oldCell.x+1 y:oldCell.y];
    [self goTo:newCell];
}
+(void)goTop
{
    _prev = (NSSize){0, -1};
    GameMap *gm = [GameMap instance];
    GameCharacter *gc = gm.character;
    GameCell *oldCell = gc.cell;
    GameCell *newCell = [gm cellAtX:oldCell.x y:oldCell.y+1];
    [self goTo:newCell];
}
+(void)goBottom
{
    _prev = (NSSize){0, 1};
    GameMap *gm = [GameMap instance];
    GameCharacter *gc = gm.character;
    GameCell *oldCell = gc.cell;
    GameCell *newCell = [gm cellAtX:oldCell.x y:oldCell.y-1];
    [self goTo:newCell];
}
+(void)goTo:(GameCell*)newCell
{
    GameMap *gm = [GameMap instance];
    GameCharacter *gc = gm.character;
    gc.health -= kDailyInjure;
    GameCell *oldCell = gc.cell;
    
    oldCell.person = nil;
    if (newCell.person) {
        gc.health -= kEnemyInjure;
        [gm removeEnemy:(GameEnemy*)newCell.person];
    }
    newCell.person = gc;
    gc.cell = newCell;
    
    if ([newCell hasWater]) {
        gc.health += kWaterHealing;
        [newCell setHasWater:NO];
    }
    [gm explore:newCell];
}

+(CGFloat)baseEnemyValue
{
    return -600 + 5*[[[GameMap instance] character] health];
}
+(CGFloat)baseWaterValue
{
    return 500 - 5*[[[GameMap instance] character] health];
}
+(CGFloat)baseUnexploredValue
{
    return 80;
}
+(CGFloat)baseObstacleValue
{
    return -1e12;
}
+(CGFloat)baseCampValue
{
    return 1.2e3;
}
+(CGFloat)cellValue:(GameCell*)cell
{
    if (!cell) {
        return 1e12;
    }
    CGFloat result = 0;
    const int kSight = kFieldWidth;
    for(int y=cell.y - kSight; y <= cell.y + kSight; ++y) {
        if (y < 0 || y >= kFieldHeight) continue;
        for(int x=cell.x - kSight; x <= cell.x + kSight; ++x) {
            if (x < 0 || x >= kFieldWidth) continue;
            CGFloat miniResult = 0;
            GameCell *gc = [[GameMap instance] cellAtX:x y:y];
            if (![gc isExplored]) {
                miniResult += [self baseUnexploredValue];
            } else {
                if ([gc hasWater]) {
                    miniResult += [self baseWaterValue];
                }
                
                if ([gc hasCamp]) {
                    miniResult += [self baseCampValue];
                }
                if ([gc person] && [gc person] != [[GameMap instance] character]) {
                    miniResult += [self baseEnemyValue];
                }
            }
            if (x == cell.x && y == cell.y) {
                if ([gc hasObstacles]) {
                    miniResult += [self baseObstacleValue];
                }
                result += miniResult;
            } else {
                result += pow(0.7, abs(x-cell.x) + abs(y-cell.y)) * miniResult;
            }
        }
    }
    return -result;
}

@end
