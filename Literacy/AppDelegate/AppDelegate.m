//
//  AppDelegate.m
//  Literacy
//
//  Created by Yuri on 2020/11/13.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
//#import "MainViewController.h"
#import "WelcomeViewController.h"
#import "FuxiViewController.h"

@interface AppDelegate (){
    WelcomeViewController *welcomeVc;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if([YUserDefaults objectForKey:kuserid]){
        [self gotoMainVC];
    }
    else{
        [self getuserID];
    }
  
//    [self gotoWelcome];
    
    //iOS 11 适配
    if (@available(iOS 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }

    ///关闭暗夜模式
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >=130000
        //xcode baseSDK为7.0或者以上
        if(@available(iOS 13.0, *)) {
            self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }else{
        }
    #else
        //xcode baseSDK为7.0以下的
    #endif
    
    
    //键盘处理
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    
    return YES;
}

- (void)getuserID{
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    YLog(@"%@",[NSString getBaseUrl:_URL_userID withparam:param])
    
//    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [YLHttpTool GET:_URL_userID parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){
            
            NSDictionary *d = dic[@"data"];
            [YUserDefaults setObject:d[@"user_id"] forKey:kuserid];
            
            [self gotoMainVC];
            

        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];

        
}


- (void)gotoMainVC{
//    UIViewController *weakRoot = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    //释放rootVc中的资源，否则可能出现内存泄露
//    for (UIView *subView in welcomeVc.view.subviews)
//        [subView removeFromSuperview];
//    welcomeVc = nil;
    
    //界面布局
    MainViewController *mainVc = [[MainViewController alloc] init];
    [self.window setRootViewController:mainVc];
    [self.window makeKeyAndVisible];


}

- (void)gotoWelcome{
    welcomeVc = [[WelcomeViewController alloc] init];
    [self.window setRootViewController:welcomeVc];
    [self.window makeKeyAndVisible];
}


@end
