//
//  AllModel.h
//  GoldCarbon
//
//  Created by Yuri on 2017/4/11.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *content;

@property(nonatomic,copy) NSString *detail;

@property(nonatomic,assign) BOOL ifselected;


/*
//图片链接
@property(nonatomic,copy) NSString *img_url;
//跳转链接
@property(nonatomic,copy) NSString *jump_url;

//热门规格名称
@property(nonatomic,copy) NSString *spec_name;
//热门规格id
@property(nonatomic,assign) NSInteger spec_id;

//热门规格尺寸
@property(nonatomic,strong) NSArray *px_size;
@property(nonatomic,strong) NSArray *mm_size;
@property(nonatomic,strong) NSArray *file_size;
@property(nonatomic,assign) double ppi;

//是否打印
@property(nonatomic,assign) BOOL is_print;

//规格数组
@property(nonatomic,strong) NSMutableArray *specs_info;

//背景色
@property(nonatomic,strong) NSArray *background_color;
@property(nonatomic,copy) NSString *color_name;
@property(nonatomic,assign) long long enc_color;
@property(nonatomic,assign) long long start_color;

//组名
@property(nonatomic,copy) NSString *group_name;

@property(nonatomic,copy) NSString *group_pic_url;

//服装id
@property(nonatomic,assign) NSInteger cloth_id;

@property(nonatomic,strong) NSArray *value;

@property(nonatomic,copy) NSString *clothes_key;

@property(nonatomic,copy) NSString *url;

@property(nonatomic,copy) NSString *name;

//背景颜色列表
@property(nonatomic,strong) NSArray *back_colors;

//背景文件列表
@property(nonatomic,strong) NSArray *file_name_list;

///流水号
@property(nonatomic,copy) NSString *serial_number;

//背景照size
@property(nonatomic,strong) NSArray *size;

//优惠券  使用mod
// 优惠金额
@property(nonatomic,assign) NSInteger coupon_amount;

// 优惠券名称
@property(nonatomic,copy) NSString* coupon_name;

// 优惠券类型 无门槛 1 满减 2 免费多背景 3 免费换装 4 免费精修 5 订单类型免减 6 免费附加规格
@property(nonatomic,assign) NSInteger coupon_type;

// 优惠券过期时间
@property(nonatomic,assign) NSInteger expired_time;

//优惠券说明
@property(nonatomic,copy) NSString *coupon_note;

//满减金额
@property(nonatomic,assign) NSInteger base_amount;


@property(nonatomic,strong) NSDictionary *additional_parameters;

//优惠券ID
@property(nonatomic,assign) NSInteger coupon_id;

//优惠券状态 状态 0 正常 1 禁用 2 过期 3 已使用
@property(nonatomic,assign) NSInteger state;


///轮廓图
@property(nonatomic,copy) NSString *contour_url;

///模特图
@property(nonatomic,copy) NSString *model_url;
*/

@end
