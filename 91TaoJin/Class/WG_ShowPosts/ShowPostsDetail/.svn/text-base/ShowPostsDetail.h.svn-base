//
//  ShowPostsDetail.h
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowPostsDetail : NSObject

@property (nonatomic, assign) int detail_id;                                //晒单ID
@property (nonatomic, strong) NSString *detail_content;                     //晒单内容
@property (nonatomic, strong) NSArray *detail_pictureAry;                   //晒单图片
@property (nonatomic, strong) NSString *detail_userName;                    //用户名称
@property (nonatomic, strong) NSString *detail_userId;                      //用户Id
@property (nonatomic, strong) NSString *detail_userLogo;                    //用户头像
@property (nonatomic, strong) NSString *detail_time;                        //晒单时间
@property (nonatomic, assign) int detail_replyNum;                          //回复数
@property (nonatomic, assign) int detail_status;                            //晒单审核状态
@property (nonatomic, strong) NSMutableArray *detail_commentAry;            //评论

-(id)initWithShines:(NSDictionary *)body;

-(void)insertCommentAry:(NSArray *)commentAry;
@end
