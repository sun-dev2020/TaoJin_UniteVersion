//
//  UserShowPosts.h
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserShowPosts : NSObject

@property (nonatomic, strong) NSString *user_content;               //用户晒单内容
@property (nonatomic, strong) NSArray *user_pictureAry;             //用户晒单图片
@property (nonatomic, strong) NSString *user_userName;              //用户名称
@property (nonatomic, strong) NSString *user_userId;                //用户ID
@property (nonatomic, strong) NSString *user_userLogo;              //用户头像
@property (nonatomic, strong) NSString *user_userTime;              //晒单时间
@property (nonatomic, assign) int user_replyNum;                    //回复数
@property (nonatomic, assign) int user_showPostsId;                 //晒单ID
@property (nonatomic, assign) int user_status;                      //审核状态
@property (nonatomic, assign) int user_golds;                       //获得的金豆

/**
 *  初始化用户的晒单对象
 *
 *  @param dic 服务器的晒单数据
 *
 */
-(id)initWithUserShowPosts:(NSDictionary *)dic;
@end
