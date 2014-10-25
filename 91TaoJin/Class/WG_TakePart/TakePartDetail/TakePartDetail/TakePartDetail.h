//
//  TakePartDetail.h
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePartDetail : NSObject
@property (nonatomic, strong) NSString *takePart_id;            //活动Id
@property (nonatomic, strong) NSString *takePart_content;       //活动内容
@property (nonatomic, strong) NSArray *takePart_pictureAry;       //活动图片

/**
 *  初始化活动详情对象
 *
 *  @param takePartId 活动ID
 *  @param content    活动内容
 *  @param pictureAry 活动的图片
 *
 */
-(id)initWithTakePartId:(NSString *)takePartId content:(NSString *)content pictureAry:(NSArray *)pictureAry;
@end
