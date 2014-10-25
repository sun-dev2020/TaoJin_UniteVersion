//
//  PhotoViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-6-18.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetHelper.h"
@protocol PhotoViewControllerDelegate <NSObject>

-(void)getImageFromLocation:(UIImage *)image;

@end

@interface PhotoViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) id <PhotoViewControllerDelegate> pvDelegate;
@property (nonatomic ,strong) NSArray *photoArray ;
@end

