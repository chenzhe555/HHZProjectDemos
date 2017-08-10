//
//  HHZGCDViewController.m
//  HHZProjectDemos
//
//  Created by 仁和Mac on 2017/8/10.
//  Copyright © 2017年 陈哲是个好孩子. All rights reserved.
//

#import "HHZGCDViewController.h"

@interface HHZGCDViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * dataArray;
@end

@implementation HHZGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = @[@"同步执行+串行队列",@"同步执行+并行队列",@"异步执行+串行队列",@"异步执行+并行队列",@"主线程上同步执行(死锁)",@"主线程上异步执行",@"dispatch_get_global_queue",@"dispatch_after"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 生成串行／并行队列
-(dispatch_queue_t)generateQueue:(BOOL)isConcurrent
{
    //第一次参数是标志符,第二个参数：DISPATCH_QUEUE_CONCURRENT(并行队列)  DISPATCH_QUEUE_SERIAL(串行队列)
    if (isConcurrent)
    {
        return dispatch_queue_create("asyncParallel.chenzhe.com", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return dispatch_queue_create("syncParallel.chenzhe.com", DISPATCH_QUEUE_SERIAL);
}

#pragma mark 同步执行
-(void)startSync:(dispatch_queue_t)queue
{
    NSLog(@"startSync__Start:(%@)",[NSThread mainThread]);
    
    //异步执行
    dispatch_sync(queue, ^{
        for (NSUInteger i = 0; i < 1000000000; ++i)
        {
            
        }
        NSLog(@"同步1任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 1000; ++i)
        {
            
        }
        NSLog(@"同步2任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; ++i)
        {
            
        }
        NSLog(@"同步3任务完成:(%@)",[NSThread currentThread]);
    });
    
    
    NSLog(@"startSync__End:(%@)",[NSThread mainThread]);
    
}

#pragma mark 异步执行
-(void)startAsync:(dispatch_queue_t)queue
{
    NSLog(@"startAsync__Start:(%@)",[NSThread mainThread]);
    
    //异步执行
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 1000000000; ++i)
        {
            
        }
        NSLog(@"异步1任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 1000; ++i)
        {
            
        }
        NSLog(@"异步2任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; ++i)
        {
            
        }
        NSLog(@"异步3任务完成:(%@)",[NSThread currentThread]);
    });
    
    NSLog(@"startAsync__End:(%@)",[NSThread mainThread]);
}


#pragma mark UITableView回调事件
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self syncMixedSerial];
        }
            break;
        case 1:
        {
            [self syncMixedParallel];
        }
            break;
        case 2:
        {
            [self asyncMixedSerial];
        }
            break;
        case 3:
        {
            [self asyncMixedParallel];
        }
            break;
        case 4:
        {
            [self serailOnMainThread];
        }
            break;
        case 5:
        {
            [self parallelOnMainThread];
        }
            break;
        case 6:
        {
            [self testGetGlobal];
        }
            break;
        case 7:
        {
            [self testAfter];
        }
            break;
        default:
        {
            [self test];
        }
            break;
    }
}


#pragma mark ----------------------------Methods
-(void)test
{
    
}


- (void)syncMixedSerial
{
    //创建串行队列
    dispatch_queue_t queue = [self generateQueue:YES];
    
    //同步执行
    [self startSync:queue];
}

- (void)syncMixedParallel
{
    //创建并行队列
    dispatch_queue_t queue = [self generateQueue:YES];
    
    //同步执行
    [self startSync:queue];
}


- (void)asyncMixedSerial
{
    //创建串行队列
    dispatch_queue_t queue = [self generateQueue:NO];
    
    //异步执行
    [self startAsync:queue];
}

- (void)asyncMixedParallel
{
    //创建并行队列
    dispatch_queue_t queue = [self generateQueue:YES];
    
    //异步执行
    [self startAsync:queue];
}


#pragma mark 主线程上执行
- (void)serailOnMainThread
{
    //主线程
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //同步执行
    [self startSync:queue];
}

- (void)parallelOnMainThread
{
    //主线程
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //异步执行
    [self startAsync:queue];
}

#pragma mark dispatch_get_global_queue
-(void)testGetGlobal
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    [self startAsync:queue];
}

-(void)testAfter
{
    //表示从什么时候开始,NSEC_PER_SEC以秒为计算单位,NSEC_PER_MSEC以毫秒为计算单位,USEC_PER_SEC以微秒为计算单位,NSEC_PER_USEC以纳秒为计算单位
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_USEC);
    
    //在主线程执行
    dispatch_queue_t queue = dispatch_get_main_queue();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    NSLog(@"%@__Start__Thread:(%@)",NSStringFromSelector(_cmd),[NSThread currentThread]);
    dispatch_after(time, queue, ^{
        NSLog(@"%@__End__Thread:(%@)",NSStringFromSelector(_cmd),[NSThread currentThread]);
    });
}

@end
