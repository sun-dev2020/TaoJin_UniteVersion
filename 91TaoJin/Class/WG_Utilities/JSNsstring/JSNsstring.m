//
//  JSNsstring.m
//  TJiphone
//
//  Created by keyrun on 13-10-18.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "JSNsstring.h"
#import "JSONKit.h"
@implementation JSNsstring

-(JSNsstring* )initStringByDictionary:(NSDictionary* )dic{
    NSString *string = [dic JSONString];
    NSString *pamar = @"PARAM=";
    NSString *jsString = [[NSString alloc] initWithFormat:@"%@%@",pamar,string];
    return (JSNsstring*)jsString;
}
-(JSNsstring* )initStringByString:(NSString* )string{
    NSString* str =[string JSONString];
    NSString* pamar=@"PARAM=";
    NSString* jsString=[NSString stringWithFormat:@"%@%@",pamar,str];
    return (JSNsstring* )jsString;
}
@end
