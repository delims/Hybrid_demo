初次听到*oc与js交互*时，你可能会觉得这是一种高深的技术，其实不然，它并不高深，也很好学，oc与js交互还有另外一个很高大上的名字叫 Hybrid开发。

苹果提供了一个JavaScriptCore框架，用于oc与js交互，里面主要有这几个类

- JSContext：给JavaScript提供运行的上下文环境
- JSValue：JavaScript和Objective-C数据和方法的桥梁
- JSManagedValue：管理数据和方法的类
- JSVirtualMachine：处理线程相关，使用较少
- JSExport：这是一个协议，如果采用协议的方法交互，自己定义的协议必须遵守此协议

下面我用最少的代码来实现js交互，为的就是让小白快速学会js交互，大神可以略过。。。这几个类不会全部用到，如果你感兴趣，可以看一下官方文档，深入学习。

js与oc交互，就是网页与原生代码互相调用，首先我们创建一个含有js代码的网页`js.html`,里面有三个按钮，当点击按钮的时调用原生方法。

**`js.html` 源码如下**
```<script type="text/javascript">
function buttonClick1(){
ocObject.buttonClick();
}
function buttonClick2(){
ocObject.buttonClick2("给我打印这个字符串");
}
function buttonClick3(){
ocObject.buttonClick3("参数1","参数2","参数3");
}
</script>
<button onclick="buttonClick1()">调无参方法</button>
<br /><br />
<button onclick="buttonClick2()">调1个参方法</button>
<br /><br />
<button onclick="buttonClick3()">调3个参方法</button>
```
创建一个与js交互的原生类`JSClass`, 定义一个协议`JSClassDelegate `继承自协议`JSExport`，`JSClassDelegate `中定义了js调用的方法，`JSClass`需遵守该协议才能与js交互。

**`JSClass.h` 源码如下**
```
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSClassDelegate <JSExport>
- (void)buttonClick;
- (void)buttonClick2:(NSString *)arg;
- (void)buttonClick3:(NSString *)arg1 :(NSString*)arg2 :(NSString*)arg3;
@end

@interface JSClass : NSObject<JSClassDelegate>
@end
```

**`JSClass.m` 源码如下**

```
#import "JSClass.h"
@implementation JSClass
- (void)buttonClick{
NSLog(@"点击了按钮");
}
- (void)buttonClick2:(NSString *)arg{
NSLog(@"%@",arg);
}
- (void)buttonClick3:(NSString *)arg1 :(NSString *)arg2 :(NSString *)arg3{
NSLog(@"%@",arg1);
NSLog(@"%@",arg2);
NSLog(@"%@",arg3);
}
@end
```

有**了html页面**和**JSClass**，下面就可以将它们绑定起来了。
直接上代码
```
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
```
我们来运行一下

![效果图](https://delims.github.io/static/cocoapods/images/hybrid.jpg)

有点丑，但是不影响我们调试功能
依次点击三个按钮后打印信息如下
```
2018-08-02 16:06:03.116370+0800 Hybrid_demo[31435:3830397] 调用了oc的无参方法
2018-08-02 16:06:04.581703+0800 Hybrid_demo[31435:3830397] 给我打印这个字符串
2018-08-02 16:06:05.485736+0800 Hybrid_demo[31435:3830397] 参数1
2018-08-02 16:06:05.486490+0800 Hybrid_demo[31435:3830397] 参数2
2018-08-02 16:06:05.487110+0800 Hybrid_demo[31435:3830397] 参数3
```
说明js已经成功调用了原生方法，是不是so easy

源码地址：[https://github.com/delims/Hybrid_demo.git](https://github.com/delims/Hybrid_demo.git)

欢迎转载，转载请注明原文地址，谢谢~

