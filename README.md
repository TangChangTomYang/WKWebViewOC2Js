
首先,我们要明确一个问题,在HTML中看到的每个内容都是用HTML标签来描述并且由CSS来决定显示的样式的,因此,我们想隐藏(移除) HTML 中的具体内容主要有2种做法:<br>(1) 移除对应的html 标签<br>(2)修改对应标签的CSS 样式<br><br>**我们这里采用第二种,修改CSS 样式来隐藏具体的内容,具体步骤如下:**

![要移除内容的网页](https://upload-images.jianshu.io/upload_images/2018969-d2acd3d21bca65e5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 1 **在Google Chrome 中打开对应的网页,并打开网页的开发者工具**
![网页开发者工具](https://upload-images.jianshu.io/upload_images/2018969-8ff87c0ff78137e4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- 2 **在网页开发者工具中找到要隐藏(去除)的内容的 标签,并验证方法是否可行**
![CSS 验证想法](https://upload-images.jianshu.io/upload_images/2018969-c50243f852023676.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 3 **在网页开发者工具中用 js 语法验证代码是否可行**
![js  验证想法](https://upload-images.jianshu.io/upload_images/2018969-74f3c60b793b402f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 4 **在手机上实现并验证**<br><br>(1)创建WKWebView 设置代理 加载网页
```
#import <WebKit/WebKit.h>


// 懒加载webview
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

```
(2) 加载网页

```

- (void)viewDidLoad {
[super viewDidLoad];


[self webView];


[self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
[self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];


NSString *urlStr = @"https://tieba.baidu.com/index.html";
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
[self.webView loadRequest:request];

}


```

(3) 在网页加载完 点击测试隐藏
```

- (IBAction)dismissBtnClick:(id)sender {

NSString *jsStr = @"document.getElementsByClassName(\"index-forum-num-ten-millions\")[0].style.display='none'";
[self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {

NSLog(@"-------error: %@",error);
}];

}

```

(4)在网页加载完 点击测试恢复
```

- (IBAction)recoverBtnClick:(id)sender {

NSString *jsStr = @"document.getElementsByClassName(\"index-forum-num-ten-millions\")[0].style.display=\"\"";
[self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {

NSLog(@"-------error: %@",error);
}];

}

```



最终效果
![oc2jsgif.gif](https://upload-images.jianshu.io/upload_images/2018969-2335ceaad21e5039.gif?imageMogr2/auto-orient/strip)











