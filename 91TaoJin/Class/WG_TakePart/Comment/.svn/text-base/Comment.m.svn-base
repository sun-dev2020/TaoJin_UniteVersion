//
//  Comment.m
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "Comment.h"

@implementation Comment

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
           commentTime:(NSString *)commentTime{
    self = [super init];
    if(self){
        self.comment_id = commentId;
        self.comment_content = content;
        self.comment_pictureAry = pictureAry;
        self.comment_userName = userName;
        self.comment_userId = userId;
        self.comment_userLogo = userLogo;
        self.comment_time = commentTime;
    }
    return self;
}
-(id)initCommentWithDic:(NSDictionary *)dic{
    if ([super init]) {
        self.comment_id =[dic objectForKey:@"Id"];
        self.comment_content =[dic objectForKey:@"Content"];
        self.comment_pictureAry =[dic objectForKey:@"Pic"];
        self.comment_time =[dic objectForKey:@"Time"];
        self.comment_userId =[dic objectForKey:@"UserId"];
        self.comment_userLogo =[dic objectForKey:@"UserPic"];
        self.comment_userName =[dic objectForKey:@"UserNickName"];
    }
    return self;
}

@end
