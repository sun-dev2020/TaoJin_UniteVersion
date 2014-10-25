//
//  NSDate+nowTime.m
//  91TaoJin
//
//  Created by keyrun on 14-6-10.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "NSDate+nowTime.h"

@implementation NSDate (nowTime)

/**
 *  获取当前的毫秒数
 *
 */
+(long long int)getNowTime{
    NSDate* nowDate = [self date];
    NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
    long long int date = (long long int)timeInterval;
    return date;
}


+(NSString *)changeTimeWith:(NSString *)timestr{      //将时间转成 -月-日
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
