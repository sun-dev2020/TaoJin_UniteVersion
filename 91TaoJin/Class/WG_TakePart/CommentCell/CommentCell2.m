//
//  CommentCell.m
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "CommentCell2.h"
#import "TaoJinLabel.h"
#import "SDImageView+SDWebCache.h"
#import "NSString+IsEmply.h"
#import "TimeClass.h"
#import "MyUserDefault.h"

@implementation CommentCell2{
    UIImageView *userLogoImg;                                       //用户头像
    TaoJinLabel *userNameLab;                                       //用户名称
    TaoJinLabel *timeLab;                                           //发表时间
    TaoJinLabel *connentLab;                                        //发表内容
    UIImageView *commentImg1;                                       //图片一
    UIImageView *commentImg2;                                       //图片二
    UIImageView *commentImg3;                                       //图片三
//    CALayer *layer;                                                 //下分隔线
    UIView *lineView;                                               //下分隔线
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //用户头像
        userLogoImg = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, Spacing2_0, 37.0f, 37.0)];
        [self addSubview:userLogoImg];
        //用户名称
        userNameLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userLogoImg.frame.origin.x + userLogoImg.frame.size.width + Spacing2_0, userLogoImg.frame.origin.y + 8.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:10.0f] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:userNameLab];
        //发表时间
        timeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(userNameLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height + 8.0f, 320.0f -37.0f -3 *Spacing2_0, 0.0f) text:@"" font:[UIFont systemFontOfSize:10.0f] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:timeLab];
        //评论内容
        connentLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(timeLab.frame.origin.x, userLogoImg.frame.origin.y + userLogoImg.frame.size.height + 8.0f, 320.0f -37.0f -3 *Spacing2_0, 0.0f) text:@"" font:[UIFont systemFontOfSize:14.0f] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
        [self addSubview:connentLab];
        //图片一
        commentImg1 = [[UIImageView alloc] init];
        commentImg1.hidden = YES;
        [self addSubview:commentImg1];
        //图片二
        commentImg2 = [[UIImageView alloc] init];
        commentImg2.hidden = YES;
        [self addSubview:commentImg2];
        //图片三
        commentImg3 = [[UIImageView alloc] init];
        commentImg3.hidden = YES;
        [self addSubview:commentImg3];
        //下分隔线
        /*
        layer = [CALayer layer];
        [layer setBackgroundColor:[kLineColor2_0 CGColor]];
        [layer setFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.5f)];
        [self.layer addSublayer:layer];
        
         */
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:kLineColor2_0];
        [lineView setFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.5f)];
        [self addSubview:lineView];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

/**
 *  设置点评内容的显示
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
    connentLab.frame = CGRectMake(connentLab.frame.origin.x, connentLab.frame.origin.y, kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0, connentLab.frame.size.height);
    float y = connentLab.frame.origin.y + connentLab.frame.size.height;
    
    if(comment.comment_pictureAry.count > 0){
        id dic1 = [comment.comment_pictureAry objectAtIndex:0];
        commentImg1.hidden = NO;
        if ([dic1 isKindOfClass:[NSData class]]) {
            UIImage *image = [UIImage imageWithData:dic1];
            float width = image.size.width;
            float width1 = width > (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) ? (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) : width;
            float height = image.size.height;
            float height1 = height * (width1/width);
            
            commentImg1.image = image;
            commentImg1.frame =CGRectMake(connentLab.frame.origin.x, connentLab.frame.origin.y + connentLab.frame.size.height  + Spacing2_0, width1, height1);
        }else{
            float width = [[dic1 objectForKey:@"Width"] floatValue];
            float width1 = width > (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) ? (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) : width;
            float height = [[dic1 objectForKey:@"Height"] floatValue];
            float height1 = height * (width1/width);
            [commentImg1 setImageWithURL:[NSURL URLWithString:[dic1 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(width1, height1)];
            commentImg1.frame = CGRectMake(connentLab.frame.origin.x, connentLab.frame.origin.y + connentLab.frame.size.height + Spacing2_0, width1, height1);
        
        }
        y = commentImg1.frame.origin.y + commentImg1.frame.size.height + 9.0f;
       
        if(comment.comment_pictureAry.count > 1){
            id dic2 = [comment.comment_pictureAry objectAtIndex:1];
            commentImg2.hidden = NO;
            if ([dic2 isKindOfClass:[NSData class]]) {
                UIImage *image = [UIImage imageWithData:dic2];
                float width = image.size.width;
                float width2 = width > (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) ? (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) : width;
                float height = image.size.height;
                float height2 = height * (width2/width);
                commentImg2.image =[UIImage imageWithData:dic2];
                commentImg2.frame =CGRectMake(connentLab.frame.origin.x, commentImg1.frame.origin.y + commentImg1.frame.size.height + Spacing2_0, width2, height2);
            }else{
                float width = [[dic2 objectForKey:@"Width"] floatValue];
                float width2 = width > (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) ? (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) : width;
                float height = [[dic2 objectForKey:@"Height"] floatValue];
                float height2 = height * (width2/width);

                [commentImg2 setImageWithURL:[NSURL URLWithString:[dic2 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(width2, height2)];
                commentImg2.frame = CGRectMake(connentLab.frame.origin.x, commentImg1.frame.origin.y + commentImg1.frame.size.height + Spacing2_0, width2, height2);
                }
                y = commentImg2.frame.origin.y + commentImg2.frame.size.height + 9.0f;
             
                if(comment.comment_pictureAry.count > 2){
                    id dic3 = [comment.comment_pictureAry objectAtIndex:2];
                    commentImg3.hidden = NO;
                    if ([dic3 isKindOfClass:[NSData class]]) {
                        UIImage *image = [UIImage imageWithData:dic3];
                        float width = image.size.width;
                        float width3 = width > (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) ? (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) : width;
                        float height = image.size.height;
                        float height3 = height * (width3/width);
                        commentImg3.image =[UIImage imageWithData:dic3];
                        commentImg3.frame =CGRectMake(connentLab.frame.origin.x, commentImg2.frame.origin.y + commentImg2.frame.size.height + Spacing2_0, width3, height3);
                    }else{
                        float width = [[dic3 objectForKey:@"Width"] floatValue];
                        float width3 = width > (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) ? (kmainScreenWidth - connentLab.frame.origin.x - Spacing2_0) : width;
                        float height = [[dic3 objectForKey:@"Height"] floatValue];
                        float height3 = height * (width3/width);

                        [commentImg3 setImageWithURL:[NSURL URLWithString:[dic3 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(width3, height3)];
                        commentImg3.frame = CGRectMake(connentLab.frame.origin.x, commentImg2.frame.origin.y + commentImg2.frame.size.height + Spacing2_0, width3, height3);
                        }
                        y = commentImg3.frame.origin.y + commentImg3.frame.size.height + 9.0f;
                }
        }
    }
    lineView.frame = CGRectMake(lineView.frame.origin.x, y + 9.0f, lineView.frame.size.width, lineView.frame.size.height);
}

-(float) getCommentCellHeight{
    return lineView.frame.size.height +lineView.frame.origin.y;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareForReuse{
    commentImg1.image =nil;
    commentImg2.image =nil;
    commentImg3.image =nil;
}
@end
















