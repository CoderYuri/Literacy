//
//  WzywebViewController.m
//  hongxinbao
//
//  Created by Yuri on 2016/11/29.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "YLwebViewController.h"
#import <WebKit/WKUIDelegate.h>
#import <WebKit/WKNavigationDelegate.h>

#import <WebKit/WebKit.h>

@interface YLwebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation YLwebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kstandardColor;
    
    // 左上角的返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav_back_n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back_n"] forState:UIControlStateHighlighted];
//    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -30, 0.0, 0.0)];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    self.title = self.titleString;
    
    

    [self createWKWebView];

//    if (@available(iOS 11.0, *)) {
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//    }
    
    if(self.urlString.length){
        //进度条初始化
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    //    self.progressView.backgroundColor = RedColor;
        self.progressView.tintColor = kpurpleColor;
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 0.5f);
        [self.view addSubview:self.progressView];
    }
    
}



#pragma mark - WKWebView
- (void)createWKWebView{
//    if(IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max){
//        _YLwkwebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, YScreenW, YScreenH - YnavBarHeight - YtaBarHeight)];
//    }
//    else{
//        _YLwkwebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, YScreenW, YScreenH - YnavBarHeight)];
//    }
  
    _YLwkwebView = [[WKWebView alloc]init];
    
    _YLwkwebView.backgroundColor = kstandardColor;
    _YLwkwebView.navigationDelegate = self;
    _YLwkwebView.UIDelegate = self;

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.userContentController = userContentController;
    config.preferences.javaScriptEnabled = YES;
    config.suppressesIncrementalRendering = YES; // 是否支持记忆读取
   [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];//支持跨域
    
    if(self.urlString.length){
        //kvo 进度条监听
        [_YLwkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

        
        [_YLwkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    else{
        
        NSString *baseString = [NSString string];
        
        if([self.bendiUrl isEqualToString:@"USER_PROTOCOL"]){
            baseString = @"web_user_protocol";
        }
        else{
            baseString = @"web_privacy";
        }
        
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.bendiUrl ofType:@"html" inDirectory:baseString];

        [_YLwkwebView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        
    }
    
    
    
//    _YLwkwebView.scrollView.bounces = NO;
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
//    [_YLwkwebView.configuration.userContentController addUserScript:noneSelectScript];
    
    
//    [WebViewJavascriptBridge enableLogging];
//    _jsBridge = [WebViewJavascriptBridge bridgeForWebView:_YLwkwebView];
//    [_jsBridge setWebViewDelegate:self];
    
    [self.view addSubview:_YLwkwebView];
    _YLwkwebView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).topEqualToView(self.view);
    
}


#pragma mark-WKWebViewNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"didsart");
    
    
//    //开始加载网页时展示出progressView
//    self.progressView.hidden = NO;
//    //开始加载网页的时候将progressView的Height恢复为1.5倍
//    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    //防止progressView被网页挡住
//    [self.view bringSubviewToFront:self.progressView];
    
    
    
    //监听点击事件 （打电话）
    NSString *path= [webView.URL absoluteString];
    NSString * newPath = [path lowercaseString];
    
    if ([newPath hasPrefix:@"sms:"] || [newPath hasPrefix:@"tel:"]) {
        
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:[NSURL URLWithString:newPath]]) {
            [app openURL:[NSURL URLWithString:newPath]];
        }
    }
    
    
//    [self jsbridgeRequestFunction];
}


// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"didCommit");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"didFinish");
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%@",error);
    NSLog(@"didFail");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if(self.urlString.length){
        _urlString = webView.URL.absoluteString;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

//WKUIDelegate
#pragma mark-WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction*)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // 接口的作用是打开新窗口委托
    //[self createNewWebViewWithURL:webView.URL.absoluteString config:Web];
    
    return webView;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

//  js 里面的alert实现，如果不实现，网页的alert函数无效
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString*)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void(^)(NSString *))completionHandler {
    
    completionHandler(@"Client Not handler");
    
}

//解决白屏问题
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)){
    
    [webView reload];
}

#pragma mark-WKWebViewNavigationDelegate    End

//- (void)jsbridgeRequestFunction{
//
//
//    [_jsBridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
//
////        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"openid"]) {
////
////            [_jsBridge callHandler:@"checkLogin" data:@{@"data":@"",@"statusCode": @"1" }];
////        }else{
////
////            [_jsBridge callHandler:@"checkLogin" data:@{@"data":@"",@"statusCode": @"-1" }];
////        }
//
//        YLog(@"%@",data)
//
//        UIImage *imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data[@"url"]]]];
//        NSArray *activityItems = @[imageToShare];
//        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
//        //去除特定的分享功能，excludedActivityTypes 去除哪些类型，这里把部分activity都给去除掉，只剩下相册和微信
//        activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
//        [self presentViewController: activityVC animated:YES completion:nil];
//
//        // 分享之后的回调
//        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//            if (completed) {
//                NSLog(@"completed");
//                //分享 成功
//            } else  {
//                NSLog(@"cancled");
//                //分享 取消
//            }
//        };
//
//    }];
//
//
//
//    /*
//     保存图片到相册
//     */
//    [_jsBridge registerHandler:@"saveImg" handler:^(id data, WVJBResponseCallback responseCallback) {
//
//        NSString *urlString = [NSString stringWithFormat:@"%@",[data objectForKey:@"url"]];
//        NSData*imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//        UIImage *image = [UIImage imageWithData:imgData];
//
//
//
//        UIAlertController * shareAlertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//        [shareAlertC addAction:[UIAlertAction actionWithTitle:LocalString(@"baocunxiangce") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *  action) {
//
////            [self saveImageToPhotos:image];
//            UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
//
//        }]];
//
//        [shareAlertC addAction:[UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:shareAlertC animated:YES completion:nil];
//    }];
//
//
//}


//- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
//
//    NSString *msg = nil ;
//
//    if(error != NULL){
//
//        msg = LocalString(@"shibai");
//    }else{
//
//        msg = LocalString(@"chenggong");
//    }
//
//    [self.view makeToast:msg duration:2 position:@"center"];
//
//
//}


#pragma mark - click



- (void)back{
    if([self.YLwkwebView canGoBack]){
        [self.YLwkwebView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.YLwkwebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.2f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 0.49f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)dealloc {
    
    if(self.urlString.length){
        [self.YLwkwebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
