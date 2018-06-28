//
//  ViewController.m
//  WKWebView
//
//  Created by yangrui on 2018/6/27.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "ViewController.h"

#import <WebKit/WebKit.h>
#import "YRScriptMessageHandler.h"

@interface ViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WKWebViewConfiguration *webViewConfig;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self webView];
    
   
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    
    NSString *urlStr = @"https://tieba.baidu.com/index.html";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
}







-(WKWebView *)webView{
    
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:[self webViewConfig]];
        
        // UI代理
        _webView.UIDelegate = self;
        
        //导航代理
        _webView.navigationDelegate = self;
        
        //是否允许手势左滑返回上一级，类似导航控制器的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        
        [self.view addSubview:_webView];
        
    }
    return _webView;
    
}


-(WKWebViewConfiguration *)webViewConfig{
    if (!_webViewConfig) {
        _webViewConfig = [[WKWebViewConfiguration alloc] init];
        
        // 设置配属属性
        _webViewConfig.preferences = [self webViewConfigPreference];
        
        // 是使用 H5 的视频播放器在线播放,还是使用原生的播放器全屏播放
        _webViewConfig.allowsInlineMediaPlayback = YES;
        
        // 设置视频是否需要用户手动播放, 设置为 NO 则会允许自动播放
        _webViewConfig.requiresUserActionForMediaPlayback = YES;
        
        // 设置是否允许画中画技术, 在特定设备上有效
        _webViewConfig.allowsPictureInPictureMediaPlayback = YES;
        
        // 设置请求的 User-Agent 信息中应用程序名称 iOS9 后可用
        _webViewConfig.applicationNameForUserAgent = @"Lettin";
        
        //这个类主要用来做native 与 javascript 的交互管理
        _webViewConfig.userContentController = [self usrContentController];
        
        
        //一下代码适配文本大小
        NSString *jsStr = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        // 用于进行 javascript 注入
        WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [_webViewConfig.userContentController addUserScript:usrScript];
        
        
        
        
        
    }
    
    return _webViewConfig;
}




-(WKPreferences *)webViewConfigPreference{
    WKPreferences *pref = [[WKPreferences alloc] init];
    
    //最小字体大小， 当javascriptEnable 属性设置为NO时，可以看到明显的效果
    pref.minimumFontSize = 0;
    
    // 是否支持javascript 默认是支持
    pref.javaScriptEnabled = YES;
    
    // 在ios 上默认为NO, 表示是否允许不经过用户交互 由javascript 自动打开窗口
    pref.javaScriptCanOpenWindowsAutomatically = YES;
    
    return pref;
}


-(WKUserContentController *)usrContentController{
    //这个类主要用来做native 与 javascript 的交互管理
    WKUserContentController *usrContentController = [[WKUserContentController alloc]init];
    
    // 代理完善
    // 自定义的 WKScriptMessageHandler 是为了解决内存不释放的问题
    YRScriptMessageHandler *scriptMessageHandler = [[YRScriptMessageHandler alloc] initWithHandler:self];
    
    
    // 注册一个那么 为 jsToOcWithoutPrams 的js 方法  设置处理接收js 方法的对象
    [usrContentController addScriptMessageHandler:scriptMessageHandler name:@"jsToOcWithoutPrams"];
    [usrContentController addScriptMessageHandler:scriptMessageHandler  name:@"jsToOcWithPrams"];
    
    return usrContentController;
}




#pragma mark- WKNavigationDelegate
// WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"------- 页面开始加载-------");
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"------- 页面加载失败-------");
}


// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
      NSLog(@"------- 内容开始返回了-------");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
     NSLog(@"------- 页面显示完成-------");
    
}





#pragma mark- 点击事件 操作
 

- (IBAction)recoverBtnClick:(id)sender {
    
    NSString *jsStr = @"document.getElementsByClassName(\"index-forum-num-ten-millions\")[0].style.display=\"\"";
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
        NSLog(@"-------error: %@",error);
    }];
    
}

- (IBAction)dismissBtnClick:(id)sender {
     
    NSString *jsStr = @"document.getElementsByClassName(\"index-forum-num-ten-millions\")[0].style.display='none'";
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
        NSLog(@"-------error: %@",error);
    }];
 
}





#pragma mark- KVO  监听网页的进度和导航栏标题的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([object isEqual:self.webView]) {
        
        if ([keyPath isEqualToString:@"title"]) {
            self.navigationItem.title = self.webView.title;
            NSLog(@"---------------更新标题---------: %@",self.webView.title);
        }
        else if ([keyPath isEqualToString:@"estimatedProgress"]) {
            NSLog(@"---------------progress: %f",self.webView.estimatedProgress);
        }
        
        
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    
}



@end
