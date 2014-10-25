//
//  CompressImage.h
//  91WashGold
//
//  Created by keyrun on 13-12-7.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompressImage : NSObject

+(UIImage* )imageWithOldImage:(UIImage*)image scaledToSize:(CGSize )size;

/**
 *  先收缩图片后对图片进行高度裁剪
 *
 *  @param image 原始图片
 *  @param size  组件的大小
 *
 */
+(UIImage *)imageWithCutImage:(UIImage *)image moduleSize:(CGSize)size;
@end
