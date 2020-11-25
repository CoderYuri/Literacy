//
//  NSString+HEX.h
//  ckxj
//
//  Created by Yuri on 2019/10/12.
//  Copyright © 2019 iOS_Size_Photo. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HEX)

+ (NSString *)ToHex:(long long int)tmpid;

+ (NSString *)convertDecimalSystemFromBinarySystem:(NSString *)binary;

+ (NSString *)getBinaryByDecimal:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
