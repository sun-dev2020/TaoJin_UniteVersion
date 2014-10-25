//
//  ShowPostsDetail.m
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowPostsDetail.h"
#import "TimeClass.h"
#import "Comment.h"

@implementation ShowPostsDetail

-(id)initWithShines:(NSDictionary *)body{
    self = [super init];
    if(self){
        NSDictionary *shines = [body objectForKey:@"Shines"];
        if(shines != nil){
            self.detail_id = [[shines objectForKey:@"ShineId"] intValue];
            self.detail_content = [shines objectForKey:@"Content"];
            self.detail_pictureAry = [shines objectForKey:@"Pic"];
            self.detail_userName = [shines objectForKey:@"UserNickName"];
            self.detail_userId = [shines objectForKey:@"UserId"];
            self.detail_userLogo = [shines objectForKey:@"UserPic"];
            self.detail_time = [TimeClass getTimeByOldTime:[shines objectForKey:@"Time"]];
            self.detail_replyNum = [[shines objectForKey:@"ReplyNum"] intValue];
            self.detail_status = [[shines objectForKey:@"Status"] intValue];
        }
        NSArray *comment = [body objectForKey:@"Comment"];
        if(comment != nil){
            self.detail_commentAry = [[NSMutableArray alloc] initWithCapacity:comment.count];
            for(NSDictionary *dic in comment){
                Comment *comment = [[Comment alloc] initWithCommentId:[dic objectForKey:@"Id"] content:[dic objectForKey:@"Content"] pictureAry:nil userName:[dic objectForKey:@"UserNickName"] userId:[dic objectForKey:@"UserId"] userLogo:[dic objectForKey:@"UserPic"] commentTime:[dic objectForKey:@"Time"]];
                [self.detail_commentAry addObject:comment];
            }
        }
    }
    return self;
}

-(void)insertCommentAry:(NSArray *)commentAry{
    for(NSDictionary *dic in commentAry){
        Comment *comment = [[Comment alloc] initWithCommentId:[dic objectForKey:@"Id"] content:[dic objectForKey:@"Content"] pictureAry:nil userName:[dic objectForKey:@"UserNickName"] userId:[dic objectForKey:@"UserId"] userLogo:[dic objectForKey:@"UserPic"] commentTime:[dic objectForKey:@"Time"]];
        [self.detail_commentAry addObject:comment];
    }
}

@end



















