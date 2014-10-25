//
//  ShowPosts.m
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowPosts.h"
#import "UserShowPosts.h"

@implementation ShowPosts

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
-(id)initWithShowPostId:(NSString *)uid showNum:(int )showNum golds1:(int )golds1 golds2:(int )golds2 shinesAry:(NSArray *)shinesAry{
    self = [super init];
    if(self){
        self.showPosts_uid = uid;
        self.showPosts_showNum = showNum;
        self.showPosts_golds1 = golds1;
        self.showPosts_golds2 = golds2;
        NSMutableArray *_shinesAry = [[NSMutableArray alloc] initWithCapacity:shinesAry.count];
        for(NSDictionary *dic in shinesAry){
            UserShowPosts *user = [[UserShowPosts alloc] initWithUserShowPosts:dic];
            [_shinesAry addObject:user];
        }
        self.showPosts_shinesAry = _shinesAry;
    }
    return self;
}

/**
 *  每次获取数据后插入晒单列表
 *
 *  @param shinesAry 服务器的列表内容
 */
-(void)insertShinesAry:(NSArray *)shinesAry{
    NSMutableArray *_shinesAry = [[NSMutableArray alloc] initWithCapacity:shinesAry.count];
    for(NSDictionary *dic in shinesAry){
        UserShowPosts *user = [[UserShowPosts alloc] initWithUserShowPosts:dic];
        [_shinesAry addObject:user];
    }
    [_showPosts_shinesAry insertObjects:_shinesAry atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_showPosts_shinesAry.count, _shinesAry.count)]];
}

/**
 *  用于插入本地的数据
 *
 */
-(void)insertShinesDic:(NSDictionary *)dic{
    UserShowPosts *user = [[UserShowPosts alloc] initWithUserShowPosts:dic];
    [self.showPosts_shinesAry insertObject:user atIndex:0];
}

-(id)copyWithZone:(NSZone *)zone{
    ShowPosts *copy = [[[self class] allocWithZone:zone] init];
    copy->_showPosts_golds1 = _showPosts_golds1;
    copy->_showPosts_golds2 = _showPosts_golds2;
    copy->_showPosts_shinesAry = [_showPosts_shinesAry copy];
    copy->_showPosts_showNum = _showPosts_showNum;
    copy->_showPosts_uid = [_showPosts_uid copy];
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    ShowPosts *copy = [[[self class] allocWithZone:zone] init];
    copy->_showPosts_golds1 = _showPosts_golds1;
    copy->_showPosts_golds2 = _showPosts_golds2;
    copy->_showPosts_shinesAry = [_showPosts_shinesAry mutableCopy];
    copy->_showPosts_showNum = _showPosts_showNum;
    copy->_showPosts_uid = [_showPosts_uid copy];
    return copy;
}
@end




