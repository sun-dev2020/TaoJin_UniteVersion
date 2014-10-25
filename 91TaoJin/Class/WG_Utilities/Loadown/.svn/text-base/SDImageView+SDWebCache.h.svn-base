//
//  UIImageView+SDWebCache.h
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageLoadingFinishBlock)();

@interface UIImageView(SDWebCacheCategory){
    
}


- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache;
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder withImageSize:(CGSize)imageSize;

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder withImageSize:(CGSize)imageSize;

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder imageLoadingFinish:(ImageLoadingFinishBlock)imageLoadingFinish;

- (void)setCutImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache needSetViewContentMode:(BOOL)needMode needBgColor:(BOOL)needBgColor placeholderImage:(UIImage *)placeholder withImageSize:(CGSize)imageSize;
@end
