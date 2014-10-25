//
//  TakePart.h
//  91TaoJin
//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePart : NSObject

@property (nonatomic, assign) int takePart_id;                                  //活动Id
@property (nonatomic, strong) NSString *takePart_title;                         //活动名称
@property (nonatomic, strong) NSString *takePart_image;                         //活动缩略图
@property (nonatomic, assign) int takePart_commentCount;                        //活动评论数

// 2.1.0 Version
@property (nonatomic, assign) int takePart_type ;                               //活动详情类型  2 是内嵌网页
@property (nonatomic, assign) int takePart_ispl ;                               // 是否支持评论
@property (nonatomic, strong) NSString *takePart_url ;                          // 内嵌网页地址

/**
 *  初始化天天参与对象
 *
 *  @param takePartId           参与ID号
 *  @param takePartTitle        参与标题
 *  @param takePartImage        缩略图
 *  @param takePartCommentCount 评论数量
 *
 */
-(id)initWithId:(int)takePartId takePartTitle:(NSString *)takePartTitle takePartImage:(NSString *)takePartImage takePartCommentCount:(int)takePartCommentCount takePartType:(int)takePartType takePartIsPL:(int)takePartIspl takePartURL:(NSString *)takePartUrl;
@end
