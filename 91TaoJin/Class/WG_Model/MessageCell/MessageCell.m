//
//  MessageCell.m
//  TJiphone
//
//  Created by keyrun on 13-10-9.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "MessageCell.h"
#import "SDImageView+SDWebCache.h"
#import "MyUserDefault.h"
#import "UIImage+ColorChangeTo.h"
#import "NSString+IsEmply.h"
#define kHeadWidth 37   //头像大小
#define kContentWidth 242  // 消息内容宽度
#define kTCoffY  16.0  //时间和文本间隔 上下
#define kICoffx   8.0  //头像和文本间隔  左右
#define kTimeH  11.0  //时间高度

#define kKCoffY 10.0   //框和文字 y间距
#define kKCoffX 17.0   //框和文字 x 间距
#define kHKoffx 2.0  // 头像和框 间距
@implementation MessageCell
{
    UILabel* textLabel;
    UILabel* label;
    UIImageView* _bgImageview;
    UIButton* _deleteImage;
    UILabel* _textLabel2;
    UIImageView* _arrowImage;
}

@synthesize deleteImage =_deleteImage;
@synthesize bgImageview =_bgImageview;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 11.0)];
        _timeLab.numberOfLines =1;
        _timeLab.backgroundColor =[UIColor clearColor];
        _timeLab.font =[UIFont systemFontOfSize:11.0];
        _timeLab.textAlignment=NSTextAlignmentCenter;
        _timeLab.textColor =KGrayColor2_0;
        
        textLabel =[[UILabel alloc]init];
        textLabel.numberOfLines =0;
        textLabel.userInteractionEnabled =NO;
        textLabel.font =[UIFont systemFontOfSize:14.0];
        textLabel.lineBreakMode =NSLineBreakByWordWrapping;
        textLabel.backgroundColor =[UIColor clearColor];
        textLabel.frame =CGRectMake(0, 0, kContentWidth, 0);
        textLabel.textColor =KOrangeColor2_0;
        
        _iconImage =[[UIImageView alloc] init];
        
        _bgImageview =[[UIImageView alloc]init];
        _bgImageview.tag =1000;
        _bgImageview.userInteractionEnabled =YES;
        UILongPressGestureRecognizer* gesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onClickCellImageView:)];
        [_bgImageview addGestureRecognizer:gesture];
        
        
        //        [self.contentView addSubview:_timeLab];
        [self.contentView addSubview:_iconImage];
        [self.contentView addSubview:_bgImageview];
        [self.contentView addSubview:textLabel];
        
    }
    return self;
}
-(UIButton *) loadAskQuestionBtnWith:(CGRect) frame withTitle:(NSString *)title andFont:(UIFont *)font{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    [btn setBackgroundImage:[UIImage createImageWithColor:KGreenColor2_0] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:kSelectGreen] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =font;
    return btn;
}
-(void)initAskBtn{
    UIButton *askBtn = [self loadAskQuestionBtnWith:CGRectMake(kOffX_float, kOffX_float, kmainScreenWidth -2* kOffX_float, 40) withTitle:@"我要提问" andFont:[UIFont systemFontOfSize:16.0]];
    [askBtn addTarget:self action:@selector(onClickedAskBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:askBtn];
    
}
-(void)onClickedAskBtn{
    [self.mcDelegate onClickAskBtn];
}
-(void)initMessageCellContentWith:(SysMessage *)message{
    
    self.msg =message;
    if (self.isOneDay ==NO) {
        NSString* timestr =self.msg.msgTime;
        _timeLab.text =timestr;
        [_timeLab sizeToFit];
        _timeLab.frame =CGRectMake(0, 15, kmainScreenWidth, _timeLab.frame.size.height);
        [self addSubview:_timeLab];
    }else{
        _timeLab.frame =CGRectMake(0, 0, kmainScreenWidth, _timeLab.frame.size.height);
    }
    
    
    if (message.type ==MessageTypeMe) {
        textLabel.textColor =KBlockColor2_0;
        if ([[MyUserDefault standardUserDefaults] getUserPic]) {
            _iconImage.image =[UIImage imageWithData:[[MyUserDefault standardUserDefaults] getUserPic]];
            
        }else{
            NSString *iconStr =[[MyUserDefault standardUserDefaults] getUserIconUrl];
            [_iconImage setImageWithURL:[NSURL URLWithString:iconStr] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage imageNamed:@"touxiang2"]];
        }
        _iconImage.frame =CGRectMake(320.0 - kOffX_float -kHeadWidth , _timeLab.frame.origin.y +_timeLab.frame.size.height +kTCoffY, kHeadWidth, kHeadWidth);
    }else{
//        _iconImage.image = GetImage(@"touxiang3.png");
        _iconImage.image = [UIImage imageNamed:@"touxiang3"];
        _iconImage.frame =CGRectMake(kOffX_float , _timeLab.frame.origin.y +_timeLab.frame.size.height +kTCoffY, kHeadWidth, kHeadWidth);
    }
    
    [_contentBtn.titleLabel sizeToFit];
    
    UIImage *bgImage ;
    
    /*
     if (self.msg.imgCount !=0) {   // 如果消息有图片 在文字前加上“图片”
     NSString *str =[[NSString alloc] init];
     for (int i =0;  i< self.msg.imgCount;  i++) {
     str =[str stringByAppendingString:@"[图片]"];
     }
     self.msg.msgCom =[str stringByAppendingString:self.msg.msgCom];
     
     }
     */
    
    textLabel.text =self.msg.msgCom;
//    textLabel.text =[NSString getFiltrationString:self.msg.msgCom];
    [textLabel sizeToFit];
    
    if (_msg.type == MessageTypeMe) {
        
        textLabel.frame =CGRectMake(320.0 - kOffX_float -kHeadWidth - kHKoffx -kKCoffX -textLabel.frame.size.width , _iconImage.frame.origin.y +kKCoffY, kContentWidth, textLabel.frame.size.height);
        bgImage =GetImage(@"message_right.png");
        bgImage =[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(bgImage.size.height - 5.0, bgImage.size.width *0.5, 4.0, bgImage.size.width *0.4) resizingMode:UIImageResizingModeStretch];
        _bgImageview.image =bgImage;
        //        _bgImageview.frame =CGRectMake(textLabel.frame.origin.x -kICoffx , _iconImage.frame.origin.y, textLabel.frame.size.width +kICoffx +kKCoffX , textLabel.frame.size.height + 1.5* kTCoffY);
        _bgImageview.frame =CGRectMake(textLabel.frame.origin.x -kICoffx , _iconImage.frame.origin.y, textLabel.frame.size.width +kICoffx +kKCoffX -4.0f, textLabel.frame.size.height + 1.5* kTCoffY);
        
        
    }else{
        
        textLabel.frame =CGRectMake(_iconImage.frame.origin.x +kHeadWidth +kHKoffx +kKCoffX, _iconImage.frame.origin.y +kKCoffY, kContentWidth, textLabel.frame.size.height);
        bgImage =GetImage(@"message_left.png");
        bgImage =[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(bgImage.size.height - 5.0, bgImage.size.width *0.5, 4.0, bgImage.size.width *0.4) resizingMode:UIImageResizingModeStretch];
        _bgImageview.image =bgImage;
        _bgImageview.frame =CGRectMake(textLabel.frame.origin.x -kKCoffX, _iconImage.frame.origin.y, 320.0 -2 *kOffX_float -kHeadWidth-kHKoffx, textLabel.frame.size.height +1.5* kTCoffY);
        
    }
    if (textLabel.frame.size.height < 30.0) {
        _bgImageview.frame =CGRectMake(_bgImageview.frame.origin.x, _bgImageview.frame.origin.y, _bgImageview.frame.size.width, kHeadWidth);
        textLabel.frame =CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, 0, 14.0);
        [textLabel sizeToFit];
        //        CGSize size =CGSizeMake(textLabel.frame.size.width + 2*kKCoffX, kHeadWidth);
        if (_msg.type ==MessageTypeMe) {
            _bgImageview.frame =CGRectMake(_bgImageview.frame.origin.x, _bgImageview.frame.origin.y, textLabel.frame.size.width + kICoffx +kKCoffX , kHeadWidth);
        }else{
            _bgImageview.frame =CGRectMake(_bgImageview.frame.origin.x, _bgImageview.frame.origin.y, textLabel.frame.size.width +kICoffx +kKCoffX, kHeadWidth);
        }
    }else{
        if (_msg.type ==MessageTypeMe) {
            _bgImageview.frame =CGRectMake(kOffX_float, _bgImageview.frame.origin.y, _bgImageview.frame.size.width +4.0f, _bgImageview.frame.size.height);
        }
    }
    
    
}
-(void)onClickCellImageView:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state ==UIGestureRecognizerStateBegan) {
        [self.mcDelegate getLongPressGestureRecognizer:self.msg.msgId andCellTag:self.tag];
    }
    
    
}

-(float)getMessageCellHeight{
    float height =0;
    if (_bgImageview.frame.size.height <= kHeadWidth ) {
        height = _iconImage.frame.origin.y +_iconImage.frame.size.height;
    }
    else{
        height = _bgImageview.frame.origin.y+_bgImageview.frame.size.height;
    }
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
