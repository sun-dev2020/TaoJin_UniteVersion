//
//  ScratchImageView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-23.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ScratchImageView.h"
#import "Scratch.h"

const size_t MDScratchImageViewDefaultRadius			= 10;

typedef void (*FillTileWithPointFunc)( id, SEL, CGPoint );
typedef void (*FillTileWithTwoPointsFunc)(id, SEL, CGPoint, CGPoint);

inline CGPoint fromUItoQuartz(CGPoint point, CGSize frameSize){
	point.y = frameSize.height - point.y;
	return point;
}

inline CGPoint scalePoint(CGPoint point, CGSize previousSize, CGSize currentSize){
	return CGPointMake(currentSize.width * point.x / previousSize.width, currentSize.height * point.y / previousSize.height);
}

@interface ScratchImageView () {
	size_t				_tilesX;
	size_t				_tilesY;
	int					_tilesFilled;
	CGColorSpaceRef		_colorSpace;
	CGContextRef		_imageContext;
	
	size_t				_radius;
    
}

@property (nonatomic, strong) Scratch			*maskedMatrix;

- (UIImage *)addTouches:(NSSet *)touches;
- (void)fillTileWithPoint:(CGPoint)point;
- (void)fillTileWithTwoPoints:(CGPoint)begin end:(CGPoint)end;

@end

@implementation ScratchImageView

- (void)dealloc {
	self.maskedMatrix = nil;
	CGColorSpaceRelease(_colorSpace);
	CGContextRelease(_imageContext);
#if !(__has_feature(objc_arc))
	[super dealloc];
#endif
}

#pragma mark - inner initalization

- (void)initialize {
	self.userInteractionEnabled = YES;
	_tilesFilled = 0;
	
	if (nil == self.image) {
		_tilesX = _tilesY = 0;
		self.maskedMatrix = nil;
		if (NULL != _imageContext) {
			CGContextRelease(_imageContext);
		}
		if (NULL != _colorSpace) {
			CGColorSpaceRelease(_colorSpace);
		}
	} else {
		// CGSize size = self.image.size;
		CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
		
		// initalize bitmap context
		if (NULL == _colorSpace) {
			_colorSpace = CGColorSpaceCreateDeviceRGB();
		}
		if (NULL != _imageContext) {
			CGContextRelease(_imageContext);
		}
		_imageContext = CGBitmapContextCreate(0, size.width, size.height, 8, size.width * 4, _colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(_imageContext, CGRectMake(0, 0, size.width, size.height), self.image.CGImage);
		
		int blendMode = kCGBlendModeClear;
		CGContextSetBlendMode(_imageContext, (CGBlendMode) blendMode);
		
		_tilesX = size.width  / (2 * _radius);
		_tilesY = size.height / (2 * _radius);
		
#if !(__has_feature(objc_arc))
		self.maskedMatrix = [[[Scratch alloc] initWithMax:MDSizeMake(_tilesX, _tilesY)] autorelease];
#else
		self.maskedMatrix = [[Scratch alloc] initWithMax:MDSizeMake(_tilesX, _tilesY)];
#endif
	}
}

#pragma mark -

- (void)setImage:(UIImage *)image radius:(size_t)radius {
	[super setImage:image];
	_radius = radius;
	[self initialize];
}

- (void)setImage:(UIImage *)image {
	if (image != self.image) {
		[self setImage:image radius:MDScratchImageViewDefaultRadius];
	}
}

#pragma mark -

- (CGFloat)maskingProgress {
	return ( ((CGFloat)_tilesFilled) / ((CGFloat)(self.maskedMatrix.max.x * self.maskedMatrix.max.y)) );
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super setImage:[self addTouches:touches]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super setImage:[self addTouches:touches]];
}

#pragma mark -

- (UIImage *)addTouches:(NSSet *)touches {
    
    CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
	CGContextRef ctx = _imageContext;
	
	CGContextSetFillColorWithColor(ctx,[UIColor clearColor].CGColor);
	CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
	int tempFilled = _tilesFilled;
	if(self.isCanScratch){
        // process touches
        for (UITouch *touch in touches) {
            CGContextBeginPath(ctx);
            CGPoint touchPoint = [touch locationInView:self];
            CGRect rect = CGRectMake(touchPoint.x, touchPoint.y, 2 * _radius, 2 * _radius);
            rect.origin = fromUItoQuartz(rect.origin, self.bounds.size);
            
            if(UITouchPhaseBegan == touch.phase){
                // on begin, we just draw ellipse
                rect.origin = scalePoint(rect.origin, self.bounds.size, size);
                rect.origin.x -= _radius;
                rect.origin.y -= _radius;
                CGContextAddEllipseInRect(ctx, rect);
                CGContextFillPath(ctx);
                static FillTileWithPointFunc fillTileFunc = nil;
                if(fillTileFunc == nil){
                    fillTileFunc = (FillTileWithPointFunc) [self methodForSelector:@selector(fillTileWithPoint:)];
                }
                (*fillTileFunc)(self,@selector(fillTileWithPoint:),rect.origin);
            } else if (UITouchPhaseMoved == touch.phase) {
                // then touch moved, we draw superior-width line
                rect.origin = scalePoint(rect.origin, self.bounds.size, size);
                CGPoint prevPoint = [touch previousLocationInView:self];
                prevPoint = fromUItoQuartz(prevPoint, self.bounds.size);
                prevPoint = scalePoint(prevPoint, self.bounds.size, size);
                
                CGContextSetStrokeColor(ctx, CGColorGetComponents([UIColor yellowColor].CGColor));
                CGContextSetLineCap(ctx, kCGLineCapRound);
                CGContextSetLineWidth(ctx, 2 * _radius);
                CGContextMoveToPoint(ctx, prevPoint.x, prevPoint.y);
                CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
                CGContextStrokePath(ctx);
                static FillTileWithTwoPointsFunc fillTileFunc = nil;
                if(fillTileFunc == nil){
                    fillTileFunc = (FillTileWithTwoPointsFunc) [self methodForSelector:@selector(fillTileWithTwoPoints:end:)];
                }
                (*fillTileFunc)(self,@selector(fillTileWithTwoPoints:end:),rect.origin, prevPoint);
            }
        }
    }
	// was _tilesFilled changed?
//	if(tempFilled != _tilesFilled) {
		[_delegate mdScratchImageView:self didChangeMaskingProgress:self.maskingProgress];
//	}
	
	CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	return image;
}

/*
 * filling tile with one ellipse
 */
-(void)fillTileWithPoint:(CGPoint) point{
	size_t x,y;
    point.x = MAX( MIN(point.x, self.image.size.width - 1) , 0);
    point.y = MAX( MIN(point.y, self.image.size.height - 1), 0);
	x = point.x * self.maskedMatrix.max.x / self.image.size.width;
	y = point.y * self.maskedMatrix.max.y / self.image.size.height;
	char value = [self.maskedMatrix valueForCoordinates:x y:y];
	if (!value){
		[self.maskedMatrix setValue:1 forCoordinates:x y:y];
		_tilesFilled++;
	}
}

/*
 * filling tile with line
 */
-(void)fillTileWithTwoPoints:(CGPoint)begin end:(CGPoint)end{
	CGFloat incrementerForx,incrementerFory;
    static FillTileWithPointFunc fillTileFunc = nil;
    if(fillTileFunc == nil){
        fillTileFunc = (FillTileWithPointFunc) [self methodForSelector:@selector(fillTileWithPoint:)];
    }
	
	/* incrementers - about size of a tile */
	incrementerForx = (begin.x < end.x ? 1 : -1) * self.image.size.width / _tilesX;
	incrementerFory = (begin.y < end.y ? 1 : -1) * self.image.size.height / _tilesY;
	
	// iterate on points between begin and end
	CGPoint i = begin;
	while(i.x <= end.x && i.y <= end.y){
		(*fillTileFunc)(self,@selector(fillTileWithPoint:),i);
		i.x += incrementerForx;
		i.y += incrementerFory;
	}
	(*fillTileFunc)(self,@selector(fillTileWithPoint:),end);
}


@end










