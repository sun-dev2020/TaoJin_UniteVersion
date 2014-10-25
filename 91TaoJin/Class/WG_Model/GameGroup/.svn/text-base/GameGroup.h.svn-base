//
//  GameGroup.h
//  TJiphone
//
//  Created by keyrun on 13-10-11.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameGroup : NSObject

@property(nonatomic,assign)int appId;
@property(nonatomic,strong)NSString* appName;
@property(nonatomic,assign)int appSize;
@property(nonatomic,assign)int appScore;
@property(nonatomic,strong)NSString* appIcon;
@property(nonatomic,strong)NSString *appInfor;
@property(nonatomic,strong)NSString* appUrl;
@property(nonatomic,assign)int giftBeanNum;
@property(nonatomic,assign)int getBeanNum;
@property(nonatomic,strong)NSString* appIntroduce;
@property(nonatomic,strong)NSMutableArray* subCells;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong) NSString* adUrl;
@property(nonatomic,strong)NSString* udidUrl;

@property(nonatomic,strong)NSString* appdescription;                //任务描述
@property(nonatomic,assign)int signIn;
@property(nonatomic,strong)NSString* schemes;

@property(nonatomic,assign) int signInState;        //签到状态
@property(nonatomic,assign) int missionState;

//2.0.1
@property (nonatomic ,assign) int superLink;          //是否自动链接回调地址

-(id)initGameAllInfor:(NSDictionary* )gamedic andisOpen:(BOOL)openOrNot index:(int )index;

-(id)initGameAllInfor:(NSDictionary* )gamedic andisOpen:(BOOL)openOrNot;
@end
