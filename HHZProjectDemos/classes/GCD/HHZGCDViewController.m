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
    _dataArray = @[@"同步执行+串行队列",@"同步执行+并行队列",@"异步执行+串行队列",@"异步执行+并行队列",@"主线程上同步执行(死锁)",@"主线程上异步执行",@"dispatch_get_global_queue",@"dispatch_after",@"dispatch_group",@"dispatch_group_enter/dispatch_group_leave",@"dispatch_apply",@"dispatch_barrier_async",@"dispatch_semaphore_signal",@"test"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)runForOne
{
    for (NSUInteger i = 0; i < 1000000000; ++i)
    {
        
    }
}

-(void)runForTwo
{
    for (int i = 0; i < 1000; ++i)
    {
        
    }
}

-(void)runForThree
{
    for (int i = 0; i < 10; ++i)
    {
        
    }
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
    
    //同步执行
    dispatch_sync(queue, ^{
        [self runForOne];
        NSLog(@"同步1任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        [self runForTwo];
        NSLog(@"同步2任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        [self runForThree];
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
        [self runForOne];
        NSLog(@"异步1任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [self runForTwo];
        NSLog(@"异步2任务完成:(%@)",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [self runForThree];
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
        case 8:
        {
            [self testGroup];
        }
            break;
        case 9:
        {
            [self testGroupEnter];
        }
            break;
        case 10:
        {
            [self testApply];
        }
            break;
        case 11:
        {
            [self testBarrier];
        }
            break;
        case 12:
        {
            [self testSemaphore];
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
    dispatch_queue_t queue = dispatch_queue_create("renhe.chenzhe.com", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"0完成%@",[NSThread currentThread]);
    
    dispatch_async(queue, ^{
        [self runForOne];
        
        NSLog(@"1完成%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        [self runForThree];
        NSLog(@"2完成%@",[NSThread currentThread]);
    });
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

#pragma mark dispatch_group
-(void)testGroup
{
    dispatch_queue_t queue = [self generateQueue:YES];
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"Group主线程:%@",[NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        [self runForOne];
        NSLog(@"Group任务1完成:%@",[NSThread currentThread]);
        
        dispatch_async(queue, ^{
             //如果任务里面还有异步事件，则最后notify不会等待这个任务完成
            [self runForThree];
            NSLog(@"Group任务1(再次异步)完成:%@",[NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            //如果任务里面还有同步事件，则最后notify会等待这个任务完成
            [self runForThree];
            NSLog(@"Group任务1(再次同步)完成:%@",[NSThread currentThread]);
        });
    });
    
    dispatch_group_async(group, queue, ^{
        [self runForOne];
        NSLog(@"Group任务2完成:%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        [self runForOne];
        NSLog(@"Group任务3完成:%@",[NSThread currentThread]);
    });
    
    //Group里面的任务完成后，调用notify处理逻辑。notify等任务里面所有的同步任务完成之后调用，如果任务中有异步线程，则不会等线程中任务完成才调用。
    dispatch_group_notify(group, queue, ^{
        NSLog(@"Group任务都完成了");
    });
}

-(void)testGroupEnter
{
    dispatch_queue_t queue = [self generateQueue:YES];
    dispatch_group_t group = dispatch_group_create();
    
    
    dispatch_group_enter(group);
    NSLog(@"Group主线程:%@",[NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        [self runForOne];
        NSLog(@"Group任务1完成:%@",[NSThread currentThread]);
        
        dispatch_async(queue, ^{
            //dispatch_group_enter和dispatch_group_leave必须成对出现，leave的情况下才算当前任务结束
            [self runForOne];
            NSLog(@"Group任务1(再次异步)完成:%@",[NSThread currentThread]);
            
            dispatch_group_leave(group);
        });
        
        dispatch_sync(queue, ^{
            [self runForThree];
            NSLog(@"Group任务1(再次同步)完成:%@",[NSThread currentThread]);
        });
    });
    
    dispatch_group_async(group, queue, ^{
        [self runForOne];
        NSLog(@"Group任务2完成:%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        [self runForOne];
        NSLog(@"Group任务3完成:%@",[NSThread currentThread]);
    });
    
    //Group里面的任务完成后，调用notify处理逻辑。notify等任务里面所有的同步任务完成之后调用，如果任务中有异步线程，则不会等线程中任务完成才调用。
    dispatch_group_notify(group, queue, ^{
        NSLog(@"Group任务都完成了");
    });
}

-(void)testApply
{
    dispatch_queue_t queue = [self generateQueue:YES];
    NSLog(@"ApplyStart主线程:%@",[NSThread currentThread]);
    dispatch_apply(100, queue, ^(size_t index) {
        NSLog(@"dispatch_apply(%zu)%@",index,[NSThread currentThread]);
    });
    NSLog(@"ApplyEnd");
   
}

-(void)testBarrier
{
    dispatch_queue_t queue = [self generateQueue:YES];
    NSLog(@"BarrierStart(%@)",[NSThread currentThread]);
    dispatch_async(queue, ^{
        [self runForOne];
        NSLog(@"任务1完成(%@)",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"我在这挡了(%@)",[NSThread currentThread]);;
    });
    
    dispatch_async(queue, ^{
        [self runForThree];
        NSLog(@"任务2完成(%@)",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [self runForThree];
        NSLog(@"任务3完成(%@)",[NSThread currentThread]);
    });
    NSLog(@"BarrierEnd(%@)",[NSThread currentThread]);
}

-(void)testSemaphore
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = [self generateQueue:YES];
    NSLog(@"dispatch_semaphore Start(%@)",[NSThread  currentThread]);
    for (int i = 0; i < 20; ++i)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"dispatch_semaphore(%d---%@)",i,[NSThread  currentThread]);
            sleep(3);
            dispatch_semaphore_signal(semaphore);
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        NSLog(@"dispatch_semaphore End(%@)",[NSThread  currentThread]);
    });
}
@end
