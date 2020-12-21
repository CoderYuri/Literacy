//
//  HeaderUrl.h
//  Literacy
//
//  Created by Yuri on 2020/12/5.
//

#ifndef HeaderUrl_h
#define HeaderUrl_h

#define BaseUrl @"https://literacy.huabanche.club/"

//getuserID
#define _URL_userID [NSString stringWithFormat:@"%@%@",BaseUrl,@"index/userid"]

//字库
#define _URL_words [NSString stringWithFormat:@"%@%@",BaseUrl,@"index/words"]

//获取验证码
#define _URL_code [NSString stringWithFormat:@"%@%@",BaseUrl,@"index/captcha"]

//登录
#define _URL_login [NSString stringWithFormat:@"%@%@",BaseUrl,@"index/login"]

//认读玩
#define _URL_fun [NSString stringWithFormat:@"%@%@",BaseUrl,@"main/literacy"]

//完成学习
#define _URL_Success [NSString stringWithFormat:@"%@%@",BaseUrl,@"index/word/achieve"]

//修改昵称
#define _URL_nickname [NSString stringWithFormat:@"%@%@",BaseUrl,@"indivi/nickname"]

//获取userInfo
#define _URL_userInfo [NSString stringWithFormat:@"%@%@",BaseUrl,@"main/user_info"]

//内购订单
#define _URL_iOSorder [NSString stringWithFormat:@"%@%@",BaseUrl,@"main/ios/order"]

//支付验证
#define _URL_iap_verify_receipt [NSString stringWithFormat:@"%@%@",BaseUrl,@"payment/iap_verify_receipt"]



#endif /* HeaderUrl_h */
