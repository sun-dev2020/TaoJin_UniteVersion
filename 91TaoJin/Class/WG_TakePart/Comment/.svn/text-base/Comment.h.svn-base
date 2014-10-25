//
//  Comment.h
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (nonatomic, strong) NSString *comment_id;             //点评ID
@property (nonatomic, strong) NSString *comment_content;        //点评内容
@property (nonatomic, strong) NSArray *comment_pictureAry;      //点评图片
@property (nonatomic, strong) NSString *comment_userName;       //用户名称
@property (nonatomic, strong) NSString *comment_userId;         //用户Id
@property (nonatomic, strong) NSString *comment_userLogo;       //用户头像
@property (nonatomic, strong) NSString *comment_time;           //点评时间

/**
 *  初始化点评对象
 *
 *  @param commentId   点评ID
 *  @param content     点评内容
 *  @param pictureAry  点评图片
 *  @param userName    用户名
 *  @param userId      用户ID
 *  @param userLogo    用户头像
 *  @param commentTime 发表时间
 *
 */
-(id)initWithCommentId:(NSString *)commentId content:(NSString *)content pictureAry:(NSArray *)pictureAry
              userName:(NSString *)userName userId:(NSString *)userId userLogo:(NSString *)userLogo
           commentTime:(NSString *)commentTime;
-(id)initCommentWithDic:(NSDictionary *)dic;
@end
