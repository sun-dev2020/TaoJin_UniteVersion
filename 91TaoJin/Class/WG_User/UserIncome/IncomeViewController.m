//
//  IncomeViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "IncomeViewController.h"
#import "TJViewController.h"
#import "IncomeCell.h"
#import "OutTable.h"
#import "IncomeTable.h"
#import "AllTable.h"
#import "MyUserDefault.h"
#import "HeadToolBar.h"
#import "TaoJinScrollView.h"
#import "LoadingView.h"

@interface IncomeViewController (){
    AllTable *allTableview;                                             //【全部】页面
    IncomeTable *incomeTableView;                                       //【收入】页面
    OutTable *outTableView;                                             //【支出】页面


    MScrollVIew *ms;
    HeadToolBar *headBar;
    UIImageView *image;
}
@end

@implementation IncomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    headBar = [[HeadToolBar alloc] initWithTitle:@"收支明细" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];

    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];

    if(self.userLog){
        [[MyUserDefault standardUserDefaults] setUserLog:self.userLog];
    }
    [self loadContentView];
    
    if (IOS_Version >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
-(void)loadContentView{
    //【全部】界面
    allTableview = [[AllTable alloc] initWithFrame:CGRectZero];
    allTableview.tag = 200;
    [allTableview initObjects];

    //【收入】界面
    incomeTableView = [[IncomeTable alloc]initWithFrame:CGRectZero];
    incomeTableView.backgroundView=nil;


    //【支出】界面
    outTableView = [[OutTable alloc]initWithFrame:CGRectZero];
    outTableView.backgroundView = nil;
    
    NSArray *array =[[NSArray alloc] initWithObjects:@"全部",@"收入",@"支出", nil];
    NSArray *arrayView =[[NSArray alloc] initWithObjects:allTableview,incomeTableView, outTableView,nil];
    TaoJinScrollView *tjScroll =[[TaoJinScrollView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height) btnAry:array btnAction:^(UIButton *button) {
        switch (button.tag) {
            case 1:
            {
                if (allTableview.allLogs.count ==0) {
                    [allTableview initObjects];
                }
            }
                break;
                
            case 2:
            {
                if (incomeTableView.allLogs.count ==0) {
                    [incomeTableView initObjects];
                }
            }
                break;

            case 3:
            {
                if (outTableView.allLogs .count ==0) {
                    [outTableView initObjects];
                }
            }
                break;

        }
    } slidColor:KOrangeColor2_0 viewAry:arrayView];
    [self.view addSubview:tjScroll];
   
 
}
-(void)viewDidAppear:(BOOL)animated{
}

-(void)viewDisappear:(BOOL)animated{
//    [headView removeFromSuperview];
//    headView = nil;
    [[LoadingView showLoadingView] actViewStopAnimation];
    [allTableview removeFromSuperview];
    allTableview = nil;
    [incomeTableView removeFromSuperview];
    incomeTableView = nil;
    [outTableView removeFromSuperview];
    outTableView = nil;
    [ms removeFromSuperview];
    ms = nil;
    [image removeFromSuperview];
    image = nil;
//    if (IOS_Version >= 7.0) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)onClickBtn:(UIButton* )btn{
    image.frame = btn.frame;
    switch (btn.tag) {
       //收支全部
        case 0:
        {
            ms.contentOffset = CGPointMake(0, 0);
        }
            break;
        //收入
        case 1:
        {
            ms.contentOffset = CGPointMake(320, 0);
        }
            break;
        //支出
        case 2:
        {
            ms.contentOffset = CGPointMake(640, 0);
        }
            break;
    }
}

-(void)onClickBackBtn:(UIButton* )btn{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
//滑动代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (ms.contentOffset.x == 0) {
        UIButton* btn = (UIButton *)[chooseBtn.btnArr objectAtIndex:0];
        image.frame = btn.frame;
    } else if (ms.contentOffset.x == 320.0){
        UIButton* btn = (UIButton *)[chooseBtn.btnArr objectAtIndex:1];
        image.frame = btn.frame;
    }else if (ms.contentOffset.x == 640.0){
        UIButton* btn = (UIButton *)[chooseBtn.btnArr objectAtIndex:2];
        image.frame = btn.frame;
    }
}
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
