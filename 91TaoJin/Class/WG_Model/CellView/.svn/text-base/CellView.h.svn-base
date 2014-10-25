//
//  CellView.h
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView
{
    UIImageView* cellImage;
    UILabel* _cellTitle;
    UIButton* forwardBtn;
    UIButton* button;
    UIImageView* nextImage;
    UIImageView* _bkimage;
    UIImageView* coinImage;
    UILabel* coinLabel;
    UILabel* messageLabel;
    UIImageView* messageTip;
    UIImageView* _hotImage;
}
@property(nonatomic,strong)UIImageView* hotImage;
@property(nonatomic,strong)UILabel* messageLabel;
@property(nonatomic,strong) UIImageView* bkimage;
@property(nonatomic,strong)UILabel* cellTitle;
-(void)setCellViewByType:(int )type andWithImage:(UIImage*)image andCellTitle:(NSString* )title;
-(void)setImageFrame:(CGRect )imageFrame andTitleFrame:(CGRect)titleFrame ;
-(void)setButtonFrame:(CGRect)buttonFrame;
-(void)showCellCoinDetails:(id)coin withIncomeType:(int)type;
-(void)showCellMessageTip:(int)number;

-(void)setTitleLabFont:(float)size andTitleColor:(UIColor *)color;
@end
