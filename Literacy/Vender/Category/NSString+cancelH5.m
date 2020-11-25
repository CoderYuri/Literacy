//
//  NSString+cancelH5.m
//  testttt
//
//  Created by Yuri on 2017/1/12.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "NSString+cancelH5.h"

@implementation NSString (cancelH5)
//ida 该方法用于去除NSString中的html标签
/**
 * @brief 去掉字符串NSString中的html标签 “<>”
 *
 * @param html 要修改的nsstring
 * @param trim 是否要将nsstring 中开始的空白用@“”替换,yes会替换，no不会替换
 *
 * @return nsstring 去掉html标签后的nsstring
 */
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}
@end
