//
//  SerialAnimationQueue.h
//  91TaoJin
//
//  Created by keyrun on 14-5-9.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerialAnimationQueue : NSObject

@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) dispatch_semaphore_t semaphore;

- (void)animateWithDurationBlock:(NSTimeInterval)duration delayBlock:(NSTimeInterval(^)())delayBlock options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

- (void)animateWithDurationBlock:(NSTimeInterval)duration delayBlock:(NSTimeInterval(^)(BOOL *isStopRun))delayBlock isStopRun:(BOOL *)isStopRun options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

- (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options
                 animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion;

- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;

- (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio
      initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
@end
