//
//  AsynURLConnection.h
//  91TaoJin
//
//  Created by keyrun on 14-4-14.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccesssBlock) (NSData *data);
typedef void (^FailBlock) (NSError *error);

@interface AsynURLConnection : NSURLConnection<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData *_data;
    SuccesssBlock _successBlock;
    FailBlock _failBlock;
}
+ (id)requestWithURL:(NSString *)url dataDic:(NSDictionary *)dataDic timeOut:(int)timeOut success:(SuccesssBlock)success fail:(FailBlock)fail;
+ (id)requestWithURLToSendJSONL:(NSString *)url boundary:(NSString *)boundary paramStr:(NSString *)paramStr body:(NSMutableData*)body timeOut:(int)timeOut success:(SuccesssBlock)success fail:(FailBlock)fail;
@end
