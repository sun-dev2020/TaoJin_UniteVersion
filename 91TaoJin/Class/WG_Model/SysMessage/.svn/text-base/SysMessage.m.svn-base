//
//  SysMessage.m
//  91淘金
//
//  Created by keyrun on 13-11-25.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "SysMessage.h"

@implementation SysMessage

-(id)initSysMessageByDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        self.msgId =[[dic objectForKey:@"Id"]integerValue];
        self.msgCom =[dic objectForKey:@"Msg"];
        self.msgStatus =[[dic objectForKey:@"Status"]integerValue];
        self.msgTime =[self changeTimeWith:[dic objectForKey:@"Time"]];
        if (![[dic objectForKey:@"Type"] isKindOfClass:[NSNull class]]) {
            self.type =[[dic objectForKey:@"Type"]intValue];   //2 是用户自己  1是91
        }
        

    }
    return self;
}

-(NSString *)changeTimeWith:(NSString *)timestr{      //将时间转成 -月-日 
    double dtime=[timestr doubleValue];
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
