//
//  SharkContent.h
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharkContent : NSObject


@property (nonatomic, strong) NSString *share_time;                         //时间
@property (nonatomic, strong) NSString *share_content;                      //内容
@property (nonatomic, strong) NSString *share_headContent;                  // 内容前缀

@property (nonatomic, strong) NSString *share_pariseNum;                    //点赞数量
@property (nonatomic, strong) NSString *share_imageUrl;                     //图片路径

@property (nonatomic, strong) NSString *share_ID ;                              //分享id
@property (nonatomic, strong) NSString *share_shareUrl ;                        // 分享地址
@property (nonatomic, assign) int share_isPra;                                  // 是否已点赞

@property (nonatomic, assign) int share_picW ;                                  // 图片宽
@property (nonatomic, assign) int share_picH ;                                  // 图片高

@property (nonatomic, strong) NSArray *share_list;                        // 各个平台的分享情况
-(id) initWithShareDictionary:(NSDictionary *) shareDic;
@end
