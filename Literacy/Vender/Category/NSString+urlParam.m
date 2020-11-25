//
//  NSString+urlParam.m
//  hongxinbao
//
//  Created by Yuri on 2016/11/8.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "NSString+urlParam.h"

@implementation NSString (urlParam)

+ (NSString *)getBaseUrl:(NSString *)url withparam:(NSDictionary *)param{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",url];
    
    [string appendString:@"?"];
    
    for (NSString *key in param.allKeys) {
        [string appendFormat:@"%@=%@&",key,param[key]];
    }
    return string;
}

@end
