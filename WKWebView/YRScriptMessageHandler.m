//
//  YRScriptMessageHandler.m
//  WKWebView
//
//  Created by yangrui on 2018/6/27.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "YRScriptMessageHandler.h"

@implementation YRScriptMessageHandler


- (instancetype)initWithHandler:(id<WKScriptMessageHandler>)handler {
    self = [super init];
    if (self) {
        self.handler = handler;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.handler respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.handler userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
