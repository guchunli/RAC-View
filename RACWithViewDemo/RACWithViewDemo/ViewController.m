//
//  ViewController.m
//  RACWithViewDemo
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 guchunli. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SecondViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     ReactiveCocoa作用
     1.target-action:rac_signalForControlEvents 
     rac_textSignal rac_gestureSignal
     2.代理 rac_signalForSelector:@selector() fromProtocol:()
     3.通知 rac_addObserverForName
     4.KVO RACObserve(object, value)
     */
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //1.target-action
    //1.1 监听textfield文字更改
//    [[self.textfiled rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x){
//        NSLog(@"change");
//    }];
    
     //简写
     [[self.textfiled rac_textSignal] subscribeNext:^(id x) {
     NSLog(@"%@",x);
     }];
    
    //1.2
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"tap");
    }];
    //注意：如果给label添加手势，需要打开userInteractionEnabled
    self.lab.userInteractionEnabled = YES;
    [self.lab addGestureRecognizer:tap];
    
    //4.KVO RACObserve(object, value)
    UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, 200, 400)];
    scrolView.contentSize = CGSizeMake(200, 800);
    scrolView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrolView];
    [RACObserve(scrolView, contentOffset) subscribeNext:^(id x) {
        NSLog(@"success");
    }];
    
}


- (IBAction)btnClick:(UIButton *)sender {
    
    /*
    //2.代理：rac_signalForSelector:@selector() fromProtocol:()
    // *** 注意：只能实现返回值为void的代理方法
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"rac test" delegate:self cancelButtonTitle:@"no" otherButtonTitles:@"yes", nil];
//    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
//        //tuple为点击按钮的各个参数
//        NSLog(@"%ld",tuple.count);
//        NSLog(@"%@",tuple.first);
//        NSLog(@"%@",tuple.second);
//        NSLog(@"%@",tuple.third);
//    }];
    //简写
    [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [alertView show];
     */
    
    //3.通知 rac_addObserverForName
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil] subscribeNext:^(NSNotification *notification) {
        NSLog(@"%@", notification.name);
        NSLog(@"%@", notification.object);
    }];
    
    [self presentViewController:[[SecondViewController alloc]init] animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
