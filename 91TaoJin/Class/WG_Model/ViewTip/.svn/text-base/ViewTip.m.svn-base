//
//  ViewTip.m
//  91淘金
//
//  Created by keyrun on 13-11-15.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "ViewTip.h"
#import "TaoJinLabel.h"

@implementation ViewTip

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setViewTipByImage:(UIImage* )image{
    imageView =[[UIImageView alloc]initWithImage:image];
    if ([UIScreen mainScreen].bounds.size.height > 480.0) {
        imageView.frame =CGRectMake(kmainScreenWidth/2 - imageView.frame.size.width/2, 166, imageView.frame.size.width, imageView.frame.size.height);
    }else{
        imageView.frame =CGRectMake(kmainScreenWidth/2 - imageView.frame.size.width/2, 90, imageView.frame.size.width, imageView.frame.size.height);
    }
    [self addSubview:imageView];
}
-(void)setViewTipByStringOne:(NSString* )string{
   labelOne =[[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height + 13, kmainScreenWidth, 14)];
    labelOne.backgroundColor =[UIColor clearColor];
    labelOne.font =[UIFont systemFontOfSize:14.0];
    labelOne.text =string;
    labelOne.textAlignment =NSTextAlignmentCenter;
    labelOne.textColor =KGrayColor2_0;
    [self addSubview:labelOne];
}
-(void)setViewTipByStringTwo:(NSString* )string{
    UILabel* labelTwo =[[UILabel alloc]initWithFrame:CGRectMake(0, labelOne.frame.origin.y+labelOne.frame.size.height+5, kmainScreenWidth, 14)];
    labelTwo.font =[UIFont systemFontOfSize:14.0];
    labelTwo.backgroundColor=[UIColor clearColor];
    labelTwo.text =string;
    labelTwo.textAlignment =NSTextAlignmentCenter;
    labelTwo.textColor =KGrayColor2_0;
    [self addSubview:labelTwo];
}

/**
 *  设置文案显示
 *
 *  @param content 文案（可包括换行符）
 */
-(void)setViewTipByContent:(NSString *)content{
    TaoJinLabel *label = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, imageView.frame.origin.y + imageView.frame.size.height + 6.0f, kmainScreenWidth, 50.0f) text:content font:[UIFont systemFontOfSize:14.0] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentCenter numberLines:0];
    [label sizeToFit];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, kmainScreenWidth, label.frame.size.height);
    [self addSubview:label];
}

/**
 *  设置图像的位置及显示
 *
 *  @param size 图像所在区域的大小，即superView的size
 *  @param image 图像
 */
-(void)setImageViewWithSize:(CGSize )size image:(UIImage* )image{
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(size.width/2 - image.size.width/2, size.height/2 - image.size.height/2 - 20.0f, image.size.width, image.size.height);
    [self addSubview:imageView];
}


-(void)newImageViewFrame:(CGRect)rect{
    imageView.frame =rect;
    labelOne.frame =CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+13, kmainScreenWidth, 14);
}
@end
