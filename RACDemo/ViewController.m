//
//  ViewController.m
//  RACDemo
//
//  Created by tederen on 2017/10/31.
//  Copyright © 2017年 zhiyuehl. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RedView.h"
#import "NSObject+Calculator.h"
#import "Calculator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic)  RedView *redView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property(nonatomic,copy)   NSString *phone;
@property(nonatomic,copy)   NSString *pswd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.redView = [[RedView alloc]initWithFrame:CGRectMake(100, 100, 50,50)];
    [self.view addSubview:self.redView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.redView.center = CGPointMake(200, 200);
    });
    
    
    [self eventResponse];
    
    [self racDefine];
    
    [self racNotification];
    
    [self lianShiBianCheng];
    
    [self manyNetworkUpdateUI];
    
    [self xinHaoDuiLie];
    
    [self validationData];
}

//事件响应
- (void)eventResponse
{
    //文本变化
    [self.password.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    //代替代理使用
    [[self.redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击了红色按钮");
    }];
    //KVO监听
    [[self.redView rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"位置变了");
    }];
    
    //点击事件
    [[self.testButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了button%@",x);
    }];
}


//宏
- (void)racDefine
{
    RAC(self.passwordLabel, text) = self.password.rac_textSignal;
    
    RACTuple *tuple = RACTuplePack(@"hl",@24);
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
    NSLog(@"%@---%@",name,age);
    
    [RACObserve(self.redView, center) subscribeNext:^(id x) {
        NSLog(@"333%@",x);
    }];
}


//通知
- (void)racNotification
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification *notification) {
        NSDictionary *info = notification.userInfo;
        NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSLog(@"height----%f",keyboardFrame.size.height);
    }];
}

//链式编程
- (void)lianShiBianCheng
{
    int result = [NSObject makeCalculators:^(Calculator *make) {
        make.add(1).add(2).add(3);
    }];
    
    NSLog(@"4444------%d",result);
}

//多网络同时更新UI
- (void)manyNetworkUpdateUI
{
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"请求1"];
            NSLog(@"11111");
        });
        return nil;
    }];
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"请求2"];
            NSLog(@"222");
        });
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
}
//更新UI
- (void)updateUIWithR1:(id)data1 r2:(id)data2
{
    NSLog(@"更新UI%@----%@",data1,data2);
}

//信号队列 [subscriber sendCompleted];完成之后才调用
- (void)xinHaoDuiLie
{
    RACSignal *singal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"one"];
        return nil;
    }];
    
    RACSignal *singal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"two"];
        return nil;
    }];
    
    RACSignal *singal3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"three"];
        return nil;
    }];
    
    [[RACSignal merge:@[singal3,singal2,singal1]] subscribeNext:^(id x) {
        NSLog(@"信号队列----%@",x);
    }];
    
    
}

- (void)validationData
{
    [self.phoneTextField.rac_textSignal subscribeNext:^(NSString *x) {
        self.phone = x;
    }];
    
    [self.passwordTextField.rac_textSignal subscribeNext:^(NSString *x) {
        self.pswd = x;
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self, phone),RACObserve(self, pswd)] reduce:^(NSString *txt1,NSString *txt2){
        return @(txt1.length > 2 && txt2.length > 2);
    }] distinctUntilChanged] subscribeNext:^(NSNumber *x) {
        if ([x boolValue]) {
            NSLog(@"yes");
        }else {
            NSLog(@"no");
        }
    }];
    
}


@end
