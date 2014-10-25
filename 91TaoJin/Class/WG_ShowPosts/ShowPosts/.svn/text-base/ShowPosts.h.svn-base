//
//  ShowPosts.h
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowPosts : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, retain) NSString *showPosts_uid;          //回传的id
@property (nonatomic, assign) int showPosts_showNum;            //可晒单次数
@property (nonatomic, assign) int showPosts_golds1;             //晒单照片1类奖励
@property (nonatomic, assign) int showPosts_golds2;             //晒单照片2类奖励
@property (nonatomic, retain) NSMutableArray *showPosts_shinesAry;     //晒单列表

/**
 *  初始化晒单列表
 *
 *  @param uid       回传的id
 *  @param showNum   可晒单次数
 *  @param golds1    1类照片奖励金豆数
 *  @param golds2    2类照片奖励金豆数
 *  @param shinesAry 晒单列表内容
 *
 */
-(id)initWithShowPostId:(NSString *)uid showNum:(int )showNum golds1:(int )golds1 golds2:(int )golds2 shinesAry:(NSArray *)shinesAry;

/**
 *  每次获取数据后插入晒单列表
 *
 *  @param shinesAry 服务器的列表内容
 */
-(void)insertShinesAry:(NSArray *)shinesAry;

/**
 *  用于插入本地的数据
 *
 */
-(void)insertShinesDic:(NSDictionary *)dic;
@end
