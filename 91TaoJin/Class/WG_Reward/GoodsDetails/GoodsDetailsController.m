//
//  GoodsDetailsController.m
//  TJiphone
//
//  Created by keyrun on 13-10-15.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "GoodsDetailsController.h"
#import "PostGoodsController.h"
#import "RewardViewController.h"
#import "MScrollVIew.h"
#import "SDImageView+SDWebCache.h"
#import "StatusBar.h"
#import "DidRewardView.h"
#import "LoadingView.h"
#import "RewardListViewController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "HeadToolBar.h"
#import "CButton.h"
//【兑奖中心】显示单个物品详细信息
@interface GoodsDetailsController ()
{
    //    HeadView* headView;
    HeadToolBar *headBar;
    MScrollVIew* ms;
    
    GoodsModel *_goodsModel;                                        //礼品对象
    int timeOutCount;
}
@end

@implementation GoodsDetailsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      _goodsModel =self.goodsModel;
         timeOutCount = 0;
    }
    return self;
}

-(id)initViewWithGoodsModel:(GoodsModel *)goodsModel{
    self = [super init];
    if (self) {
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //ios7 以上，更改状态栏的样式
    //    if (IOS_Version >= 7.0) {
    //        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 20)];
    //        view.backgroundColor = [UIColor blackColor];
    //        [self.view addSubview:view];
    //    }
    //
    //    headView = [[HeadView alloc]initWithFrame:CGRectMake(0, kOriginY, kmainScreenWidth,kHeadViewHeigh)];
    //    [headView initHeadViewWithTitle:@"礼品详情"];
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"礼品详情" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    if (IOS_Version >= 7.0) {
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height + 20) andWithPageCount:1 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:1 backgroundImg:nil];
    }

    
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
     ms.bounces =YES;
    [self.view addSubview:ms];
    if (!self.isPush) {
        [self initViewContent:self.goodsModel];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pop2View) name:@"popview" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //    [self requestToGoodsDetailedInfo];         新版商品详情不需要单独请求
}

-(void)viewWillDisappear:(BOOL)animated{
//    [ms removeFromSuperview];
//    ms = nil;
//    [headBar removeFromSuperview];
//    headBar = nil;
//    _goodsModel = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popview" object:nil];
}

//【返回】按钮事件
-(void)onClickBackBtn:(UIButton *)btn{
    [[LoadingView showLoadingView] actViewStopAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}

//【兑换】按钮事件
-(void)onClickExchangeBtn:(UIButton* )btn{
    [[LoadingView showLoadingView] actViewStartAnimation];
    btn.userInteractionEnabled = NO;
    
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    int type = _goodsModel.type + 2;         // 3:虚拟道具   4:炫酷产品   5:充值卡
    NSDictionary *dic = @{@"sid": sid, @"Type": [NSNumber numberWithInt:type], @"Num":[NSNumber numberWithInt:1], @"AwardId":[NSNumber numberWithInt:_goodsModel.awardId]};
    [self requestToGetLimitCount:dic duiHuanBtn:btn];
}

//请求查询限兑的数量（new）
-(void)requestToGetLimitCount:(NSDictionary *)dic duiHuanBtn:(UIButton *)duiHuanBtn{
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetLimit"];
    NSLog(@"请求查询限兑的数量【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求查询限兑的数量【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                long userBeanNum = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
                NSDictionary *body = [dataDic objectForKey:@"body"];
                NSString *info = [body objectForKey:@"Info"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    duiHuanBtn.userInteractionEnabled = YES;
                    if(info != nil && [@"ok" isEqualToString:info]){
                        //可兑换
                        if(userBeanNum < _goodsModel.needBean){
                            //用户淘金豆不足
                            [self showNotEnough];
                        }else if(_goodsModel.stock == 0){
                            //礼品库存为0
                            [StatusBar showTipMessageWithStatus:@"报告金主,库存不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }else{
                            if(_goodsModel.type == 2){
                                //炫酷奖品
                                PostGoodsController* pc = [[PostGoodsController alloc] initWithNibName:nil bundle:nil];
                                pc.good = self.goodsModel;
                                pc.goodsName =self.goodsModel.introduce;

                                [self.navigationController pushViewController:pc animated:YES];
                            }else{
                                DidRewardView* view = [[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
                                view.needBean = _goodsModel.needBean;
                                view.type = _goodsModel.type;
                                view.goodsName = _goodsModel.introduce;
                                view.isAdress = NO;
                                view.goods = _goodsModel;
                                view.rewardType = _goodsModel.type + 2;
                                [view setBasicView];
                                [self.view addSubview:view];
                            }
                        }
                    }else if(info != nil && [@"no" isEqualToString:info]){
                        //不可兑换
                        int limit = _goodsModel.limit;
                        
                        if (userBeanNum < _goodsModel.needBean) {
                            [self showNotEnough];
                        }else if (_goodsModel.stock ==0){
                            [StatusBar showTipMessageWithStatus:@"报告金主,库存不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }else{
                            [StatusBar showTipMessageWithStatus:[NSString stringWithFormat:@"报告金主，每人限兑%d个",limit] andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    duiHuanBtn.userInteractionEnabled = YES;
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"请求查询限兑的数量【erroe】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            [[LoadingView showLoadingView] actViewStopAnimation];
        }
    }];
}

-(void)pop2View{
    RewardListViewController* re = [[RewardListViewController alloc]initWithNibName:nil bundle:nil];
    NSLog(@"  GOODs VC");
    re.isRootPush =YES;
    [self.navigationController pushViewController:re animated:YES];
}

//请求获取礼品的详细信息
-(void)requestToGoodsDetailedInfo:(int)goodId{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"AwardId":[NSNumber numberWithInt:goodId]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardFullInfoById"];
    NSLog(@"请求获取礼品的详细信息【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            timeOutCount = 0;
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求获取礼品的详细信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    NSDictionary *body = [dataDic objectForKey:@"body"];
                    GoodsModel *goodsModel = [[GoodsModel alloc]initGoodsModelByDictionary:body];
                    self.goodsModel=goodsModel;
                    [self initViewContent:goodsModel];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"请求获取礼品的详细信息【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                [self requestToGoodsDetailedInfo:goodId];
            }else{
                timeOutCount = 2;
                
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}

//初始化界面的显示文字的Label
-(UILabel *)loadWithGoodsInfo:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize textColor:(UIColor *)textColor{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.userInteractionEnabled = NO;
    [label sizeToFit];
    
    return label;
}

//加载礼品详细信息的界面
-(void)initViewContent:(GoodsModel *)goodsModel{
    //加载礼品图片
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(kOffX_float, 10.0f, 320 -2 *kOffX_float, 183)];
    [goodsImage setImageWithURL:[NSURL URLWithString:goodsModel.bigImgUrl] refreshCache:NO placeholderImage:GetImage(@"pic_def.png")];
    [ms addSubview:goodsImage];
    
    //礼品名称
    NSString *text =goodsModel.introduce;
    if (self.isPush) {
        text =goodsModel.awardName;
    }
    UILabel *goodNameLab = [self loadWithGoodsInfo:CGRectMake(kOffX_float, goodsImage.frame.origin.y + goodsImage.frame.size.height + 10.0f, 0, 16) text:text fontSize:16 textColor:KBlockColor2_0];
    [ms addSubview:goodNameLab];
    
    //库存数量
    NSString *countStr ;
    if (goodsModel.stock != -1) {
        countStr = [NSString stringWithFormat:@"库存:%d       ",goodsModel.stock];
    }else{
        countStr = [NSString stringWithFormat:@"库存充足        "];
    }
    int  limitText =goodsModel.limit;
    if (self.isPush) {
        limitText  =goodsModel.perman;
    }
    if (limitText == -1) {
        countStr = [countStr stringByAppendingString:@"限兑:无限制"];
    }else{
        countStr = [countStr stringByAppendingString:[NSString stringWithFormat:@"每人限兑%d个",limitText]];
    }
    UILabel *goodCountLab = [self loadWithGoodsInfo:CGRectMake(kOffX_float, goodNameLab.frame.origin.y + goodNameLab.frame.size.height + 6.0f, 0, 11) text:countStr fontSize:11 textColor:KGrayColor2_0];
    [ms addSubview:goodCountLab];
    
    
    //淘金豆所需数量
    UILabel *jinDouLab = [self loadWithGoodsInfo:CGRectMake(0, goodNameLab.frame.origin.y , 0, 15) text:[NSString stringWithFormat:@"价格:%d",goodsModel.needBean] fontSize:14 textColor:kCrownColor];
    
    jinDouLab.frame = CGRectMake(kmainScreenWidth - jinDouLab.frame.size.width - kOffX_float, jinDouLab.frame.origin.y , jinDouLab.frame.size.width, 15);
    NSMutableAttributedString *attStr =[[NSMutableAttributedString alloc] initWithString:jinDouLab.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:KBlockColor2_0 range:NSMakeRange(0, 3)];
    [attStr addAttribute:NSForegroundColorAttributeName value:KOrangeColor2_0 range:NSMakeRange(3, jinDouLab.text.length -3)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(3, jinDouLab.text.length-3)];
    jinDouLab.attributedText =attStr;
    [ms addSubview:jinDouLab];
    
    
    //淘金豆Logo
    //    UIImageView *beanImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beans_2.png"]];
    //    beanImg.frame = CGRectMake(jinDouLab.frame.origin.x - beanImg.frame.size.width/2 - 5.0f, jinDouLab.frame.origin.y - 5.0f, beanImg.frame.size.width/2, beanImg.frame.size.height/2);
    //    [ms addSubview:beanImg];
    
    //兑换按钮
    CButton *chargeBtn =[self loadBtnWithFrame:CGRectMake(kOffX_float, goodCountLab.frame.origin.y +goodCountLab.frame.size.height +10.0f, 320.0 -2*kOffX_float, 40) withTitle:@"立即兑换" andFont:[UIFont systemFontOfSize:16.0]];
    chargeBtn.tag =6;
    [chargeBtn addTarget:self action:@selector(onClickExchangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ms addSubview:chargeBtn];
    
    //礼品详细信息
    NSString *infoText =goodsModel.detail;
    if (self.isPush) {
        infoText =goodsModel.introduce;
    }
    UILabel *infoLab = [self loadWithGoodsInfo:CGRectMake(kOffX_float, chargeBtn.frame.origin.y + chargeBtn.frame.size.height + 10.0f, 320.0 - 2 *kOffX_float, 0.0f) text:infoText fontSize:11.0f textColor:KGrayColor2_0];
    [ms addSubview:infoLab];
    if (infoLab.frame.size.height + infoLab.frame.origin.y +5 > ms.frame.size.height) {
        [ms setContentSize:CGSizeMake(320, infoLab.frame.size.height + infoLab.frame.origin.y + headBar.frame.origin.y + headBar.frame.size.height + 1)];
    }
}
-(CButton *)loadBtnWithFrame:(CGRect)frame withTitle:(NSString *)title andFont:(UIFont*) font{
    CButton * btn =[CButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor =btn.nomalColor =KGreenColor2_0;
    btn.changeColor =kSelectGreen;
    btn.frame =frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =font;
    return btn;
}
-(void)showNotEnough{
    UIAlertView* alertView =[[UIAlertView alloc]initWithTitle:@"金豆余额不足" message:@"报告金主，您的金豆余额不足，可通过做任务、邀请好友、参与活动等方式赚取金豆" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚金豆", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex != 0) {

        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"goBackToTaojin" object:nil userInfo:nil];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
