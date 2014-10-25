//
//  SerialAnimationQueue.m
//  91TaoJin
//
//  Created by keyrun on 14-5-9.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "SerialAnimationQueue.h"

@implementation SerialAnimationQueue

- (id)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)animateWithDurationBlock:(NSTimeInterval)duration delayBlock:(NSTimeInterval(^)())delayBlock options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    [self performAnimationsSerially:^{
        NSTimeInterval delay = delayBlock();
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:^(BOOL finished) {
            [self runCompletionBlock:completion animationDidFinish:finished];
        }];
    }];
}

- (void)animateWithDurationBlock:(NSTimeInterval)duration delayBlock:(NSTimeInterval(^)(BOOL *isStopRun))delayBlock isStopRun:(BOOL *)isStopRun options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    [self performAnimationsSerially:^{
        NSTimeInterval delay = delayBlock(isStopRun);
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:^(BOOL finished) {
            [self runCompletionBlock:completion animationDidFinish:finished];
        }];
    }];
}

- (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [self performAnimationsSerially:^{
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:^(BOOL finished) {
            [self runCompletionBlock:completion animationDidFinish:finished];
        }];
    }];
}

- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [self performAnimationsSerially:^{
        [UIView animateWithDuration:duration animations:animations completion:^(BOOL finished) {
            [self runCompletionBlock:completion animationDidFinish:finished];
        }];
    }];
}

- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations {
    [self performAnimationsSerially:^{
        [UIView animateWithDuration:duration animations:animations completion:^(BOOL finished) {
            [self runCompletionBlock:nil animationDidFinish:YES];
        }];
    }];
}

- (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [self performAnimationsSerially:^{
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity
                            options:options animations:animations completion:^(BOOL finished) {
                                [self runCompletionBlock:completion animationDidFinish:finished];
                            }];
    }];
}

- (void)performAnimationsSerially:(void (^)(void))animation {
    dispatch_async(self.queue, ^{
        self.semaphore = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), animation);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    });
}

- (void)runCompletionBlock:(void (^)(BOOL finished))completion animationDidFinish:(BOOL)finished {
    if (completion) {
        completion(finished);
    }
    dispatch_semaphore_signal(self.semaphore);
}

@end
