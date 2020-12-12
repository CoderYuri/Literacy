//
//  HeaderUrl.h
//  Literacy
//
//  Created by Yuri on 2020/12/5.
//

#ifndef HeaderUrl_h
#define HeaderUrl_h

#define BaseUrl @"http://101.133.149.129:8000/"

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



#endif /* HeaderUrl_h */
