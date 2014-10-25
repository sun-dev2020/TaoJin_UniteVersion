//
//  WelcomeViewController.m
//  91淘金
//
//  Created by keyrun on 14-7-10.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIImage+ColorChangeTo.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *welcomeView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    if (IOS_Version < 7.0) {
        welcomeView.frame =CGRectMake(0, -20, kmainScreenWidth, kmainScreenHeigh);
    }
    UIImage *bgImage ;
    NSLog(@" deceive Height %f %d",kmainScreenHeigh ,kIsRetinaDevice);
    if (kmainScreenHeigh > 480.0f) {
        bgImage =GetImage(@"Default-568h@2x");
    }else{
        if (kIsRetinaDevice) {
            bgImage =GetImage(@"Default@2x");
        }else{
        bgImage =GetImage(@"Default.png");
        }
    }
    [welcomeView setImage:bgImage];
    [self.view addSubview:welcomeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
