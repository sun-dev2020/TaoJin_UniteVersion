//
//  StatusBar.m
//  TJiphone
//
//  Created by keyrun on 13-10-23.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "StatusBar.h"

@interface StatusBar ()
@property (nonatomic, strong, readwrite) UIWindow *overlayWindow;
@property (nonatomic, strong, readwrite) UIView *topBar;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) UILabel* coinLabel;
@property (nonatomic ,strong) UIImageView* topImageView;
@property (nonatomic, strong) UIImageView* coinImageView;
@property (nonatomic ,assign) BOOL showing ;
@end


@implementation StatusBar
@synthesize topBar, overlayWindow, stringLabel, coinLabel,topImageView,coinImageView;


+(StatusBar* )sharedView{
    static dispatch_once_t once;
    static StatusBar* sharedView;
    dispatch_once(&once, ^ {
        sharedView=[[StatusBar alloc]initWithFrame:[UIScreen mainScreen].bounds] ;
    });
    return sharedView;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled=NO;
        self.backgroundColor=[UIColor clearColor];
        self.alpha =1;
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

-(UIWindow* )overlayWindow{
    if (!overlayWindow) {
        overlayWindow=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled=NO;
        overlayWindow.windowLevel=UIWindowLevelStatusBar;
    }
    return overlayWindow;
    
}
-(UIView* )topBar{
    if(!topBar) {
        topBar = [[UIView alloc] init];
        
        topBar.frame =CGRectMake(0, kmainScreenHeigh-32, overlayWindow.frame.size.width, 30.0);
        topBar.alpha =1;
        topBar.layer.cornerRadius =2.5;
        [overlayWindow addSubview:topBar];
    }
    return topBar;
}
-(UILabel* )stringLabel{
    if (stringLabel ==nil) {
        stringLabel =[[UILabel alloc]initWithFrame:CGRectZero];
        stringLabel.textColor= [UIColor orangeColor];
        stringLabel.backgroundColor=[UIColor clearColor];
        stringLabel.adjustsFontSizeToFitWidth =YES;
        stringLabel.textAlignment = NSTextAlignmentCenter;
        stringLabel.baselineAdjustment =UIBaselineAdjustmentAlignCenters;
        stringLabel.font =[UIFont systemFontOfSize:14.0];
        stringLabel.numberOfLines=1;
    }
    if (!stringLabel.superview) {
        [self.topBar addSubview:stringLabel];
    }
    return stringLabel;
}
-(UILabel* )coinLabel{
    if (coinLabel ==nil) {
        coinLabel =[[UILabel alloc]initWithFrame:CGRectZero];
        
        coinLabel.backgroundColor=[UIColor clearColor];
        coinLabel.adjustsFontSizeToFitWidth =YES;
        coinLabel.textAlignment = NSTextAlignmentLeft;
        //        coinLabel.baselineAdjustment =UIBaselineAdjustmentAlignCenters;
        coinLabel.font =[UIFont systemFontOfSize:14.0];
        coinLabel.numberOfLines=1;
    }
    if (!coinLabel.superview) {
        [self.topBar addSubview:coinLabel];
    }
    return coinLabel;
}

-(UIImageView* )topImageView{
    if (!topImageView) {
        topImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        
    }
    if (!topImageView.superview)
        [self.topBar addSubview:topImageView];
    
    return topImageView;
}
-(UIImageView* )coinImageView{
    if (!coinImageView) {
        coinImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        
    }
    if (!coinImageView.superview)
        [self.topBar addSubview:coinImageView];
    
    return coinImageView;
}

+(void)showTipMessageWithStatus:(NSString* )message andImage:(UIImage* )image andTipIsBottom:(BOOL)isBottom{
    if (![StatusBar sharedView].showing) {
        [[StatusBar sharedView] showStatusWithString:message andTopImage:image andTipIsBottom:(BOOL)isBottom];
        [StatusBar performSelector:@selector(dismiss) withObject:self afterDelay:2.0 ];
    }
    
    
}
+(void)showTipMessageWithStatus:(NSString* )message andImage:(UIImage* )image andCoin:(NSString*)coin andSecImage:(UIImage*)secImage
                 andTipIsBottom:(BOOL)isBottom{
    if (![StatusBar sharedView].showing) {
        
        [[StatusBar sharedView] showStatusWithString:message andTopImage:image andCoin:coin andSecImage:secImage andTipIsBottom:(BOOL)isBottom];
        
        [StatusBar performSelector:@selector(dismiss) withObject:self afterDelay:2.0 ];
    }
    
}

+(void)dismiss{
    [[StatusBar sharedView] dismiss];
}
-(void)dismiss{
    
    [topBar removeFromSuperview];
    topBar = nil;
    [overlayWindow removeFromSuperview];
    overlayWindow = nil;
    self.showing =NO;
    /*
     [UIView animateWithDuration:0.6 animations:^{
     [topBar removeFromSuperview];
     topBar = nil;
     topBar.alpha =0.0;
     [overlayWindow removeFromSuperview];
     overlayWindow = nil;
     } completion:^(BOOL finished) {
     }];
     */
    
}

-(void)showStatusWithString:(NSString* )string andTopImage:(UIImage *)image andTipIsBottom:(BOOL)isBottom{
    if (!self.superview)
        [self.overlayWindow addSubview:self];
    
    self.showing =YES;
    self.topBar.backgroundColor=[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1];
    NSString* text=string;
    UIImage* topImage=image;
    CGRect labelRect = CGRectZero;
    CGFloat width =0;
    CGFloat height =0;
    
    self.stringLabel.hidden=NO;
    self.stringLabel.text=text;
    self.stringLabel.textColor =[UIColor whiteColor];
    if (image !=nil) {
        self.topImageView.frame =CGRectMake(10, 7.5, 15, 15);
        self.topImageView.image=topImage;
    }
    if (string) {
        CGSize stringSize =[text sizeWithFont:self.stringLabel.font constrainedToSize:CGSizeMake(self.topBar.frame.size.width, self.topBar.frame.size.height)];
        width =stringSize.width;
        height =stringSize.height;
        labelRect =CGRectMake((self.topImageView.frame.origin.x +20), 6, width, height);
    }
    self.stringLabel.frame=labelRect;
    if (isBottom ==YES) {
        self.topBar.frame =CGRectMake((kmainScreenWidth-self.topImageView.frame.size.width-self.stringLabel.frame.size.width-25)/2, kmainScreenHeigh-37-kfootViewHeigh, self.topImageView.frame.size.width+10+self.stringLabel.frame.size.width+15, 30);
    }else{
        self.topBar.frame =CGRectMake((kmainScreenWidth-self.topImageView.frame.size.width-self.stringLabel.frame.size.width-25)/2, kmainScreenHeigh-kfootViewHeigh-37, self.topImageView.frame.size.width+10+self.stringLabel.frame.size.width+15, 30);
    }
    [self.overlayWindow setHidden:NO];
    self.topBar.alpha =1.0;
    /*
     [UIView animateWithDuration:.6 animations:^{
     [self.overlayWindow setHidden:NO];
     self.topBar.alpha =1.0;
     }];
     */
    [self setNeedsDisplay];
    
}
-(void)showStatusWithString:(NSString* )string andTopImage:(UIImage *)image andCoin:(NSString*)coin andSecImage:(UIImage*)secImage andTipIsBottom:(BOOL)isBottom{
    if (!self.superview)
        [self.overlayWindow addSubview:self];
    self.topBar.backgroundColor=[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1];
    NSString* text=string;
    UIImage* topImage=image;
    
    CGRect labelRect = CGRectZero;
    CGFloat width =0;
    CGFloat height =0;
    
    if (image !=nil) {
        self.topImageView.frame =CGRectMake(10, 7.5, 15, 15);
        
        self.topImageView.image=topImage;
    }
    
    if (string) {
        CGSize stringSize =[text sizeWithFont:self.stringLabel.font constrainedToSize:CGSizeMake(self.topBar.frame.size.width, self.topBar.frame.size.height)];
        width =stringSize.width;
        height =stringSize.height;
        labelRect =CGRectMake((self.topImageView.frame.origin.x +20), 6, width, height);
    }
    self.stringLabel.frame=labelRect;
    
    self.stringLabel.hidden=NO;
    self.stringLabel.text=text;
    self.stringLabel.textColor =[UIColor whiteColor];
    
    
    
    NSString* cointext =coin;
    self.coinLabel.text =cointext;
    
    self.coinLabel.textColor =kOrangeColor;
    [self.coinLabel sizeToFit];
    self.coinLabel.frame =CGRectMake(labelRect.origin.x+labelRect.size.width+5, 6, self.coinLabel.frame.size.width, self.coinLabel.frame.size.height);
    
    if (image !=nil) {
        self.coinImageView.frame =CGRectMake(self.coinLabel.frame.origin.x+self.coinLabel.frame.size.width+5, 5, 17, 17);
        self.coinImageView.image=secImage;
        
    }
    
    self.topBar.frame =CGRectMake((kmainScreenWidth-self.topImageView.frame.size.width-self.stringLabel.frame.size.width-self.coinImageView.frame.size.width-35-self.coinLabel.frame.size.width)/2, kmainScreenHeigh-37-kfootViewHeigh, self.topImageView.frame.size.width+10+self.stringLabel.frame.size.width+25+self.coinImageView.frame.size.width+self.coinLabel.frame.size.width, 30);
    
    self.topBar.alpha =1.0;
    [self.overlayWindow setHidden:NO];
    /*
     [UIView animateWithDuration:.6 animations:^{
     
     self.topBar.alpha =1.0;
     [self.overlayWindow setHidden:NO];
     }];
     */
    [self setNeedsDisplay];
}


@end
