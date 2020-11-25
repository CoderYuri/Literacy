//
//  UIImage+GradientColor.h
//  ckxj
//
//  Created by Yuri on 2019/10/17.
//  Copyright © 2019 iOS_Size_Photo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GradientType) {

GradientTypeTopToBottom = 0,//从上到小

GradientTypeLeftToRight = 1,//从左到右

GradientTypeUpleftToLowright = 2,//左上到右下

GradientTypeUprightToLowleft = 3,//右上到左下

};

@interface UIImage (GradientColor)

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end

NS_ASSUME_NONNULL_END
