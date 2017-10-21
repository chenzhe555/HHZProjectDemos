//
//  HHZMethodSignViewController.m
//  HHZProjectDemos
//
//  Created by 仁和Mac on 2017/10/7.
//  Copyright © 2017年 陈哲是个好孩子. All rights reserved.
//

#import "HHZMethodSignViewController.h"

static NSString * value;

@interface HHZMethodSignViewController ()

@end

@implementation HHZMethodSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreArgs:(id)sender
{
    SEL method = @selector(evaluateMoreArg:arg2:arg3:arg4:arg5:);
    //获取方法签名
    NSMethodSignature * sign = [[self class] instanceMethodSignatureForSelector:method];
    
    //签名初始化获取invocation
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sign];
    
    //设置Selector
    [invocation setSelector:method];
    
    //添加参数,Index从2开始,因为前两个被selector和target占用
    NSInteger count = 1;
    NSNumber * num = @(2);
    NSString * str = @"3";
    NSArray * arr = @[@(4),@"5"];
    UIView * vie = [UIView new];
    vie.frame = CGRectMake(1, 2, 3, 4);
    
    [invocation setArgument:&count atIndex:2];
    [invocation setArgument:&num atIndex:3];
    [invocation setArgument:&str atIndex:4];
    [invocation setArgument:&arr atIndex:5];
    [invocation setArgument:&vie atIndex:6];
    
    //消息调用
    [invocation invokeWithTarget:self];
    
    //获取返回值
    [invocation getReturnValue:&value];
    NSLog(@"6.返回值:%@",value);
}

-(NSString *)evaluateMoreArg:(NSInteger)count arg2:(NSNumber *)num arg3:(NSString *)str arg4:(NSArray *)arr arg5:(UIView *)vie
{
    NSLog(@"1.%ld",(long)count);
    NSLog(@"2.%@",num);
    NSLog(@"3.%@",str);
    NSLog(@"4.%@-%@",arr[0],arr[1]);
    NSLog(@"5.%@",vie);
    return @"qwertyuiop";
}

@end
