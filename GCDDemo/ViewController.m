//
//  ViewController.m
//  GCDDemo
//
//  Created by bean on 16/5/4.
//  Copyright © 2016年 com.xile. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@property (strong, nonatomic)UIImageView *imageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //----------------创建-----------------
    //1.创建主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //2.创建全局并行队列
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //3.创建串行队列
    dispatch_queue_t queue3 = dispatch_queue_create("chuanxingduilie", NULL);
    
    //----------------执行-----------------
    //1.异步
    void dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
    
    
    //2.同步
    void dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
    
    //3.延时
    void dispatch_after(dispatch_time_t when,dispatch_queue_t queue,dispatch_block_t block);
    
    
    
    
}

//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------操作---------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------

/*
 如果是在 子线程中调用 同步函数 + 主队列, 那么没有任何问题 【子同主】
 */
- (void)syncMain2
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        // block会在子线程中执行
        //        NSLog(@"%@", [NSThread currentThread]);
        
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_sync(queue, ^{
            // block一定会在主线程执行
            NSLog(@"%@", [NSThread currentThread]);
        });
    });
    NSLog(@"------------");
}
/*
 如果是在 主线程中调用同步函数 + 主队列, 那么会导致死锁 【主同主】
 导致死锁的原因:
 sync函数是在主线程中执行的, 并且会等待block执行完毕. 先调用
 block是添加到主队列的, 也需要在主线程中执行. 后调用
 */
- (void)syncMain
{
    NSLog(@"%@", [NSThread currentThread]);
    // 主队列:
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //  如果是调用 同步函数, 那么会等同步函数中的任务执行完毕, 才会执行后面的代码
    // 注意: 如果dispatch_sync方法是在主线程中调用的, 并且传入的队列是主队列, 那么会导致死锁
    dispatch_sync(queue, ^{
        NSLog(@"----------");
        NSLog(@"%@", [NSThread currentThread]);
    });
    NSLog(@"----------");
}
/*
 异步 + 主队列 : 不会创建新的线程, 并且任务是在 主线程中执行 【主异主】
 */
- (void)asyncMain
{
    // 主队列:
    // 特点: 只要将任务添加到主队列中, 那么任务"一定"会在主线程中执行 \
    无论你是调用同步函数还是异步函数
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
}
/*
 同步 + 并发 : 不会开启新的线程
 妻管严
 */
- (void)syncConCurrent
{
    // 1.创建一个并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 2.将任务添加到队列中
    dispatch_sync(queue, ^{
        NSLog(@"任务1  == %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2  == %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3  == %@", [NSThread currentThread]);
    });
    
    NSLog(@"---------");
}
/*
 同步 + 串行: 不会开启新的线程
 注意点: 如果是调用 同步函数, 那么会等同步函数中的任务执行完毕, 才会执行后面的代码
 */
- (void)syncSerial
{
    // 1.创建一个串行队列
    // #define DISPATCH_QUEUE_SERIAL NULL
    // 所以可以直接传NULL
    dispatch_queue_t queue = dispatch_queue_create("com.520it.lnj", NULL);
    
    // 2.将任务添加到队列中
    dispatch_sync(queue, ^{
        NSLog(@"任务1  == %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2  == %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3  == %@", [NSThread currentThread]);
    });
    
    NSLog(@"---------");
}
/*
 异步 +　串行：会开启新的线程
 但是只会开启一个新的线程
 注意: 如果调用 异步函数, 那么不用等到函数中的任务执行完毕, 就会执行后面的代码
 */
- (void)asynSerial
{
    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.520it.lnj", DISPATCH_QUEUE_SERIAL);
    /*
     能够创建新线程的原因:
     我们是使用"异步"函数调用
     只创建1个子线程的原因:
     我们的队列是串行队列
     */
    // 2.将任务添加到队列中
    dispatch_async(queue, ^{
        NSLog(@"任务1  == %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2  == %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3  == %@", [NSThread currentThread]);
    });
    
    NSLog(@"--------");
}

/*
 异步 + 并发 : 会开启新的线程
 如果任务比较多, 那么就会开启多个线程
 */
- (void)asynConcurrent
{
    /*
     执行任务
     dispatch_async
     dispatch_sync
     */
    
    /*
     第一个参数: 队列的名称
     第二个参数: 告诉系统需要创建一个并发队列还是串行队列
     DISPATCH_QUEUE_SERIAL :串行
     DISPATCH_QUEUE_CONCURRENT　并发
     */
    //    dispatch_queue_t queue = dispatch_queue_create("com.520it.lnj", DISPATCH_QUEUE_CONCURRENT);
    
    // 系统内部已经给我们提供好了一个现成的并发队列
    /*
     第一个参数: iOS8以前是优先级, iOS8以后是服务质量
     iOS8以前
     *  - DISPATCH_QUEUE_PRIORITY_HIGH          高优先级 2
     *  - DISPATCH_QUEUE_PRIORITY_DEFAULT:      默认的优先级 0
     *  - DISPATCH_QUEUE_PRIORITY_LOW:          低优先级 -2
     *  - DISPATCH_QUEUE_PRIORITY_BACKGROUND:
     
     iOS8以后
     *  - QOS_CLASS_USER_INTERACTIVE  0x21 用户交互(用户迫切想执行任务)
     *  - QOS_CLASS_USER_INITIATED    0x19 用户需要
     *  - QOS_CLASS_DEFAULT           0x15 默认
     *  - QOS_CLASS_UTILITY           0x11 工具(低优先级, 苹果推荐将耗时操作放到这种类型的队列中)
     *  - QOS_CLASS_BACKGROUND        0x09 后台
     *  - QOS_CLASS_UNSPECIFIED       0x00 没有设置
     
     第二个参数: 废物
     */
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    /*
     第一个参数: 用于存放任务的队列
     第二个参数: 任务(block)
     
     GCD从队列中取出任务, 遵循FIFO原则 , 先进先出
     输出的结果和苹果所说的原则不符合的原因: CPU可能会先调度其它的线程
     
     能够创建新线程的原因:
     我们是使用"异步"函数调用
     能够创建多个子线程的原因:
     我们的队列是并发队列
     */
    dispatch_async(queue, ^{
        NSLog(@"任务1  == %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2  == %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3  == %@", [NSThread currentThread]);
    });
}














//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//------------线程间通信-------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.imageView];
    
    NSLog(@"--------");
    // 1.除主队列以外, 随便搞一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 2.调用异步函数
    dispatch_async(queue, ^{
        // 1.下载图片
        NSURL *url = [NSURL URLWithString:@"http://pic.4j4j.cn/upload/pic/20130531/07ed5ea485.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 2.将二进制转换为图片
        UIImage *image = [UIImage imageWithData:data];
        
        // 3.回到主线程更新UI
        //        self.imageView.image = image;
        /*
         技巧:
         如果想等UI更新完毕再执行后面的代码, 那么使用同步函数
         如果不想等UI更新完毕就需要执行后面的代码, 那么使用异步函数
         */
        dispatch_sync(dispatch_get_main_queue(), ^{ // 会等block代码执行完毕后，执行后面最后一句的打印代码
            self.imageView.image = image;
        });
        NSLog(@"设置图片完毕 %@", image);
    });
}


//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------从子线程回到主线程---------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
-(void)subToMain
{
//    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
//        
//        // 1. 执行耗时的异步操作
////        .......
//        
//        //2. 回到主线程，执行UI刷新操作
//        dispatch_async(dispatch_get_main_queue(),^{
//            
//            //这里使用的是dispatch_async:不用等block执行完，就会调用下面的打印代码，如果替换为使用dispatch_sync同步函数：那么会等block执行更新UI完毕，才会执行最后一句打印代码
////            .......
//        });
//    };
//    NSLog(@"更新UI界面结束");
    
    
    
    NSLog(@"--------");
    // 1.除主队列以外, 随便搞一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 2.调用异步函数
    dispatch_async(queue, ^{
        // 1.下载图片
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/img/bd_logo1.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 2.将二进制转换为图片
        UIImage *image = [UIImage imageWithData:data];
        
        // 3.回到主线程更新UI
        //        self.imageView.image = image;
        /*
         技巧:
         如果想等UI更新完毕再执行后面的代码, 那么使用同步函数
         如果不想等UI更新完毕就需要执行后面的代码, 那么使用异步函数
         */
        dispatch_sync(dispatch_get_main_queue(), ^{ // 会等block代码执行完毕后，执行后面最后一句的打印代码
            self.imageView.image = image;
        });
        NSLog(@"设置图片完毕 %@", image);
    });
    
}










//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//------------延时执行---------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
-(void)delay
{
    
//    1、iOS常见的延时执行，调用NSObject的方法
//    performSelector 一旦定制好延时任务，不会卡住当前线程
//    2秒后再调用self的run方法
    
    [self performSelector:@selector(run) withObject:nil afterDelay:2.0];
}


-(void)delay2
{
//    2、使用GCD函数
// 该方法中, 会根据传入的队列来决定回掉block在哪个线程中执行
// 如果传入的是主队列, 那么block会在主线程调用
// 如果传入的是全局队列, 那么block会在子线程中调用
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        // 这里传入全局队列会在子线程中执行block，如果传入主队列就会在主线程中执行block
        NSLog(@"3秒之后执行  %@", [NSThread currentThread]);
    });
}

-(void)delay3
{
//    3、使用NSTimer
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(test) userInfo:nil repeats:NO];

    
}
- (void)test{
    NSLog(@"---- begin-----");
    [NSThread sleepForTimeInterval:3]; // 它会卡住线程
    //延时执行不要用 sleepForTimeInterval（它会卡住线程） ( 不使用 )
    NSLog(@"---- end-----");
}









//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//-----------一次性代码--------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
-(void)onlyOnce
{
//    使用dispatch_once函数能保证某段代码在程序运行过程中只被执行1次，只执行1次的代码(这里面默认是线程安全的)
//    注意： 千万不能把一次性代码当作懒加载来使用
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@" 一次性代码");
    });
}








//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
//------------快速迭代---------------
//---------------------------------
//---------------------------------
//---------------------------------
//---------------------------------
-(void)fast
{
//    使用dispatch_apply函数能进行快速迭代遍历，但是它和for循环又有些不同
//        
//        第一个参数: 需要遍历几次
//        第二个参数: 决定第三个参数的block在哪个线程中执行
//        第三个参数: 回掉
//        
//        dispatch_apply(10, 队列queue, ^(size_tindex){
//            //执行10次代码，index顺序不确定
//        });
    
    
    //拷贝文件到目标目录中 ： 快速迭代实现
    // 1.定义变量记录原始文件夹和目标文件夹的路径
    NSString * sourcePath = @"/Users/cjp/Desktop/原始文件";
    NSString * destPath = @"/Users/cjp/Desktop/目标文件";
    // 2.取出原始文件夹中所有的文件
    NSFileManager * manager = [NSFileManager defaultManager];
    NSArray * files = [manager subpathsAtPath:sourcePath];
    //    NSLog(@"%@", files);
    // 3.开始拷贝文件
    /*
     for (NSString *fileName in files) {
     // 3.1生产原始文件的绝对路径
     NSString *sourceFilePath = [sourcePath stringByAppendingPathComponent:fileName];
     // 3.2生产目标文件的绝对路径
     NSString *destFilePath = [destPath stringByAppendingPathComponent:fileName];
     //        NSLog(@"%@", sourceFilePath);
     //        NSLog(@"%@", destFilePath);
     // 3.3利用NSFileManager拷贝文件
     [manager moveItemAtPath:sourceFilePath toPath:destFilePath error:nil];
     }
     */
    dispatch_apply(files.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSString *fileName = files[index];
        // 3.1生产原始文件的绝对路径
        NSString *sourceFilePath = [sourcePath stringByAppendingPathComponent:fileName];
        // 3.2生产目标文件的绝对路径
        NSString *destFilePath = [destPath stringByAppendingPathComponent:fileName];
        //        NSLog(@"%@", sourceFilePath);
        //        NSLog(@"%@", destFilePath);
        // 3.3利用NSFileManager拷贝文件
        [manager moveItemAtPath:sourceFilePath toPath:destFilePath error:nil];
    });
}












//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
//-----------栅栏 dispatch_barrier_async-------------
//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
- (void)barrier
{
    
    /**
     1、功能:
     1.拦截前面的任务, 只有先添加到队列中的任务=执行完毕, 才会执行栅栏添加的任务
     2.如果栅栏后面还有其它的任务, 那么必须等栅栏执行完毕才会执行后面的其它任务
     2、注意点：
     1.如果想要使用栅栏, 那么就不能使用全局的并发队列
     2.如果想使用栅栏, 那么所有的任务都必须添加到同一个队列中
     3、实例：合并两种图片，异步函数并发队列多线程下载图片，多个线程同时下载图片，当两种图片下载完毕 -> 开启栅栏功能子线程中进行合并图片，合成图片结束后，再会到主线程更新UI，
     使用，栅栏可以实现该需求，使用下面介绍的队列组也可以实现该功能
     */
    
    
    dispatch_queue_t queue = dispatch_queue_create("cjp", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_queue_t queue2 = dispatch_queue_create("cjp", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    __block UIImage *image1 = nil;
    __block UIImage *image2 = nil;
    // 1.开启一个新的线程下载第一张图片
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"https://img.alicdn.com/tps/i1/TB1AE.sFVXXXXaCXFXXwu0bFXXX.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        image1 = image;
        NSLog(@"图片1下载完毕");
    });
    // 2.开启一个新的线程下载第二张图片
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/img/bd_logo1.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        image2 = image;
        NSLog(@"图片2下载完毕");
    });
    
    // 3.开启一个新的线程, 合成图片
    // 栅栏
    dispatch_barrier_async(queue, ^{
        // 图片下载完毕
        NSLog(@"%@ %@", image1, image2);
        
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        // 2.将第一张图片画上去
        [image1 drawInRect:CGRectMake(0, 0, 100, 200)];
        // 3.将第二张图片画上去
        [image2 drawInRect:CGRectMake(100, 0, 100, 200)];
        // 4.从上下文中获取绘制好的图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 5.关闭上下文
        UIGraphicsEndImageContext();
        
        // 4.回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = newImage;
            // 将合并后的图片写到本地桌面：
            [UIImagePNGRepresentation(newImage) writeToFile:@"/Users/cjp/Desktop/123.png" atomically:YES];
        });
        
        NSLog(@"栅栏执行完毕了");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---------");
    });
    dispatch_async(queue, ^{
        NSLog(@"---------");
    });
    dispatch_async(queue, ^{
        NSLog(@"---------");
    });
}












//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
//---------------队列组 dispatch_group_t-------------
//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
//--------------------------------------------------
-(void)group
{
//应用场景：分别异步执行2个耗时的操作，要等2个异步操作都执行完毕后，再回到主线程执行操作
//    注意：该场景，使用上面的栅栏也可解决
//    dispatch_group_t group =  dispatch_group_create();
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
//        //执行1个耗时的异步操作
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
//        //执行1个耗时的异步操作
//    });
//    dispatch_group_notify(group, dispatch_get_main_queue(),^{
//        //等前面的异步操作都执行完毕后，回到主线程...
//    });
//    实例：异步线程中，下载两种图片，在dispatch_group_notify通知中说明图片下载完-> 合并图片，合并图片结束后 ->再回到主线程中更新UI
    
    
    NSLog(@"%s", __func__);
    
    dispatch_queue_t queue = dispatch_queue_create("cjp", DISPATCH_QUEUE_CONCURRENT);
    
    __block UIImage *image1 = nil;
    __block UIImage *image2 = nil;
    
    dispatch_group_t group = dispatch_group_create();
    
    // 1.开启一个新的线程下载第一张图片
    dispatch_group_async(group, queue, ^{
        NSURL *url = [NSURL URLWithString:@"https://img.alicdn.com/tps/i1/TB1AE.sFVXXXXaCXFXXwu0bFXXX.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        image1 = image;
        NSLog(@"图片1下载完毕");
    });
    
    // 2.开启一个新的线程下载第二张图片
    dispatch_group_async(group, queue, ^{
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/img/bd_logo1.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        image2 = image;
        NSLog(@"图片2下载完毕");
    });
    
    // 3.开启一个新的线程, 合成图片
    // 只要将队列放到group中, 队列中的任务执行完毕, group就会发出一个通知
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"%@ %@", image1, image2);
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        // 2.将第一张图片画上去
        [image1 drawInRect:CGRectMake(0, 0, 100, 200)];
        // 3.将第二张图片画上去
        [image2 drawInRect:CGRectMake(100, 0, 100, 200)];
        // 4.从上下文中获取绘制好的图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 5.关闭上下文
        UIGraphicsEndImageContext();
        
        // 4.回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = newImage;
            [UIImagePNGRepresentation(newImage) writeToFile:@"/Users/cjp/Desktop/123.png" atomically:YES];
        });
    });

}


@end
