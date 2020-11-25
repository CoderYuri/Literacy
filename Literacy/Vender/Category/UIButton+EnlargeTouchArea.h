//
//  UIButton+EnlargeTouchArea.h
//  Professionalimage
//
//  Created by Yuri on 2020/2/28.
//  Copyright © 2020 iOS_Professional_image. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (EnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end

NS_ASSUME_NONNULL_END
