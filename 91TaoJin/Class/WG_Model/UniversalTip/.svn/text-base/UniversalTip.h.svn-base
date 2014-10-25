//
//  UniversalTip.h
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UniversalTip : UIView{
}
@property (nonatomic ,strong) UIImageView *tipImage ;
@property (nonatomic ,strong) UILabel *tipTitle ;
@property (nonatomic, strong) NSMutableArray *heightArray;

-(id)initWithFrame:(CGRect)frame andTips:(NSArray *)tips andTipBackgrundColor:(UIColor *)tintColor withTipFont:(UIFont *)font andTipImage:(UIImage *)image andTipTitle:(NSString *)title andTextColor:(UIColor *)textColor;

-(void)uploadTipContent:(NSArray *)array andFont:(UIFont *)font andTextColor:(UIColor *)color needAdjustPosition:(BOOL)isNeed;
-(float)getLabelWidth;

@end
