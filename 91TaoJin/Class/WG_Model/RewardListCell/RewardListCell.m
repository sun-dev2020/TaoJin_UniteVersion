//
//  RewardListCell.m
//  TJiphone
//
//  Created by keyrun on 13-10-16.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardListCell.h"
#import "StatusBar.h"
#import "NSString+IsEmply.h"
#import "CButton.h"
#import "UIImage+ColorChangeTo.h"
#define kCellOffx  8.0
#define kCellOffy  12.0
@implementation RewardListCell{
    float secLBHeight;
    float height;
}

@synthesize bgImage = _bgImage;
@synthesize firstLB = _firstLB;
@synthesize secLB = _secLB;
@synthesize thrLB = _thrLB;
@synthesize fouLB = _fouLB;
@synthesize state = _state;
@synthesize logo = _logo;

@synthesize haveVersandLab = _haveVersandLab;
@synthesize toCopyBtn = _toCopyBtn;
@synthesize toCopyBtn2 = _toCopyBtn2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        secLBHeight = 0.0f;
        height = 0.0f;
        
//        self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 110)];
//        [self addSubview:self.bgImage];
        
        self.firstLB = [self loadWithLabel:CGRectMake(kCellOffx ,kCellOffy , 280, 15)];
        [self addSubview:self.firstLB];
        
        self.secLB = [self loadWithLabel:CGRectMake(kCellOffx, self.firstLB.frame.origin.y + self.firstLB.frame.size.height , 300, 11)];
        self.secLB .hidden = YES;
        [self addSubview:self.secLB];
        
        self.thrLB = [self loadWithLabel:CGRectMake(kCellOffx, self.secLB.frame.origin.y + self.secLB.frame.size.height, 300, 11)];
        [self addSubview:self.thrLB];
        
        self.fouLB = [self loadWithLabel:CGRectMake(kCellOffx, self.thrLB.frame.origin.y + self.thrLB.frame.size.height , 300, 11)];
        [self addSubview:self.fouLB];
        
        self.state = [self loadWithStateLabel:CGRectMake(kCellOffx, 85, 250, 14)];
        [self addSubview:self.state];
        
        self.state2 =[self loadWithStateLabel:CGRectMake(kCellOffx, self.state.frame.origin.y +self.state.frame.size.height +14, 250, 14)];
        
        self.haveVersandLab = [self loadWithHaveVersandLab:CGRectMake(280, kCellOffy, 40, 11)];
        self.haveVersandLab.hidden = YES;
        [self addSubview:self.haveVersandLab];
        
        self.toCopyBtn = [self loadWithCopyButton:CGRectMake(242, self.state.frame.origin.y - 6, 70, 25)];
        self.toCopyBtn.tag = 1;
        self.toCopyBtn.hidden = YES;
        [self addSubview:self.toCopyBtn];
        
        self.toCopyBtn2 = [self loadWithCopyButton:CGRectMake(242, self.state2.frame.origin.y - 6, 70, 25)];
        self.toCopyBtn2.tag = 2;
        self.toCopyBtn2.hidden = YES;
        [self addSubview:self.toCopyBtn2];
    
        
    }
    return self;
}

-(void)loadSeparatorLine{
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, [self getCellHeight] -0.5, kmainScreenWidth, 0.5)];
    lineView.backgroundColor =kGrayLineColor2_0;
    [self addSubview:lineView];
}

//初始化各项Label
-(UILabel *)loadWithLabel:(CGRect )frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = KGrayColor2_0;
    label.font = [UIFont systemFontOfSize:11.0];
    return label;
}

//初始化状态
-(UILabel *)loadWithStateLabel:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = KOrangeColor2_0;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

//初始化已发货
-(UILabel *)loadWithHaveVersandLab:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:11.0];
    label.textColor = KGreenColor2_0;
    label.backgroundColor = [UIColor clearColor];
//    label.transform = CGAffineTransformMakeRotation(0.75);
    return label;
}

//初始化【复制】按钮
-(UIButton *)loadWithCopyButton:(CGRect )frame{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"复制" forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont systemFontOfSize:14.0];
    button.frame = frame;
    [button setBackgroundImage:[UIImage createImageWithColor:KOrangeColor2_0] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage createImageWithColor:kSelectYellow] forState:UIControlStateHighlighted];
    //    button.frame =CGRectMake(250, state.frame.origin.y-3, 60, 20);
    [button addTarget:self action:@selector(copyGoodsOrder:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)initCellContent{
    [self loadSeparatorLine];
    
    _firstLB.text = [NSString stringWithFormat:@"奖品名称 : %@",self.goods.goodsName];
    [_firstLB sizeToFit];
    _firstLB.frame = CGRectMake(kCellOffx, kCellOffy, kmainScreenWidth - 20.0f, _firstLB.frame.size.height);

    
    if (self.goods.goodsType == 1 ) {
        NSString* name = self.goods.goodsQQ;
        _secLB.text =[NSString stringWithFormat:@"充值QQ号 : %@",name];
    }else if (self.goods.goodsType ==2 ){
        NSString* name = self.goods.goodsPhone;
        _secLB.text =[NSString stringWithFormat:@"充值手机号 : %@",name];
    }else if(self.goods.goodsType ==3 ){
//        NSString* name = self.goods.goodsCode;
//        _secLB.text =[NSString stringWithFormat:@"游戏道具 : %@",name];
    }else if (self.goods.goodsType ==4){
        NSString* name = self.goods.goodsAddress;
        _secLB.text =[NSString stringWithFormat:@"邮寄地址 : %@",name];
    }else if (self.goods.goodsType ==5){
//        NSString* name = self.goods.goodsCode;
//        firstLB.text =[NSString stringWithFormat:@"邮寄地址 : %@",name];
    }else if (self.goods.goodsType ==6){
        NSString* name = self.goods.goodsUserAccount;
        _secLB.text =[NSString stringWithFormat:@"支付宝号 : %@",name];
    }else if (self.goods.goodsType ==7){
        NSString* name = self.goods.goodsUserAccount;
        _secLB.text =[NSString stringWithFormat:@"财付通号 : %@",name];
    }
    
    if(![NSString isEmply:_secLB.text]){
        [_secLB sizeToFit];
        _secLB.frame = CGRectMake(_secLB.frame.origin.x, _firstLB.frame.origin.y + _firstLB.frame.size.height + 2, kmainScreenWidth - 20.0f, _secLB.frame.size.height);
        if(_secLB.hidden != NO){
            _secLB.hidden = NO;
            height = _secLB.frame.size.height;
            secLBHeight = height + 2.0f;
        }else{
            secLBHeight = 0.0;
        }
    }else{
        if(_secLB.hidden != YES){
            _secLB.hidden = YES;
            secLBHeight = -height - 2.0;
        }else{
            secLBHeight = 0.0;
        }
    }
    
    _thrLB.text = [NSString stringWithFormat:@"兑换时间 : %@",self.goods.goodsTime];
    [_thrLB sizeToFit];
    _thrLB.frame = CGRectMake(_thrLB.frame.origin.x, _firstLB.frame.origin.y + _firstLB.frame.size.height + secLBHeight + 2, kmainScreenWidth - 20.0f, _thrLB.frame.size.height);
    
    _fouLB.text = [NSString stringWithFormat:@"兑换单号 : %d",self.goods.goodsOrder];
    [_fouLB sizeToFit];
    _fouLB.frame = CGRectMake(_fouLB.frame.origin.x, _thrLB.frame.origin.y + _thrLB.frame.size.height + 2, kmainScreenWidth - 20.0f, _fouLB.frame.size.height);
    
    if (self.goods.goodsType == 3) {
        _state.frame = CGRectMake(_bgImage.frame.origin.x + 8, 70, 250, 15);
    }else if (self.goods.goodsType == 5) {
        _state.frame = CGRectMake(_bgImage.frame.origin.x + 8, 70, 250, 15);
        _toCopyBtn.frame =CGRectMake(_toCopyBtn.frame.origin.x, _state.frame.origin.y -5, _toCopyBtn.frame.size.width, _toCopyBtn.frame.size.height);
        _state2.frame =CGRectMake(_state.frame.origin.x, 100, 250, 15);
        _toCopyBtn2.frame =CGRectMake(_toCopyBtn2.frame.origin.x, _state2.frame.origin.y -2, _toCopyBtn2.frame.size.width, _toCopyBtn2.frame.size.height);
    }
    
    _logo.hidden = YES;
    _haveVersandLab.hidden = YES;
    _toCopyBtn.hidden = YES;
    _toCopyBtn2.hidden = YES;

    if (self.goods.goodsType == 4 && self.goods.goodsStatus == 1) {
         _toCopyBtn.hidden = NO;
    }
    if (self.goods.goodsType == 5 && self.goods.goodsStatus == 1) {
        _toCopyBtn.hidden = NO;
        _toCopyBtn2.hidden = NO;
    }
    if (self.goods.goodsType == 3 && self.goods.goodsStatus == 1) {
        _toCopyBtn.hidden = NO;
    }
    switch (self.goods.goodsStatus) {
        case 0:
        {
            _state.text = @"等待发货";
        }
            break;
            
        case 1:
        {
            _logo.frame = CGRectMake(283, 0, 32, 32);
            _haveVersandLab.text = @"已发货";
            _haveVersandLab.hidden = NO;
            if (self.goods.goodsType == 4) {
                _state.text = self.goods.goodsPs;
            }else if (self.goods.goodsType == 3) {
                _state.text = [NSString stringWithFormat:@"礼包:%@",self.goods.goodsCode];
            }else if (self.goods.goodsType == 5) {

                _state.text = [NSString stringWithFormat:@"卡号:%@",self.goods.goodsCard];
                _state2.text = [NSString stringWithFormat:@"密码:%@",self.goods.goodsCode];
                [self addSubview:_state2];
            }else{
               _state.text = self.goods.goodsPs;
            }
        }
            break;
        default:
            break;
    }
    if(![NSString isEmply:_state.text]){
        [_state sizeToFit];
        _state.frame = CGRectMake(_state.frame.origin.x, _state.frame.origin.y, 250.0, _state.frame.size.height);
    }
    if(_toCopyBtn.hidden == NO){
        _toCopyBtn.frame = CGRectMake(_toCopyBtn.frame.origin.x, self.state.frame.origin.y - 3, _toCopyBtn.frame.size.width, _toCopyBtn.frame.size.height);
    }
    if(_toCopyBtn2.hidden == NO){
        _toCopyBtn.frame = CGRectMake(_toCopyBtn2.frame.origin.x, self.state.frame.origin.y - 2, _toCopyBtn2.frame.size.width, _toCopyBtn2.frame.size.height);
    }
}
-(void)copyGoodsOrder:(UIButton* )btn{
    NSString* string;
    UIPasteboard* pasteboard =[UIPasteboard generalPasteboard];
    if (self.goods.goodsType==3) {
        string = _state.text;
        
    }
    if (self.goods.goodsType ==4) {
        string = _state.text;
    }
    if (self.goods.goodsType ==5) {
        switch (btn.tag) {
            case 1:
                string= _state.text;
                break;
            case 2:
                string= _state2.text;
                break;
        }
    }
    NSArray* array =[string componentsSeparatedByString:@":"];
    NSString* copyString =[array objectAtIndex:1];
    [copyString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    [pasteboard setValue:copyString forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    if (self.goods.goodsType ==5) {
        if (btn.tag ==1) {
            [StatusBar showTipMessageWithStatus:@"卡号复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
        }else if (btn.tag ==2){
            [StatusBar showTipMessageWithStatus:@"密码复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
        }
    }else if(self.goods.goodsType ==4){
        [StatusBar showTipMessageWithStatus:@"快递号复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
    }else if(self.goods.goodsType ==3){
        [StatusBar showTipMessageWithStatus:@"礼包复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
    }else{
        [StatusBar showTipMessageWithStatus:@"复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
    }
}
-(float)getCellHeight{
    float cellHeight = 0;
    if (self.goods.goodsType ==5) {
        cellHeight = 132.0;
    }else if(self.goods.goodsType ==3){
        cellHeight =101.0;
    }else{
        cellHeight = 115.0;
    }
    return cellHeight;
}
-(void)prepareForReuse{
    NSLog(@" prepare");
    [super prepareForReuse];
    self.goods =nil;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
