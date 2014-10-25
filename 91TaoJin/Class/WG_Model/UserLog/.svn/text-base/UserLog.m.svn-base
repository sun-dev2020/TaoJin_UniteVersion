//
//  UserLog.m
//  TJiphone
//
//  Created by keyrun on 13-10-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "UserLog.h"

@implementation UserLog

- (id)initWithDictionary:(NSDictionary* )dic{
    self =[super init];
    
    if (self) {
    
        self.logId =[[dic objectForKey:@"Id"]integerValue];
        self.message =[dic objectForKey:@"Message"];
        self.value =[dic objectForKey:@"Value"];

        float  str =[[dic objectForKey:@"Time"]floatValue];

        NSDate *date=[NSDate dateWithTimeIntervalSince1970:str];
//
//        NSDate* nowDate=[NSDate date];
//        NSTimeZone* zone=[NSTimeZone systemTimeZone];
//        NSInteger interval=[zone secondsFromGMTForDate:nowDate];
//        NSDate* locationDate=[nowDate dateByAddingTimeInterval:interval];
//        
//        NSString* string1=[date description];
//        NSArray* arr=[string1 componentsSeparatedByString:@" "];
//        float between=[locationDate timeIntervalSinceDate:date];
//        NSString* sdate=[arr objectAtIndex:1];
//        
//        for (int i=1; i<10000; i++) {
//            if (between <12*60*60.0) {
//                self.time=[NSString stringWithFormat:@"今天:%@",sdate];
//            }
//            if (between > i*12*60*60.0 & between < (i+1)*12*60*60.0) {
//                self.time=[NSString stringWithFormat:@"%d天前",i];
//            }
//        }
        
        NSDate* nowDate=[NSDate date];
        NSTimeZone* zone=[NSTimeZone systemTimeZone];
        NSInteger interval=[zone secondsFromGMTForDate:nowDate];
        NSDate* locationDate=[nowDate dateByAddingTimeInterval:interval];
        
        NSDate* date2 =[date dateByAddingTimeInterval:interval];
        
//        float between=[locationDate timeIntervalSinceDate:date2];

       //[Sun] 2014.02.18 修改用户收支表的时间显示
        NSString* timeString =[date2 description];
        NSString* locationDateString=[locationDate description];
        NSArray* timeArray =[timeString componentsSeparatedByString:@" "];
        NSArray* locationArray =[locationDateString componentsSeparatedByString:@" "];
        
        if (timeArray.count!=0 && locationArray.count!=0) {
            NSString* string =[timeArray objectAtIndex:0];
            NSString* stringtwo =[locationArray objectAtIndex:0];
            if ([string isEqualToString:stringtwo]) {          //一天之内
                NSString* dateString =[timeArray objectAtIndex:1];
                NSArray* clockString =[dateString componentsSeparatedByString:@":"];
                if (clockString.count !=0) {
                    NSString* oneString =[clockString objectAtIndex:0];
                    NSString* twoString =[clockString objectAtIndex:1];
                    self.time =[NSString stringWithFormat:@"今天 %@:%@",oneString,twoString];
                }
            }
           else{
           
                NSString* dateString =[timeArray objectAtIndex:0];
                NSArray* dateArray =[dateString componentsSeparatedByString:@"-"];
                NSString* clockString =[timeArray objectAtIndex:1];
                NSArray* clockArray =[clockString componentsSeparatedByString:@":"];
                NSString* oneString ;
                NSString* twoSting ;
                NSString* threeString;
                NSString* fourString;
                if (dateArray.count !=0) {
                    oneString =[dateArray objectAtIndex:1];
                    twoSting =[dateArray objectAtIndex:2];
                    threeString =[clockArray objectAtIndex:0];
                    fourString =[clockArray objectAtIndex:1];
                    self.time =[NSString stringWithFormat:@"%@月%@日 %@:%@",oneString,twoSting,threeString,fourString];
                }
            }
        }
        
        /*
        for (int i=1; i<60; i++) {
            
            if (between <60.0) {
                self.time=[NSString stringWithFormat:@"刚刚"];
                
            }
     
            
            if (between > 60.0*i && between < (i+1)*60.0) {
                self.time=[NSString stringWithFormat:@"%d分钟前",i];
//                NSLog(@"%@",self.time);

               
            }
            
        }
    
        for (int i=1; i<24; i++) {
            
            if (between > 3600.0*i && between < (i+1)*3600.0) {
                self.time=[NSString stringWithFormat:@"%d小时前",i];
//                 NSLog(@"%@",self.time);
            }
            
        }
        
        for(int i=1; i<30; i++) {
            NSDate* nowDate=[NSDate date];
            NSTimeZone* zone=[NSTimeZone systemTimeZone];
            NSInteger interval=[zone secondsFromGMTForDate:nowDate];
           
//            NSDate* locationDate=[nowDate dateByAddingTimeInterval:interval];
            
            NSDate* date2 =[date dateByAddingTimeInterval:interval];
            float between=[nowDate timeIntervalSinceDate:date2];
            
            if (between > 24*60*60.0*i && between < (i+1)*24*60*60.0) {
                self.time=[NSString stringWithFormat:@"%d天前",i];
                NSLog(@"Time%@>>>>%d",date2,i);
//                NSLog(@"%d",i);
                        }
        }
        
        
        for (int i=1; i<12; i++) {
            
            if (between > 30*60*24*60.0*i && between < (i+1)*30*60*24*60.0) {
                self.time=[NSString stringWithFormat:@"%d月前",i];
//                 NSLog(@"%@",[NSString stringWithFormat:@"%d月",i]);
            }
            
        }


    */
         }
         
    return self;
}
@end
