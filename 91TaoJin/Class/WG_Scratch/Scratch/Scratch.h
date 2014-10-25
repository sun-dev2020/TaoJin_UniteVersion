//
//  Scratch.h
//  91TaoJin
//
//  Created by keyrun on 14-5-23.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
	size_t x;
	size_t y;
} MDSize;

MDSize MDSizeMake(size_t x,size_t y){
	MDSize r = {x,y};
	return r;
}

@interface Scratch : NSObject

-(id)initWithMaxX:(size_t)x MaxY:(size_t)y;
-(id)initWithMax:(MDSize) maxCoords;

-(char)valueForCoordinates:(size_t)x y:(size_t)y;
-(void)setValue:(char)value forCoordinates:(size_t)x y:(size_t)y;

-(void)fillWithValue:(char)value;

@property (readonly, assign) MDSize			max;

@end
