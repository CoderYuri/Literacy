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
//#import "FuxiViewController.h"
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:1];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    YLog(@"%.0f",[[NSDate date] timeIntervalSince1970])
    
    [YUserDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kfirstchuo];
    
    //进入欢迎页
    [self gotoWelcome];

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
        
    //处于开发阶段
    #ifdef DEBUG
    #else
    //处于发布阶段
    //友盟统计 iPad和iPhone版
    if(isPad){
        [UMConfigure initWithAppkey:@"5fe05fac345b8b53f5754613" channel:@"App Store"];
    }
    else{
        [UMConfigure initWithAppkey:@"5fe05fec345b8b53f5754617" channel:@"App Store"];
    }
    #endif

    
    return YES;
}

- (void)gotoMainVC{
    //界面布局
    MainViewController *mainVc = [[MainViewController alloc] init];
    [self.window setRootViewController:mainVc];
    [self.window makeKeyAndVisible];
}

- (void)gotoWelcome{
    WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
    [self.window setRootViewController:welcomeVc];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
    
    double nowchuo = [[NSDate date] timeIntervalSince1970];
    double shijiancha = nowchuo - [YUserDefaults doubleForKey:kfirstchuo];
    
    NSString *shijianchaS = [NSString stringWithFormat:@"%.0f",shijiancha];
    
    param[@"using_time"] = [NSNumber numberWithInteger:[shijianchaS integerValue]];

    YLog(@"%@",[NSString getBaseUrl:_URL_UsingLong withparam:param])
    
    [YLHttpTool POST:_URL_UsingLong parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {
        
        if([dic[@"code"] integerValue] == 200){
            
        }
        else{
                
        }
        YLog(@"%@",dic)
        
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
        
    }];
    
}

//- (void)gotoFuxi{
//    FuxiViewController *welcomeVc = [[FuxiViewController alloc] init];
//    [self.window setRootViewController:welcomeVc];
//    [self.window makeKeyAndVisible];
//}


@end
