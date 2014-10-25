//
//  DashLine.m
//  91TaoJin
//
//  Created by keyrun on 14-5-26.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "DashLine.h"

@implementation DashLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, KRedColor2_0.CGColor);
    float lengths[] ={2,2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    CGContextStrokePath(context);
//    CGContextClosePath(context);

}


@end
