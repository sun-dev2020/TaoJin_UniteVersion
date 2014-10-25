//
//  CommentViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-5-19.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MScrollVIew.h"
typedef enum {
    CommentTypeAsk =0,       //提问
    CommentTypePinLun =1,    // 评论活动
    CommentTypeShow          // 晒单
//    CommentTypePLShow          // 评论晒单
}CommentType;

@protocol ReloadViewDelegate <NSObject>

-(void)reloadView:(id)object;

@end

@interface CommentViewController : UIViewController <UITextViewDelegate ,UIActionSheetDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MScrollVIewDelegate>

@property (nonatomic ,assign) CommentType commentType;
@property (nonatomic ,strong) NSString *topicId ;

@property (nonatomic ,assign) int showGoldOne ;
@property (nonatomic ,assign) int showGoldTwo ;

@property (nonatomic, strong) id<ReloadViewDelegate> delegate;
@end
