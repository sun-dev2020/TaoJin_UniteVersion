//
//  SortModule.m
//
//
//  Created by Hack on 13-12-17.
//

#import "SortModule.h"

NSString *sortKey;
SortKeyType sortKeyType;
Boolean ascending;

@implementation SortModule

+ (NSString *)getStringValue:(NSDictionary *)dictionary withSortKey:(NSString *)kSortKey {
    return [(NSString *)[dictionary objectForKey:kSortKey] isKindOfClass:[NSNull class]] ? @"": (NSString *)[dictionary objectForKey:kSortKey];
}

NSComparisonResult compareDictionary(NSDictionary *firstDict, NSDictionary *secondDict, void *context) {
        switch (sortKeyType) {
        case SortKey_string:
        {
            NSString *string_first = [SortModule getStringValue:firstDict withSortKey:sortKey];
            NSString *string_second = [SortModule getStringValue:secondDict withSortKey:sortKey];
            if (ascending){
                return [string_first caseInsensitiveCompare:string_second];
            }else{
                if ([string_first caseInsensitiveCompare:string_second]==NSOrderedAscending){
                    return NSOrderedDescending;
                }else if ([string_first caseInsensitiveCompare:string_second]==NSOrderedDescending){
                    return NSOrderedAscending;
                }else{
                    return NSOrderedSame;
                }
            }
        }
            break;
        default:
            break;
    }
}


/**
 * 
 * @param array      源数据
 * @param key        排序字段 
 * @param ascending  是否升序 true 升序 false 降序
 * @return array
 */


+(NSArray *) sortWithArray:(NSArray *)array initWithKey:(NSString *)key WithKeyType:(SortKeyType)keyType Withascending:(Boolean)asc{
    if ((array)&&(array.count>0)){
        sortKey = key;
        sortKeyType = keyType;
        ascending = asc;
        NSArray *sortedArray = [array sortedArrayUsingFunction:compareDictionary context:NULL];
        return sortedArray;
        
    }else{
        return array;
    }
}

+(NSArray *)sortWithArray:(NSArray *)array initWithKey:(NSString *)key Withascending:(Boolean)ascending {
    return [SortModule sortWithArray:array initWithKey:key WithKeyType:SortKey_string Withascending:ascending];
}

@end
