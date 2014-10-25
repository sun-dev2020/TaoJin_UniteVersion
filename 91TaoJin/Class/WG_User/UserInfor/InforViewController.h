//
//  InforViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface InforViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>


@property (nonatomic ,strong) User *user;


@end
