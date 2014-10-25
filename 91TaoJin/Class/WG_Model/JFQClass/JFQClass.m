//
//  JFQClass.m
//  91TaoJin
//
//  Created by keyrun on 14-3-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "JFQClass.h"

@implementation JFQClass

-(id)initWithDictionary:(NSDictionary* )dic{
    self =[super init];
    if (self) {
        self.content =[dic objectForKey:@"content"];
        self.gold =[dic objectForKey:@"gold"];
        self.icon =[dic objectForKey:@"icon"];
        self.name =[dic objectForKey:@"name"];
        self.nick =[dic objectForKey:@"nick"];
        self.add_ad =[[dic objectForKey:@"add_ad"]intValue];
        self.add_gold =[[dic objectForKey:@"add_gold"]intValue];
    }
    return self;
}

@end
