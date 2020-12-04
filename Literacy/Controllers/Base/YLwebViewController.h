//
//  WzywebViewController.h
//  hongxinbao
//
//  Created by Yuri on 2016/11/29.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WebViewJavascriptBridge.h"
#import <WebKit/WKWebView.h>

@interface YLwebViewController : UIViewController

@property (nonatomic,strong)WKWebView *YLwkwebView;

@property (nonatomic,strong)NSString *urlString;
@property(nonatomic,copy) NSString *bendiUrl;
@property (nonatomic,strong)NSString *titleString;

//@property(nonatomic,strong)WebViewJavascriptBridge *jsBridge;
@end
