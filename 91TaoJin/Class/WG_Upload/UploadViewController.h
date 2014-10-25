//
//  UploadViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TaskPhoto.h"
#import "GameGroup.h"
#import "PhotoViewController.h"

@protocol UploadImageSuccessDelegate <NSObject>
-(void)uploadImageSuccess;
@end
/*
@interface UploadViewController : UIViewController <UIActionSheetDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UIAlertViewDelegate,PhotoViewControllerDelegate>
*/
@interface UploadViewController : UIViewController <UIActionSheetDelegate  ,UIAlertViewDelegate,PhotoViewControllerDelegate ,UIGestureRecognizerDelegate>

/*
@property (nonatomic ,strong) NSString *missonDes;     //任务描述

@property (nonatomic ,strong) NSString *plUrl ;        // 评论地址

@property (nonatomic ,assign) int uploadGold;     //上传获得金豆数

@property (nonatomic ,strong) NSArray *imgsArr ;   //示例图
 */

@property (nonatomic ,strong) TaskPhoto *taskPhoto ;      //数据对象
@property (nonatomic, assign) id<UploadImageSuccessDelegate> delegate;

@end
