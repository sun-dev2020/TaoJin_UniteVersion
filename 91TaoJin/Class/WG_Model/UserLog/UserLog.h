//
//  UserLog.h
//  TJiphone
//
//  Created by keyrun on 13-10-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLog : NSObject

@property(nonatomic,assign) int logId;
@property(nonatomic,strong) NSString* message;
@property(nonatomic,strong) NSString* time;
@property(nonatomic,strong) NSString* value;

- (id)initWithDictionary:(NSDictionary* )dic;

@end
