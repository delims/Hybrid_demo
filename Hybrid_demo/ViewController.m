//
//  ViewController.m
//  Hybrid_demo
//
//  Created by delims on 2018/8/2.
//  Copyright © 2018年 com.delims. All rights reserved.
//

#import "ViewController.h"
#import "JSClass.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,weak) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"js" ofType:@"html"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (content.length == 0) return;
    UIWebView *webView  = [[UIWebView alloc] init];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView loadHTMLString:content baseURL:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取js上下文对象
    JSContext *context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //创建与js绑定的原生对象
    JSClass *jsObject = [JSClass new];
    //原生对象传给js
    context[@"ocObject"] = jsObject;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
