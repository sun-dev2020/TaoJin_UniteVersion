//
//  TaskPhoto.m
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TaskPhoto.h"

@implementation TaskPhoto

/**
 *  初始化任务对象
 *
 *  @param missionDes 任务描述
 *  @param commentUrl 评论地址
 *  @param gold       金豆数
 *  @param imageAry   示例图
 *  @param step       步骤序列号
 *  @param isPL       是否是评论任务
 */
-(id)initWithMissionDes:(NSString *)missionDes appId:(int)appId commentUrl:(NSString *)commentUrl gold:(int )gold imageAry:(NSArray *)imageAry step:(int)step isAppStorePL:(int) isPL andImgs:(int )count andTip:(NSString *)tip{
    self = [super init];
    if(self){
        self.taskPhoto_missionDes = missionDes;
        self.taskPhoto_appId = appId;
        self.taskPhoto_commentUrl = commentUrl;
        self.taskPhoto_gold = gold;
        self.taskPhoto_imageAry = imageAry;
        self.taskPhoto_step = step;
        self.taskPhoto_isPl =isPL;
        self.taskPhoto_imgCount =count;
        self.taskPhoto_tipString =tip;
    }
    return self;
}


@end
