//
//  PhotoItemCell.m
//  91TaoJin
//
//  Created by keyrun on 14-6-18.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "PhotoItemCell.h"

@implementation PhotoItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.imgView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
