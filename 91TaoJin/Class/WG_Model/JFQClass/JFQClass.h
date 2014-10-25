//
//  JFQClass.h
//  91TaoJin
//
//  Created by keyrun on 14-3-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFQClass : NSObject

@property(nonatomic,strong) NSString* content;
@property(nonatomic,strong) NSString* gold;
@property(nonatomic,strong) NSString* icon;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* nick;

@property(nonatomic,assign) int add_ad;
@property(nonatomic,assign) int add_gold;
-(id)initWithDictionary:(NSDictionary* )dic;
@end
