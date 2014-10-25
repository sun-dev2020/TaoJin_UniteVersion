//
//  CompressImage.m
//  91WashGold
//
//  Created by keyrun on 13-12-7.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "CompressImage.h"

@implementation CompressImage
+(UIImage* )imageWithOldImage:(UIImage*)image scaledToSize:(CGSize )size{
//    float scale = [[UIScreen mainScreen] scale];
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    return newImage;
}

/**
 *  先收缩图片后对图片进行高度裁剪
 *
 *  @param image 原始图片
 *  @param size  组件的大小
 *
 */
+(UIImage *)imageWithCutImage:(UIImage *)image moduleSize:(CGSize)size{
    float scale = [[UIScreen mainScreen] scale];
    if(image.size.width < size.width && image.size.height < size.height)
        return image;
    
    float newHeight = 0.0f;
    float newWidth = 0.0f;
    //先判断收缩后是以宽为主还是以高为主
    if((image.size.height/2 - size.height/2) > (image.size.width/2 - size.width/2)){
        //先获取收缩到组件宽度后图片的高度
        newHeight = size.width/image.size.width * image.size.height;
        newWidth = size.width ;
    }else{
        //先获取收缩到组件高度后图片的宽度
        newHeight = size.height ;
        newWidth = size.height/image.size.height * image.size.width;
    }
    CGSize newSize = CGSizeMake(newWidth , newHeight );
    //按计算后的大小进行收缩
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"newImage.frame = (%f, %f)",newImage.size.width, newImage.size.height);
    if(newImage.size.height < size.height || newImage.size.width < size.width)
        return newImage;
    
    //如果收缩后的图片高度大于组件的高度或收缩后的图片宽度大于组件的宽度，取中间部分
    CGImageRef imageRef = newImage.CGImage;
    CGRect rect = CGRectMake(newImage.size.width/2 - size.width/2, newImage.size.height/2 - size.height/2, size.width * scale, size.height * scale );
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(imageRef,rect);
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageRef scale:image.scale orientation:UIImageOrientationUp];
//    UIImage *cutImage = [[UIImage alloc] initWithCGImage:cutImageRef];
    
    return cutImage;
}
@end







