//
//  NSTimer+Reference.m
//  HHZProjectDemos
//
//  Created by 仁和Mac on 2017/8/9.
//  Copyright © 2017年 陈哲是个好孩子. All rights reserved.
//

#import "NSTimer+Reference.h"

@implementation NSTimer (Reference)
+(NSTimer *)hhz_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block
{
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(hhz_blcokInvoke:) userInfo:[block copy] repeats:repeats];
}

+(void)hhz_blcokInvoke:(NSTimer *)timer
{
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}
@end
