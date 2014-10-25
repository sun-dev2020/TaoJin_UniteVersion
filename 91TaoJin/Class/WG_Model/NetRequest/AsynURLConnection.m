//
//  AsynURLConnection.m
//  91TaoJin
//
//  Created by keyrun on 14-4-14.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "AsynURLConnection.h"
#import "JSNsstring.h"
#import "MyUserDefault.h"
#import   "OriginData.h"
#import "NSData+DesCode.h"
#import "JSONKit.h"
#import "GTMBase64.h"
@implementation AsynURLConnection{
    NSTimer *_timer;
   
}
static BOOL sidTimeOut ;
+ (id)requestWithURL:(NSString *)url dataDic:(NSDictionary *)dataDic timeOut:(int)timeOut success:(SuccesssBlock)success fail:(FailBlock)fail
{
    AsynURLConnection *obj = [[self alloc] requestWithURL:url dataDic:dataDic timeOut:timeOut success:success fail:fail];
    return obj;
}

+ (id)requestWithURLToSendJSONL:(NSString *)url boundary:(NSString *)boundary paramStr:(NSString *)paramStr body:(NSMutableData*)body timeOut:(int)timeOut success:(SuccesssBlock)success fail:(FailBlock)fail{
    AsynURLConnection *obj = [[self alloc] requestWithURLToSendJSONL:url boundary:boundary paramStr:paramStr body:body timeOut:timeOut success:success fail:fail];
    return obj;
}

- (id)requestWithURL:(NSString *)url dataDic:(NSDictionary *)dataDic timeOut:(int)timeOut success:(SuccesssBlock)success fail:(FailBlock)fail{
    
    url = [url stringByAppendingString:[[NSString alloc] initWithFormat:@"&ver=%@",AppVersion]];  //2.0.1 请求地址后面加版本信息
    
    NSURL *_url = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:timeOut];
    [request setHTTPMethod:@"POST"];
    
    
//    JSNsstring *jsstring = [[JSNsstring alloc]initStringByDictionary:dataDic];
    
    
    // 2.0.1 请求数据将会被加密
    NSString *jsstring = [dataDic JSONString];
    NSArray *array = [url componentsSeparatedByString:@"&"];
    NSString *codeKey =@"12345678";
    if (array.count > 3 && [[array objectAtIndex:2] isEqualToString:@"m=Login"]) {
        
    }else{
        codeKey =[[MyUserDefault standardUserDefaults] getRequestCodeKey];
    }
    NSString *encryString =[NSData encryptUseDES:jsstring key:codeKey];
    jsstring = [[JSNsstring alloc] initStringByString:encryString];
    NSData *data = [jsstring dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    if ([[MyUserDefault standardUserDefaults] getCookieSid]) {
        if (array.count > 3 && [[array objectAtIndex:2] isEqualToString:@"m=Login"]) {
            // 登陆请求不发送cookieSid  测试发送
        }else{
            [request setValue:[[MyUserDefault standardUserDefaults] getCookieSid] forHTTPHeaderField:@"content-length"];
        }
    }else{
        [request setValue:@"head" forHTTPHeaderField:@"content-length"];
    }

    //自定义时间超时
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeOut target:self selector: @selector(handleTimer) userInfo:nil repeats:NO] ;
    
    self = [super initWithRequest:request delegate:self startImmediately:NO];
    if (self) {
        [self scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _successBlock = [success copy];
        _failBlock = [fail copy];
        [self start];
    }
    
    return self;
}


//用于有图片内容的上传
- (id)requestWithURLToSendJSONL:(NSString *)url boundary:(NSString *)boundary paramStr:(NSString *)paramStr body:(NSMutableData*)body timeOut:(int)timeOut success:(SuccesssBlock)success fail:(FailBlock)fail{
    NSURL *_url = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:_url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:httpTimeout];
    NSString* contentType= [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    self = [super initWithRequest:request delegate:self startImmediately:NO];
    if (self) {
        _successBlock = [success copy];
        _failBlock = [fail copy];
        [self start];
    }
    return self;
}

//时间超时定义
-(void)handleTimer
{
    NSLog(@"连接超时");
    [self connection:self didFailWithError:[NSError errorWithDomain:@"连接超时" code:timeOutErrorCode userInfo:nil]];
    [_timer invalidate];
    _timer = nil;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpRep =(NSHTTPURLResponse *)response;
    if ([httpRep.allHeaderFields objectForKey:@"Set-Cookie"]) {
        NSString *cookieSid =[httpRep.allHeaderFields objectForKey:@"Set-Cookie"];
        [[MyUserDefault standardUserDefaults] setCookieSid:cookieSid];
    }
    if ([httpRep.allHeaderFields objectForKey:@"Server_message"]) {  //头文件中包含重新登录请求时发送通知
        if (sidTimeOut ==NO) {
            sidTimeOut =YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetLogin" object:nil];
            
        }
        
    }
    
    if(_data != nil){
        [_data resetBytesInRange:NSMakeRange(0, _data.length)];
    }else{
        _data = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _successBlock(_data);
    //    if(_timer != nil){
    [_timer invalidate];
    _timer = nil;
    //    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _failBlock(error);
}

@end
