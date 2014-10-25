//
//  TakePartDetailCell.m
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TakePartDetailCell.h"
#import "TaoJinLabel.h"
#import "UIImage+ColorChangeTo.h"
#import "SDImageView+SDWebCache.h"

@implementation TakePartDetailCell{
    TaoJinLabel *takePartContentLab;                                //活动详情内容
    UIImageView *takePartImg1;                                      //图片一
    UIImageView *takePartImg2;                                      //图片二
    UIImageView *takePartImg3;                                      //图片三
    CALayer *layer;                                                 //下分隔线
    
    UIWebView *_headWebView ;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //活动详情内容
        takePartContentLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) text:@"" font:[UIFont systemFontOfSize:14] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
        [self addSubview:takePartContentLab];
        //图片1
        takePartImg1 = [[UIImageView alloc] init];
        takePartImg1.hidden = YES;
        [self addSubview:takePartImg1];
        //图片2
        takePartImg2 = [[UIImageView alloc] init];
        takePartImg2.hidden = YES;
        [self addSubview:takePartImg2];
        //图片3
        takePartImg3 = [[UIImageView alloc] init];
        takePartImg3.hidden = YES;
        [self addSubview:takePartImg3];
        //【参与评论】按钮
        self.takePartBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(Spacing2_0, 0.0f, kmainScreenWidth - Spacing2_0 * 2, 41.0f) titleStr:@"参与评论" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14.0f] logoImg:nil backgroundImg:[UIImage createImageWithColor:KGreenColor2_0]];
        [self addSubview:self.takePartBtn];
        //下分隔线
        layer = [CALayer layer];
        [layer setBackgroundColor:[kLineColor2_0 CGColor]];
        [layer setFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.5f)];
        
        
        
        _headWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 0)];
        _headWebView.delegate = self;
        _headWebView.userInteractionEnabled =NO;
        _headWebView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        [(UIScrollView* )[[_headWebView subviews]objectAtIndex:0]setBounces:NO];
        _headWebView.scalesPageToFit =NO;
        _headWebView.hidden =YES;
        [self addSubview:_headWebView];
        
        
        [self.layer addSublayer:layer];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    NSLog(@" webFrame %@ ",NSStringFromCGRect(frame));
    if (webView.frame.size.height >1) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTabHeadCell" object:nil];
    }else{
       
    }
    
}
-(void)loadHeadWebViewWithUrl:(NSString *)urlStr {
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlStr]];
    [_headWebView loadRequest:request];
}
/**
 *  设置活动详情的显示内容
 *
 *  @param takePartDetail 活动详情对象
 */
-(void)showTakePartDetail:(TakePartDetail *)takePartDetail{
    takePartContentLab.text = takePartDetail.takePart_content;
    [takePartContentLab sizeToFit];
    takePartContentLab.frame = CGRectMake(Spacing2_0, Spacing2_0, kmainScreenWidth - 2 * Spacing2_0, takePartContentLab.frame.size.height);
    float y = takePartContentLab.frame.origin.y;
    if(takePartDetail.takePart_pictureAry.count > 0){
        NSDictionary *dic1 = [takePartDetail.takePart_pictureAry objectAtIndex:0];
        takePartImg1.hidden = NO;
        float oldWidth1 = [[dic1 objectForKey:@"Width"] floatValue];
        float newWidth1 = oldWidth1 > (kmainScreenWidth - 2 * Spacing2_0) ? (kmainScreenWidth - 2 * Spacing2_0) : oldWidth1;
        float height1 = [[dic1 objectForKey:@"Height"] floatValue];
        height1 = height1 * newWidth1/oldWidth1;
        [takePartImg1 setImageWithURL:[NSURL URLWithString:[dic1 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(newWidth1, height1)];
        takePartImg1.frame = CGRectMake(Spacing2_0, takePartContentLab.frame.origin.y + takePartContentLab.frame.size.height + 9.0f, newWidth1, height1);
        y = takePartImg1.frame.origin.y + takePartImg1.frame.size.height + 9.0f;
        if(takePartDetail.takePart_pictureAry.count > 1){
            NSDictionary *dic2 = [takePartDetail.takePart_pictureAry objectAtIndex:1];
            takePartImg2.hidden = NO;
            float oldWidth2 = [[dic2 objectForKey:@"Width"] floatValue];
            float newWidth2 = oldWidth2 > (kmainScreenWidth - 2 * Spacing2_0) ? (kmainScreenWidth - 2 * Spacing2_0) : oldWidth2;
            float height2 = [[dic2 objectForKey:@"Height"] floatValue];
            height2 = height2 * newWidth2/oldWidth2;
            [takePartImg2 setImageWithURL:[NSURL URLWithString:[dic2 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(newWidth2, height2)];
            takePartImg2.frame = CGRectMake(Spacing2_0, takePartImg1.frame.origin.y + takePartImg1.frame.size.height + 9.0f, newWidth2, height2);
            y = y + takePartImg2.frame.size.height + 9.0f;
            if(takePartDetail.takePart_pictureAry.count > 2){
                NSDictionary *dic3 = [takePartDetail.takePart_pictureAry objectAtIndex:2];
                takePartImg3.hidden = NO;
                float oldWidth3 = [[dic3 objectForKey:@"Width"] floatValue];
                float newWidth3 = oldWidth3 > (kmainScreenWidth - 2 * Spacing2_0) ? (kmainScreenWidth - 2 * Spacing2_0) : oldWidth3;
                float height3 = [[dic3 objectForKey:@"Height"] floatValue];
                height3 = height3 * newWidth3/oldWidth3;
                [takePartImg3 setImageWithURL:[NSURL URLWithString:[dic3 objectForKey:@"Url"]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"pic_default2"] withImageSize:CGSizeMake(newWidth3, height3)];
                takePartImg3.frame = CGRectMake(Spacing2_0, takePartImg2.frame.origin.y + takePartImg2.frame.size.height + 9.0f, newWidth3, height3);
                y = y + takePartImg3.frame.size.height + 9.0f;
            }
        }
    }
    self.takePartBtn.frame = CGRectMake(self.takePartBtn.frame.origin.x, y, self.takePartBtn.frame.size.width, self.takePartBtn.frame.size.height);
    layer.frame = CGRectMake(layer.frame.origin.x, self.takePartBtn.frame.origin.y + self.takePartBtn.frame.size.height + 9.0f, layer.frame.size.width, layer.frame.size.height);
}

-(float)getTakePartCellHeight{
    return layer.frame.origin.y + layer.frame.size.height;
}


-(void)resetCellLayerFrame {
    layer.frame = CGRectMake(layer.frame.origin.x, self.takePartBtn.frame.origin.y + self.takePartBtn.frame.size.height + 9.0f, layer.frame.size.width, layer.frame.size.height);
}
-(void) hiddenTheLine{
    [layer removeFromSuperlayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end






