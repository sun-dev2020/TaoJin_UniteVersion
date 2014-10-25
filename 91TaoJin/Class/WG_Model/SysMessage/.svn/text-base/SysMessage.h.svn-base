//
//  SysMessage.h
//  91淘金
//
//  Created by keyrun on 13-11-25.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    MessageTypeOther =1 ,
    MessageTypeMe =2
    
} MessageType;
@interface SysMessage : NSObject

@property (nonatomic ,assign) int msgId;
@property (nonatomic, strong) NSString* msgCom;
@property (nonatomic, assign) int msgStatus;
@property (nonatomic, strong) NSString* msgTime;
@property (nonatomic ,assign) MessageType type;


-(id)initSysMessageByDic:(NSDictionary*)dic;
@end
