//
//  RewardGoodsView.m
//  TJiphone
//
//  Created by keyrun on 13-9-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardGoodsView.h"
#import "GoodsModel.h"
#import "UIImage+ColorChangeTo.h"
//#import "OriginData.h"
#import "SDImageView+SDWebCache.h"
@implementation RewardGoodsView

@synthesize leftImage = _leftImage;
@synthesize rightImage = _rightImage;

@synthesize leftView = _leftView;
@synthesize rightView = _rightView;

@synthesize leftBgImg = _leftBgImg;
@synthesize rightBgImg = _rightBgImg;

@synthesize leftNeedBeanLab = _leftNeedBeanLab;
@synthesize rightNeedBeanLab = _rightNeedBeanLab;

@synthesize leftBtn = _leftBtn;
@synthesize rightBtn = _rightBtn;

@synthesize isDouble = _isDouble;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(kOffX_float, 0, 150, 143)];
        _leftView.clipsToBounds = YES;
        _leftView.hidden = NO;

        _rightView = [[UIView alloc] initWithFrame:CGRectMake( 6.0f+ kOffX_float + 150, 0, 150, 143)];
        _rightView.clipsToBounds = YES;
        _rightView.hidden = YES;
        
        //加载左边产品图片
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, kOffX_float, 149, 90)];
        _leftImage.clipsToBounds = YES;
        _leftImage.userInteractionEnabled =NO;
        [_leftView addSubview:_leftImage];
        //加载右边产品图片
        _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, kOffX_float, 150, 90)];
        _rightImage.clipsToBounds = YES;
        _rightImage.userInteractionEnabled =NO;
        [_rightView addSubview:_rightImage];
        
        //加载左边产品名称
        _leftNameLab = [self loadWithNameLab:CGRectMake(0, _leftImage.frame.size.height+5.0+_leftImage.frame.origin.y, 144, 12)];
        [_leftView addSubview:_leftNameLab];
        //加载右边产品名称
        _rightNameLab = [self loadWithNameLab:CGRectMake(0, _rightImage.frame.size.height+_rightImage.frame.origin.y +5.0, 144, 12)];
        [_rightView addSubview:_rightNameLab];
        
        /*
        //加载左边的淘金豆logo
        UIImageView *leftBeanImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 111, 19, 19)];
        leftBeanImg.image = [UIImage imageNamed:@"beans_2.png"];
        [_leftView addSubview:leftBeanImg];
        
        //加载右边的淘金豆logo
        UIImageView *rightBeanImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 111, 19, 19)];
        rightBeanImg.image = [UIImage imageNamed:@"beans_2.png"];
        [_rightView addSubview:rightBeanImg];
         */
        
        //加载左边所需淘金豆数量
        _leftNeedBeanLab = [self loadWithNeedBeanLab:CGRectMake(_leftNameLab.frame.origin.x, _leftNameLab.frame.origin.y+_leftNameLab.frame.size.height +5, _leftView.frame.size.width, 16)];
        [_leftView addSubview:_leftNeedBeanLab];
        
        //加载右边所需淘金豆数量
        _rightNeedBeanLab = [self loadWithNeedBeanLab:CGRectMake(_rightNameLab.frame.origin.x , _rightNameLab.frame.origin.y+_rightNameLab.frame.size.height +5, _rightView.frame.size.width, 16)];
        [_rightView addSubview:_rightNeedBeanLab];
      
        /*
        //加载左边库存信息显示
        _leftStockLab = [self loadWithStockLab:CGRectMake(54, 116, 90, 11)];
        [_leftView addSubview:_leftStockLab];
        
        //加载右边库存信息显示
        _rightStockLab = [self loadWithStockLab:CGRectMake(54, 116, 90, 11)];
        [_rightView addSubview:_rightStockLab];
        */
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0.0, _leftImage.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height);
        [_leftView insertSubview:_leftBtn belowSubview:_leftImage];

        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0.0, _rightImage.frame.origin.y, _rightView.frame.size.width, _rightView.frame.size.height);
        [_rightView insertSubview:_rightBtn belowSubview:_rightImage];
        
        _leftBtn.backgroundColor =_rightBtn.backgroundColor =[UIColor clearColor];
//        [_leftBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateHighlighted];
//        [_rightBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateHighlighted];
        [self addSubview:_leftView];
        [self addSubview:_rightView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//初始化产品名称的Label
-(UILabel *)loadWithNameLab:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = KBlockColor2_0;
    label.font = [UIFont systemFontOfSize:kFont2_0_Size11];
    return label;
}

//初始化所需淘金豆的Label
-(UILabel *)loadWithNeedBeanLab:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = KOrangeColor2_0;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    return label;
}

//初始化库存信息的Label
-(UILabel *)loadWithStockLab:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = kSilverColor;
    label.font = [UIFont systemFontOfSize:11.0];
    return label;
}

-(void)initCellContent{
    
    _leftNameLab.text = self.leftGoods.introduce;
    [_leftNameLab sizeToFit];
    
    _rightNameLab.text = self.rightGoods.introduce;
    [_rightNameLab sizeToFit];
    
    _leftNeedBeanLab.text = [NSString stringWithFormat:@"%d",self.leftGoods.needBean];
    [_leftNeedBeanLab sizeToFit];
    
    _rightNeedBeanLab.text = [NSString stringWithFormat:@"%d",self.rightGoods.needBean];
    [_rightNeedBeanLab sizeToFit];
    
    if (_leftGoods.stock == -1) {
        _leftStockLab.text = [NSString stringWithFormat:@"库存:充足"];
    }else{
        _leftStockLab.text = [NSString stringWithFormat:@"库存:%d",self.leftGoods.stock];
    }
    [_leftStockLab sizeToFit];
    _leftStockLab.frame = CGRectMake(_leftView.frame.size.width - _leftStockLab.frame.size.width - 5.0f, _leftStockLab.frame.origin.y, _leftStockLab.frame.size.width, _leftStockLab.frame.size.height);
    
    if (_rightGoods.stock == -1) {
        _rightStockLab.text =[NSString stringWithFormat:@"库存:充足"];
    }else{
        _rightStockLab.text =[NSString stringWithFormat:@"库存:%d",self.rightGoods.stock];
    }
    [_rightStockLab sizeToFit];
    _rightStockLab.frame = CGRectMake(_rightView.frame.size.width - _rightStockLab.frame.size.width - 5.0f, _rightStockLab.frame.origin.y, _rightStockLab.frame.size.width, _rightStockLab.frame.size.height);
}
-(void)prepareForReuse {
//    [super prepareForReuse];
    [_leftImage setImage:nil];
    [_rightImage setImage:nil];
    [super prepareForReuse];
}
@end
