//
//  HeaderUrl.h
//  Literacy
//
//  Created by Yuri on 2020/12/5.
//

#ifndef HeaderUrl_h
#define HeaderUrl_h

#define BaseUrl @"http://101.133.149.129:8000/index/"

//getuserID
#define _URL_userID [NSString stringWithFormat:@"%@%@",BaseUrl,@"userid"]

//字库
#define _URL_words [NSString stringWithFormat:@"%@%@",BaseUrl,@"words"]

//获取验证码
#define _URL_code [NSString stringWithFormat:@"%@%@",BaseUrl,@"captcha"]

//登录
#define _URL_login [NSString stringWithFormat:@"%@%@",BaseUrl,@"login"]

//


#endif /* HeaderUrl_h */
