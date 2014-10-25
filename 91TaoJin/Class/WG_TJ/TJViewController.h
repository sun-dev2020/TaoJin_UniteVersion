//
//  TJViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

//test
@interface TJViewController : UITabBarController<UITabBarControllerDelegate,UIAlertViewDelegate>
{
    UIImageView* one;
    UIImageView* two;
    UIImageView* three;
    UIImageView* four;

    UILabel* Lone;
    UILabel* Ltwo;
    UILabel* Lthree;
    UILabel* Lfour;

    NSArray* array;
    UIImageView* backView;
}
@property (nonatomic,assign) int state;

-(void)setViews;
-(void)checkUpdate;
-(void)requestWelcomeAndShow;
@end
