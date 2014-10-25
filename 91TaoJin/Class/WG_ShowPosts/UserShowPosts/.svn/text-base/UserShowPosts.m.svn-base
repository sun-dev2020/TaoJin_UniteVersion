//
//  UserShowPosts.m
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "UserShowPosts.h"
#import "TimeClass.h"

@implementation UserShowPosts

/**
 *  初始化用户的晒单对象
 *
 *  @param dic 服务器的晒单数据
 *
 */
-(id)initWithUserShowPosts:(NSDictionary *)dic{
    self = [super init];
    if(self){
        self.user_content = [dic objectForKey:@"Content"];
        NSArray *picAry = [dic objectForKey:@"Pic"];
        if(picAry != nil){
            self.user_pictureAry = [dic objectForKey:@"Pic"];
        }else{
            self.user_pictureAry = [[NSArray alloc] init];
        }
        self.user_userName = [dic objectForKey:@"UserNickName"];
        self.user_userId = [dic objectForKey:@"UserId"];
        self.user_userLogo = [dic objectForKey:@"UserPic"];
        self.user_userTime = [TimeClass getTimeByOldTime:[dic objectForKey:@"Time"]];
        self.user_replyNum = [[dic objectForKey:@"ReplyNum"] intValue];
        self.user_showPostsId = [[dic objectForKey:@"ShId"] intValue];
        self.user_status = [[dic objectForKey:@"Status"] intValue];
        self.user_golds = [[dic objectForKey:@"Gold"] intValue];
    }
    return self;
}

@end
