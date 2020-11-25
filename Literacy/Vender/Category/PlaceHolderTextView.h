//
//  PlaceHolderTextView.h
//  XinJia
//
//  Created by 金璟 on 16/6/12.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
