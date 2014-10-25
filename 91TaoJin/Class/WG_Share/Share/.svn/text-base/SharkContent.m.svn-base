//
//  SharkContent.m
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "SharkContent.h"

@implementation SharkContent

-(id)initWithShakeTime:(NSString *)time content:(NSString *)content pariseNum:(NSString *)pariseNum imageUrl:(NSString *)imageUrl{
    self = [self init];
    if(self){
        
    }
    return self;
}

-(id) initWithShareDictionary:(NSDictionary *) shareDic{
    if ([self init]) {
        self.share_content  =[shareDic objectForKey:@"Content"];
        self.share_headContent =[shareDic objectForKey:@"Content2"];
        NSArray *picArr =[shareDic objectForKey:@"Pic"];
        if (picArr.count > 0) {
            NSDictionary *picDic =[picArr objectAtIndex:0];
            self.share_imageUrl =[picDic objectForKey:@"Url"];
            self.share_picH =[[picDic objectForKey:@"Height"] intValue];
            self.share_picW =[[picDic objectForKey:@"Width"] intValue];
        }
        self.share_pariseNum =[shareDic objectForKey:@"PraiseNum"];
        self.share_time =[self getTimeWith:[shareDic objectForKey:@"Time"]];
        self.share_isPra =[[shareDic objectForKey:@"IsPra"] intValue];
        self.share_ID =[shareDic objectForKey:@"ShareId"];
        self.share_shareUrl =[shareDic objectForKey:@"Url"];
        self.share_list =[shareDic objectForKey:@"ShareList"];
    }
    return self;
}
-(NSString *)getTimeWith:(NSString *)serTime{
    double dtime=[serTime doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:dtime];
    NSDate* nowDate=[NSDate date];
    
    NSTimeZone* zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:nowDate];
    NSDate* date2 =[date dateByAddingTimeInterval:interval];
    
    NSString* dateStr =[date2 description];

    NSArray* array =[dateStr componentsSeparatedByString:@" "];
    NSString* string1 =[array objectAtIndex:0];
    NSArray* array2 =[string1 componentsSeparatedByString:@"-"];
    
    NSString* one =[array2 objectAtIndex:1];
    NSString* two =[array2 objectAtIndex:2];
    NSString* timetext =[NSString stringWithFormat:@"%@月%@日",one,two];
    return timetext;
}
@end
