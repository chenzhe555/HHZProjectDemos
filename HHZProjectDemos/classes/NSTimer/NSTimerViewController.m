//
//  NSTimerViewController.m
//  HHZProjectDemos
//
//  Created by 仁和Mac on 2017/8/9.
//  Copyright © 2017年 陈哲是个好孩子. All rights reserved.
//

#import "NSTimerViewController.h"
#import "NSTimer+Reference.h"

@interface NSTimerViewController ()
@property (nonatomic, strong) NSTimer * test1Timer;
@property (nonatomic, strong) NSTimer * test2Timer;
@property (nonatomic, strong) dispatch_source_t gcdTimer;

@property (nonatomic, copy) NSString * testString;

@end

@implementation NSTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)test1:(id)sender
{
    self.test1Timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(test1Function) userInfo:nil repeats:YES];
}

- (IBAction)test2:(id)sender
{
    __weak typeof(self) weakSelf = self;
    self.test2Timer = [NSTimer hhz_scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer) {
        NSLog(@"test2Timer方法执行( %@ )",NSStringFromSelector(_cmd));
        weakSelf.testString = @"chenzhe";
    }];
}
- (IBAction)testGCD:(id)sender
{
    //获取当前主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //创建GCD定时器
    self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置开始时间和时间间隔
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    uint64_t interval = 0.5 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.gcdTimer, start, interval, 0);
    
    //设置定时器回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        NSLog(@"gcdTimer方法执行( %@ )",NSStringFromSelector(_cmd));
        weakSelf.testString = @"chenzhe";
    });
    
    //运行定时器
    dispatch_resume(self.gcdTimer);
    
}

-(void)test1Function
{
    NSLog(@"test1Timer方法执行( %@ )",NSStringFromSelector(_cmd));
}

-(void)dealloc
{
    NSLog(@"NSTimerViewController---(dealloc)");
    [self.test1Timer invalidate];
    [self.test2Timer invalidate];
    self.gcdTimer = nil;
}


@end
