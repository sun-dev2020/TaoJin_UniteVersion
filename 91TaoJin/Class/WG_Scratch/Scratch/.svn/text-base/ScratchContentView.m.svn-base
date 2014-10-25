//
//  ScratchContentView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-23.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ScratchContentView.h"

@implementation ScratchContentView{
    CGContextRef context;
    NSArray *_awardsAry;
    NSArray *_scratchContentAry;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setOpaque:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 0.5);
    UIFont *font = [UIFont boldSystemFontOfSize:11.0];
    if(_awardsAry.count > 0){
        for(int i = 0 ; i < 3 ; i ++){
            for(int j = 0 ; j < 2 ; j ++){
                NSString *text = [_awardsAry objectAtIndex:(2 * i + j)];
                text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
                [text drawInRect:CGRectMake(0 + j * 100, 16 + i * 22, 80, 11) withFont:font];
            }
        }
    }
    CGContextSetRGBFillColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0);
    if(_scratchContentAry.count > 0){
        for(int i = 0 ; i < 3 ; i ++){
            for(int j = 0 ; j < 2 ; j ++){
                int index = 2 * i + j;
                if(index < _scratchContentAry.count){
                    NSString *text = [_scratchContentAry objectAtIndex:(2 * i + j)];
                    [text drawInRect:CGRectMake(40 + j * 100, 16 + i * 22, 80, 11) withFont:font];
                }else{
                    break;
                }
            }
        }
    }
}

- (void)setAwards:(NSArray *)awardsAry{
    _awardsAry = awardsAry;
    [self setNeedsDisplay];
}

- (void)setScratchContents:(NSArray *)scratchContentAry{
    _scratchContentAry = scratchContentAry;
    [self setNeedsDisplay];
}

@end
