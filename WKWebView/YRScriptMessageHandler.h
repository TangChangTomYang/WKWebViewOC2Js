//
//  YRScriptMessageHandler.h
//  WKWebView
//
//  Created by yangrui on 2018/6/27.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface YRScriptMessageHandler : NSObject <WKScriptMessageHandler>


//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> handler;

- (instancetype)initWithHandler:(id<WKScriptMessageHandler>)handler;

@end
