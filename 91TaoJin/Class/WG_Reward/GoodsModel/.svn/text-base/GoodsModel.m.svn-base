//
//  GoodsModel.m
//  TJiphone
//
//  Created by keyrun on 13-10-24.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
-(id)initGoodsModelByDictionary:(NSDictionary* )dic{
    self = [super init];
    if (self) {
        self.awardId =[[dic objectForKey:@"AwardId"]integerValue];
        self.stock =[[dic objectForKey:@"Stock"]integerValue];
        self.needBean =[[dic objectForKey:@"NeedBean"]integerValue];
        self.type =[[dic objectForKey:@"Type"]integerValue];
        self.awardName =[dic objectForKey:@"Name"];
//        self.limit =[[dic objectForKey:@"Limit"]integerValue];
        self.awardImg =[dic objectForKey:@"Img"];
        self.introduce =[dic objectForKey:@"Introduce"];
        self.picString =[dic objectForKey:@"Img"];
        if ([[dic objectForKey:@"Perman"]intValue]) {
            self.perman=[[dic objectForKey:@"Perman"]intValue];
        }
        if ([dic objectForKey:@"Limit"]) {
            self.limit =[[dic objectForKey:@"Limit"]intValue];
        }
        self.bigImgUrl =[dic objectForKey:@"Pic"];
        self.detail =[dic objectForKey:@"Detail"];
    }
    return self;
}
@end
