//
//  NewJFQCell.m
//  91TaoJin
//
//  Created by keyrun on 14-3-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "NewJFQCell.h"

@implementation NewJFQCell{
    UILabel *leftZhuanQianLab;                                          //左边【赚钱频道】显示文案
    UILabel *rightZhuanQianLab;                                         //右边【赚钱频道】显示文案
    
    UILabel *leftJinDouLab;                                             //左边【金豆】显示文案
    UILabel *rightJinDouLab;                                            //右边【金豆】显示文案
}

@synthesize leftJFQ = _leftJFQ;
@synthesize rightJFQ = _rightJFQ;

@synthesize leftImage = _leftImage;
@synthesize rightImage = _rightImage;

@synthesize leftAdGenXinImg = _leftAdGenXinImg;
@synthesize rightAdGenXinImg = _rightAdGenXinImg;

@synthesize leftAdNumberLab = _leftAdNumberLab;
@synthesize rightAdNumberLab = _rightAdNumberLab;

@synthesize leftNameLab = _leftNameLab;
@synthesize rightNameLab = _rightNameLab;

@synthesize leftBeanNumberLab = _leftBeanNumberLab;
@synthesize rightBeanNumberLab = _rightBeanNumberLab;

@synthesize isDouble = _isDouble;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        self.frame = CGRectMake(0, 0, kmainScreenWidth, 75);
        [self setUserInteractionEnabled:YES];
        
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth/2, 75)];
        [self.contentView addSubview:self.leftView];
        self.rightView = [[UIView alloc]initWithFrame:CGRectMake(160.5, 0, 159.5, 75)];
        self.rightView.hidden = YES;
        [self.contentView addSubview:self.rightView];
        
        self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 12, 50, 50)];
        [self.leftView addSubview:self.leftImage];
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 12, 50, 50)];
        [self.rightView addSubview:self.rightImage];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = self.leftView.frame;
        [self.leftButton setBackgroundColor:[UIColor clearColor]];
        self.leftButton.tag = kJfqLeftTag;
        [self.leftButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
        [self.leftButton addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftButton addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchUpOutside];
        [self.leftButton addTarget:self action:@selector(cancelTouch) forControlEvents:UIControlEventTouchCancel];
        [self.leftView addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(0.0f, 0.0f, self.rightView.frame.size.width, self.rightView.frame.size.height);
        [self.rightButton setBackgroundColor:[UIColor clearColor]];
        self.rightButton.tag = kJfqRightTag;
        [self.rightButton addTarget:self action:@selector(onClickBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton addTarget:self action:@selector(changeColor2:) forControlEvents:UIControlEventTouchDown];
        [self.rightButton addTarget:self action:@selector(revertColor2:) forControlEvents:UIControlEventTouchUpOutside];
        [self.rightButton addTarget:self action:@selector(cancelTouch2) forControlEvents:UIControlEventTouchCancel];
        [self.rightView addSubview:self.rightButton];
        
        //左边红点图片
        self.leftAdGenXinImg = [self loadWithAdGenXinImage:CGRectMake(self.leftImage.frame.origin.x + self.leftImage.frame.size.width - 14, 5, 21, 21)];
        self.leftAdGenXinImg.hidden = YES;
        [self.leftView addSubview:self.leftAdGenXinImg];
        //左边红点上的数字
        self.leftAdNumberLab = [self loadWithAdGenXinNumberLabel:_leftAdGenXinImg.frame];
        self.leftAdNumberLab.hidden = YES;
        [self.leftView addSubview:self.leftAdNumberLab];
        
        //右边红点图片
        self.rightAdGenXinImg = [self loadWithAdGenXinImage:CGRectMake(self.rightImage.frame.origin.x + self.rightImage.frame.size.width - 14, 5, 21, 21)];
        self.rightAdGenXinImg.hidden = YES;
        [self.rightView addSubview:self.rightAdGenXinImg];
        //右边红点上的数字
        self.rightAdNumberLab = [self loadWithAdGenXinNumberLabel:self.rightAdGenXinImg.frame];
        self.rightAdNumberLab.hidden = YES;
        [self.rightView addSubview:self.rightAdNumberLab];
        
        //左边积分墙的名称
        self.leftNameLab = [self loadWithUniversalLabel:CGRectMake(63, 20, 0, 16) font:[UIFont systemFontOfSize:16.0]];
        self.leftNameLab.textColor = KBlockColor2_0;
        [self.leftView addSubview:self.leftNameLab];
        //右边积分墙的名称
        self.rightNameLab = [self loadWithUniversalLabel:CGRectMake(63, 20, 0, 16) font:[UIFont systemFontOfSize:16.0]];
        self.rightNameLab.textColor = KBlockColor2_0;
        [self.rightView addSubview:self.rightNameLab];
        
        //左边【赚钱频道】文案
        leftZhuanQianLab = [self loadWithUniversalLabel:CGRectMake(self.leftNameLab.frame.origin.x + self.leftNameLab.frame.size.width, 25, 100, 11) font:[UIFont systemFontOfSize:11.0]];
        [self.leftView addSubview:leftZhuanQianLab];
        //右边【赚钱频道】文案
        rightZhuanQianLab = [self loadWithUniversalLabel:CGRectMake(self.rightNameLab.frame.origin.x + self.rightNameLab.frame.size.width, 25, 100, 11) font:[UIFont systemFontOfSize:11.0]];
        [self.rightView addSubview:rightZhuanQianLab];
        
        //左边金豆数量
        self.leftBeanNumberLab = [self loadWithBeanNumberLabel:CGRectMake(self.leftNameLab.frame.origin.x, 41, 0, 12)];
        [self.leftView addSubview:self.leftBeanNumberLab];
        //右边金豆数量
        self.rightBeanNumberLab = [self loadWithBeanNumberLabel:CGRectMake(self.rightNameLab.frame.origin.x, 41, 0, 12)];
        [self.rightView addSubview:self.rightBeanNumberLab];
        
        //左边【金豆】文案
        leftJinDouLab = [self loadWithUniversalLabel:CGRectMake(self.leftBeanNumberLab.frame.origin.x + self.leftBeanNumberLab.frame.size.width + 5, 48, 100, 9) font:[UIFont systemFontOfSize:9.0]];
        [self.leftView addSubview:leftJinDouLab];
        //右边【金豆】文案
        rightJinDouLab = [self loadWithUniversalLabel:CGRectMake(self.rightBeanNumberLab.frame.origin.x + self.rightBeanNumberLab.frame.size.width + 5, 48, 100, 9) font:[UIFont systemFontOfSize:9.0]];
        [self.rightView addSubview:rightJinDouLab];
        
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0f, kmainScreenWidth, 0.5)];
        topLine.backgroundColor = kLineColor2_0;
        
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 74.5, kmainScreenWidth/2, 0.5)];
        leftLine.backgroundColor = kLineColor2_0;
        
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(kmainScreenWidth/2, 74.5, kmainScreenWidth/2, 0.5)];
        rightLine.backgroundColor = kLineColor2_0;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kmainScreenWidth/2, 0, 0.5, 75)];
        line.backgroundColor = kLineColor2_0;
        
        [self  addSubview:topLine];
//        [self addSubview:leftLine];
        [self addSubview:line];
//        [self addSubview:rightLine];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//初始化更新的红点图片
-(UIImageView *)loadWithAdGenXinImage:(CGRect )frame{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tipNumber.png"]];
    imageView.frame = frame;
    return imageView;
}

//初始化红点图片上的数字
-(UILabel *)loadWithAdGenXinNumberLabel:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = KRedColor2_0;
    label.font = [UIFont systemFontOfSize:11.0];
    return label;
}

//初始化通用的Label
-(UILabel *)loadWithUniversalLabel:(CGRect )frame font:(UIFont *)font{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
//    label.textColor = kNameColor;
    
    label.font = font;
    return label;
}

//初始化金豆数量的Label
-(UILabel *)loadWithBeanNumberLabel:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = KOrangeColor2_0;
    label.text = [NSString stringWithFormat:@"+%d",self.leftJFQ.add_gold];
//    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    return label;
}

//加载cell的内容
-(void)loadWithCellContent{
    if(_leftJFQ.add_ad != 0){
        _leftAdNumberLab.text = [NSString stringWithFormat:@"%d",_leftJFQ.add_ad];
        if(_leftJFQ.add_ad >= 10){
            _leftAdNumberLab.font = [UIFont systemFontOfSize:10];
        }
        [_leftAdNumberLab sizeToFit];
        _leftAdGenXinImg.hidden = NO;
        _leftAdNumberLab.hidden = NO;
        float x = 2.0f;
        if(_leftAdNumberLab.text.length > 1){
            x = 1.0f;
        }
        _leftAdNumberLab.frame = CGRectMake(_leftAdGenXinImg.frame.origin.x + (_leftAdGenXinImg.frame.size.width/2 - _leftAdNumberLab.frame.size.width/2) + x, _leftAdGenXinImg.frame.origin.y + (_leftAdGenXinImg.frame.size.height/2 - _leftAdNumberLab.frame.size.height/2) - 1.0f, _leftAdNumberLab.frame.size.width, _leftAdNumberLab.frame.size.height);
    }else{
        _leftAdGenXinImg.hidden = YES;
        _leftAdNumberLab.hidden = YES;
    }
    if(_rightJFQ.add_ad != 0 && _isDouble){
        _rightAdNumberLab.text = [NSString stringWithFormat:@"%d",_rightJFQ.add_ad];
        if(_rightJFQ.add_ad >= 10){
            _rightAdNumberLab.font = [UIFont systemFontOfSize:10];
        }
        [_rightAdNumberLab sizeToFit];
        _rightAdGenXinImg.hidden = NO;
        _rightAdNumberLab.hidden = NO;
        float x = 2.0f;
        if(_rightAdNumberLab.text.length > 1){
            x = 1.0f;
        }
        _rightAdNumberLab.frame = CGRectMake(_rightAdGenXinImg.frame.origin.x + (_rightAdGenXinImg.frame.size.width/2 - _rightAdNumberLab.frame.size.width/2) + x, _rightAdGenXinImg.frame.origin.y + (_rightAdGenXinImg.frame.size.height/2 - _rightAdNumberLab.frame.size.height/2) - 1.0f, _rightAdNumberLab.frame.size.width, _rightAdNumberLab.frame.size.height);
    }else{
        _rightAdGenXinImg.hidden = YES;
        _rightAdNumberLab.hidden = YES;
    }
    
    _leftNameLab.text = _leftJFQ.name;
    [_leftNameLab sizeToFit];
    _rightNameLab.text = _rightJFQ.name;
    [_rightNameLab sizeToFit];
    
    leftZhuanQianLab.text = @"赚钱频道";
    leftZhuanQianLab.textColor = [UIColor grayColor];
    [leftZhuanQianLab sizeToFit];
    leftZhuanQianLab.frame = CGRectMake(_leftNameLab.frame.origin.x + _leftNameLab.frame.size.width, leftZhuanQianLab.frame.origin.y, leftZhuanQianLab.frame.size.width, leftZhuanQianLab.frame.size.height);
    rightZhuanQianLab.text = @"赚钱频道";
    rightZhuanQianLab.textColor = [UIColor grayColor];
    [rightZhuanQianLab sizeToFit];
    rightZhuanQianLab.frame = CGRectMake(_rightNameLab.frame.origin.x + _rightNameLab.frame.size.width, rightZhuanQianLab.frame.origin.y, rightZhuanQianLab.frame.size.width, rightZhuanQianLab.frame.size.height);
    
    _leftBeanNumberLab.text = [NSString stringWithFormat:@"+%d",_leftJFQ.add_gold];
    [_leftBeanNumberLab sizeToFit];
    _rightBeanNumberLab.text = [NSString stringWithFormat:@"+%d",_rightJFQ.add_gold];
    [_rightBeanNumberLab sizeToFit];
    
    /*
     // 2.0版本不显示
    leftJinDouLab.text = @"金豆";
    [leftJinDouLab sizeToFit];
    leftJinDouLab.frame = CGRectMake(_leftBeanNumberLab.frame.origin.x + _leftBeanNumberLab.frame.size.width + 5.0f, leftJinDouLab.frame.origin.y, leftJinDouLab.frame.size.width, leftJinDouLab.frame.size.height);
    rightJinDouLab.text = @"金豆";
    [rightJinDouLab sizeToFit];
    rightJinDouLab.frame = CGRectMake(_rightBeanNumberLab.frame.origin.x + _rightBeanNumberLab.frame.size.width + 5.0f, rightJinDouLab.frame.origin.y, rightJinDouLab.frame.size.width, rightJinDouLab.frame.size.height);
    */
    
    if(_isDouble){
        self.rightView.hidden = NO;
    }else{
        self.rightView.hidden = YES;
    }
}

-(void)receiveTapGesture:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:self.leftView];
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointZero inView:self];
    if (pan.state ==UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(self.leftView.frame, point)) {
            self.leftView.backgroundColor = kSelectBGColor;
        }else if (CGRectContainsPoint(self.rightView.frame, point)){
            self.rightView.backgroundColor = kSelectBGColor;
        }

    }else if (pan.state ==UIGestureRecognizerStateChanged){
        if (CGRectContainsPoint(self.leftView.frame, point)) {
            self.leftView.backgroundColor = kSelectBGColor;
        }else if (CGRectContainsPoint(self.rightView.frame, point)){
            self.rightView.backgroundColor = kSelectBGColor;
        }

    }else if (pan.state ==UIGestureRecognizerStateEnded){
        UIColor*color =self.leftView.backgroundColor;
        if ( [color isEqual:kSelectBGColor]) {
            NSLog(@"changecolor");
            self.leftView.backgroundColor =[UIColor clearColor];
        }
        if (self.rightView.backgroundColor == kSelectBGColor) {
            self.rightView.backgroundColor =[UIColor clearColor];
        }

    }
}

-(void)changeColor:(UIButton* )btn{
    self.leftView.backgroundColor = kJFQSelctColor2_0;
}
-(void)revertColor:(UIButton* )btn{
    self.leftView.backgroundColor =[UIColor clearColor];
}
-(void)onClickBtn:(UIButton* )btn{
    self.leftView.backgroundColor =[UIColor clearColor];
}
-(void)cancelTouch{
    self.leftView.backgroundColor =[UIColor clearColor];
}
-(void)cancelTouch2{
    self.rightView.backgroundColor =[UIColor clearColor];
}
-(void)onClickBtn2:(UIButton* )btn{
    self.rightView.backgroundColor =[UIColor clearColor];
}
-(void)changeColor2:(UIButton* )btn{
    self.rightView.backgroundColor =kJFQSelctColor2_0;
}
-(void)revertColor2:(UIButton* )btn{
    self.rightView.backgroundColor =[UIColor clearColor];
}

@end
