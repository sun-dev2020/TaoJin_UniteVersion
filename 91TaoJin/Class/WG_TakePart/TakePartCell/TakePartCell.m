//
//  TakePartCell.m
//

//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TakePartCell.h"
#import "SDImageView+SDWebCache.h"
#import "UIImage+ColorChangeTo.h"
#import <QuartzCore/QuartzCore.h>

#define kLocalCellHeight                                                74.0f
#define kLogoBackgroundImgHeight                                        60.0f
#define kLogoBackgroundImgWidth                                         76.0f
#define kTitleLabelHeight                                               40.0f

@implementation TakePartCell{
    UIImageView *commentImgView;                          //评论标识图片
    UIImage *loadImg;
//    UIImageView *loadingImgView;                          //正在加载的默认图片
    TakePart *_takePart;
}

@synthesize logoImgView = _logoImgView;
@synthesize titleLab = _titleLab;
@synthesize commentCount = _commentCount;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        loadImg = [UIImage imageNamed:@"pic_default"];
        /*
        //Logo
        self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, Spacing2_0, kLogoBackgroundImgWidth, kLogoBackgroundImgHeight)];
        self.logoImgView.image = [UIImage createImageWithColor:kImageBackgound2_0];
        //加载图
        UIImage *loadImg = [UIImage imageNamed:@"pic_default"];
        loadingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.logoImgView.frame.size.width/2 - loadImg.size.width/2,self.logoImgView.frame.size.height/2 - loadImg.size.height/2, loadImg.size.width, loadImg.size.height)];
        loadingImgView.image = loadImg;
        [self.logoImgView addSubview:loadingImgView];
        [self.contentView addSubview:self.logoImgView];
         */
//
        self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, Spacing2_0, kLogoBackgroundImgWidth, kLogoBackgroundImgHeight)];
        [self.contentView addSubview:self.logoImgView];
        
        //title
        float titleLabX = self.logoImgView.frame.origin.x + self.logoImgView.frame.size.width + Spacing2_0;
        self.titleLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(titleLabX, self.logoImgView.frame.origin.y, kmainScreenWidth - titleLabX - 25.0f, kTitleLabelHeight) text:@"" font:[UIFont systemFontOfSize:14] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:2];
        [self addSubview:self.titleLab];
        //评论数
        self.commentCount = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:11] textColor:KGrayColor2_0 textAlignment:UITextAlignmentRight numberLines:1];
        [self.contentView addSubview:self.commentCount];
        //评论的图标
        UIImage *commentImg = [UIImage imageNamed:@"icon_comment"];
        commentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, commentImg.size.width, commentImg.size.height)];
        commentImgView.image = commentImg;
        [self.contentView addSubview:commentImgView];
        //向右箭头图标
        UIImage *arrowImg = [UIImage imageNamed:@"pic_next"];
        UIImageView *nextImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kmainScreenWidth - 15.0f - arrowImg.size.width, kLocalCellHeight/2 - arrowImg.size.height/2, arrowImg.size.width, arrowImg.size.height)];
        nextImgView.image = arrowImg;
        [self.contentView addSubview:nextImgView];
        
        CALayer *layer = [CALayer layer];
        [layer setBackgroundColor:[kLineColor2_0 CGColor]];
        [layer setFrame:CGRectMake(Spacing2_0, kLocalCellHeight - LineWidth, kmainScreenWidth - Spacing2_0, LineWidth)];
        [self.layer addSublayer:layer];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = kBlockBackground2_0;
    }
    return self;
}

/**
 *  动态设置【天天参与】列表的数据
 *
 *  @param titleStr         标题内容
 *  @param image            Logo
 *  @param commentCountStr  评论数量
 */
- (void)setTakePartCellContent:(NSString *)titleStr imageUrl:(NSString *)imageUrl commentCountStr:(NSString *)commentCountStr takeType:(int)type isPinLun:(int)isPl{
    _titleLab.text = titleStr;
    _commentCount.text = commentCountStr;
    [_commentCount sizeToFit];
    _commentCount.frame = CGRectMake(_titleLab.frame.origin.x + _titleLab.frame.size.width - _commentCount.frame.size.width - 2.0f, kLocalCellHeight - 10.0f - _commentCount.frame.size.height, _commentCount.frame.size.width, _commentCount.frame.size.height);
    commentImgView.frame = CGRectMake(_commentCount.frame.origin.x - commentImgView.frame.size.width - 4.0f, _commentCount.frame.origin.y + 1.0f, commentImgView.frame.size.width, commentImgView.frame.size.height);

    [_logoImgView setImageWithURL:[NSURL URLWithString:imageUrl] refreshCache:NO placeholderImage:GetImage(@"pic_default") withImageSize:CGSizeMake(kLogoBackgroundImgWidth, kLogoBackgroundImgHeight)];
    if (type !=0 && isPl == 0) {
        commentImgView.hidden =YES;
        _commentCount.hidden =YES;

        _titleLab.frame =CGRectMake(_titleLab.frame.origin.x, (74.0f -_titleLab.frame.size.height) /2, _titleLab.frame.size.width, _titleLab.frame.size.height);
    }else if (type ==0 && isPl ==0){   // 数据不是网页  但不支持评论
        commentImgView.hidden =YES;
        _commentCount.hidden =YES;
        
        _titleLab.frame =CGRectMake(_titleLab.frame.origin.x, (74.0f -_titleLab.frame.size.height) /2, _titleLab.frame.size.width, _titleLab.frame.size.height);
    }
    else{
        _titleLab.frame =CGRectMake(_titleLab.frame.origin.x, _logoImgView.frame.origin.y, _titleLab.frame.size.width, _titleLab.frame.size.height);
        commentImgView.hidden =NO;
        _commentCount.hidden =NO;
    }
    /*
    if(image != nil){
        [_logoImgView setImageWithURL:[NSURL URLWithString:@"http://pic.91taojin.com.cn/data/attachment/image/20140319/20140319145414_92656.png"] refreshCache:false needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage createImageWithColor:kImageBackgound2_0] imageLoadingFinish:^{
            loadingImgView.hidden = YES;
            _logoImgView.backgroundColor = [UIColor clearColor];
        }];
    }
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end















