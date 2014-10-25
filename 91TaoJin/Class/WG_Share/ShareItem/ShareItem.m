//
//  ShareItem.m
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShareItem.h"

@implementation ShareItem
-(id)initWithShareItem:(NSDictionary *)itemDic{
    if ([super init]) {
        
        self.shareItem_gold =[[itemDic objectForKey:@"Glod"] stringValue];
        self.shareItem_isShared =[[itemDic objectForKey:@"IsShare"] intValue];
        self.shareItem_itemId =[[itemDic objectForKey:@"ShareId"] intValue];
    }
    return self;
}
@end
