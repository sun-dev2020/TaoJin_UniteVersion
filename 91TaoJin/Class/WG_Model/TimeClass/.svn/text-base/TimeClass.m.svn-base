//
//  TimeClass.m
//  91淘金
//
//  Created by keyrun on 13-11-20.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "TimeClass.h"

@implementation TimeClass
{
   
}
+(NSString*)getTimeByOldTime:(NSString* )oldTime{
   
    double dtime=[oldTime doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:dtime];
    
    NSDate* nowDate=[NSDate date];
    NSTimeZone* zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:nowDate];
    NSDate* locationDate=[nowDate dateByAddingTimeInterval:interval];
    
    NSDate* date2 =[date dateByAddingTimeInterval:interval];
    
    float between=[locationDate timeIntervalSinceDate:date2];
    
    

    NSString* string=@"ad";
    
    if (between /(3600*24*30) >0 && between /(3600*24*30) < 12) {
         int tt =between/(3600*24*30);
    string =[NSString stringWithFormat:@"%d个月前",tt];
  }
     if (between /(3600*24) >0 && between /(3600*24) < 30) {
         int tt =between/(3600*24);
//         NSLog(@"time>>>%@>>%d",date2,tt);
    string =[NSString stringWithFormat:@"%d天前",tt];

     }

    if (between /3600 >0 && between /3600 <24) {
        int tt =between/3600;
    string =[NSString stringWithFormat:@"%d小时前",tt];
    }

    if (between /60 >0 && between /60 <60) {
        int tt =between/60;
        string =[NSString stringWithFormat:@"%d分钟前",tt];
    }

    if (between < 60) {
        string =@"刚刚";
    }

    
    
    return string;
}

@end
