//
//  Scratch.m
//  91TaoJin
//
//  Created by keyrun on 14-5-23.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "Scratch.h"

@interface  Scratch(){
    char *_data;
}

@end

@implementation Scratch

- (id)initWithMaxX:(size_t)x MaxY:(size_t)y {
	if (self = [super init]) {
		_data = (char *) malloc(x * y);
		_max = MDSizeMake(x, y);
		[self fillWithValue:0];
	}
	return self;
}

- (id)initWithMax:(MDSize) maxCoords {
	return [self initWithMaxX:maxCoords.x MaxY:maxCoords.y];
}

#pragma mark -

- (char)valueForCoordinates:(size_t)x y:(size_t)y {
    long index = x + self.max.x * y;
    if (index >= self.max.x * self.max.y){
        return 1; //NSAssert(0, @"I should not to be here! :( ");
    } else {
		return _data[x + self.max.x * y];
	}
}

- (void)setValue:(char)value forCoordinates:(size_t)x y:(size_t)y {
    long index = x + self.max.x * y;
    if (index < self.max.x * self.max.y){
		_data[x + self.max.x * y] = value;
    }
}

- (void)fillWithValue:(char)value {
	char *temp = _data;
	for(size_t i = 0; i < self.max.x * self.max.y; ++i){
		*temp = value;
		++temp;
	}
}

#pragma mark -

- (void)dealloc {
	if(_data){
		free(_data);
	}
#if !(__has_feature(objc_arc))
	[super dealloc];
#endif
}

@end
