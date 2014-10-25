//
//  MScrollVIew.h
//  TJiphone
//
//  Created by keyrun on 13-10-16.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MScrollVIewDelegate <NSObject>;
@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
@end

@interface MScrollVIew : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,strong)id<MScrollVIewDelegate> msDelegate;

- (id)initWithFrame:(CGRect)frame andWithPageCount:(int)count backgroundImg:(UIImageView *)backgroundImg;

@end
