//
//  ShowPostsDetailCell.m
//  91TaoJin
//
//  Created by keyrun on 14-6-4.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowPostsDetailCell.h"
#import "TaoJinLabel.h"
#import "UIImage+ColorChangeTo.h"
#import "SDImageView+SDWebCache.h"
#import "NSString+IsEmply.h"

@implementation ShowPostsDetailCell{
    UIImageView *userLogoImg;                                       //用户头像
    TaoJinLabel *userNameLab;                                       //用户名称
    TaoJinLabel *timeLab;                                           //发表时间
    TaoJinLabel *detailLab;                                         //晒单内容
    UIImageView *detailImg1;                                        //图片一
    UIImageView *detailImg2;                                        //图片二
    UIImageView *detailImg3;                                        //图片三
    
//    CALayer *layer;                                                 //下分隔线
    UIView *lineView;                                               //下分隔线
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //用户头像
        userLogoImg = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, 9.0f, 37.0f, 37.0)];
        [self addSubview:userLogoImg];
        //用户名称
        userNameLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userLogoImg.frame.origin.x + userLogoImg.frame.size.width + Spacing2_0, userLogoImg.frame.origin.y + 5.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:11.0f] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:userNameLab];
        //发表时间
        timeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userNameLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height + 8.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:12.0f] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:timeLab];
        //晒单详情内容
        detailLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userLogoImg.frame.origin.x, userLogoImg.frame.origin.y + userLogoImg.frame.size.height + 8.0f, kmainScreenWidth - 2 * Spacing2_0, 0.0f) text:@"" font:[UIFont systemFontOfSize:14] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
        [self addSubview:detailLab];
        //图片1
        detailImg1 = [[UIImageView alloc] init];
        detailImg1.hidden = YES;
        [self addSubview:detailImg1];
        //图片2
        detailImg2 = [[UIImageView alloc] init];
        detailImg2.hidden = YES;
        [self addSubview:detailImg2];
        //图片3
        detailImg3 = [[UIImageView alloc] init];
        detailImg3.hidden = YES;
        [self addSubview:detailImg3];
        //下分隔线
        /*
        layer = [CALayer layer];
        [layer setBackgroundColor:[kLineColor2_0 CGColor]];
        [layer setFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.5f)];
        [self.layer addSublayer:layer];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
         */
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:kLineColor2_0];
        [lineView setFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.5f)];
        [self addSubview:lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  设置晒单详情的显示内容
 *
 *  @param showPostsDetail 晒单详情对象
 */
-(void)showShowPostsDetail:(ShowPostsDetail *)showPostsDetail{
    if(![NSString isEmply:showPostsDetail.detail_userLogo]){
        [userLogoImg setImageWithURL:[NSURL URLWithString:showPostsDetail.detail_userLogo] refreshCache:NO placeholderImage:[UIImage imageNamed:@"touxiang2"]withImageSize:CGSizeMake(37.0f, 37.0f)];
    }else{
        userLogoImg.image = [UIImage imageNamed:@"touxiang2"];
    }
    if(![NSString isEmply:showPostsDetail.detail_userName]){
        userNameLab.text = showPostsDetail.detail_userName;
    }else{
        userNameLab.text = showPostsDetail.detail_userId;
    }
    [userNameLab sizeToFit];
    timeLab.text = showPostsDetail.detail_time;
    [timeLab sizeToFit];
    timeLab.frame = CGRectMake(timeLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height + 3.0f, timeLab.frame.size.width, timeLab.frame.size.height);
    detailLab.text = [NSString dealStringWithNewLine:showPostsDetail.detail_content];
    [detailLab sizeToFit];
    detailLab.frame = CGRectMake(detailLab.frame.origin.x, detailLab.frame.origin.y, kmainScreenWidth - 2 * Spacing2_0, detailLab.frame.size.height);
    float y = detailLab.frame.origin.y + detailLab.frame.size.height + 9.0f;
    if(showPostsDetail.detail_pictureAry.count > 0){
        NSDictionary *dic1 = [showPostsDetail.detail_pictureAry objectAtIndex:0];
        detailImg1.hidden = NO;
        float oldWidth1 = [[dic1 objectForKey:@"Width"] floatValue];
        float newWidth1 = oldWidth1 > (kmainScreenWidth - 2 * Spacing2_0) ? (kmainScreenWidth - 2 * Spacing2_0) : oldWidth1;
        float height1 = [[dic1 objectForKey:@"Height"] floatValue];
        height1 = height1 * newWidth1/oldWidth1;
        [detailImg1 setImageWithURL:[NSURL URLWithString:[dic1 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(newWidth1, height1)];
        detailImg1.frame = CGRectMake(Spacing2_0, detailLab.frame.origin.y + detailLab.frame.size.height + 10.0f, newWidth1, height1);
        y = y + detailImg1.frame.size.height + 9.0f;
        if(showPostsDetail.detail_pictureAry.count > 1){
            NSDictionary *dic2 = [showPostsDetail.detail_pictureAry objectAtIndex:1];
            detailImg2.hidden = NO;
            float oldWidth2 = [[dic2 objectForKey:@"Width"] floatValue];
            float newWidth2 = oldWidth2 > (kmainScreenWidth - 2 * Spacing2_0) ? (kmainScreenWidth - 2 * Spacing2_0) : oldWidth2;
            float height2 = [[dic2 objectForKey:@"Height"] floatValue];
            height2 = height2 * newWidth2/oldWidth2;
            [detailImg2 setImageWithURL:[NSURL URLWithString:[dic2 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(newWidth2, height2)];
            detailImg2.frame = CGRectMake(Spacing2_0, detailImg1.frame.origin.y + detailImg1.frame.size.height + 9.0f, newWidth2, height2);
            y = y + detailImg2.frame.size.height + 9.0f;
            if(showPostsDetail.detail_pictureAry.count > 2){
                NSDictionary *dic3 = [showPostsDetail.detail_pictureAry objectAtIndex:2];
                detailImg3.hidden = NO;
                float oldWidth3 = [[dic3 objectForKey:@"Width"] floatValue];
                float newWidth3 = oldWidth3 > (kmainScreenWidth - 2 * Spacing2_0) ? (kmainScreenWidth - 2 * Spacing2_0) : oldWidth3;
                float height3 = [[dic3 objectForKey:@"Height"] floatValue];
                height3 = height3 * newWidth3/oldWidth3;
                [detailImg3 setImageWithURL:[NSURL URLWithString:[dic3 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(newWidth3, height3)];
                detailImg3.frame = CGRectMake(Spacing2_0, detailImg2.frame.origin.y + detailImg2.frame.size.height + 9.0f, newWidth3, height3);
                y = y + detailImg3.frame.size.height + 9.0f;
            }else{
                detailImg3.hidden = YES;
            }
        }else{
            detailImg2.hidden = YES;
            detailImg3.hidden = YES;
        }
    }else{
        detailImg1.hidden = YES;
        detailImg2.hidden = YES;
        detailImg3.hidden = YES;
    }
    lineView.frame = CGRectMake(lineView.frame.origin.x, y, lineView.frame.size.width, lineView.frame.size.height);
}
@end












