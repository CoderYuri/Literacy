//
//  NSString+urlParam.h
//  hongxinbao
//
//  Created by Yuri on 2016/11/8.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (urlParam)

+ (NSString *)getBaseUrl:(NSString *)url withparam:(NSDictionary *)param;

@end
