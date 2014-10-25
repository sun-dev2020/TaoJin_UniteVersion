//
//  ScratchPrize.m
//  91TaoJin
//
//  Created by keyrun on 14-5-30.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ScratchPrize.h"

@implementation ScratchPrize

/**
 *  初始化刮刮乐信息
 *
 *  @param scratchAry 奖品列表
 *  @param scratchNum 可刮次数
 *  @param winNum     当前所中的奖品代号
 *
 */
-(id)initWithScratchAry:(NSArray *)scratchAry scratchNum:(int)scratchNum winNum:(int)winNum{
    self = [super init];
    if(self){
        self.scratch_prizes = [[NSMutableArray alloc] initWithCapacity:scratchAry.count];
        for(NSDictionary *dic in scratchAry){
            int num = [[dic objectForKey:@"Num"] intValue];
            int gold = [[dic objectForKey:@"Gold"] intValue];
            [self.scratch_prizes insertObject:[NSString stringWithFormat:@"%d",gold] atIndex:(num - 1)];
        }
        self.scratch_scratchNum = scratchNum;
        self.scratch_winNum = winNum;
    }
    return self;
}

@end
