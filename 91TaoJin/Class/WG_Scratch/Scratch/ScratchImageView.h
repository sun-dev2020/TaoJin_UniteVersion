//
//  ScratchImageView.h
//  91TaoJin
//
//  Created by keyrun on 14-5-23.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScratchImageView;
@protocol ScratchImageViewDelegate
@required
- (void)mdScratchImageView:(ScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress;
@end

@interface ScratchImageView : UIImageView

//@property (nonatomic, strong) BOOL                              isCanSc
@property (nonatomic, readonly) CGFloat							maskingProgress;
@property (nonatomic, assign) id<ScratchImageViewDelegate>      delegate;
@property (nonatomic, assign) BOOL                              isCanScratch;                       //判断是否能够刮彩

- (void)setImage:(UIImage *)image radius:(size_t)radius;

@end
