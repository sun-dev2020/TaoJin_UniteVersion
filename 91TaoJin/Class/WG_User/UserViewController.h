//
//  UserViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "IncomeViewController.h"
#import "StatusBar.h"
@interface UserViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,NSURLConnectionDelegate,UIGestureRecognizerDelegate ,UIScrollViewDelegate>
{
    UIImageView* headImageView;
    UIImageView* settingView;
    
}

@property(nonatomic,strong)NSString* userName;
@property(nonatomic,strong)UIImage* userHeadImage;
@property(nonatomic,assign)int userJD;

@property(nonatomic,assign)BOOL isReload;
@end
