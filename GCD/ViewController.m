//
//  ViewController.m
//  GCD
//
//  Created by 王延磊 on 2018/11/12.
//  Copyright © 2018 追@寻. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 什么是GCD
 1. 全称是Grand Central Dispatch，可译为“牛逼的中枢调度器”
 2. 纯c语言，提供了非常多强大的函数
 GCD的优势
 1. GCD是苹果公司为多核的并行运算提出的解决方案
 2. GCD会自动利用更多的CPU内核（比如双核、四核）
 3. GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 4. 程序员只需要告诉GCD想要执行什么任务，不需要编写任何管理线程代码
 
 执行任务
 1.GCD中有2个用来执行任务的函数
 说明：把右边的参数（任务）提交给左边的参数（队列）进行执行
 
 （1）用同步的方式执行任务 dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
 参数说明：
 queue：队列
 block：任务
 （2）用异步的方式执行任务 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 2.同步和异步的区别
 同步：在当前线程中执行(不会开启子线程)
 异步：在另一条线程中执行(一定会开启子线程)
 串行:在创建队列时，传参数DISPATCH_QUEUE_SERIAL表示创建串行队列。任务会一个一个地执行，只有前一个任务执行完成，才会继续执行下一个任务。串行执行并不是同步执行的意思，一定要注意区分
 并行:在创建队列时，传参数DISPATCH_QUEUE_CONCURRENT表示创建并发队列。并发队列会尽可能多地创建线程去执行任务。并发队列中的任务会按入队的顺序执行任务，但是哪个任务先完成是不确定的。
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    [self delayExecute];
}

//单个GCD操作
-(void)gcdSingleTask{
    NSLog(@"执行GCDSigleTask");               //优先级
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:3];
        //执行耗时操作
        NSLog(@"start task 1");
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新UI
            NSLog(@"upDataUI");
        });
    });
}



//多个任务,异步串行执行
- (void)gcdMoreTask{
    
    dispatch_queue_t queue = dispatch_queue_create("GCD_Name", DISPATCH_QUEUE_SERIAL);
    /*
     DISPATCH_QUEUE_SERIAL 串行  NULL默认 以FIFO顺序连续执行块的调度队列。
     DISPATCH_QUEUE_CONCURRENT 并行   并发执行块的调度队列。尽管它们并发地执行块，但是您可以使用barrier块在队列中创建同步点。
     */
    dispatch_async(queue, ^{
        NSLog(@"start Task1");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task1");
    });
    dispatch_async(queue, ^{
        NSLog(@"start Task2");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task2");
    });
    dispatch_async(queue, ^{
        NSLog(@"start Task3");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task3");
    });
    dispatch_async(queue, ^{
        NSLog(@"start Task4");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task4");
    });
    /*
     打印结果
     2018-11-12 16:33:15.167847+0800 GCD[8150:3150902] start Task1
     2018-11-12 16:33:17.169228+0800 GCD[8150:3150902] end Task1
     2018-11-12 16:33:17.169618+0800 GCD[8150:3150902] start Task2
     2018-11-12 16:33:19.173970+0800 GCD[8150:3150902] end Task2
     2018-11-12 16:33:19.174319+0800 GCD[8150:3150902] start Task3
     2018-11-12 16:33:21.179119+0800 GCD[8150:3150902] end Task3
     2018-11-12 16:33:21.179516+0800 GCD[8150:3150902] start Task4
     2018-11-12 16:33:23.184859+0800 GCD[8150:3150902] end Task4
     一定是顺序打印
     */
}

//多个任务,异步并发执行
- (void)gcdMoreConcurrent{
    //异步并发执行
    dispatch_queue_t queue2 = dispatch_queue_create("GCD_Name", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue2, ^{
        NSLog(@"start Task1");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task1");
    });
    dispatch_async(queue2, ^{
        NSLog(@"start Task2");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task2");
    });
    dispatch_async(queue2, ^{
        NSLog(@"start Task3");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task3");
    });
    dispatch_async(queue2, ^{
        NSLog(@"start Task4");
        [NSThread sleepForTimeInterval:2];//程序睡2秒钟
        NSLog(@"end Task4");
    });
    
    /*
     打印结果
     2018-11-12 16:35:30.825929+0800 GCD[8179:3176187] start Task2
     2018-11-12 16:35:30.825929+0800 GCD[8179:3176188] start Task1
     2018-11-12 16:35:30.825929+0800 GCD[8179:3176189] start Task4
     2018-11-12 16:35:30.825958+0800 GCD[8179:3176190] start Task3
     2018-11-12 16:35:32.829034+0800 GCD[8179:3176188] end Task1
     2018-11-12 16:35:32.829034+0800 GCD[8179:3176189] end Task4
     2018-11-12 16:35:32.829070+0800 GCD[8179:3176187] end Task2
     2018-11-12 16:35:32.829071+0800 GCD[8179:3176190] end Task3
     不是顺序执行,即不需要等待第上一个线程执行完成再开始下一个任务,以上打印结果不是唯一形式
     */
}



-(void)gcdGroupTask{
    dispatch_queue_t queue = dispatch_queue_create("Group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"start Task1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end Task1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"start Task2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end Task2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"start Task3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end Task3");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"刷新主线程UI");
    });
    
    /*
     打印结果
     2018-11-12 16:43:23.741996+0800 GCD[8230:3256190] start Task1
     2018-11-12 16:43:23.742003+0800 GCD[8230:3256188] start Task2
     2018-11-12 16:43:23.742003+0800 GCD[8230:3256189] start Task3
     2018-11-12 16:43:25.745789+0800 GCD[8230:3256188] end Task2
     2018-11-12 16:43:25.745789+0800 GCD[8230:3256189] end Task3
     2018-11-12 16:43:25.745786+0800 GCD[8230:3256190] end Task1
     2018-11-12 16:43:25.746265+0800 GCD[8230:3255929] 刷新主线程UI
     刷新主线程一定在最后打印,但是由于是DISPATCH_QUEUE_CONCURRENT并发执行,所以任务那个先执行,那个先执行结束不确定
     */
    
}


//两个异步请求同时发送，并且统一回调，之后再去处理主线程问题
- (void)gcdEnterGorup{
    dispatch_queue_t queue = dispatch_queue_create("com.GCD.name", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    //一个耗时操作放到group里边,让group持有这个任务
    dispatch_group_enter(group);
    [self sendRequest1:^{
        NSLog(@"sendRequest1 down");
        //group不再持有该任务,需释放
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self sendRequest2:^{
        NSLog(@"sendRequest2 down");
        dispatch_group_leave(group);
    }];
    dispatch_group_async(group, queue, ^{
        NSLog(@"start Task3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end Task3");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"刷新主线程UI");
    });
    
#warning 错误逻辑，这样写不能保证在更新UI时sendRequest1、sendRequest2已经执行结束
    //    dispatch_group_async(group, queue, ^{
    //        //异步网络请求
    //       [self sendRequest1:^{
    //           NSLog(@"sendRequest1 down");
    //       }];
    //    });
    //
    //
    //    dispatch_group_async(group, queue, ^{
    //        [self sendRequest2:^{
    //            NSLog(@"sendRequest2 down");
    //        }];
    //    });
    
}


- (void)sendRequest1:(void(^)(void))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
        if (block) {
            block();
        }
    });
}

- (void)sendRequest2:(void(^)(void))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
        
        if (block) {
            block();
        }
        
    });
}


//延迟执行
- (void)delayExecute{
    __weak typeof(self) weakself = self;
    NSLog(@"注意,3秒后我要改变背景颜色");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"3");
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       NSLog(@"2");
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       NSLog(@"1");
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       __strong typeof(self) self = weakself;
        self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        NSLog(@"修改结束");
    });
}

@end
