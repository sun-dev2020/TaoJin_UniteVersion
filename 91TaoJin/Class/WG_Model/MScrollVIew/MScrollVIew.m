//
//  MScrollVIew.m
//  TJiphone
//
//  Created by keyrun on 13-10-16.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "MScrollVIew.h"

@implementation MScrollVIew

- (id)initWithFrame:(CGRect)frame andWithPageCount:(int)count backgroundImg:(UIImageView *)backgroundImg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.delegate = self;
        self.bounces = NO;    //控制scrollview 滑动边界效果
        [self setContentSize:CGSizeMake(frame.size.width * count, 0)];
        self.delaysContentTouches =NO;
        self.backgroundColor = [UIColor clearColor];
        if(backgroundImg != nil){
            backgroundImg.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
            [self addSubview:backgroundImg];
        }
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.msDelegate scrollViewDidScroll:self];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.msDelegate scrollViewWillBeginDragging:self];
}

@end
