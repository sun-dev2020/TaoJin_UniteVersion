//
//  NSString+IsEmply.m
//  91TaoJin
//
//  Created by keyrun on 14-5-4.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "NSString+IsEmply.h"

@implementation NSString (IsEmply)

/**
 *  判断NSString是否为空
 *
 */
+(BOOL)isEmply:(NSString *)str{
    /*
    if (!self) {
        return true;
    }else{
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        }else{
            return false;
        }
    }*/
    if(str == nil || [@"" isEqualToString:str] || [str isKindOfClass:[NSNull class]]){
        return true;
    }
    return false;
}

/**
 *  多行换行替换为空格
 *
 *  @param string       原文
 *
 */
+(NSString *)getFiltrationString:(NSString *)string{
    /*
    NSArray *strArr = [string componentsSeparatedByString:@"\\n"];
    // 将换行符用空格代替  多个换行只用一个空格间隔
    NSMutableArray *newStrArr = [[NSMutableArray alloc] init];
    for (NSString *str in strArr) {
        if (![str isEqualToString:@""]){
            NSString *string = [NSString stringWithFormat:@" %@",str];
            [newStrArr addObject:string];
        }
    }
    NSString *newString = [[NSString alloc] init];
    for (NSString *str in newStrArr) {
        newString = [newString stringByAppendingString:str];
    }
    return newString;
    */
    NSString *content = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    __block NSString *contentDealed = [[NSString alloc] init];
    __block NSString *oldLine = nil;
    __block int i=0;
    [content enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
       
        if([oldLine isEqualToString:@""] && [line isEqualToString:@""]){
            
        }else{
            if(![oldLine isEqualToString:@""] && [line isEqualToString:@""]){
                
            }else{
                if (i ==0) {
                    contentDealed =[contentDealed stringByAppendingString:line];
                }else{
                    contentDealed =[contentDealed stringByAppendingString:[NSString stringWithFormat:@" %@",line]];
                }
                
            }

        }
        i++;
        oldLine = line;
        
        
    }];
    return contentDealed;
}

/**
 *  处理文本有多个换行的显示
 *
 *  @param str 原文
 *
 */
+(NSString *)dealStringWithNewLine:(NSString *)str{
    NSString *content = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    __block NSString *contentDealed = [[NSString alloc] init];
    __block NSString *oldLine = nil;
    [content enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        if([oldLine isEqualToString:@""] && [line isEqualToString:@""]){
            
        }else{
            if(![oldLine isEqualToString:@""] && [line isEqualToString:@""]){
                
            }else{
                contentDealed = [contentDealed stringByAppendingString:line];
            }
            contentDealed = [contentDealed stringByAppendingString:@"\n"];
        }
        oldLine = line;
    }];
    return contentDealed;
}

/**
 *  禁止输入Emoji表情符号
 *
 *  @param text         原文
 *
 */
+(NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

/**
 *  判断是否包含emoji表情
 *
 *  @param text 原文
 *
 */
+(BOOL)isContainsEmoji:(NSString *)text{
    __block BOOL isEomji = NO;
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            NSLog(@"ls = %hu",ls);
            if (ls == 0x20e3 || ls == 65039) {
                isEomji = YES;
            }
        }
            // non surrogate
            /*if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else*/ if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a || hs == 0x27A1 || hs == 0x2197 || hs == 0x25C0 || hs == 0x23EA || hs == 0x2196 ||                       hs == 0x25B6 || hs == 0x23E9 || hs == 0x2198 || hs == 0x2199 || hs == 0x267F || hs == 0x3299 || hs == 0x3297 ||
                hs == 0x263A || hs == 0x260E || hs == 0x2764 || hs == 0x2702 || hs == 0x26BD || hs == 0x26BE ||
                hs == 0x26F3 || hs == 0x2615 || hs == 0x26EA || hs == 0x26FA || hs == 0x26F2 || hs == 0x2708 || hs == 0x26F5 ||
                hs == 0x26A0 || hs == 0x26FD || hs == 0x2668 || hs == 0x2600 || hs == 0x2601 || hs == 0x26A1 || hs == 0x2614 ||
                hs == 0x26C4 || hs == 0x2728 || hs == 0x270B || hs == 0x261D || hs == 0x270A || hs == 0x270C || hs == 0x2733 ||
                hs == 0x26CE || hs == 0x274C || hs == 0x2B55 || hs == 0x2122 || hs == 0x2755 || hs == 0x2754 || hs == 0x23F3 ||
                hs == 0x231B || hs == 0x2709 || hs == 0x2712 || hs == 0x270F || hs == 0x2744 || hs == 0x2747 || hs == 0x267B ||
                hs == 0x23EB || hs == 0x23EC || hs == 0x2194 || hs == 0x21A9 || hs == 0x2935 || hs == 0x2195 || hs == 0x21AA ||
                hs == 0x2934 || hs == 0x2139 || hs == 0x24C2 || hs == 0x274E || hs == 0x274E || hs == 0x2734 || hs == 0x26D4 ||
                hs == 0x203C || hs == 0x2049 || hs == 0x2757 || hs == 0x2753 || hs == 0x2660 || hs == 0x2611 || hs == 0x2663 ||
                hs == 0x2716 || hs == 0x2666 || hs == 0x27B0 || hs == 0x2795 || hs == 0x2796 || hs == 0x303D ) {
                isEomji = YES;
            } else if(hs >= 0x2648 && hs <= 0x2653){
                isEomji = YES;
            }
        
    }];
    return isEomji;
}
@end








