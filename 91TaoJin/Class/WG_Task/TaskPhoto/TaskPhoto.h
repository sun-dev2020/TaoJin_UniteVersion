//
//  TaskPhoto.h
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskPhoto : NSObject

@property (nonatomic, strong) NSString *taskPhoto_missionDes;           //任务描述
@property (nonatomic, assign) int taskPhoto_appId;                               //app id
@property (nonatomic, strong) NSString *taskPhoto_commentUrl;           //评论地址
@property (nonatomic, assign) int taskPhoto_gold;                       //上次获得金豆数
@property (nonatomic, assign) NSArray *taskPhoto_imageAry;              //示例图
@property (nonatomic, assign) int taskPhoto_step;                       //步骤数
@property (nonatomic, assign) int taskPhoto_isPl;                       // 是否是评论任务
@property (nonatomic, assign) int taskPhoto_imgCount;                            //需要上传图片数
@property (nonatomic, assign) NSString *taskPhoto_tipString ;            //截图说明
/**
 *  初始化任务对象
 *
 *  @param missionDes 任务描述
 *  @param commentUrl 评论地址
 *  @param gold       金豆数
 *  @param imageAry   示例图
 *  @param step       步骤序列号
 *
 */
-(id)initWithMissionDes:(NSString *)missionDes appId:(int)appId commentUrl:(NSString *)commentUrl gold:(int )gold imageAry:(NSArray *)imageAry step:(int)step isAppStorePL:(int) isPL andImgs:(int )count andTip:(NSString *)tip;
@end
