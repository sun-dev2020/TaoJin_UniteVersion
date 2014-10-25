//
//  PhotoViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-6-18.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "PhotoViewController.h"
#import "HeadToolBar.h"
#import "PhotoItemCell.h"
#import "SortModule.h"
#import "MyUserDefault.h"
#import "ViewTip.h"
#define kIpadScale 0.75
#define kItemSize 98
#define kPhotoDate
@interface PhotoViewController ()
{
    HeadToolBar *headBar ;
    NSMutableArray *allPhotoUrl ;   // 相片路径
    
    int count;
}
@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)onClickedGoBackBtn{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    headBar =[[HeadToolBar alloc] initWithTitle:@"选择截图" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightBtnTitle:nil rightBtnImg:nil rightBtnHighlightedImg:nil backgroundColor:KOrangeColor2_0];
    [headBar.leftBtn addTarget:self action:@selector(onClickedGoBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing =0;
    layout.sectionInset =UIEdgeInsetsMake(kHeadViewHeigh +4* kOffX_float , kOffX_float, kOffX_float, 6);
    self.collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height) collectionViewLayout:layout];
    [self.collectionView registerClass:[PhotoItemCell class] forCellWithReuseIdentifier:@"collectCell"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:headBar];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self initObjects];
    [self getUserLocationPhoto];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kItemSize, kItemSize);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [ASSETHELPER getPhotoCountOfCurrentGroup];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"collectCell";
    PhotoItemCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell =[[PhotoItemCell alloc] initWithFrame:CGRectMake(0, 0, kItemSize, kItemSize)];
    }
    cell.imgView.image =[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_THUMBNAIL];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.pvDelegate getImageFromLocation:[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_FULL_RESOLUTION]];
    [self onClickedGoBackBtn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initObjects{
    allPhotoUrl =[[NSMutableArray alloc] init];
}


-(void)getUserLocationPhoto{
    [ASSETHELPER getSavedPhotoList:^(NSArray *photos) {
        [self.collectionView reloadData];
        
    } error:^(NSError *error) {
        if ([ASSETHELPER getPhotoCountOfCurrentGroup] ==0) {
            [self showTip];
        }
    }];
    
}
-(void)showTip{
    ViewTip* tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, headBar.frame.origin.y+ headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh)];
    [tip setViewTipByImage:[UIImage imageNamed:@"a3.png"]];
    [tip setViewTipByContent:@"通过：设置-隐私-照片\n打开91淘金选项，才能显示截图"];
    [self.view insertSubview:tip belowSubview:headBar];
}

-(void)updateCollection{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
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
