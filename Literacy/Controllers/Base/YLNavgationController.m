//
//  YLNavgationController.m
//  GoldCarbon
//
//  Created by Yuri on 2017/2/28.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "YLNavgationController.h"

@interface YLNavgationController ()<UIGestureRecognizerDelegate>

@end

@implementation YLNavgationController

+ (void)initialize
{
    /** 设置UINavigationBar */
    UINavigationBar *bar = [UINavigationBar appearance];
    
    // 设置标题文字属性
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    barAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [bar setTitleTextAttributes:barAttrs];
    
    /** 设置UIBarButtonItem */
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // UIControlStateNormal
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    // UIControlStateDisabled
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    //设置navigationBar的颜色
    self.navigationBar.barTintColor = WhiteColor;
    self.navigationBar.translucent = NO;
    
    
    //    UILabel *titleLabel = [[UILabel alloc] init];
    //    titleLabel.size = CGSizeMake(100, 40);
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    self.navigationItem.titleView = titleLabel;
    
    //设置返回按钮的颜色
    //    self.navigationBar.tintColor = [UIColor whiteColor];
    // 统一设置导航栏返回按钮 取消返回两个字
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    //修改头部标题 尺寸颜色
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:kblackColor}];

}

/**
 * 拦截所有push进来的子控制器
 * @param viewController 每一次push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if (不是第一个push进来的子控制器) {
    if (self.childViewControllers.count >= 1) {
        

        // 左上角的返回
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"nav_back_n"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        backItem.title = @"";
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
         
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>
/**
 * 每当用户触发[返回手势]时都会调用一次这个方法
 * 返回值:返回YES,手势有效; 返回NO,手势失效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 如果当前显示的是第一个子控制器,就应该禁止掉[返回手势]
    //    if (self.childViewControllers.count == 1) return NO;
    //    return YES;
    return self.childViewControllers.count > 1;
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
