//
//  AppDelegate.h
//  Literacy
//
//  Created by Yuri on 2020/11/13.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
    
@property (strong, nonatomic) UIWindow *window;

- (void)gotoMainVC;

/*
 当前的网络状态
 */
@property(nonatomic,assign)int netWorkStatesCode;

@end

