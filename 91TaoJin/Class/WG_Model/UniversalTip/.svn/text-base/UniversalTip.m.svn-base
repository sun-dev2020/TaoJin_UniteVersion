//
//  UniversalTip.m
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "UniversalTip.h"
#define kImageX 6.0
#define kImageY 7.0
#define kImageX2  8.0

@implementation UniversalTip

@synthesize tipImage =_tipImage;
@synthesize heightArray = _heightArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andTips:(NSArray *)tips andTipBackgrundColor:(UIColor *)tintColor withTipFont:(UIFont *)font andTipImage:(UIImage *)image andTipTitle:(NSString *)title andTextColor:(UIColor *)textColor{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =tintColor;
        self.heightArray =[[NSMutableArray alloc]init];
        if (image !=nil) {
            self.tipImage = [self loadTipImageWithImage:image];
            [self addSubview:self.tipImage];
        }
        self.tipTitle = [self loadTipTitleWith:title andTextFont:font andTextColor:textColor];
        [self addSubview:self.tipTitle];
        
        if (tips.count != 0) {
            [self loadTipsWith:tips andFont:font andTextColor:textColor];
        }
        if (self.heightArray.count !=0) {
            UILabel *label =[self.heightArray lastObject];
            self.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, label.frame.origin.y+label.frame.size.height+10);
        }
    }
    return self;
}

-(void)loadTipsWith:(NSArray *)array andFont:(UIFont *)font andTextColor:(UIColor *)color{
    for (int i=0; i<array.count; i++) {
        NSString *content =[array objectAtIndex:i];
        UILabel *lastLabel = [_heightArray objectAtIndex:i];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(kImageX, lastLabel.frame.origin.y +lastLabel.frame.size.height  , self.frame.size.width - (2 * kImageX), 0)];
        label.backgroundColor =[UIColor clearColor];
        label.font =font;
        label.text =content;
        label.textColor =color;
        label.numberOfLines =0;
        label.lineBreakMode =NSLineBreakByWordWrapping;
        label.textAlignment = UITextAlignmentLeft;
        [label sizeToFit];
        label.frame =CGRectMake(kImageX, lastLabel.frame.origin.y +lastLabel.frame.size.height, self.frame.size.width - (2 * kImageX), label.frame.size.height);
        [self addSubview:label];
        [_heightArray addObject:label];
    }
}

//更新Tip内容
-(void)uploadTipContent:(NSArray *)array andFont:(UIFont *)font andTextColor:(UIColor *)color needAdjustPosition:(BOOL)isNeed{
    for(int i = _heightArray.count - 1 ; i > 0 ; i --){
        UILabel *label = (UILabel *)[_heightArray objectAtIndex:i];
        [label removeFromSuperview];
        [_heightArray removeLastObject];
    }
    for (int i=0; i<array.count; i++) {
        NSString *content =[array objectAtIndex:i];
        UILabel *lastLabel = [_heightArray objectAtIndex:i ];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(kImageX, lastLabel.frame.origin.y +lastLabel.frame.size.height  , self.frame.size.width - (2 * kImageX), 0)];
        label.backgroundColor =[UIColor clearColor];
        label.font =font;
        label.text =content;
        label.textColor =color;
        label.numberOfLines =0;
        label.lineBreakMode =NSLineBreakByWordWrapping;
        label.textAlignment = UITextAlignmentLeft;
        [label sizeToFit];
        if (isNeed) {
            label.frame =CGRectMake(kImageX2 +2, lastLabel.frame.origin.y +lastLabel.frame.size.height, self.frame.size.width -(2 *kImageX2), label.frame.size.height);
        }else{
            label.frame =CGRectMake(kImageX, lastLabel.frame.origin.y +lastLabel.frame.size.height, self.frame.size.width - (2 * kImageX), label.frame.size.height);
        }
        [self addSubview:label];
        [_heightArray addObject:label];
    }
    if (self.heightArray.count !=0) {
        UILabel *label =[self.heightArray lastObject];
        self.frame =CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, label.frame.origin.y+label.frame.size.height+10);
    }
}

-(UIImageView *)loadTipImageWithImage:(UIImage *)image{
    UIImageView * imageView =[[UIImageView alloc]initWithImage:image];
    imageView.frame =CGRectMake(kImageX, kImageY, image.size.width, image.size.height);
    return imageView;
}

-(UILabel *)loadTipTitleWith:(NSString *)title andTextFont:(UIFont *)font andTextColor:(UIColor *)color{
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(self.tipImage.frame.origin.x +self.tipImage.frame.size.width + 6, self.tipImage.frame.origin.y + 2, self.frame.size.width -(self.tipImage.frame.origin.x +self.tipImage.frame.size.width + 6), self.tipImage.frame.size.height)];
    label.font =font;
    label.backgroundColor =[UIColor clearColor];
    label.text =title;
    label.textColor =color;
    CGRect oldFrame =label.frame;
    [label sizeToFit];
    label.frame =CGRectMake(oldFrame.origin.x, oldFrame.origin.y, label.frame.size.width, self.tipImage.frame.size.height);
    [_heightArray addObject:label];
    return label;
}

-(float)getLabelWidth{
    return self.frame.size.width - (2 * kImageX);
}
@end







