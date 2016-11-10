//
//  ViewController.m
//  RunLoop
//
//  Created by YSC on 16/11/5.
//  Copyright © 2016年 lianai911. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self showDemo1]; // 用来展示CFRunLoopModeRef和CFRunLoopTimerRef的结合使用
    
//    [self showDemo2]; // 用来展示CFRunLoopObserverRef使用

//    [self showDemo4]; // 用来展示常驻内存的方式
}

/**
 * 第四个例子：用来展示常驻内存的方式
 */
- (void)showDemo4
{
    // 创建线程，并调用run1方法执行任务
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
    [self.thread start];
}

- (void) run1
{
    // 这里写任务
    NSLog(@"----run1-----%@",[NSThread currentThread]);
    
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop] run];
    
    // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。
    NSLog(@"-------------");
}

- (void) run2
{
    NSLog(@"----run2------");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self showDemo3]; // 用来展示UIImageView的延迟显示
    
    // 利用performSelector调用常驻线程self.thread的run2方法
//    [self performSelector:@selector(run2) onThread:self.thread withObject:nil waitUntilDone:NO]; // 用来展示常驻内存的方式
}


/**
 * 第三个例子：用来展示UIImageView的延迟显示
 */
- (void)showDemo3
{
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"tupian"] afterDelay:4.0 inModes:@[NSDefaultRunLoopMode]];
}

- (IBAction)BtnClick:(id)sender {
    NSLog(@".....");
}

/**
 * 第二个例子：用来展示CFRunLoopObserverRef使用
 */
- (void)showDemo2
{
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd",activity);
    });
    
    // 添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    // 释放observer
    CFRelease(observer);
}

/**
 * 第一个例子：用来展示CFRunLoopModeRef和CFRunLoopTimerRef的结合使用
 */
- (void)showDemo1
{
    // 定义一个定时器，约定两秒之后调用self的run方法
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 将定时器添加到当前RunLoop的NSDefaultRunLoopMode下,一旦RunLoop进入其他模式，定时器timer就不工作了
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
//    // 将定时器添加到当前RunLoop的UITrackingRunLoopMode下，只在拖动情况下工作
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
//
//    // 将定时器添加到当前RunLoop的NSRunLoopCommonModes下，定时器就会跑在被标记为Common Modes的模式下
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    // 调用了scheduledTimer返回的定时器，已经自动被加入到了RunLoop的NSDefaultRunLoopMode模式下。
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
}

- (void)run
{
    NSLog(@"---run");
    
}

@end
