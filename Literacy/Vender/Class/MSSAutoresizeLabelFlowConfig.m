//
//  MSSAutoresizeLabelFlowConfig.m
//  MSSAutoresizeLabelFlow
//
//  Created by Mrss on 15/12/26.
//  Copyright © 2015年 expai. All rights reserved.
//

#import "MSSAutoresizeLabelFlowConfig.h"

@implementation MSSAutoresizeLabelFlowConfig

+ (MSSAutoresizeLabelFlowConfig *)shareConfig {
    static MSSAutoresizeLabelFlowConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

// default

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(10, Ymargin, 10, Ymargin);
        self.lineSpace = 10;
        self.itemHeight = 32;
        self.itemSpace = 8;
        self.itemCornerRaius = 6;
        self.itemColor = kstandardColor;
        self.textMargin = 20;
        self.textColor = kblackColor;
        self.textFont = [UIFont systemFontOfSize:14];
        self.backgroundColor = WhiteColor;
        
    }
    return self;
}

@end
