//
//  TjAlertView.h
//  91TaoJin
//
//  Created by keyrun on 14-3-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TjAlertViewDelegate <NSObject>

@optional
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@interface TjAlertView : UIAlertView


@property (nonatomic,strong) id <TjAlertViewDelegate> tjAlertViewDelegate;
@end
