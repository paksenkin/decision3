//
//  EnemyAI.m
//  DM3
//
//  Created by Pavel Aksenkin on 03.06.13.
//  Copyright (c) 2013 Pavel Aksenkin. All rights reserved.
//

#import "EnemyAI.h"
#import "GameMap.h"

@implementation EnemyAI

+(void)makeStep
{
    GameMap *gm = [GameMap instance];
    NSArray *enemies = [[gm enemies] copy];
    for (GameEnemy *enemy in enemies) {
        GameCell *cell = enemy.cell;
        int x = cell.x;
        int y = cell.y;
        if ([gm distanceToCharAtX:x y:y] <= kEnemySightRange) {
            int left = [[gm cellAtX:x-1 y:y] hasObstacles] ? INT32_MAX :[gm distanceToCharAtX:x-1 y:y];
            int right = [[gm cellAtX:x+1 y:y] hasObstacles] ? INT32_MAX :[gm distanceToCharAtX:x+1 y:y];
            int top = [[gm cellAtX:x y:y+1] hasObstacles] ? INT32_MAX :[gm distanceToCharAtX:x y:y+1];
            int bottom = [[gm cellAtX:x y:y-1] hasObstacles] ? INT32_MAX :[gm distanceToCharAtX:x y:y-1];
            if (left <= right) {
                if (left <= top) {
                    if (left <= bottom) {
                        [self enemyGoLeft:enemy];
                    } else {
                        [self enemyGoBottom:enemy];
                    }
                } else {
                    if (top <= bottom) {
                        [self enemyGoTop:enemy];
                    } else {
                        [self enemyGoBottom:enemy];
                    }
                }
            } else {
                if (right <= top) {
                    if (right <= bottom) {
                        [self enemyGoRight:enemy];
                    } else {
                        [self enemyGoBottom:enemy];
                    }
                } else {
                    if (top <= bottom) {
                        [self enemyGoTop:enemy];
                    } else {
                        [self enemyGoBottom:enemy];
                    }
                }
            }
        }
    }
}

+(void)enemyGoLeft:(GameEnemy*)enemy
{
    [self enemy:enemy goTo:[[GameMap instance] cellAtX:enemy.cell.x-1 y:enemy.cell.y]];
}
+(void)enemyGoRight:(GameEnemy*)enemy
{
    [self enemy:enemy goTo:[[GameMap instance] cellAtX:enemy.cell.x+1 y:enemy.cell.y]];
}
+(void)enemyGoTop:(GameEnemy*)enemy
{
    [self enemy:enemy goTo:[[GameMap instance] cellAtX:enemy.cell.x y:enemy.cell.y+1]];
}
+(void)enemyGoBottom:(GameEnemy*)enemy
{
    [self enemy:enemy goTo:[[GameMap instance] cellAtX:enemy.cell.x y:enemy.cell.y-1]];
}
+(void)enemy:(GameEnemy*)enemy goTo:(GameCell*)newCell
{
    GameCell *oldCell = enemy.cell;
    GameCharacter *gc = [[GameMap instance] character];
    if (newCell.person) {
        if (newCell.person == gc) {
            gc.health -= kEnemyInjure;
            oldCell.person = nil;
            [[GameMap instance] removeEnemy:enemy];
        } else {
            // Do nothing, мой коллега сам во всем разберется и уничтожит этого наглого человечишку
        }
    } else {
        if (newCell.hasWater) {
            newCell.hasWater = NO;
        }
        oldCell.person = nil;
        newCell.person = enemy;
        enemy.cell = newCell;
    }
}



@end
