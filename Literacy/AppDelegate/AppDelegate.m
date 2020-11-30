//
//  AppDelegate.m
//  Literacy
//
//  Created by Yuri on 2020/11/13.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //界面布局
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *mainVc = [[MainViewController alloc] init];
    YLNavgationController *navC = [[YLNavgationController alloc] initWithRootViewController:mainVc];

    [self.window setRootViewController:navC];
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //只支持横屏
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        return YES;
    }
    /*else//只支持竖屏
     if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
     {
     return YES;
    
     }
     */
    return NO;
}




@end
