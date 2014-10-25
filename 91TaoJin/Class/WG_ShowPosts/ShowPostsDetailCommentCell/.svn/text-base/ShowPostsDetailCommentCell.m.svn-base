//
//  ShowPostsDetailCell.m
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowPostsDetailCommentCell.h"
#import "TaoJinLabel.h"
#import "SDImageView+SDWebCache.h"
#import "NSString+IsEmply.h"
#import "TimeClass.h"
#import "MyUserDefault.h"

@implementation ShowPostsDetailCommentCell{
    UIImageView *userLogoImg;                                       //用户头像
    TaoJinLabel *userNameLab;                                       //用户名称
    TaoJinLabel *timeLab;                                           //发表时间
    TaoJinLabel *connentLab;                                        //发表内容
//    CALayer *layer;                                                 //下分隔线
    UIView *lineView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kLightWhite2_0;
        
        //用户头像
        userLogoImg = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, 8.0f, 37.0f, 37.0f)];
        [self addSubview:userLogoImg];
        //用户名称
        userNameLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userLogoImg.frame.origin.x + userLogoImg.frame.size.width + Spacing2_0, userLogoImg.frame.origin.y + 8.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:10.0f] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:userNameLab];
        //发表时间
        timeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userNameLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height + 8.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:10.0f] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:timeLab];
        //评论内容
        float x = userLogoImg.frame.origin.x + userLogoImg.frame.size.width + 8.0f;
        connentLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userLogoImg.frame.origin.x + userLogoImg.frame.size.width + 8.0f, userLogoImg.frame.origin.y + userLogoImg.frame.size.height + 8.0f, kmainScreenWidth - x - Spacing2_0, 0.0f) text:@"" font:[UIFont systemFontOfSize:14.0f] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
        [self addSubview:connentLab];
        //下分隔线
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.5f)];
        [lineView setBackgroundColor:kLineColor2_0];
        [self addSubview:lineView];
        /*
        layer = [CALayer layer];
        [layer setBackgroundColor:[kLineColor2_0 CGColor]];
        [layer setFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.5f)];
        [self.layer addSublayer:layer];
        
         */
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  设置点评的显示内容
 *
 *  @param comment 点评对象
 */
-(void)showComment:(Comment *)comment{
    if(![NSString isEmply:comment.comment_userLogo]){
        [userLogoImg setImageWithURL:[NSURL URLWithString:comment.comment_userLogo] refreshCache:NO placeholderImage:[UIImage imageNamed:@"touxiang2"] withImageSize:CGSizeMake(37.0f, 37.0f)];
    }else{
        NSData *imageData = [[MyUserDefault standardUserDefaults] getUserPic];
        if(imageData != nil){
            userLogoImg.image = [UIImage imageWithData:imageData];
        }else{
            NSString *userIconUrl = [[MyUserDefault standardUserDefaults] getUserIconUrl];
            if([NSString isEmply:userIconUrl]){
                userLogoImg.image = [UIImage imageNamed:@"touxiang2"];
            }else{
                [userLogoImg setImageWithURL:[NSURL URLWithString:userIconUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"touxiang2"] withImageSize:CGSizeMake(37.0f, 37.0f)];
            }
        }
    }
    if(![NSString isEmply:comment.comment_userName]){
        userNameLab.text = comment.comment_userName;
    }else{
        userNameLab.text = [NSString stringWithFormat:@"%@",comment.comment_userId];
    }
    [userNameLab sizeToFit];
    timeLab.text = [TimeClass getTimeByOldTime:comment.comment_time];
    [timeLab sizeToFit];
    timeLab.frame = CGRectMake(timeLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height + 6.0f, timeLab.frame.size.width, timeLab.frame.size.height);
    connentLab.text = [NSString dealStringWithNewLine:comment.comment_content];
    [connentLab sizeToFit];
    connentLab.frame = CGRectMake(connentLab.frame.origin.x, connentLab.frame.origin.y, kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0 , connentLab.frame.size.height);
    float y = connentLab.frame.origin.y + connentLab.frame.size.height;
    lineView.frame = CGRectMake(lineView.frame.origin.x, y + 9.0f, lineView.frame.size.width, lineView.frame.size.height);
}
@end












