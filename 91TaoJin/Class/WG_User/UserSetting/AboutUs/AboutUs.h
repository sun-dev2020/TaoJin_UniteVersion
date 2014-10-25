//
//  AboutUs.h
//  TJiphone
//
//  Created by keyrun on 13-10-8.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAboutUs @"关于我们"
#define kGameName  @"91淘金"
#define kGameVersion @"版本号：2.0.0"
@interface AboutUs : UIViewController <UITableViewDelegate ,UITableViewDataSource ,UIGestureRecognizerDelegate>
{
    NSMutableArray* array;
    UIImageView* topImage;
    UIImageView* bottomImage;
}
@end
