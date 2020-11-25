//
//  BaseViewController.m
//  ckxj
//
//  Created by Yuri on 2019/9/18.
//  Copyright © 2019 iOS_Size_Photo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //    导航栏变为透明
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //    让黑线消失的方法
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.translucent = YES;

}


//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    //    导航栏取消透明
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//    //    让黑线显示
//    self.navigationController.navigationBar.shadowImage = nil;
//    
//    self.navigationController.navigationBar.translucent = NO;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kstandardColor;
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
