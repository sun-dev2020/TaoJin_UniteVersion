//
//  CellView.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "CellView.h"
#import "CButton.h"
@implementation CellView
@synthesize bkimage=_bkimage;
@synthesize hotImage=_hotImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 加个Next按钮
//      forwardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [forwardBtn setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
//        forwardBtn.frame=CGRectMake(286, 16, 10, 14);
        nextImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next.png"]];
        nextImage.frame=CGRectMake(296, frame.size.height/2 -6.0, 8, 12);
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}
-(void)setCellViewByType:(int )type andWithImage:(UIImage*)image andCellTitle:(NSString* )title{
    cellImage = [[UIImageView alloc] initWithImage:image];
    _bkimage = [[UIImageView alloc] init];
    _bkimage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _cellTitle = [[UILabel alloc]init];
    _cellTitle.text = title;
    _cellTitle.font = [UIFont systemFontOfSize:16.0];
    [_cellTitle setBackgroundColor:[UIColor clearColor]];
    _cellTitle.textColor = KBlockColor2_0;
    button = [CButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    
    if (type ==3) {
        _hotImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hot.png"]];
        _hotImage.frame=CGRectMake(238, self.frame.size.height/2 -10.0, 51, 20);
        _hotImage.alpha =0;
    }
    
    coinLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, self.frame.size.height/2 -7.0, 170, 14)];
    coinLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    coinLabel.backgroundColor = [UIColor clearColor];
    coinLabel.textAlignment = NSTextAlignmentRight;
 
//    coinImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beans_2.png"]];
//    coinImage.frame = CGRectMake(259, 12, 19, 19);

    messageTip = [[UIImageView alloc]initWithImage:GetImage(@"new@2x.png")];
    messageTip.frame = CGRectMake(263, self.frame.size.height/2 -13, 26, 26);
    messageTip.hidden = YES;
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(263, self.frame.size.height/2 -7, 26, 14)];
    messageLabel.numberOfLines = 0;
    messageLabel.hidden = YES;
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.font = [UIFont systemFontOfSize:14.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = KRedColor2_0;
    self.messageLabel = messageLabel;
    
    UIView* line =[[UIView alloc]initWithFrame:CGRectMake(kOffX_float, self.frame.size.height -0.5, self.frame.size.width -kOffX_float, 0.5)];
    line.backgroundColor =kGrayLineColor2_0;
    
    [self addSubview:button];
    [self addSubview:cellImage];
    [self addSubview:_cellTitle];
    [self addSubview:coinLabel];
    [self addSubview:nextImage];
    [self addSubview:_hotImage];
    [self addSubview:messageLabel];
    [self insertSubview:messageTip belowSubview:messageLabel];
    [self addSubview:line];
//    [self setNeedsDisplay];
}


//设置cell的金豆提示信息
-(void)showCellCoinDetails:(id)coin withIncomeType:(int)type{

    NSNumber* num =[NSNumber numberWithInt:0];
    if (coinLabel.text) {
        coinLabel.text=nil;
    }
    if ([coin isKindOfClass:[NSNull class]]) {
        if (coinImage) {
            [coinImage removeFromSuperview];
        }

    }else{
    switch (type) {
       //红色
        case 1:
        {
            if (coin == nil) {
                if (coinImage) {
                    [coinImage removeFromSuperview];
                }
            }else{
                coinLabel.textColor=kRedColor;
                if (coin ==num) {
                    
                }else{
                coinLabel.text=[NSString stringWithFormat:@"%@",coin];
                [self insertSubview:coinImage belowSubview:nextImage];
                }
            }
                   }
            break;
         //绿色
        case 2:
        {
            coinLabel.textColor=kGreenColor;
            if (coin ==num) {
                
            }else{
            coinLabel.text=[NSString stringWithFormat:@"+%@",coin];
             [self insertSubview:coinImage belowSubview:nextImage];
            }
        }
            break;
    }
    }
}
//设置cell的消息提示
-(void)showCellMessageTip:(int)number{
    if (number >0) {
         messageLabel.text=[NSString stringWithFormat:@"%d",number];
        messageLabel.hidden=NO;
        messageTip.hidden=NO;
    }else{
        messageLabel.hidden=YES;
        messageTip.hidden=YES;
    }
}
-(void)setTitleLabFont:(float)size andTitleColor:(UIColor *)color{
    _cellTitle.font =[UIFont systemFontOfSize:size];
    _cellTitle.textColor =color;
}
-(void)setButtonFrame:(CGRect)buttonFrame{
    button.frame=buttonFrame;
}
-(void)setImageFrame:(CGRect )imageFrame andTitleFrame:(CGRect)titleFrame {
    cellImage.frame=imageFrame;
    _cellTitle.frame=titleFrame;
    
}
-(void)drawRect:(CGRect)rect{
  /*
    float height =self.frame.size.height;
    CGContextRef currentContext =UIGraphicsGetCurrentContext();
//    CGContextBeginPath(currentContext);
    CGContextSetStrokeColorWithColor(currentContext, KGrayColor2_0.CGColor);
    CGContextSetLineWidth(currentContext, 0.5f);
    
    CGContextMoveToPoint(currentContext, 320, height-0.5f);
    CGContextAddLineToPoint(currentContext, kOffX_float, height-0.5f);
    CGContextStrokePath(currentContext);
   */
}
@end
