//
//  TjAlertView.m
//  91TaoJin
//
//  Created by keyrun on 14-3-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TjAlertView.h"

@implementation TjAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate =self;
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.tjAlertViewDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
}

@end
