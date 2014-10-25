//
//  InforViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "InforViewController.h"
#import "HeadToolBar.h"
#import "MScrollVIew.h"
#import "CButton.h"
#import "MyUserDefault.h"
#import "SDImageView+SDWebCache.h"
#import "TJViewController.h"
#import "JSNsstring.h"
#import "JSONKit.h"
#import "CompressImage.h"
#import "UniversalTip.h"
#import "AsynURLConnection.h"
#import  "StatusBar.h"
#import "NSString+IsEmply.h"
#import "UIImage+ColorChangeTo.h"
@interface InforViewController ()
{
    MScrollVIew *ms;
    UIImage *getImage;
    UIImageView *headImage;
    UITextField *textFiled;
    
}
@end

@implementation InforViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)goBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    HeadToolBar *headBar = [[HeadToolBar alloc] initWithTitle:@"用户信息" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];
    [headBar.leftBtn addTarget:self action:@selector(goBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    if (IOS_Version >= 7.0) {
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height + 20) andWithPageCount:3 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:3 backgroundImg:nil];
    }
    ms.bounces =YES;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    [self.view  addSubview:ms];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [ms addGestureRecognizer:tap];
    [self loadContentView];
    
}
-(void)closeKeyboard{
    if (textFiled) {
        [textFiled resignFirstResponder];
    }
    
}
-(UILabel *)loadLabelWithFrame:(CGRect) rect andLabText:(NSString *)text andTextFont:(UIFont *)font{
    UILabel *label =[[UILabel alloc]initWithFrame:rect];
    label.backgroundColor =[UIColor clearColor];
    label.text =text;
    label.font =font;
    label.textAlignment =NSTextAlignmentCenter;
    return label;
}
-(void)loadContentView{
    
    NSString *icon = self.user.userIcon;
    NSString *name = self.user.userName;
    
    UIImageView *imageKuang =[[UIImageView alloc]initWithImage:GetImage(@"imagekuang.png")];
    imageKuang.frame =CGRectMake(117, 10, 85, 85);
    
    
    headImage =[[UIImageView alloc]init];
    headImage.frame =CGRectMake(127, 20, 65, 65);
    NSData *picData =[[MyUserDefault standardUserDefaults] getUserPic];
    if (picData !=nil) {
        headImage.image =[UIImage imageWithData:picData];
    }else{
        [headImage setImageWithURL:[NSURL URLWithString:icon] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    }
    UIButton *headBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame =imageKuang.frame;
    [headBtn addTarget:self action:@selector(onClickedChangeImage) forControlEvents:UIControlEventTouchUpInside];
    [ms addSubview:headBtn];
    [ms addSubview:headImage];
    [ms addSubview:imageKuang];
    
    if (![name isEqualToString:@""] && ![icon isEqualToString:@""]) {    // 有名字有头像
        UILabel *nameLab =[self loadLabelWithFrame:CGRectMake(kOffX_float, imageKuang.frame.origin.y +imageKuang.frame.size.height +8, 320.0f -kOffX_float *2, 15) andLabText:name andTextFont:[UIFont systemFontOfSize:14.0]];
        nameLab.textColor =KGrayColor2_0;
        [ms addSubview:nameLab];
        [self setTipsContextPositon:nameLab];
    }else if (![name isEqualToString:@""] &&[icon isEqualToString:@""]){  //有名字没头像
        UILabel *nameLab =[self loadLabelWithFrame:CGRectMake(kOffX_float, imageKuang.frame.origin.y +imageKuang.frame.size.height +8, 320.0f -2*kOffX_float, 15) andLabText:name andTextFont:[UIFont systemFontOfSize:14.0]];

        nameLab.textColor =KGrayColor2_0;
        [ms addSubview:nameLab];
//        UIButton *btn =[self loadButtonWithFrame:CGRectMake(nameLab.frame.origin.x, nameLab.frame.origin.y +nameLab.frame.size.height+8, 320.0 - 2* kOffX_float, 40.0)];
//        [ms addSubview:btn];
        [self setTipsContextPositon:nameLab];
    }
    else{
        textFiled =[[UITextField alloc]initWithFrame:CGRectMake(kOffX_float, imageKuang.frame.origin.y +imageKuang.frame.size.height +27, 320-kOffX_float *2, 15.0)];
        textFiled.textColor =KGrayColor2_0;
        textFiled.placeholder =@"输入你的名字";
        textFiled.font =[UIFont systemFontOfSize:14.0];
        if (![name isEqualToString:@""]) {
            textFiled.text =name;
            [textFiled setEnabled:NO];
        }
        [ms addSubview:textFiled];
        
        UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(kOffX_float, textFiled.frame.origin.y +textFiled.frame.size.height +15, 320-kOffX_float, 0.5)];
        lineView.backgroundColor =KGrayColor2_0;
        [ms addSubview:lineView];
        
        UIButton *nameBtn = [self loadButtonWithFrame:CGRectMake(kOffX_float, lineView.frame.origin.y +10, 320 - 2 *(kOffX_float), 40)];
        [ms addSubview:nameBtn];
        [self setTipsContextPositon:nameBtn];
    }
    
}
-(UIButton *)loadButtonWithFrame:(CGRect) rect{
    UIButton *nameBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [nameBtn setBackgroundImage:[UIImage createImageWithColor:KGreenColor2_0] forState:UIControlStateNormal];
    [nameBtn setBackgroundImage:[UIImage createImageWithColor:KLightGreenColor2_0] forState:UIControlStateHighlighted];
    nameBtn.frame =rect;
    [nameBtn addTarget:self action:@selector(getJDRewardClick) forControlEvents:UIControlEventTouchUpInside];
    [nameBtn setTitle:@"领取金豆" forState:UIControlStateNormal];
    return nameBtn;
}
-(void)setTipsContextPositon:(UIView *)object{
    NSArray *array =[NSArray arrayWithObjects:[NSString stringWithFormat:@"首次修改昵称和头像可获得%d金豆奖励，昵称只可修改一次。",self.user.giftGold], nil];
    UniversalTip *tip =[[UniversalTip alloc]initWithFrame:CGRectMake(kOffX_float, object.frame.origin.y +object.frame.size.height +10, 320-2*(kOffX_float), 51) andTips:array andTipBackgrundColor:KTipBackground2_0 withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:[UIImage imageNamed:@"tips_3.png"] andTipTitle:@"修改提示:" andTextColor:KOrangeColor2_0];
    [ms addSubview:tip];
}
-(void)getJDRewardClick{   // 修改用户信息按钮
    NSString *icon = self.user.userIcon;
    NSString *name = self.user.userName;
    if ([[MyUserDefault standardUserDefaults] getUserPic]) {
        icon =@"91tj";
    }
    
    if ([name isEqual:@""] && ![icon isEqual:@""]) {   //只换了头像  没改名字
        if (![textFiled.text isEqualToString:@""]) {
            [self checkName:textFiled.text];
        }else{
            [StatusBar showTipMessageWithStatus:@"请输入用户昵称后领取" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
        }
    }else if (![name isEqual:@""]  && [icon isEqual:@""]){   //只改了昵称  没换头像
        [StatusBar showTipMessageWithStatus:@"请更改用户头像后领取" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
    }else if ( [name isEqual:@""] &&  [icon isEqual:@""]){   //昵称 头像都没改
        if (![NSString isEmply:textFiled.text]) {
            [self checkName:textFiled.text];
        }else{
            [StatusBar showTipMessageWithStatus:@"请完善用户资料后领取" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
        }
    }else{
    }
    
}
-(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(void)checkName:(NSString *)name{
    
    if ([self convertToInt:name] >12) {
        [StatusBar showTipMessageWithStatus:@"不能超过12个字母、数字或6个汉字" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
    }
    else if ([self convertToInt:name] <6){
        [StatusBar showTipMessageWithStatus:@"不能少于6个字母、数字或3个汉字" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
    }/*else if ([NSString isEmply:textFiled.text]){
        [StatusBar showTipMessageWithStatus:@"不能少于4个字母、数字或2个汉字哦" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
    }*/else if ([self isPureInt:name]){
        [StatusBar showTipMessageWithStatus:@"不能为纯数字" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
    }
    else if ([self isincludeSpecialChar:name]){
        [StatusBar showTipMessageWithStatus:@"请使用汉字、字母、数字" andImage:[UIImage imageNamed:@"icon_no.png"] andTipIsBottom:YES];
    }else{   // 符合取名条件 发送取名请求
        NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
        NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:sid,@"sid",name,@"Nick", nil];
        NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"SetNick"];
        [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"  取名==%@",dataDic);
                if ([[dataDic objectForKey:@"flag"]integerValue] ==1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [StatusBar showTipMessageWithStatus:@"取名成功" andImage:GetImage(@"laba.png") andCoin:[NSString stringWithFormat:@"+%d",self.user.giftGold] andSecImage:[UIImage imageNamed:@"tipBean.png"] andTipIsBottom:YES ];

                        [[MyUserDefault standardUserDefaults] setUserNickname:name];
                        [self goBackClicked];
                    });
                    
                }else if ([[dataDic objectForKey:@"flag"]integerValue] ==2){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *body =[dataDic objectForKey:@"body"];
                        int messageCode = [[dataDic objectForKey:@"message"] intValue];
                        if (messageCode == -10008003  || [[body objectForKey:@"State"] intValue] ==3) {
                            [StatusBar showTipMessageWithStatus:@"请先更换用户头像" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }else if(messageCode == -10008007){
                            //昵称过长
                            [StatusBar showTipMessageWithStatus:@"不能超过12个字母、数字或6个汉字" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }else if(messageCode == -10008005){
                            [StatusBar showTipMessageWithStatus:@"不能少于6个字母、数字或3个汉字" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }else if(messageCode == -10008006){
                            [StatusBar showTipMessageWithStatus:@"不能为纯数字" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }else if(messageCode == -10008004){
                            [StatusBar showTipMessageWithStatus:@"请使用汉字、字母、数字" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }else if (messageCode == -10008002){
                            [StatusBar showTipMessageWithStatus:@"昵称已被使用" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }
                        /*
                        if ([[dataDic objectForKey:@"message"] intValue] ==-10008003  || [[body objectForKey:@"State"] intValue] ==3) {
                            [StatusBar showTipMessageWithStatus:@"请先更换用户头像" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }else if ([[body objectForKey:@"State"] intValue] ==1){
                            [StatusBar showTipMessageWithStatus:@"昵称已被使用" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }else if ([[body objectForKey:@"State"] intValue] ==2){
                            //fix bug
                            [StatusBar showTipMessageWithStatus:@"昵称不符合条件" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                        }
                        */
                    });
                }
                
            });
        } fail:^(NSError *error) {
            
        }];
        
    }
}
-(BOOL)isincludeSpecialChar:(NSString* )name{
    NSRange urgentRange = [name rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~;'￥#&*<>《》()[]{}【】^@/￡¤￥|§¨'「」『』￠￢￣~@#￥&*（）——+|《》$_€￥‘；=+ ·~,，.。、`!？?%^\""]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
-  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength);
    
}


-(void)revertColor:(UIButton *)btn{
    btn.backgroundColor =KGreenColor2_0;
}
-(void)changeColor:(UIButton *)btn{
    btn.backgroundColor =kSelectGreen;
}
-(void)cancelTouch:(UIButton *)btn{
    btn.backgroundColor =KGreenColor2_0;
}
-(void)onClickedChangeImage{  // 更换头像
    UIActionSheet* as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    
    as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [as dismissWithClickedButtonIndex:2 animated:YES];
    if (IOS_Version < 7.0) {
        TJViewController *tj = [[TJViewController alloc]init];
        [as showFromTabBar:tj.tabBar];
    }else{
        [as showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            //拍照
        case 0:
        {
            UIImagePickerControllerSourceType type=UIImagePickerControllerSourceTypeCamera;
            if([UIImagePickerController isSourceTypeAvailable:type]){
                UIImagePickerController* pc=[[UIImagePickerController alloc]init];
                pc.delegate=self;
                pc.allowsEditing=YES;
                pc.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:pc animated:YES completion:nil];
            }
        }
            break;
            //从相册取相片
        case 1:
        {
            UIImagePickerController* pc=[[UIImagePickerController alloc]init];
            pc.delegate=self;
            pc.allowsEditing=YES;
            pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pc animated:YES completion:nil];
            
        }
            break;
        case 2:
        {
            
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    getImage=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([self isBigImage:getImage]==YES) {
        getImage =[CompressImage imageWithOldImage:getImage scaledToSize:CGSizeMake(120 *2, 120 *2)];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(getImage, self, nil, NULL);
    }
    [self sendSaveInforRequest:getImage];
}
-(BOOL)isBigImage:(UIImage*)image{
    NSData* data =UIImageJPEGRepresentation(image, 1.0);
    
    if (data.length >10240) {
        return YES;
    }else{
        return NO;
    }
}

-(void)sendSaveInforRequest:(UIImage*)userimage{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSString* sid =[defaults objectForKey:@"sid"];
    
    NSMutableDictionary* dic2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:sid,@"sid", nil];
    NSString* paramStr =[dic2 JSONString];
    UIImage* image =userimage;
    [dic2 setObject:image forKey:[NSString stringWithFormat:@"userPic"]];
    NSData* data12 =UIImageJPEGRepresentation(image, 1.0);
    
    NSString* urlStr =[NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"ChangePic"];
    NSURL* url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest* urlRequest=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];
    NSString* boundary =@"0xKhTmLbOuNdArY";
    NSString* contentType= [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
    [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* body =[NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='PARAM';value='%@'\n\n",paramStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"{\"sid\":\"%@\"}",sid] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //第二段
    int imageTag=0;
    for (NSString* key in dic2.allKeys) {
        id value =[dic2 objectForKey:key];
        
        if ([value isKindOfClass:[UIImage class]]) {
            NSData* dataImg;
            if (data12.length >10240) {
                dataImg= UIImageJPEGRepresentation(value, 0.5);
            }else{
                dataImg= UIImageJPEGRepresentation(value, 1);
            }
            [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='userfile%d';filename='userfile.jpg'\n",imageTag] dataUsingEncoding:NSUTF8StringEncoding]];
            imageTag++;
            [body appendData:[[NSString stringWithFormat:@"Content-Type:image/jpg\n\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:dataImg];
            [body appendData:[[NSString stringWithFormat:@"\n--%@--\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }
    
    [AsynURLConnection requestWithURLToSendJSONL:urlStr boundary:boundary paramStr:paramStr body:body timeOut:httpTimeout +30 success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int flag =[[dic objectForKey:@"flag"] integerValue];
            if (flag ==1) {
                int coin =[[dic objectForKey:@"message"] intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    headImage.image =getImage;
                    if (coin != 0) {
                        [StatusBar showTipMessageWithStatus:@"头像更换成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andCoin:[NSString stringWithFormat:@"+%d",coin] andSecImage:[UIImage imageNamed:@"tipBean.png"]andTipIsBottom:YES];
                        
                    }else{
                        [StatusBar showTipMessageWithStatus:@"头像更换成功" andImage:[UIImage imageNamed:@"icon_yes.png"]andTipIsBottom:YES];
                    }
                    NSData* userHeadPic =[NSData dataWithData:UIImagePNGRepresentation(getImage)];
                    [[MyUserDefault standardUserDefaults] setUserPic:userHeadPic];
                    
                });
            }else{
                [StatusBar showTipMessageWithStatus:@"更换头像失败，请再次上传" andImage:[UIImage imageNamed:@"icon_yes.png"]andTipIsBottom:YES];
            }
        });
    } fail:^(NSError *error) {
        [StatusBar showTipMessageWithStatus:@"更换头像失败，请再次上传" andImage:[UIImage imageNamed:@"icon_yes.png"]andTipIsBottom:YES];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
