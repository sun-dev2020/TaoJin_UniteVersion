//
//  ShowImgView.m
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowImgView.h"
#import "SDImageView+SDWebCache.h"
@implementation ShowImgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithImgListArr:(NSArray *)listArr{
    if ([super init]) {
        self.backgroundColor =[UIColor blackColor];
        self.frame =CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh);
        
        UIScrollView *sv =[self loadScrollViewWithPage:listArr];
        pc =[self loadPageControlWithFrame:CGRectMake(0, kmainScreenHeigh -30, 320, 30) andPageNum:listArr.count];
        if (listArr.count <2) {
            pc.hidden =YES;
        }
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage)];
        [sv addGestureRecognizer:tap];
        
        [self addSubview:sv];
        [self addSubview:pc];
    }
    return self;
}
-(void)showImages{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

-(UIPageControl *)loadPageControlWithFrame:(CGRect) frame andPageNum:(int)num{
    UIPageControl *pageControl =[[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages =num;
    pageControl.currentPageIndicatorTintColor =KOrangeColor2_0;
    return pageControl;

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x ==0) {
        pc.currentPage =0;
    }else{
        pc.currentPage =1;
    }
}
-(UIScrollView *)loadScrollViewWithPage:(NSArray *)pages{
    UIScrollView *scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.pagingEnabled =YES;
    scrollView.delegate =self;
    scrollView.showsHorizontalScrollIndicator =NO;
    [scrollView setContentSize:CGSizeMake(kmainScreenWidth *pages.count, kmainScreenHeigh)];
    for (int i=0;  i< pages.count; i++) {
        UIImageView *imageView =[[UIImageView alloc]init];
        NSDictionary *imgDic =[pages objectAtIndex:i];
        float width =[[imgDic objectForKey:@"Width"] floatValue];
        float height =[[imgDic objectForKey:@"Height"] floatValue];
        
        float scale1 =kmainScreenWidth*1.0 /(kmainScreenHeigh *1.0);
        float scale2 =width/height;
        
        if (width ==kmainScreenWidth*2) {
           imageView.frame =CGRectMake(kmainScreenWidth *i, 0, kmainScreenWidth, kmainScreenHeigh);
         if(height > kmainScreenHeigh*2){    // 图高比屏幕大
            float size =kmainScreenHeigh*2.0 /height ;
            float newWidth =size *kmainScreenWidth ;
            imageView.frame =CGRectMake((kmainScreenWidth/2 - newWidth/2) +kmainScreenWidth *i, 0, newWidth, kmainScreenHeigh);
            
        }else if (height < kmainScreenHeigh *2){      // 图宽比屏幕大
            imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -height/4, kmainScreenWidth, height/2);
        }
        }
        //按道理示例图的宽不会不等于屏幕宽的
        else if (width > kmainScreenWidth*2){
            if (scale1 > scale2) {
                float scale =kmainScreenHeigh *1.0 /(height /2);
                 imageView.frame =CGRectMake(kmainScreenWidth/2 -(width/4)*scale +kmainScreenWidth *i, 0, width/2 *scale, kmainScreenHeigh);
            }else if (scale1 < scale2){
                float scale =kmainScreenWidth*1.0 /(width/2);
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -(height/4)*scale, kmainScreenWidth, (height/2) *scale);
            }
            /*
            if (height > kmainScreenHeigh*2) {
                float size =kmainScreenHeigh*2.0 /height ;
                float newWidth =size *kmainScreenWidth ;
                imageView.frame =CGRectMake((kmainScreenWidth/2 - newWidth/4) +kmainScreenWidth *i, 0, newWidth, kmainScreenHeigh);

            }else if (height <kmainScreenHeigh){
                
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -height/4, kmainScreenWidth, height/2);
            }
             */
        }else if (width <kmainScreenWidth *2){
            imageView.frame =CGRectMake(kmainScreenWidth *i, 0, kmainScreenWidth, kmainScreenHeigh);
            if (scale1 >scale2) {
                float scale =  (kmainScreenHeigh *1.0) /(height/2);
               imageView.frame =CGRectMake(kmainScreenWidth/2 - scale *(width/4) +kmainScreenWidth *i, 0, width/2 *scale, kmainScreenHeigh);
            }else if (scale1 <scale2){
                float scale =kmainScreenWidth*1.0 /(width /2);
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -(height/4)*scale, kmainScreenWidth, (height/2)*scale);
                
            }
            /*
            if (height >kmainScreenHeigh*2) {
                float size =kmainScreenHeigh*2.0 /height ;
                float newWidth =size *kmainScreenWidth ;
                imageView.frame =CGRectMake(kmainScreenWidth/2 -width/4 +kmainScreenWidth *i, 0, newWidth, height/2);
            }else if (height <kmainScreenHeigh *2){
                imageView.frame =CGRectMake(kmainScreenWidth *i, kmainScreenHeigh/2 -height/4, kmainScreenWidth, height/2);
            }
             */
        }
        NSString *imgUrl =[imgDic objectForKey:@"Url"];
        [imageView setImageWithURL:[NSURL URLWithString:imgUrl] refreshCache:NO placeholderImage:GetImage(@"pic_def.png")];
        [scrollView addSubview:imageView];
    }
    return scrollView;
}
-(void)onTapImage{      //点击图片退出
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
