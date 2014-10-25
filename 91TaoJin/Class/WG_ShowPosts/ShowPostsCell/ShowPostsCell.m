//
//  ShowPostsCell.m
//  91TaoJin
//
//  Created by keyrun on 14-5-27.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowPostsCell.h"
#import "TaoJinLabel.h"
#import "NSString+IsEmply.h"
#import "SDImageView+SDWebCache.h"
#import "UserShowPosts.h"
#import "CompressImage.h"
#import "SDImageCache.h"

#define showPostsImgSize                                70

@implementation ShowPostsCell{
    UIImageView *userLogoImgView;                       //用户头像
    TaoJinLabel *nameLab;                               //用户名称或ID号
    TaoJinLabel *timeLab;                               //时间
    TaoJinLabel *jindouNumLab;                          //获取的金豆数
    TaoJinLabel *commentNumLab;                         //评论数
    UIImageView *commentLogoImgView;                    //评论Logo
    TaoJinLabel *contentLab;                            //内容
    UIImageView *showPostsImg1;                         //第一张晒图
    UIImageView *showPostsImg2;                         //第二张晒图
    UIImageView *showPostsImg3;                         //第三张晒图
    
//    CALayer *layer;                                     //线条
    UIView *lineView;                                   //线条
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //用户头像
        userLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, 9.0f, 37.0f, 37.0f)];
        [self addSubview:userLogoImgView];
        //用户名称或ID号
        nameLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userLogoImgView.frame.origin.x + userLogoImgView.frame.size.width + Spacing2_0, userLogoImgView.frame.origin.y + 5.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:11] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:nameLab];
        //时间
        timeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:11] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:timeLab];
        //评论数
        commentNumLab = [[TaoJinLabel alloc] initWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:11] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentRight numberLines:1];
        [self addSubview:commentNumLab];
        //金豆数
        jindouNumLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) text:@"" font:[UIFont boldSystemFontOfSize:16] textColor:KOrangeColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:jindouNumLab];
        //评论Logo
        commentLogoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        commentLogoImgView.image = [UIImage imageNamed:@"icon_comment"];
        [self addSubview:commentLogoImgView];
        //内容
        contentLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userLogoImgView.frame.origin.x, userLogoImgView.frame.origin.y + userLogoImgView.frame.size.height + 9.0f, kmainScreenWidth - 2 * Spacing2_0, 0.0f) text:@"" font:[UIFont systemFontOfSize:14] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:2];
        [self addSubview:contentLab];
        //第一张晒图
        showPostsImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(userLogoImgView.frame.origin.x, contentLab.frame.origin.y + contentLab.frame.size.width, showPostsImgSize, showPostsImgSize)];
        showPostsImg1.hidden = YES;
        [self addSubview:showPostsImg1];
        //第二张晒图   
        showPostsImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(showPostsImg1.frame.origin.x + showPostsImg1.frame.size.width + 4.0f, showPostsImg1.frame.origin.y, showPostsImgSize, showPostsImgSize)];
        showPostsImg2.hidden = YES;
        [self addSubview:showPostsImg2];
        //第三张晒图
        showPostsImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(showPostsImg2.frame.origin.x + showPostsImg2.frame.size.width + 4.0f, showPostsImg1.frame.origin.y, showPostsImgSize, showPostsImgSize)];
        showPostsImg3.hidden = YES;
        [self addSubview:showPostsImg3];

        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = kBlockBackground2_0;
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:kLineColor2_0];
        [self addSubview:lineView];
        /*
        layer = [CALayer layer];
        [layer setBackgroundColor:[kLineColor2_0 CGColor]];
        [self.layer addSublayer:layer];
         */
    }
    return self;
}

-(void)showCellContent:(UserShowPosts *)userShowPosts{

    if(![NSString isEmply:userShowPosts.user_userLogo]){
//        [userLogoImgView setImageWithURL:[NSURL URLWithString:userShowPosts.user_userLogo] refreshCache:NO placeholderImage:[UIImage imageNamed:@"touxiang2"]];
        [userLogoImgView setImageWithURL:[NSURL URLWithString:userShowPosts.user_userLogo] refreshCache:NO placeholderImage:[UIImage imageNamed:@"touxiang2"] withImageSize:CGSizeMake(37.0f, 37.0f)];
    }else{
        userLogoImgView.image = [UIImage imageNamed:@"touxiang2"];
    }

    if(![NSString isEmply:userShowPosts.user_userName]){
        nameLab.text = userShowPosts.user_userName;
    }else{
        nameLab.text = userShowPosts.user_userId;
    }
    [nameLab sizeToFit];
    timeLab.text = userShowPosts.user_userTime;
    [timeLab sizeToFit];
    timeLab.frame = CGRectMake(nameLab.frame.origin.x, nameLab.frame.size.height + nameLab.frame.origin.y + 3.0f, timeLab.frame.size.width, timeLab.frame.size.height);
    commentNumLab.text = [NSString stringWithFormat:@"%d",userShowPosts.user_replyNum];
    [commentNumLab sizeToFit];
    commentNumLab.frame = CGRectMake(kmainScreenWidth - Spacing2_0 - commentNumLab.frame.size.width, nameLab.frame.origin.y, commentNumLab.frame.size.width, commentNumLab.frame.size.height);
    commentLogoImgView.frame = CGRectMake(commentNumLab.frame.origin.x - 4.0f - commentLogoImgView.image.size.width, commentNumLab.frame.origin.y + 1.0f, commentLogoImgView.image.size.width, commentLogoImgView.image.size.height);
    
    if(userShowPosts.user_status == 3){
        commentLogoImgView.hidden = NO;
        commentNumLab.hidden = NO;
        jindouNumLab.text = [NSString stringWithFormat:@"+%d",userShowPosts.user_golds];
        jindouNumLab.textColor = KOrangeColor2_0;
        jindouNumLab.font = [UIFont boldSystemFontOfSize:16];
        [jindouNumLab sizeToFit];
        jindouNumLab.frame = CGRectMake(kmainScreenWidth - jindouNumLab.frame.size.width - Spacing2_0, commentNumLab.frame.origin.y + commentNumLab.frame.size.height, jindouNumLab.frame.size.width, jindouNumLab.frame.size.height);
    }else{
        commentLogoImgView.hidden = YES;
        commentNumLab.hidden = YES;
        if(userShowPosts.user_status == 1){
            jindouNumLab.text = @"审核中";
        }else if(userShowPosts.user_status == 2){
            jindouNumLab.text = @"未通过";
        }
        jindouNumLab.textColor = KRedColor2_0;
        jindouNumLab.font = [UIFont boldSystemFontOfSize:11];
        [jindouNumLab sizeToFit];
        jindouNumLab.frame = CGRectMake(kmainScreenWidth - jindouNumLab.frame.size.width - Spacing2_0, commentNumLab.frame.origin.y + commentNumLab.frame.size.height, jindouNumLab.frame.size.width, jindouNumLab.frame.size.height);
    }
    contentLab.text = [NSString getFiltrationString:userShowPosts.user_content];
    [contentLab sizeToFit];
    contentLab.frame = CGRectMake(contentLab.frame.origin.x, contentLab.frame.origin.y, kmainScreenWidth - 2 * Spacing2_0, contentLab.frame.size.height);
    
    NSArray *showPostsImgUrlAry = userShowPosts.user_pictureAry;
    if(showPostsImgUrlAry.count > 0){
        showPostsImg1.hidden = NO;
        NSDictionary *dic1 = [showPostsImgUrlAry objectAtIndex:0];
        if([[dic1 objectForKey:@"Url"] isKindOfClass:[NSString class]]){
            [showPostsImg1 setCutImageWithURL:[NSURL URLWithString:[dic1 objectForKey:@"Url"]] refreshCache:YES needSetViewContentMode:YES needBgColor:YES placeholderImage:[UIImage imageNamed:@"pic_default"] withImageSize:CGSizeMake(showPostsImgSize, showPostsImgSize)];
        }else if([[dic1 objectForKey:@"Url"] isKindOfClass:[NSData class]]){
            UIImage *image = [UIImage imageWithData:[dic1 objectForKey:@"Url"]];
            showPostsImg1.image = [CompressImage imageWithCutImage:image moduleSize:CGSizeMake(showPostsImgSize, showPostsImgSize)];
        }
        showPostsImg1.frame = CGRectMake(showPostsImg1.frame.origin.x, contentLab.frame.origin.y + contentLab.frame.size.height + 9.0f, showPostsImgSize, showPostsImgSize);
        if(showPostsImgUrlAry.count > 1){
            showPostsImg2.hidden = NO;
            NSDictionary *dic2 = [showPostsImgUrlAry objectAtIndex:1];
            if([[dic2 objectForKey:@"Url"] isKindOfClass:[NSString class]]){
                [showPostsImg2 setCutImageWithURL:[NSURL URLWithString:[dic2 objectForKey:@"Url"]] refreshCache:YES needSetViewContentMode:YES needBgColor:YES placeholderImage:[UIImage imageNamed:@"pic_default"] withImageSize:CGSizeMake(showPostsImgSize, showPostsImgSize)];
            }else if([[dic2 objectForKey:@"Url"] isKindOfClass:[NSData class]]){
                UIImage *image = [UIImage imageWithData:[dic2 objectForKey:@"Url"]];
                showPostsImg2.image = [CompressImage imageWithCutImage:image moduleSize:CGSizeMake(showPostsImgSize, showPostsImgSize)];
            }
            showPostsImg2.frame = CGRectMake(showPostsImg2.frame.origin.x, showPostsImg1.frame.origin.y , showPostsImgSize, showPostsImgSize);
            if(showPostsImgUrlAry.count > 2){
                showPostsImg3.hidden = NO;
                NSDictionary *dic3 = [showPostsImgUrlAry objectAtIndex:2];
                if([[dic3 objectForKey:@"Url"] isKindOfClass:[NSString class]]){
                    [showPostsImg3 setCutImageWithURL:[NSURL URLWithString:[dic3 objectForKey:@"Url"]] refreshCache:YES needSetViewContentMode:YES needBgColor:YES placeholderImage:[UIImage imageNamed:@"pic_default"] withImageSize:CGSizeMake(showPostsImgSize, showPostsImgSize)];
                }else if([[dic3 objectForKey:@"Url"] isKindOfClass:[NSData class]]){
                    UIImage *image = [UIImage imageWithData:[dic3 objectForKey:@"Url"]];
                    showPostsImg3.image = [CompressImage imageWithCutImage:image moduleSize:CGSizeMake(showPostsImgSize, showPostsImgSize)];
                }
                showPostsImg3.frame = CGRectMake(showPostsImg3.frame.origin.x, showPostsImg1.frame.origin.y , showPostsImgSize, showPostsImgSize);
            }else{
                showPostsImg3.hidden = YES;
            }
        }else{
            showPostsImg2.hidden = YES;
            showPostsImg3.hidden = YES;
        }
    }else{
        showPostsImg1.hidden = YES;
        showPostsImg2.hidden = YES;
        showPostsImg3.hidden = YES;
    }
    lineView.frame = CGRectMake(0.0f, showPostsImg1.frame.origin.y + showPostsImg1.frame.size.height + 11.0f, kmainScreenWidth, 0.5f);
//    layer.frame = CGRectMake(0.0f, showPostsImg1.frame.origin.y + showPostsImg1.frame.size.height + 11.0f, kmainScreenWidth, 0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
