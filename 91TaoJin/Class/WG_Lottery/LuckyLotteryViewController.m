//
//  LuckyLotteryViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-5-8.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "LuckyLotteryViewController.h"
#import "SerialAnimationQueue.h"
#import "AsynURLConnection.h"
#import "MyUserDefault.h"
#import "HeadToolBar.h"
#import "TaoJinButton.h"
#import "UIImage+ColorChangeTo.h"
#import "UniversalTip.h"
#import "TaoJinLabel.h"
#import "LotteryReward.h"
#import "SDImageView+SDWebCache.h"
#import "LoadingView.h"
#import "StatusBar.h"
#define RewordCount     12                                          //抽奖奖品总数量
#define Count           3                                           //每行或每类显示的奖品数量
#define BorderLength    57                                          //边框长度（即长或高）

#define kBoxOrange1 [UIColor colorWithRed:255.0/255.0 green:170.0/255.0 blue:25.0/255.0 alpha:1]
#define kBoxOrange2 [UIColor colorWithRed:255.0/255.0 green:200.0/255.0 blue:70.0/255.0 alpha:1]
@interface LuckyLotteryViewController (){
    NSMutableArray *picAry;                                         //存放所有的奖品视图
    HeadToolBar *headView;
    MScrollVIew *ms;
    NSMutableArray *allRewards ;                                //所有奖品
    UIView *backColor;
    TaoJinButton *greenBtn;
    int totalNum ;                                       //总共抽奖次数
    int fNum  ;                                          //每天免费抽奖次数
    UniversalTip *tip ;
    NSMutableArray *tips;
    int timeoutCount;
    TaoJinButton *startBtn;
    NSString *rewardInfo;
    int indexTag ;                                      //上次选中位置
    
    int imgIsChange ;                                  // 判断本地图片是否和服务器一致   1,使用服务器图片  2，使用本地数据
    NSMutableArray *allData;
    int fNum_ed;
    UIAlertView *alertTip ;
}

@end

@implementation LuckyLotteryViewController

@synthesize queue = _queue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        _queue = [[SerialAnimationQueue alloc] init];
    }
    return self;
}

-(void)initObjects{
    picAry = [[NSMutableArray alloc] initWithCapacity:RewordCount];
    allRewards =[[NSMutableArray alloc] init];
    allData  =[[NSMutableArray alloc] init];
    totalNum = 0;
    fNum = 0;
    timeoutCount =0 ;
    indexTag =0 ;
    imgIsChange = 0;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor =[UIColor whiteColor];
    [self initObjects];
    [self initBackContent];
    
    [self initLuckLottery];
    
    [self requestToGetRewardMessage];
}
-(void)showMessage{
    
}
-(void)initLuckLottery{
    
    backColor =[[UIView alloc] initWithFrame:CGRectMake((kmainScreenWidth -4 *BorderLength) /2, 10.0 , 4 * (BorderLength+1), 4 * (BorderLength+1))];
    backColor.backgroundColor = KRedColor2_0;
    [ms addSubview:backColor];
    
    [self addLuckBackBox];
    //    UIView *rewardView =[self showRewordPicturesWithFrame:CGRectMake(backColor.frame.origin.x +BorderLength, backColor.frame.origin.y, backColor.frame.size.width, backColor.frame.size.height)];
    //    [ms addSubview:rewardView];
    
    startBtn =[[TaoJinButton alloc] initWithFrame:CGRectMake((kmainScreenWidth -4 *BorderLength) /2, backColor.frame.origin.y +backColor.frame.size.height+1, backColor.frame.size.width, 35.0f) titleStr:@"点击绿色按钮开始抽奖" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] logoImg:nil backgroundImg:[UIImage createImageWithColor:KRedColor2_0]];
    [startBtn addTarget:self action:@selector(showMessage) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setBackgroundImage:[UIImage createImageWithColor:KLightRedColor2_0] forState:UIControlStateHighlighted];
    [ms addSubview:startBtn];
    
    
    greenBtn =[[TaoJinButton alloc] initWithFrame:CGRectMake(backColor.frame.origin.x +BorderLength+1, backColor.frame.origin.y +BorderLength+1, 2*BorderLength +1, 2*BorderLength +1)];
    [greenBtn setBackgroundImage:[UIImage createImageWithColor:KGreenColor2_0] forState:UIControlStateNormal];
    [greenBtn setBackgroundImage:[UIImage createImageWithColor:KLightGreenColor2_0] forState:UIControlStateHighlighted];
    [greenBtn addTarget:self action:@selector(onClickedLottery) forControlEvents:UIControlEventTouchUpInside];
    [greenBtn setTitle:@"马上抽奖" forState:UIControlStateNormal];
    greenBtn.userInteractionEnabled = NO;
    [ms addSubview:greenBtn];
    
    tips =[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"1.每日有%d次免费抽奖机会，可通过做任务获得更多抽奖机会（完成一个任务获得一次抽奖机会）；",fNum], @"2.部分游戏/应用包含多个任务，可获得多次抽奖机会；",@"3.若抽中金豆奖励，则直接充值到用户账户中；",@"4.若抽中实物奖品，可点击“领取”，输入收货信息后我们将在1—3个工作日为您发货。",nil];
    tip =[[UniversalTip alloc] initWithFrame:CGRectMake(kOffX_float, startBtn.frame.origin.y +startBtn.frame.size.height + 10, kmainScreenWidth -2*kOffX_float, 0) andTips:tips andTipBackgrundColor:kPinkColor2_0 withTipFont:[UIFont systemFontOfSize:11] andTipImage:[UIImage imageNamed:@"dengpao_red"] andTipTitle:@"幸运抽奖说明：" andTextColor:KRedColor2_0];
    [ms addSubview:tip];
}
-(void)onClickedLottery{
    if (totalNum ==0) {
        alertTip =[[UIAlertView alloc] initWithTitle:@"免费抽奖次数已用完" message:@"可通过做任务获取抽奖机会， 做得越多奖励的抽奖机会越多；\n部分游戏/应用包含多个任务，可获得多次抽奖机会；\n是否立即做任务获得抽奖机会？" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"去做任务", nil];
        [alertTip show];
    }else{
        [self requestToGetLottery];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView == alertTip) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"goBackToTaojin" object:nil userInfo:nil];
    }
}
-(void)addLuckBackBox{
    float origionX = (kmainScreenWidth -4* BorderLength) /2 ;
    float origionY = 10.0 ;
    for (int i =0; i< 4; i++) {
        for (int j= 0; j< 4; j++) {
            UIColor *color ;
            CGRect frame =CGRectMake(origionX +i*(BorderLength+1) , origionY +(BorderLength+1) *j, BorderLength, BorderLength);
            
            /*
             if (i %2 ==0 && j%2 ==1) {
             color = kBoxOrange1 ;
             }else if(i%2 ==0 && j%2 ==0){
             color = kBoxOrange2 ;
             }
             else if (i %2 ==1 && j%2 ==1){
             color = kBoxOrange2 ;
             }else if (i%2 ==1 && j%2 ==0){
             color = kBoxOrange1 ;
             }
             */
            if (i%2 == j%2) {
                color =kBoxOrange2;
            }else{
                color =kBoxOrange1;
            }
            UIView *boxView =[self addBoxByColor:color andFrame:frame];
            [ms addSubview:boxView];
            
        }
        
    }
}
-(UIView *)addBoxByColor:(UIColor *)color andFrame:(CGRect) frame{
    UIView *view =[[UIView alloc] initWithFrame:frame];
    view.backgroundColor =color;
    return view;
}
-(void)onClickBackBtn:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initBackContent{
    headView = [[HeadToolBar alloc] initWithTitle:@"幸运抽奖" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:@"抽奖次数：" backgroundColor:KRedColor2_0];
    headView.leftBtn.tag = 1;
    [headView.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y + headView.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headView.frame.size.height - headView.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    ms.msDelegate = self;
    ms.bounces = YES;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -kmainScreenHeigh, kmainScreenWidth, kmainScreenHeigh)];
    view.backgroundColor = KRedColor2_0;
    [ms addSubview:view];
    
    UIView *backgroundView1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 10 +2.5 *BorderLength +1)];
    backgroundView1.backgroundColor = KRedColor2_0;
    
    [self.view addSubview:headView];
    [ms addSubview:backgroundView1];
    [self.view addSubview:ms];
    
}
-(void)requestToGetRewardMessage{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
    int randNum =arc4random() %1000;
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:sid,@"sid",[NSNumber numberWithInt:randNum],@"Random", nil];
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"GetLotteryInfo"];
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            NSString *errStr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            greenBtn.userInteractionEnabled =YES;
            NSError *error ;
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"__抽奖信息_%@ ",dataDic);
            NSDictionary *body =[dataDic objectForKey:@"body"];
            fNum = [[body objectForKey:@"FNum"]intValue];
            int mNum = [[body objectForKey:@"MNum_ed"] intValue];
            fNum_ed = [[body objectForKey:@"FNum_ed"] intValue];
            totalNum = fNum + mNum;
            NSArray *array =[body objectForKey:@"Prizes"];
            allRewards =[self getLotteryRewardsWith:array];
            
            NSMutableArray *originRewards =[[MyUserDefault standardUserDefaults] getLotteryImgsObj];
            if (![array isEqualToArray:originRewards]) {
                imgIsChange =1;
                
            }else{
                imgIsChange =2;
                
            }
            [[MyUserDefault standardUserDefaults] setLotteryImgsObj:(NSMutableArray *)array];
            
            if (allRewards.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [headView setRightLabText:[NSString stringWithFormat:@"抽奖次数：%d",totalNum]];
                    UIView *rewardView =[self showRewordPicturesWithFrame:CGRectMake(backColor.frame.origin.x +BorderLength, backColor.frame.origin.y, backColor.frame.size.width, backColor.frame.size.height)];
                    [ms insertSubview:rewardView belowSubview:greenBtn];
                    [tips replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"1.每日有%d次免费抽奖机会，可通过做任务获得更多抽奖机会（完成一个任务获得一次抽奖机会）；",fNum_ed]];
                    [tip uploadTipContent:tips andFont:[UIFont systemFontOfSize:11] andTextColor:KRedColor2_0 needAdjustPosition:NO];
                });
            }
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadingView showLoadingView] actViewStopAnimation];
        });
        
        
    } fail:^(NSError *error) {
        [[LoadingView showLoadingView] actViewStopAnimation];
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeoutCount <= 2){
                timeoutCount ++;
                [self requestToGetRewardMessage];
            }else{
                
            }
        }
        
    }];
}
-(NSMutableArray *)getLotteryRewardsWith:(NSArray *)rewards{
    NSMutableArray *mAry =[[NSMutableArray alloc] init];
    for (NSDictionary *dic in rewards) {
        LotteryReward *reward =[[LotteryReward alloc] initLotteryRewardWithDic:dic];
        [mAry addObject:reward];
    }
    return mAry;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
/**
 *  加载显示所有的抽奖奖品
 */
-(UIView *)showRewordPicturesWithFrame:(CGRect )frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor =[UIColor clearColor];
    float imageX = 0.0f;                                    //起始x坐标
    float imageY = 0.0f;                                    //起始y坐标
    int plusMinusSign = 1;                                  //标识坐标是递增还是递减
    for(int i = 1 ; i <= RewordCount / Count ; i ++){
        for(int j = 1 ; j <= Count ; j ++){
            UIView *picView = [self loadLotteryPictureViewWithTag:(i - 1) * Count + (j - 1) ];
            
            int index = i == 1 ? (j - 1) : j;
            if(i % 2 == 1){
                //x坐标变，y坐标不变
                picView.frame = CGRectMake(imageX + index * (BorderLength+1) * plusMinusSign, imageY, BorderLength, BorderLength);
                if(j == Count){
                    imageX = imageX + index * (BorderLength+1) * plusMinusSign;
                }
            }else{
                //x坐标不变，y坐标变
                picView.frame = CGRectMake(imageX, imageY + index * (BorderLength+1) * plusMinusSign, BorderLength, BorderLength);
                if(j == Count){
                    imageY = imageY + index * (BorderLength+1) * plusMinusSign;
                }
            }
            [view addSubview:picView];
            [picAry addObject:picView];
        }
        
        if(i == RewordCount / Count / 2){
            plusMinusSign = -1;
        }
    }
    return view;
}

/**
 *  加载单个奖品的视图
 *
 *  @param tag 唯一标识
 *
 */
-(UIView *)loadLotteryPictureViewWithTag:(int)tag {
    UIView *view = [[UIView alloc] init];
    /*
     if(tag % 2 == 0){
     view.backgroundColor = kBoxOrange1;
     }else{
     view.backgroundColor = kBoxOrange2;
     }
     */
    //奖品图案
    //    UIImage *lotteryImg = [UIImage imageNamed:@"Icon-60"];
    //    float lotteryImgWidth = lotteryImg.size.width > BorderLength ? 57 : lotteryImg.size.width;
    //    float lotteryImgHeight = lotteryImg.size.height > BorderLength  ? 57 : lotteryImg.size.height;
    UIImageView *lotteryImgView = [self loadLotteryImageWithFrame:CGRectMake(1.0f, 0.0f, BorderLength, BorderLength) image:nil tag:tag + 100];
    
    if (imgIsChange == 1) {
        LotteryReward *reward =[allRewards objectAtIndex:tag];
        [lotteryImgView setImageWithURL:[NSURL URLWithString:reward.LRImageUrl] refreshCache:YES ];
        lotteryImgView.backgroundColor =[UIColor clearColor];
        [view addSubview:lotteryImgView];
        int sTag = tag ;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data =[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:reward.LRImageUrl]];
            if (data !=nil) {
                NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"imgData", [NSNumber numberWithInt:sTag],@"tag", nil];
                [allData addObject:dic];
                if (allData.count == 12) {
                    allData =(NSMutableArray *)[allData sortedArrayUsingComparator:^(id obj1, id obj2) {
                        NSComparisonResult result = [[obj1 objectForKey:@"tag"] compare:[obj2 objectForKey:@"tag"]];
                        return result == NSOrderedDescending;
                    }];
                    [[MyUserDefault standardUserDefaults] setLotteryImgsData:allData];
                }
            }
        });
    }else if(imgIsChange == 2){
        NSMutableArray *array =[[MyUserDefault standardUserDefaults] getLotteryImgsData];
        NSDictionary *dic =[array objectAtIndex:tag];
        NSData *data =[dic objectForKey:@"imgData"];
        [lotteryImgView setImage:[UIImage imageWithData:data]];
        [view addSubview:lotteryImgView];
        /*
         for (NSDictionary *dic in array) {
         if ([[dic objectForKey:@"tag"] intValue] == tag) {
         NSData *data =[dic objectForKey:@"imgData"];
         [lotteryImgView setImage:[UIImage imageWithData:data]];
         [view addSubview:lotteryImgView];
         }
         }
         */
    }
    
    
    //选中时显示高亮状态
    UIImageView *selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(1.0f, 0.0f, BorderLength, BorderLength)];
    selectImg.image = [UIImage imageNamed:@"luckSelect@2x"];
    selectImg.alpha = 0.0;
    selectImg.tag = tag + 200;
    [view addSubview:selectImg];
    
    //奖品文案
    //    UILabel *lotteryLab = [self loadLabellWithFrame:CGRectMake(0.0f, lotteryImgView.frame.origin.y + lotteryImgView.frame.size.height, BorderLength, 10.0f) tag:tag + 300];
    //    [view addSubview:lotteryLab];
    return view;
}

/**
 *  加载抽奖奖品的图片
 *
 *  @param frame 图片大小
 *  @param image 图片
 *  @param tag   唯一标识
 *
 */
-(UIImageView *)loadLotteryImageWithFrame:(CGRect )frame image:(UIImage *)image tag:(int)tag{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}


/**
 *  加载抽奖奖品的文案显示
 *
 *  @param frame 文案显示大小
 *  @param tag   唯一标识
 *
 */
-(UILabel *)loadLabellWithFrame:(CGRect )frame tag:(int)tag{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:8.0];
    label.text = @"1金豆";
    label.numberOfLines = 1;
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    return label;
}

/**
 *  开始抽奖动画
 */
-(void)startLotteryAction{
    
}

//请求获取抽奖得到的奖品（test）
-(void)requestToGetLottery{
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"JoinLottery1"];
    //    NSString *page = [NSString stringWithFormat:@"%d",1];
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid":sid};
    NSLog(@"请求获取抽奖得到的奖品【urlStr】 = %@",urlStr);
    
    /**
     *  抽奖动画选中图片的高亮状态或正常状态
     *
     *  @param index 第几个奖品图标
     *  @param alpha alpha值，用于显示或隐藏高亮状态
     *
     */
    void (^lotterying)(int, float) = ^(int index, float alpha){
        UIView *view = [picAry objectAtIndex:index];
        UIImageView *selectImg = (UIImageView *)[view viewWithTag:200 + index];
        selectImg.alpha = alpha;
    };
    _queue = [[SerialAnimationQueue alloc] init];
    
    /**
     *  调整动画速度
     *
     */
    __block float speed = 0.0f;                 //速率
    __block float speedTime = 0.0f;             //动画运行时间
    __block BOOL isRecive = false;              //是否收到数据响应
    __block int randomNum = -1;                 //随机值（只用于本地测试，实际数值由服务器提供）
    __block float localSpeed = -1.0f;
    void (^ adjustSpeed)(int, int) = ^(int i, int j){
        [_queue animateWithDurationBlock:0.01f delayBlock:^NSTimeInterval{
            if(speedTime == 0.0f){
                speedTime = 0.5f;
            }
            if(speed > - 0.45f && !isRecive){
                //刚启动抽奖时动画开始加快
                speed -= 0.05f;
            }else if(speed <= 0.0001f && isRecive){
                //接收到数据后动画开始减慢
                int count ;
                if(localSpeed == -1.0f){
                    //接收到数据后还有距离目标还有多少个view要跑
                    //                    count = RewordCount + (randomNum + (RewordCount - j));
                    count  = RewordCount + randomNum - j ;
                    //求出递减速率的起始值
                    localSpeed = (-speed)/count;
                }
                speed += localSpeed ;
                if(speed > 0.0001f){
                    dispatch_suspend(_queue.queue);
                }
            }
            NSLog(@"speed = %f %d ",speed ,j);
            return speedTime + speed;
        } options:UIViewAnimationOptionLayoutSubviews animations:^{
            NSLog(@"j = %d",j);
            lotterying(j - 1 >= 0 ? (j - 1) : (RewordCount - 1), -1);
            lotterying(j, 1);
        } completion:^(BOOL finished) {
            if(speed > 0.0001f){
                [greenBtn setTitle:@"马上抽奖" forState:UIControlStateNormal];
                greenBtn.userInteractionEnabled =YES ;
                startBtn.userInteractionEnabled =YES ;
                [startBtn setTitle:[NSString stringWithFormat:@"恭喜抽中%@",rewardInfo] forState:UIControlStateNormal];
                indexTag =j;       //标记上次抽奖位置
            }
        }];
    };
    
    BOOL isStopRunnig = NO;
    for(int i = 0 ; i < 1000; i ++){
        int j =0;
        if (indexTag !=0) {
            j =indexTag +1;
            if (i > 0) {
                indexTag = 0;
            }
        }
        for(j = indexTag ; j < RewordCount ; j ++){
            
            adjustSpeed(i, j);
            if(isStopRunnig){
                break;
            }
        }
        if(isStopRunnig){
            break;
        }
    }
    [greenBtn setTitle:@"抽奖中" forState:UIControlStateNormal];
    greenBtn.userInteractionEnabled =NO ;
    startBtn.userInteractionEnabled =NO ;
    [startBtn setTitle:@"抽奖中" forState:UIControlStateNormal];
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" data  %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            NSDictionary *body =[dataDic objectForKey:@"body"];
            if ([[dataDic objectForKey:@"flag"]intValue] ==1) {
                NSDictionary *loPrizes =[body objectForKey:@"LoPrizes"];
                int rewardId =[[loPrizes objectForKey:@"Id"] intValue];
                
                for (int i=0; i< allRewards.count; i++) {
                    LotteryReward *reward =[allRewards objectAtIndex:i];
                    if (reward.LRId == rewardId) {
                        randomNum = i ;
                        NSLog(@"random %d",randomNum);
                    }
                }
                rewardInfo =[loPrizes objectForKey:@"AwardName"];
                
                totalNum --;                      //成功之后次数减1
                dispatch_async(dispatch_get_main_queue(), ^{
                    [headView setRightLabText:[NSString stringWithFormat:@"抽奖次数：%d",totalNum]];
                });
                NSLog(@"请求获取抽奖得到的奖品【response】 = %@",dataDic);
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0f * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    NSLog(@"接收到数据");
                    isRecive = true;
                });
                
            }
            
        });
    } fail:^(NSError *error) {
        NSLog(@"请求获取抽奖得到的奖品【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            
        }
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    if (_queue) {
        dispatch_suspend(_queue.queue);
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end







