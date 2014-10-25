//
//  SettingViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUs.h"
#import "TJViewController.h"
#import "StatusBar.h"
#import "MScrollVIew.h"
#import "HeadToolBar.h"
#import "NewUserTableCell.h"
#import "MyUserDefault.h"
#import "UIImage+ColorChangeTo.h"
@interface SettingViewController ()
{
    UIImageView* showImage ;
    MScrollVIew* ms;
    NSString* appUrl;
    NSMutableArray* array;
    HeadToolBar *headBar;
   
    
    AboutUs *au;
    UITableView *settingTab;
    
    UIImageView *imageView;
    UILabel *show;
}
@end

@implementation SettingViewController

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
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"设置" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    
    ms=[[MScrollVIew alloc]initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh-headBar.frame.size.height-headBar.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    ms.bounces =YES;
    
//    [self.view addSubview:ms];
    [self initViews];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self checkNewVersionIsClicked:NO];
}
-(void)receiveNewMessage:(id )sender{
    UISwitch* switchButton =(UISwitch* )sender;
    BOOL isOn =switchButton.on;
    NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
    NSNumber* num =[NSNumber numberWithBool:isOn];
    //接受新消息通知
    if (isOn ==YES) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound)];
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    [ud setObject:num forKey:@"isRecesiveMessage"];
}

-(void)initViews{
    array=[NSMutableArray arrayWithObjects:kCheckNewVersions,kAboutUs, nil];
    settingTab =[[UITableView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y+headBar.frame.size.height) style:UITableViewStylePlain];
    settingTab.dataSource =self;
    settingTab.delegate =self;
    settingTab.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:settingTab];
    
    if (![[[MyUserDefault standardUserDefaults] getAppStoreAdress] isEqualToString:@""]) {   //显示评价
        [array addObject:kMakeGrade];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"settingCell";
    NewUserTableCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[NewUserTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setCellViewByType:1 andWithImage:nil andCellTitle:[array objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self checkNewVersionIsClicked:YES];
        }
            break;
            
        case 1:
        {
            au = [[AboutUs alloc]initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:au animated:YES];
        }
            break;
        case 2:
        {
            //06.20 评价地址写在前端
            NSURL *webUrl = [NSURL URLWithString:kMakeGardeWeb];
            [[UIApplication sharedApplication]openURL:webUrl];
            
            
        }
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appUrl]];
    }
}

-(void)checkNewVersionIsClicked:(BOOL) isClicked{

    if ([[MyUserDefault standardUserDefaults]getUpdate] == nil) {
        if (isClicked) {
            [StatusBar showTipMessageWithStatus:@"您已经是最新版本了" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
        }
        
    }else{
        NSDictionary* dic =[[MyUserDefault standardUserDefaults]getUpdate];
        NSString* content =[dic objectForKey:@"Content"];
        appUrl =[dic objectForKey:@"Apk"];
        NSString* ver =[dic objectForKey:@"Ver"];
        NSString* version = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey];
        if ([ver isEqualToString:version]) {
            if (isClicked) {
                [StatusBar showTipMessageWithStatus:@"您已经是最新版本了" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
            }
        }else{
            if (isClicked) {
                UIAlertView* alert =[[UIAlertView alloc]initWithTitle:knewVersion message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                [alert show];
            }else{
                [self showUpdateTip];
            }
        }
    }
    
}

-(void)showUpdateTip{
    if (!imageView) {
        imageView =[[UIImageView alloc]initWithImage:[UIImage createImageWithColor:KRedColor2_0]];
    }
    if (!show) {
        show =[[UILabel alloc]initWithFrame:CGRectMake( 234, (kCellHeight-15.0) /2, 55.0, 15.0)];
    }
    imageView.frame =show.frame;
    show.textAlignment =NSTextAlignmentCenter;
    show.text =@"有更新";
    show.textColor =[UIColor whiteColor];
    show.font =[UIFont systemFontOfSize:13.0];
    show.backgroundColor =[UIColor clearColor];
    NewUserTableCell *cell = (NewUserTableCell *)[settingTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:show];
}
-(void)onClickNextBtn:(UIButton* )btn{
    
    
    switch (btn.tag) {
            //检测新版本
        case 1:
        {
            [self checkNewVersionIsClicked:YES];
        }
            break;
            //关于我们
        case 2:
        {
        }
            break;
            //意见反馈
            /*
             case 3:
             {
             OpinionBack *ob = [[OpinionBack alloc]initWithNibName:nil bundle:nil];
             [nc presentViewController:ob animated:YES completion:^{
             
             }];
             }
             break;
             */
            //给我评分
        case 3:
        {
            NSURL *webUrl = [NSURL URLWithString:kMakeGardeWeb];
            [[UIApplication sharedApplication]openURL:webUrl];
        }
            break;
            //输入邀请码  已弃用
        case 5:
        {
            
        }
            break;
    }
}

-(void)showImagehid{
    showImage.highlighted =NO;
}

-(void)onClickBackBtn:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
