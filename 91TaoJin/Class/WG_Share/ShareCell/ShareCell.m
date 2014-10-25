//
//  ShakeCell.m
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShareCell.h"
#import "SDImageView+SDWebCache.h"
#import "UIImage+ColorChangeTo.h"
#define kSpaceOffY   7.0f
@implementation ShareCell{
    TaoJinLabel *_timeLab;                                       //时间
    TaoJinLabel *_contentLab;                                    //内容
    UIImageView *_pictureImg;                                    //封面图片
    TaoJinButton *_praiseBtn;                                    //点赞按钮
    TaoJinButton *_shareBtn;                                     //分享按钮
    CALayer *_sperateLine;                                       //分割线
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //时间
        _timeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(Spacing2_0, Spacing2_0, 320.0f, 15.0f) text:@"" font:[UIFont fontWithName:@"Helvetica-Bold" size:14.0] textColor:KGreenColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:_timeLab];
        //内容
        _contentLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(Spacing2_0, 0.0f,kmainScreenWidth - 2* Spacing2_0, 0.0f) text:@"" font:[UIFont systemFontOfSize:14] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
        [self addSubview:_contentLab];
        //图片
        _pictureImg = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 0.0f, kmainScreenWidth - 30.0f, 180.0f)];
        [self addSubview:_pictureImg];
        //点赞按钮
        _praiseBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 145.0f, 40.0f) titleStr:@"" titleColor:KRedColor2_0 font:[UIFont systemFontOfSize:17.0f] logoImg:nil backgroundImg:nil];
        _praiseBtn.adjustsImageWhenHighlighted =NO;
        _praiseBtn.imageEdgeInsets =UIEdgeInsetsMake(7.0f, 30.0f, 7.0f, 90.0f);
        _praiseBtn.layer.borderWidth =0.5f;
        _praiseBtn.layer.borderColor =kLineColor2_0.CGColor;
        [_praiseBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateHighlighted];
        [self addSubview:_praiseBtn];
        //分享按钮
        _shareBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(_praiseBtn.frame.origin.x + _praiseBtn.frame.size.width -0.5f, 0.0f, 145.0f, 40.0f) titleStr:@"分享" titleColor:KGreenColor2_0 font:[UIFont systemFontOfSize:17.0f] logoImg:[UIImage imageNamed:@"share"] backgroundImg:nil];
        _shareBtn.imageEdgeInsets =UIEdgeInsetsMake(7.0f, 30.0f, 7.0f, 90.0f);
        _shareBtn.adjustsImageWhenHighlighted =NO;
        _shareBtn.layer.borderWidth =0.5f;
        _shareBtn.layer.borderColor =kLineColor2_0.CGColor;
        [_shareBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateHighlighted];
        [self addSubview:_shareBtn];
        
        _sperateLine =[CALayer layer];
        _sperateLine.backgroundColor =kLineColor2_0.CGColor;
        [self.layer addSublayer:_sperateLine];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)showShareCellContent{
    _timeLab.text =self.shareContent.share_time;
    [_timeLab sizeToFit];
    _timeLab.frame =CGRectMake(Spacing2_0, Spacing2_0, 320.0f, 15.0f);
    
    _contentLab.text =self.shareContent.share_content;
    [_contentLab sizeToFit];
    _contentLab.frame =CGRectMake(Spacing2_0, _timeLab.frame.origin.y +_timeLab.frame.size.height +kSpaceOffY,kmainScreenWidth - 2* Spacing2_0, _contentLab.frame.size.height);
    
    [_pictureImg setImageWithURL:[NSURL URLWithString:self.shareContent.share_imageUrl] refreshCache:NO needBgColor:YES placeholderImage:GetImage(kDefaultPic)];
    
    float width =kmainScreenWidth -30.0f;
    float width2 =self.shareContent.share_picW;
    float height2 =self.shareContent.share_picH;
    float height;
    if(width2 != 0){
        height =(height2 /width2 ) *width;
    }else{
        height =height2;
    }
    _pictureImg.frame =CGRectMake(15.0f, _contentLab.frame.origin.y +_contentLab.frame.size.height +Spacing2_0, kmainScreenWidth -30.0f, height);
    
        [_praiseBtn setTitle:self.shareContent.share_pariseNum forState:UIControlStateNormal];
    
    if (self.shareContent.share_isPra ==1) {
        [_praiseBtn setImage:GetImage(@"praise_select") forState:UIControlStateNormal];
    }else{
        [_praiseBtn setImage:GetImage(@"praise_unSelect") forState:UIControlStateNormal];
    }
    _praiseBtn.frame =CGRectMake(15.0f, _pictureImg.frame.origin.y +_pictureImg.frame.size.height +10.0f, 145.0f, 40.0f);
    
    _shareBtn.frame =CGRectMake(_praiseBtn.frame.origin.x +_praiseBtn.frame.size.width -0.5f, _praiseBtn.frame.origin.y, 145.0f, 40.0f);
    
    _sperateLine.frame =CGRectMake(0.0f, _shareBtn.frame.origin.y +_shareBtn.frame.size.height +kSpaceOffY, kmainScreenWidth, 0.5f);
    
    _praiseBtn.tag =_shareBtn.tag =self.tag;
}

-(float )getShareCellHeight{
    float h =_praiseBtn.frame.origin.y +_praiseBtn.frame.size.height +kSpaceOffY +1.0f;
    return h;
}
/*
-(void)prepareForReuse{
  
    [_praiseBtn removeFromSuperview];
    _praiseBtn =nil;
    [_shareBtn removeFromSuperview];
    _shareBtn =nil;
}
*/
@end









