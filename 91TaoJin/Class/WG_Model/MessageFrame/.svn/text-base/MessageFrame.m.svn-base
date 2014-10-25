//
//  MessageFrame.m
//  91TaoJin
//
//  Created by keyrun on 14-5-16.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "MessageFrame.h"
#import "SysMessage.h"
#define kHeadWidth 37   //头像大小
#define kContentWidth 260  // 消息内容宽度
#define kTCoffY  16.0  //时间和文本间隔 上下
#define kICoffx   8.0  //头像和文本间隔  左右
#define kTimeH  11.0  //时间高度
@implementation MessageFrame

-(void) setMessage:(SysMessage *)message{
    _message =message;
    
    if (_showTime) {    //时间位置
        CGFloat timey  =0;
        
        CGSize timeSize =[_message.msgTime sizeWithFont:[UIFont systemFontOfSize:11.0]];
        CGFloat timex =(kmainScreenWidth -timeSize.width )/2;
        _timeFrame =CGRectMake(timex, timey, timeSize.width +20.0, timeSize.height);
    }
    
    CGFloat iconx =kOffX_float;
    if (_message.type ==MessageTypeMe) {    // 自己头像在右
        iconx =320.0 -kOffX_float -kContentWidth;
    }
    CGFloat icony =kTCoffY +_timeFrame.size.height;
    _iconFrame =CGRectMake(iconx, icony, kHeadWidth, kHeadWidth);
    
    CGFloat contentx =iconx +_iconFrame.size.width +kICoffx;
    CGFloat contenty =icony;
    CGSize contentSize  = [_message.msgCom sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(kContentWidth, CGFLOAT_MAX)];
    
    if (_message.type ==MessageTypeMe) {
        contentx =iconx -kICoffx -contentSize.width;
    }
    _contentFrame =CGRectMake(contentx, contenty, contentSize.width, contentSize.height);
    
    if (CGRectGetMaxY(_contentFrame) >CGRectGetMaxY(_iconFrame)) {
        _messageCellHeight  = CGRectGetMaxY(_contentFrame) +kTCoffY;
    }else{
        _messageCellHeight =CGRectGetMaxY(_iconFrame) +kTCoffY;
    }
    NSLog( @" %@  %@  %@",NSStringFromCGRect(_iconFrame) ,NSStringFromCGRect(_timeFrame),NSStringFromCGRect(_contentFrame));
}
@end
