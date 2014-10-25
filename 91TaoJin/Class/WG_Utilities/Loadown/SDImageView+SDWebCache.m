//
//  UIImageView+SDWebCache.m
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDImageView+SDWebCache.h"
#import "CustomObject.h"
#import "CompressImage.h"
#import <QuartzCore/QuartzCore.h>

static ImageLoadingFinishBlock _imageLoadingFinish;

@implementation UIImageView(SDWebCacheCategory)

- (void)setImageWithURL:(NSURL *)url
{

	[self setImageWithURL:url refreshCache:NO];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache
{
	[self setImageWithURL:url refreshCache:refreshCache placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url refreshCache:refreshCache needSetViewContentMode:true needBgColor:true placeholderImage:placeholder];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder withImageSize:(CGSize)imageSize {
    [self setImageWithURL:url refreshCache:refreshCache needSetViewContentMode:true needBgColor:true placeholderImage:placeholder withImageSize:imageSize];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder;
{
    [self setImageWithURL:url refreshCache:refreshCache needSetViewContentMode:true needBgColor:needBgColor placeholderImage:placeholder];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url refreshCache:refreshCache needSetViewContentMode:needMode needBgColor:needBgColor placeholderImage:placeholder withImageSize:CGSizeZero];
    
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder imageLoadingFinish:(ImageLoadingFinishBlock)imageLoadingFinish{
    [self setImageWithURL:url refreshCache:refreshCache needSetViewContentMode:needMode needBgColor:needBgColor placeholderImage:placeholder withImageSize:CGSizeZero imageLoadingFinish:imageLoadingFinish];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder withImageSize:(CGSize)imageSize imageLoadingFinish:(ImageLoadingFinishBlock)imageLoadingFinish{
    // Remove in progress downloader from queue
    
    
    // [BY :GY] 优化等待缺省图片的静候显示效果，加入区域底色、图片获取完成后的加载变换效果。
    self.image = placeholder;
    if (!CGSizeEqualToSize(CGSizeZero, imageSize)) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, imageSize.width, imageSize.height)];
    }
    if (needBgColor) {
        float _color = 230.0/255.0;
        [self setBackgroundColor:[UIColor colorWithRed:_color green:_color blue:_color alpha:1.0]];
    }
    [self setClearsContextBeforeDrawing:YES];
    if (needMode) {
        [self setContentStretch:CGRectMake(0.3, 0.3, 0.4, 0.4)];
        [self setContentMode:UIViewContentModeCenter];
    }
    
    if (![url isEqual:@""])
    {
        if ([[CustomObject sharedCustomObject] isExistImage:url]) {
            if (needMode) {
                [self setContentStretch:CGRectMake(0.0, 0.0, 1, 1)];
                [self setContentMode:UIViewContentModeScaleAspectFill];
            }
            self.image = [[CustomObject sharedCustomObject]getImage:url];
            _imageLoadingFinish = [imageLoadingFinish copy];
            _imageLoadingFinish();
        }
        else{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc]initWithData:data];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[CustomObject sharedCustomObject] addImage:image key:url];
                        
                        // 添加渐变效果
                        CATransition *animation = [CATransition animation];
                        animation.delegate = self;
                        animation.duration = 0.3 ;  // 动画持续时间(秒)
                        animation.timingFunction = UIViewAnimationCurveEaseInOut;
                        animation.type = kCATransitionFade;//淡入淡出效果
                        
                        [self.layer addAnimation:animation forKey:nil];
                        if (needMode) {
                            [self setContentStretch:CGRectMake(0.0, 0.0, 1, 1)];
                            [self setContentMode:UIViewContentModeScaleAspectFill];
                        }
                        self.image = image;
                        _imageLoadingFinish = [imageLoadingFinish copy];
                        _imageLoadingFinish();
                    });
                }
            });
        }
    }
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder withImageSize:(CGSize)imageSize {
    // Remove in progress downloader from queue
    
    // [BY :GY] 优化等待缺省图片的静候显示效果，加入区域底色、图片获取完成后的加载变换效果。
    self.image = placeholder;
    if (!CGSizeEqualToSize(CGSizeZero, imageSize)) {
        if(imageSize.width < self.image.size.width || imageSize.height < self.image.size.height)
            self.image = [self imageByScalingToSize:CGSizeMake(imageSize.width, imageSize.height) sourceImage:placeholder];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, imageSize.width, imageSize.height)];
    }
    if (needBgColor) {
        [self setBackgroundColor:kImageBackgound2_0];
    }
    [self setClearsContextBeforeDrawing:YES];
    if (needMode) {
        [self setContentStretch:CGRectMake(0.3, 0.3, 0.4, 0.4)];
        [self setContentMode:UIViewContentModeCenter];
    }
    
    if (![url isEqual:@""])
    {
        if ([[CustomObject sharedCustomObject] isExistImage:url]) {
            if (needMode) {
                [self setContentStretch:CGRectMake(0.0, 0.0, 1, 1)];
                [self setContentMode:UIViewContentModeScaleToFill];
            }
            self.image = [[CustomObject sharedCustomObject]getImage:url];
            [self setBackgroundColor:[UIColor clearColor]];
            //            self.image = [self imageByScalingToSize:CGSizeMake(imageSize.width, imageSize.height) sourceImage:[[CustomObject sharedCustomObject]getImage:url]];
        }
        else{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc]initWithData:data];
                
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[CustomObject sharedCustomObject] addImage:image key:url];
                        
                        // 添加渐变效果
                        CATransition *animation = [CATransition animation];
                        animation.delegate = self;
                        animation.duration = 0.3 ;  // 动画持续时间(秒)
                        animation.timingFunction = UIViewAnimationCurveEaseInOut;
                        animation.type = kCATransitionFade;//淡入淡出效果
                        
                        [self.layer addAnimation:animation forKey:nil];
                        if (needMode) {
                            [self setContentStretch:CGRectMake(0.0, 0.0, 1, 1)];
                            [self setContentMode:UIViewContentModeScaleToFill];
                        }
                        self.image = image;
                        [self setBackgroundColor:[UIColor clearColor]];
                    });
                }
            });
        }
    }
}

/**
 *  裁剪图片后显示
 *
 */
- (void)setCutImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder withImageSize:(CGSize)imageSize {
    // Remove in progress downloader from queue
    
    // [BY :GY] 优化等待缺省图片的静候显示效果，加入区域底色、图片获取完成后的加载变换效果。
    self.image = placeholder;
    if (!CGSizeEqualToSize(CGSizeZero, imageSize)) {
        if(imageSize.width < self.image.size.width || imageSize.height < self.image.size.height)
            self.image = [self imageByScalingToSize:CGSizeMake(imageSize.width, imageSize.height) sourceImage:placeholder];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, imageSize.width, imageSize.height)];
    }
    if (needBgColor) {
        [self setBackgroundColor:kImageBackgound2_0];
    }
    [self setClearsContextBeforeDrawing:YES];
    if (needMode) {
        [self setContentStretch:CGRectMake(0.3, 0.3, 0.4, 0.4)];
        [self setContentMode:UIViewContentModeCenter];
    }

    if (![url isEqual:@""])
    {
        if ([[CustomObject sharedCustomObject] isExistImage:url]) {
            if (needMode) {
                [self setContentStretch:CGRectMake(0.0, 0.0, 1, 1)];
                [self setContentMode:UIViewContentModeScaleToFill];
            }
            
            self.image = [[CustomObject sharedCustomObject] getImage:url];
            [self setBackgroundColor:[UIColor clearColor]];
//            self.image = [self imageByScalingToSize:CGSizeMake(imageSize.width, imageSize.height) sourceImage:[[CustomObject sharedCustomObject]getImage:url]];
        }
        else{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc]initWithData:data];
                
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        // 添加渐变效果
                        CATransition *animation = [CATransition animation];
                        animation.delegate = self;
                        animation.duration = 0.3 ;  // 动画持续时间(秒)
                        animation.timingFunction = UIViewAnimationCurveEaseInOut;
                        animation.type = kCATransitionFade;//淡入淡出效果
                        
                        [self.layer addAnimation:animation forKey:nil];
                        if (needMode) {
                            [self setContentStretch:CGRectMake(0.0, 0.0, 1, 1)];
                            [self setContentMode:UIViewContentModeScaleToFill];
                        }
                        NSLog(@"image.size.width = %f",image.size.width);
                        NSLog(@"image.size.height = %f",image.size.height);
                        NSLog(@"imageSize.width = %f",imageSize.width);
                        NSLog(@"imageSize.height = %f",imageSize.height);
                        UIImage *newImage = [CompressImage imageWithCutImage:image moduleSize:imageSize];
                        self.image = newImage;
                        [[CustomObject sharedCustomObject] addImage:newImage key:url];
                        [self setBackgroundColor:[UIColor clearColor]];
                    });
                }
            });
        }
    }
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}
@end
