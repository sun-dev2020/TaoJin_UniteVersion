//
//  GarnishedDetailController.m
//  91TaoJin
//
//  Created by keyrun on 14-6-9.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "GarnishedDetailController.h"
#import "HeadToolBar.h"
#import "TaoJinLabel.h"
#import "TaoJinButton.h"
#import "NSString+IsEmply.h"
#import "UIImage+ColorChangeTo.h"
#import "StatusBar.h"

@interface GarnishedDetailController (){
    Guise *_guise;
    HeadToolBar *headView;
}

@end

@implementation GarnishedDetailController

- (id)initWithGuise:(Guise *)guise{
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
        //顶部横栏
        headView = [[HeadToolBar alloc] initWithTitle:@"任务详情" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:nil rightLabTitle:nil backgroundColor:KOrangeColor2_0];
        headView.leftBtn.tag = 1;
        [headView.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:headView];
        
        _guise = guise;
        [self initWithView:guise];
         
    } 
    return self;
}

/**
 *  初始化界面
 *
 *  @param guise 伪装对象
 */
- (void)initWithView:(Guise *)guise{
    TaoJinLabel *garnishedLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(Spacing2_0, headView.frame.origin.y + headView.frame.size.height + Spacing2_0, kmainScreenWidth - 2 * Spacing2_0, 0.0f) text:guise.guise_subContentStr font:[UIFont systemFontOfSize:14.0f] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
    [garnishedLab sizeToFit];
    garnishedLab.frame = CGRectMake(garnishedLab.frame.origin.x, garnishedLab.frame.origin.y, kmainScreenWidth - 2 * Spacing2_0, garnishedLab.frame.size.height);
    [self.view addSubview:garnishedLab];
    
    TaoJinButton *garnishedBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(Spacing2_0, garnishedLab.frame.origin.y + garnishedLab.frame.size.height + Spacing2_0, kmainScreenWidth - 2 * Spacing2_0, 44.0f) titleStr:@"" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] logoImg:nil backgroundImg:[UIImage createImageWithColor:KGreenColor2_0]];
    [garnishedBtn setBackgroundImage:[UIImage createImageWithColor:KLightGreenColor2_0] forState:UIControlStateHighlighted];
    [self.view addSubview:garnishedBtn];
    if(![NSString isEmply:guise.guise_url]){
        [garnishedBtn setTitle:guise.guise_buttonStr forState:UIControlStateNormal];
        [garnishedBtn addTarget:self action:@selector(skipToWeb) forControlEvents:UIControlEventTouchUpInside];
    }else if([@"经营学徒" isEqualToString:guise.guise_titleStr]){
        [garnishedBtn setTitle:@"我要收学徒" forState:UIControlStateNormal];
        [garnishedBtn addTarget:self action:@selector(showToast) forControlEvents:UIControlEventTouchUpInside];
    }else if([@"每日签到" isEqualToString:guise.guise_titleStr]){
        [garnishedBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        [garnishedBtn addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)skipToWeb{
    NSURL *url = [NSURL URLWithString:_guise.guise_url];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)showToast{
    [StatusBar showTipMessageWithStatus:@"金豆不足，请先赚取金豆再收学徒！" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
}

-(void)showAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"恭喜你获取3000金豆奖励" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    alert = nil;
}

- (void)onClickBackBtn:(UIButton* )btn{
    switch (btn.tag) {
            //返回按钮
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
