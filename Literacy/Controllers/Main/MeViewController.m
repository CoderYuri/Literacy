//
//  MeViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/20.
//

#import "MeViewController.h"
#import "WordCollectionViewCell.h"
#import "NSString+correctPhone.h"

#import <WebKit/WKWebView.h>
#import <WebKit/WKUIDelegate.h>
#import <WebKit/WKNavigationDelegate.h>
#import "YLwebViewController.h"

#define kbackColor [JKUtil getColor:@"F4FAFF"]
#define klcolor [JKUtil getColor:@"E5EEFD"]
#define kocolor [JKUtil getColor:@"FF6112"]
#define chuziColor [JKUtil getColor:@"2E4476"]
#define xuanziColor [JKUtil getColor:@"1D69FF"]


#define yonghuxieyi @"http://huabanche.club/shizi_user_agreement"
#define yincexieyi  @"http://huabanche.club/shizi_privacy"

@interface MeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WKUIDelegate,WKNavigationDelegate>{
    UIView *backV;
    
    UIImageView *vipImg;
    
    UILabel *nameL;
    UILabel *vipL;
    
    UIButton *selectedBtn;
    UIView *selectedV;
    NSInteger selectIndex;
    
    //进行操作的View
    UIView *rightV;
    UIView *goumaiV;
    UIView *qingkuangV;
    UIView *kefuV;
    UIView *aboutV;
    
    UICollectionView *collectionView;
    UILabel *leftL;
    UILabel *rightL;
    NSMutableArray *dataArr;

    //关闭按钮 登录页面
    UIView *blackV;
    UIView *dengluV;
    NoHighBtn *closeBtn;
    
    UITextField *mobileTextF;
    UITextField *codeTextF;
    
    UIButton *huoquBtn;
    
    NoHighBtn *anothercloseBtn;
    CGFloat thisScale;
}

@property (nonatomic,strong) NudeIn *monL;

@property (nonatomic,strong) NudeIn *xieyiLabel;

@property (nonatomic,strong)WKWebView *YLwkwebView;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataArr = [NSMutableArray array];
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    if(arr.count){
        dataArr = [AllModel mj_objectArrayWithKeyValuesArray:arr];
        [self setupView];

    }

    if(isPad){
        thisScale = YScaleWidth;
    }
    else{
        thisScale = YScaleWidth * 0.8;
    }

    
    [self setupView];
    [self setupDengluV];
}

- (void)setupDengluV{
    blackV = [UIView new];
    blackV.backgroundColor = kblackColor;
    blackV.alpha = 0.55;
    [backV addSubview:blackV];
    blackV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
        
    dengluV = [UIView new];
    dengluV.backgroundColor = WhiteColor;
    [backV addSubview:dengluV];
    dengluV.layer.cornerRadius = 3 ;
    dengluV.layer.borderColor = [JKUtil getColor:@"B8D0FF"].CGColor;
//    dengluV.layer.masksToBounds = YES;
    dengluV.sd_layout.centerXEqualToView(backV).centerYEqualToView(backV).widthIs(620 * thisScale).heightIs(516 * thisScale);
    
    
    closeBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"elementclose"] forState:UIControlStateNormal];
    [backV addSubview:closeBtn];
    closeBtn.sd_layout.leftSpaceToView(backV, (YScreenW - 620 * thisScale) * 0.5 + 620 * thisScale - 67 * thisScale).topSpaceToView(backV, (YScreenH - 516 * thisScale) * 0.5 - 27 * thisScale).widthIs(94 * thisScale).heightEqualToWidth();
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self closeClick];
    
    UILabel *shangzL = [UILabel new];
    shangzL.text = @"手机号快捷登录";
    shangzL.font = YSystemFont(32 * thisScale);
    shangzL.textColor = [JKUtil getColor:@"5B5B5B"];
    shangzL.textAlignment = NSTextAlignmentCenter;
    [dengluV addSubview:shangzL];
    shangzL.sd_layout.topSpaceToView(dengluV, 75 * thisScale).centerXEqualToView(dengluV).widthIs(400 * thisScale).heightIs(45 * thisScale);
    
    UILabel *detaiL = [UILabel new];
    detaiL.text = @"未注册的手机号将自动创建账户";
    detaiL.font = YSystemFont(22 * thisScale);
    detaiL.textColor = [JKUtil getColor:@"B6B7BA"];
    detaiL.textAlignment = NSTextAlignmentCenter;
    [dengluV addSubview:detaiL];
    detaiL.sd_layout.topSpaceToView(shangzL, 10 * thisScale).centerXEqualToView(dengluV).widthIs(400 * thisScale).heightIs(22 * thisScale);
    
    UIView *backV1 = [UIView new];
    [dengluV addSubview:backV1];
    backV1.backgroundColor = [JKUtil getColor:@"EBF3F6"];
    backV1.sd_layout.topSpaceToView(dengluV, 182 * thisScale).centerXEqualToView(dengluV).widthIs(440 * thisScale).heightIs(60 * thisScale);
    backV1.layer.cornerRadius = 4;
    backV1.layer.masksToBounds = YES;

    
    mobileTextF = [self textF];
    mobileTextF.placeholder = @"请输入手机号";
    [backV1 addSubview:mobileTextF];
    mobileTextF.sd_layout.centerYEqualToView(backV1).leftSpaceToView(backV1, 24 * thisScale).rightSpaceToView(backV1, 24 * thisScale).heightIs(25 * thisScale);
    
    UIView *backV2 = [UIView new];
    [dengluV addSubview:backV2];
    backV2.backgroundColor = [JKUtil getColor:@"EBF3F6"];
    backV2.sd_layout.topSpaceToView(backV1, 23 * thisScale).centerXEqualToView(dengluV).widthIs(440 * thisScale).heightIs(60 * thisScale);
    backV2.layer.cornerRadius = 4;
    backV2.layer.masksToBounds = YES;

    
    codeTextF = [self textF];
    codeTextF.placeholder = @"请输入验证码";
    [backV2 addSubview:codeTextF];
    codeTextF.sd_layout.centerYEqualToView(backV2).leftSpaceToView(backV2, 24 * thisScale).rightSpaceToView(backV2, 160 * thisScale).heightIs(25 * thisScale);
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [JKUtil getColor:@"B6B7BA"];
    [backV2 addSubview:lineV];
    lineV.sd_layout.leftSpaceToView(codeTextF, 10 * thisScale).centerYEqualToView(backV2).widthIs(1 * thisScale).heightIs(30 * thisScale);
    
    huoquBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [huoquBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [huoquBtn setTitleColor:[JKUtil getColor:@"1665FF"] forState:UIControlStateNormal];
    huoquBtn.titleLabel.font = YSystemFont(18 * thisScale);
    [huoquBtn addTarget:self action:@selector(huoquclick) forControlEvents:UIControlEventTouchUpInside];
    [backV2 addSubview:huoquBtn];
    huoquBtn.sd_layout.centerYEqualToView(backV2).rightEqualToView(backV2).widthIs(150 * thisScale).heightIs(22 * thisScale);
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:korangeColor];
    loginBtn.titleLabel.font = YSystemFont(26 * thisScale);
    [loginBtn addTarget:self action:@selector(dengluClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 30 * thisScale;
    loginBtn.layer.masksToBounds = YES;
    [dengluV addSubview:loginBtn];
    loginBtn.sd_layout.centerXEqualToView(dengluV).bottomSpaceToView(dengluV, 96 * thisScale).widthIs(358 * thisScale).heightIs(60 * thisScale);
    
    _xieyiLabel = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"点击登录，即表示同意").fontName(@"PingFangSC-Regular",14 * thisScale).color([JKUtil getColor:@"CDCDCD"]).attach();
        make.text(@"《用户协议》").fontName(@"PingFangSC-Regular",14 * thisScale).color([JKUtil getColor:@"1665FF"]).attach();
        make.text(@"和").fontName(@"PingFangSC-Regular",14 * thisScale).color([JKUtil getColor:@"CDCDCD"]).attach();
        make.text(@"《隐私政策》").fontName(@"PingFangSC-Regular",14 * thisScale).color([JKUtil getColor:@"1665FF"]).attach();
        
    }];
    _xieyiLabel.userInteractionEnabled = NO;
        _xieyiLabel.textAlignment = NSTextAlignmentCenter;
    [dengluV addSubview:_xieyiLabel];
    _xieyiLabel.sd_layout.topSpaceToView(loginBtn, 44 * thisScale).widthIs(400 * thisScale).heightIs(20 * thisScale).centerXEqualToView(dengluV);

    UIButton *xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xieyiBtn addTarget:self action:@selector(xieyiclick) forControlEvents:UIControlEventTouchUpInside];
    [dengluV addSubview:xieyiBtn];
    xieyiBtn.sd_layout.topSpaceToView(loginBtn, 34 * thisScale).leftSpaceToView(dengluV, 300 * thisScale).widthIs(72 * thisScale).heightIs(40 * thisScale);
    
    UIButton *yinsiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yinsiBtn addTarget:self action:@selector(yinsiclick) forControlEvents:UIControlEventTouchUpInside];
    [dengluV addSubview:yinsiBtn];
    yinsiBtn.sd_layout.topSpaceToView(loginBtn, 34 * thisScale).rightSpaceToView(dengluV, 151 * thisScale).widthIs(72 * thisScale).heightIs(40 * thisScale);
    
}

- (UITextField *)textF{
    UITextField *textF = [[UITextField alloc] init];
    textF.backgroundColor = ClearColor;
    textF.font = YSystemFont(18 * thisScale);
    textF.tintColor = kblackColor;
//    textF.delegate = self;
    textF.keyboardType = UIKeyboardTypeNumberPad;

    return textF;
}


- (void)setupView{
    backV = self.view;
    backV.backgroundColor = [JKUtil getColor:@"1665FF"];
    
    NoHighBtn *backBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"iconback"] forState:UIControlStateNormal];
    [backV addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(backV, 27 * YScaleWidth).topSpaceToView(backV, 27 * YScaleWidth).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];

    
    UIView *midV = [UIView new];
    [backV addSubview:midV];
    midV.backgroundColor = WhiteColor;
    midV.sd_layout.centerXEqualToView(backV).bottomSpaceToView(backV, 30 * YScaleHeight).widthIs(1020 * YScaleWidth).heightIs(660 * YScaleHeight);
    
    UIView *leftV = [UIView new];
    [midV addSubview:leftV];
    leftV.backgroundColor = [JKUtil getColor:@"F2F9FF"];
    leftV.sd_layout.leftEqualToView(midV).bottomEqualToView(midV).topEqualToView(midV).widthIs(180 * YScaleWidth);
    
    
    ///个人信息
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementuser"]];
    [leftV addSubview:userIcon];
    userIcon.sd_layout.leftSpaceToView(leftV, 11 * YScaleWidth).topSpaceToView(leftV, 30 * YScaleHeight).widthIs(50 * YScaleWidth).heightEqualToWidth();
    
    vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notvip"]];
    [leftV addSubview:vipImg];
    vipImg.sd_layout.leftSpaceToView(leftV, 45 * YScaleWidth).topSpaceToView(leftV, 30 * YScaleHeight + 35 * YScaleWidth).widthIs(18 * YScaleWidth).heightEqualToWidth();
    
    nameL = [UILabel new];
    nameL.text = @"未登录";
    nameL.font = YSystemFont(16 * YScaleWidth);
    nameL.textColor = [JKUtil getColor:@"2A2D34"];
    [leftV addSubview:nameL];
    nameL.sd_layout.leftSpaceToView(leftV, 70 * YScaleWidth).topSpaceToView(leftV , 35 * YScaleHeight).heightIs(22 * YScaleWidth).widthIs(88 * YScaleWidth);
    
    NoHighBtn *changeNameBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [changeNameBtn setBackgroundImage:[UIImage imageNamed:@"elementedit"] forState:UIControlStateNormal];
    [changeNameBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [leftV addSubview:changeNameBtn];
    changeNameBtn.sd_layout.centerYEqualToView(nameL).rightSpaceToView(leftV, 20 * YScaleWidth).widthIs(10 * YScaleWidth).heightEqualToWidth();
    [changeNameBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
//    17449C  当前未开通会员   A6A6A6
//    FF5E18  有效期至2021.11.30   当前未开通会员
    

    vipL = [UILabel new];
    vipL.textColor = [JKUtil getColor:@"A6A6A6"];
    vipL.text = @"当前未开通会员";
    
    vipL.font = YSystemFont(11 * YScaleWidth);
    [leftV addSubview:vipL];
    vipL.sd_layout.leftEqualToView(nameL).topSpaceToView(nameL, 3 * YScaleHeight).heightIs(16 * YScaleWidth).widthIs(108 * YScaleWidth);
    
    if([YUserDefaults objectForKey:kusername]){
        self->nameL.text = [YUserDefaults objectForKey:kusername];
        if([YUserDefaults boolForKey:kis_member]){
            self->vipImg.image = [UIImage imageNamed:@"vip"];
            self->vipL.text = @"有效期至2021.11.30";
            self->vipL.textColor = [JKUtil getColor:@"FF6112"];

        }
        else{
            self->vipImg.image = [UIImage imageNamed:@"notvip"];
            self->vipL.text = @"当前未开通会员";
            self->vipL.textColor = [JKUtil getColor:@"A6A6A6"];
        }
    }

    
    
    
    NSArray *namearr = @[@"购买方案",@"识字情况",@"联系客服",@"关于我们"];
    ///操作按钮
    for (int i = 0; i < 4; i++) {
        NoHighBtn *btn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = YSystemFont(20 * YScaleWidth);
        [btn setTitle:namearr[i] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageWithColor:klcolor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kocolor] forState:UIControlStateSelected];
        
        [btn setTitleColor:[JKUtil getColor:@"6B7CA4"] forState:UIControlStateNormal];
        [btn setTitleColor:WhiteColor forState:UIControlStateSelected];

        [leftV addSubview:btn];
        btn.frame = CGRectMake(0, 50 * YScaleWidth + 60 * YScaleHeight + 66 * YScaleWidth * i, 180 * YScaleWidth, 52 * YScaleWidth);
        
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(caozuoClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 0){
            [self caozuoClick:btn];
        }
    }
    
    
    rightV = [UIView new];
    [midV addSubview:rightV];
    rightV.backgroundColor = WhiteColor;
    rightV.sd_layout.rightEqualToView(midV).bottomEqualToView(midV).topEqualToView(midV).leftSpaceToView(leftV, 0);
    
    
    [self setupView1];
}

//购买方案
- (void)setupView1{
    goumaiV = [UIView new];
    goumaiV.backgroundColor = kbackColor;
    [rightV addSubview:goumaiV];
    goumaiV.sd_layout.centerXEqualToView(rightV).centerYEqualToView(rightV).widthIs(806 * YScaleWidth).heightIs(600 * YScaleHeight);
    
    UIImageView *hintimg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon1"]];
    [goumaiV addSubview:hintimg1];
    hintimg1.sd_layout.leftSpaceToView(goumaiV, 53 * YScaleWidth).widthIs(20 * YScaleWidth).heightEqualToWidth();
    
    UILabel *hintL1 = [UILabel new];
    hintL1.text = @"可支持两台设备同时登录";
    hintL1.textColor = [JKUtil getColor:@"FF0000"];
    hintL1.font = YSystemFont(18 * YScaleWidth);
    [goumaiV addSubview:hintL1];
    hintL1.sd_layout.leftSpaceToView(hintimg1, 10 * YScaleWidth).centerYEqualToView(hintimg1).widthIs(300 * YScaleWidth).heightIs(25 * YScaleWidth);

    UIImageView *hintimg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon2"]];
    [goumaiV addSubview:hintimg2];
    hintimg2.sd_layout.leftSpaceToView(goumaiV, 53 * YScaleWidth).topSpaceToView(hintimg1, 9 * YScaleHeight).widthIs(20 * YScaleWidth).heightEqualToWidth();
    
    UILabel *hintL2 = [UILabel new];
    hintL2.text = @"没有虚折扣价，欢迎全网比效果比价";
    hintL2.textColor = [JKUtil getColor:@"FF0000"];
    hintL2.font = YSystemFont(18 * YScaleWidth);
    [goumaiV addSubview:hintL2];
    hintL2.sd_layout.leftSpaceToView(hintimg2, 10 * YScaleWidth).centerYEqualToView(hintimg2).widthIs(300 * YScaleWidth).heightIs(25 * YScaleWidth);

    UIView *topV = [UIView new];
    topV.backgroundColor = [JKUtil getColor:@"EEF8FF"];
    [goumaiV addSubview:topV];
    topV.sd_layout.leftEqualToView(goumaiV).rightEqualToView(goumaiV).heightIs(60 * YScaleWidth);
    
    NSArray *shangArr = @[@"1580个",@"3160个",@"1500个",@"不限次数"];
    NSArray *xiaArr = @[@"部编版汉字",@"常用词语",@"创意字卡",@"重新免费学习"];

    
    for (int j = 0; j < shangArr.count; j++) {
        UIView *vv = [UIView new];
        vv.backgroundColor = [JKUtil getColor:@"EEF8FF"];
        [topV addSubview:vv];
        vv.frame = CGRectMake(53 * YScaleWidth + 186 * YScaleWidth * (j % 4), 9 * YScaleWidth, 144 * YScaleWidth, 42 * YScaleWidth);
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"card%i",j]]];
        [vv addSubview:img];
        img.sd_layout.leftEqualToView(vv).centerYEqualToView(vv).widthIs(42 * YScaleWidth).heightEqualToWidth();
        
        UILabel *shangL = [UILabel new];
        shangL.text = shangArr[j];
        shangL.textColor = [JKUtil getColor:@"677A9F"];
        shangL.font = YSystemFont(16 * YScaleWidth);
        [vv addSubview:shangL];
        shangL.sd_layout.leftSpaceToView(img, 10 * YScaleWidth).topEqualToView(img).rightEqualToView(vv).heightIs(22 * YScaleWidth);
        
        UILabel *xiaL = [UILabel new];
        xiaL.text = xiaArr[j];
        xiaL.textColor = chuziColor;
        xiaL.font = YSystemFont(12 * YScaleWidth);
        [vv addSubview:xiaL];
        xiaL.sd_layout.leftSpaceToView(img, 10 * YScaleWidth).bottomEqualToView(img).rightEqualToView(vv).heightIs(22 * YScaleWidth);

    }
    
    UIView *zhongjianV = [UIView new];
    zhongjianV.backgroundColor = ClearColor;
    [goumaiV addSubview:zhongjianV];
    zhongjianV.sd_layout.centerXEqualToView(goumaiV).widthIs(700 * YScaleWidth).heightIs(178 * thisScale);
    
    NSArray *nameArr = @[@"永久卡",@"年卡",@"月卡"];
    NSArray *monArr = @[@"68",@"45",@"8"];
    NSArray *shixiaoArr = @[@"终身有效",@"自动订阅",@"自动订阅"];
    
    CGFloat margin = (700 * YScaleWidth - 600 * thisScale)/2.0;
    for (int i = 0; i < nameArr.count; i++) {
        UIView *v = [UIView new];
        [zhongjianV addSubview:v];
        v.layer.borderColor = [JKUtil getColor:@"C6D9FF"].CGColor;
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = 4;
        v.layer.masksToBounds = YES;
        v.backgroundColor = WhiteColor;
        v.frame = CGRectMake((200 * thisScale + margin) * i, 0, 200 * thisScale, 178 * thisScale);
        
        UILabel *nameL = [UILabel new];
        nameL.text = nameArr[i];
        nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size: 26 * thisScale];
        nameL.textColor = [JKUtil getColor:@"677A9F"];
        [v addSubview:nameL];
        nameL.backgroundColor = [JKUtil getColor:@"EEF8FF"];
        nameL.layer.cornerRadius = 4;
        nameL.layer.masksToBounds = YES;
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.sd_layout.leftEqualToView(v).topEqualToView(v).rightEqualToView(v).heightIs(62 * thisScale);
        
        
        NSString *monS = monArr[i];
        UILabel *monL = [UILabel new];
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",monS]];
        
//        [attributedStr addAttribute:NSFontAttributeName
//                              value:[UIFont systemFontOfSize:30 * thisScale]
//                              range:NSMakeRange(0, 1)];

//        [attributedStr addAttribute:NSFontAttributeName
//                              value:[UIFont systemFontOfSize:60 * thisScale]
//                              range:NSMakeRange(1, monS.length)];
         
        
        //富文本的属性通过字典的形式传入
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont fontWithName:@"Helvetica-Bold" size:30 * thisScale],NSFontAttributeName,//字体
                                       nil];
        
        NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont fontWithName:@"Helvetica-Bold" size:60 * thisScale],NSFontAttributeName,//字体
                                       nil];

        [attributedStr addAttributes:attributeDict range:NSMakeRange(0, 1)];
        [attributedStr addAttributes:attributeDict1 range:NSMakeRange(1, monS.length)];

        monL.attributedText = attributedStr;
        monL.textAlignment = NSTextAlignmentCenter;
        [v addSubview:monL];
        monL.sd_layout.leftSpaceToView(v, 0).topSpaceToView(nameL, 8 * thisScale).rightSpaceToView(v, 30 * thisScale).heightIs(70 * thisScale);
        
//        _monL = [NudeIn make:^(NUDTextMaker *make) {
//            make.text(@"￥").fontName(@"Helvetica-Bold",30 * thisScale).color(chuziColor).attach();
//            make.text(monArr[i]).fontName(@"Helvetica-Bold",60 * thisScale).color(chuziColor).attach();
//        }];
//        _monL.textAlignment = NSTextAlignmentCenter;
//        [v addSubview:_monL];
//        _monL.userInteractionEnabled = YES;
//        _monL.sd_layout.centerXEqualToView(v).topSpaceToView(nameL, 8 * thisScale).widthIs(200 * thisScale).heightIs(70 * thisScale);
        
        UILabel *detailL = [UILabel new];
        detailL.text = shixiaoArr[i];
        detailL.font = YSystemFont(14 * thisScale);
        detailL.textColor = chuziColor;
        [v addSubview:detailL];
        detailL.textAlignment = NSTextAlignmentCenter;
        detailL.sd_layout.leftEqualToView(v).bottomSpaceToView(v, 5 * thisScale).rightEqualToView(v).heightIs(20 * thisScale);
        
        UIView *lineV = [UIView new];
        lineV.backgroundColor = klcolor;
        [v addSubview:lineV];
        lineV.sd_layout.centerXEqualToView(v).widthIs(180 * thisScale).heightIs(1).bottomSpaceToView(detailL, 5 * thisScale);

        v.userInteractionEnabled = YES;
        v.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [v addGestureRecognizer:tap];

        if(i == 0){
            [self tapAction:tap];
        }
        
    }

    
    NoHighBtn *payBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:kocolor];
    [payBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    payBtn.titleLabel.font = YSystemFont(24 * thisScale);
    payBtn.layer.cornerRadius = 30 * thisScale;
    payBtn.layer.masksToBounds = YES;
    [goumaiV addSubview:payBtn];
    payBtn.sd_layout.centerXEqualToView(goumaiV).widthIs(446 * thisScale).heightIs(60 * thisScale);
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = klcolor;
    [goumaiV addSubview:lineV];
    lineV.sd_layout.centerXEqualToView(goumaiV).widthIs(760 * YScaleWidth).heightIs(1);

    
///iPad  iPhone适配
    if(isPad){
        lineV.hidden = NO;
        payBtn.sd_layout.bottomSpaceToView(goumaiV, 48 * YScaleHeight);
        lineV.sd_layout.topSpaceToView(zhongjianV, 49 * YScaleHeight);
        
        hintimg1.sd_layout.topSpaceToView(goumaiV, 32 * YScaleHeight);
        topV.sd_layout.topSpaceToView(hintL2, 31 * YScaleHeight);
        zhongjianV.sd_layout.topSpaceToView(topV, 50 * YScaleHeight);
    }
    else{
        
        if(Height_Bottom){
            lineV.hidden = YES;
            payBtn.sd_layout.bottomSpaceToView(goumaiV, 10 * YScaleHeight);
        }
        else{
            lineV.hidden = NO;
            lineV.sd_layout.topSpaceToView(zhongjianV, 49 * YScaleHeight);
            payBtn.sd_layout.bottomSpaceToView(goumaiV, 48 * YScaleHeight);
        }
        
        hintimg1.sd_layout.topSpaceToView(goumaiV, 16 * YScaleHeight);
        topV.sd_layout.topSpaceToView(hintL2, 15 * YScaleHeight);
        zhongjianV.sd_layout.topSpaceToView(topV, 25 * YScaleHeight);

    }


    
    
    /*
    UIImageView *hintimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconhint"]];
    [goumaiV addSubview:hintimg];
    hintimg.sd_layout.leftSpaceToView(goumaiV, 24 * YScaleWidth).topSpaceToView(goumaiV, 32 * YScaleHeight).widthIs(20 * YScaleWidth).heightEqualToWidth();
    
    UILabel *hintL = [UILabel new];
    hintL.text = @"可支持两台设备同时登录";
    hintL.textColor = [JKUtil getColor:@"FF0000"];
    hintL.font = YSystemFont(20 * YScaleWidth);
    [goumaiV addSubview:hintL];
    hintL.sd_layout.leftSpaceToView(hintimg, 10 * YScaleWidth).centerYEqualToView(hintimg).widthIs(300 * YScaleWidth).heightIs(28 * YScaleWidth);
    

    NoHighBtn *payBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:kocolor];
    [payBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    payBtn.titleLabel.font = YSystemFont(24 * YScaleWidth);
    payBtn.layer.cornerRadius = 30 * YScaleWidth;
    payBtn.layer.masksToBounds = YES;
    [goumaiV addSubview:payBtn];
    payBtn.sd_layout.centerXEqualToView(goumaiV).bottomSpaceToView(goumaiV, 68 * YScaleHeight).widthIs(446 * YScaleWidth).heightIs(60 * YScaleWidth);
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = klcolor;
    [goumaiV addSubview:lineV];
    lineV.sd_layout.centerXEqualToView(goumaiV).bottomSpaceToView(payBtn, 51 * YScaleHeight).widthIs(760 * YScaleWidth).heightIs(1);
    
    NSArray *nameA = @[@"月卡会员：",@"永久会员："];
    NSArray *shangArr = @[@"1580个",@"3160个",@"1500个",@"不限次数"];
    NSArray *xiaArr = @[@"部编版汉字",@"常用词语",@"创意字卡",@"重新免费学习"];
    NSArray *numArr = @[@"8",@"45"];
    
    for (int i = 0; i < 2; i++) {
        UIView *v = [UIView new];
        [goumaiV addSubview:v];
        v.layer.borderColor = [JKUtil getColor:@"C6D9FF"].CGColor;
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = 4;
        v.layer.masksToBounds = YES;
        v.backgroundColor = WhiteColor;
        v.frame = CGRectMake(24 * YScaleWidth + 384 * YScaleWidth * i, 80 * YScaleHeight, 364 * YScaleWidth, 300 * YScaleHeight);
        
        UILabel *nameL = [UILabel new];
        nameL.text = nameA[i];
        nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size: 32 * YScaleHeight];
        nameL.textColor = [JKUtil getColor:@"2E4476"];
        [v addSubview:nameL];
        nameL.sd_layout.leftSpaceToView(v, 24 * YScaleWidth).topSpaceToView(v, 32 * YScaleHeight).widthIs(210 * YScaleWidth).heightIs(45 * YScaleHeight);
        
        _monL = [NudeIn make:^(NUDTextMaker *make) {
            make.text(@"￥").fontName(@"Helvetica-Bold",30 * YScaleHeight).color(kocolor).attach();
            make.text(numArr[i]).fontName(@"Helvetica-Bold",60 * YScaleHeight).color(kocolor).attach();
        }];
        _monL.textAlignment = NSTextAlignmentRight;
        [v addSubview:_monL];
        _monL.sd_layout.rightSpaceToView(v, 23 * YScaleWidth).topSpaceToView(v, 15 * YScaleHeight).widthIs(100 * YScaleWidth).heightIs(84 * YScaleHeight);

        
        v.userInteractionEnabled = YES;
        v.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [v addGestureRecognizer:tap];

        if(i == 0){
            [self tapAction:tap];
        }
        
        UIView *lineVV = [UIView new];
        lineVV.backgroundColor = klcolor;
        [v addSubview:lineVV];
        lineVV.sd_layout.centerXEqualToView(v).topSpaceToView(v, 83 * YScaleHeight).widthIs(292 * YScaleWidth).heightIs(1);
        
        for (int j = 0; j < 4; j++) {
            UIView *vv = [UIView new];
            vv.backgroundColor = [JKUtil getColor:@"EEF8FF"];
            vv.layer.cornerRadius = 4;
            vv.layer.masksToBounds = YES;
            [v addSubview:vv];
            vv.frame = CGRectMake(24 * YScaleWidth + 164 * YScaleWidth * (j % 2), 119 * YScaleHeight + 70 * YScaleHeight * (j / 2), 152 * YScaleWidth, 60 * YScaleHeight);
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"card%i",j]]];
            [vv addSubview:img];
            img.sd_layout.leftSpaceToView(vv, 8 * YScaleWidth).centerYEqualToView(vv).widthIs(42 * YScaleHeight).heightEqualToWidth();
            
            UILabel *shangL = [UILabel new];
            shangL.text = shangArr[j];
            shangL.textColor = [JKUtil getColor:@"677A9F"];
            shangL.font = YSystemFont(16 * YScaleHeight);
            [vv addSubview:shangL];
            shangL.sd_layout.leftSpaceToView(img, 10 * YScaleWidth).topEqualToView(img).rightEqualToView(vv).heightIs(22 * YScaleHeight);
            
            UILabel *xiaL = [UILabel new];
            xiaL.text = xiaArr[j];
            xiaL.textColor = [JKUtil getColor:@"2E4476"];
            xiaL.font = YSystemFont(12 * YScaleHeight);
            [vv addSubview:xiaL];
            xiaL.sd_layout.leftSpaceToView(img, 10 * YScaleWidth).bottomEqualToView(img).rightEqualToView(vv).heightIs(22 * YScaleHeight);

            
        }

        
        
    }
    */
    
}

//识字情况
- (void)setupView2{
    qingkuangV = [UIView new];
    qingkuangV.backgroundColor = WhiteColor;
    [rightV addSubview:qingkuangV];
    qingkuangV.sd_layout.leftEqualToView(rightV).rightEqualToView(rightV).topEqualToView(rightV).bottomEqualToView(rightV);
    
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcardpre"]];
    [qingkuangV addSubview:leftImg];
    leftImg.sd_layout.leftSpaceToView(qingkuangV, 94 * YScaleWidth).topSpaceToView(qingkuangV, 10 * YScaleHeight).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    NSInteger yixuexiCounts = [YUserDefaults integerForKey:khas_learn_num];
    NSInteger weixuexiCounts = dataArr.count - yixuexiCounts;

    leftL = [UILabel new];
    leftL.text = [NSString stringWithFormat:@"已学习（%ld个）",yixuexiCounts];;
    leftL.textColor = [JKUtil getColor:@"3F4D6C"];
    leftL.font = YSystemFont(12 * YScaleWidth);
    [qingkuangV addSubview:leftL];
    leftL.sd_layout.leftSpaceToView(leftImg, 10 * YScaleWidth).centerYEqualToView(leftImg).widthIs(104 * YScaleWidth).heightIs(17 * YScaleWidth);
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcarddefault"]];
    [qingkuangV addSubview:rightImg];
    rightImg.sd_layout.leftSpaceToView(leftImg, 110 * YScaleWidth).centerYEqualToView(leftImg).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    rightL = [UILabel new];
    rightL.text = [NSString stringWithFormat:@"未学习（%ld个）",weixuexiCounts];;
    rightL.textColor = [JKUtil getColor:@"3F4D6C"];
    rightL.font = YSystemFont(12 * YScaleWidth);
    [qingkuangV addSubview:rightL];
    rightL.sd_layout.leftSpaceToView(rightImg, 10 * YScaleWidth).centerYEqualToView(leftImg).widthIs(200).heightIs(17 * YScaleWidth);
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(112 * YScaleWidth, 112 * YScaleWidth);
    layout.minimumInteritemSpacing = 30 * YScaleWidth;
    layout.minimumLineSpacing = 30 * YScaleWidth;

    
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(17 * YScaleWidth, 20 * YScaleHeight + 38 * YScaleWidth, 806 * YScaleWidth, 572 * YScaleHeight) collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(50 * YScaleWidth, 82 * YScaleWidth, 50 * YScaleWidth, 44 * YScaleWidth);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = FALSE;
    collectionView.backgroundColor = kbackColor;
    [collectionView registerClass:[WordCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([WordCollectionViewCell class])];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [qingkuangV addSubview:collectionView];
        
    NSInteger numCounts = dataArr.count / 10;

    for (int i = 0; i < numCounts; i++) {
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%d",(i + 1) * 10];
        label.textColor = xuanziColor;
        label.alpha = 0.3;
        label.font = YSystemFont(20 * YScaleWidth);
        label.textAlignment = NSTextAlignmentRight;
        
        [collectionView addSubview:label];
        label.frame = CGRectMake( - 74 * YScaleWidth, 184 * YScaleWidth + 284 * YScaleWidth * i, 50 * YScaleWidth, 28 * YScaleWidth);
        
    }

    
}


//联系客服
- (void)setupView3{
    kefuV = [UIView new];
    kefuV.backgroundColor = kbackColor;
    [rightV addSubview:kefuV];
    kefuV.sd_layout.centerXEqualToView(rightV).centerYEqualToView(rightV).widthIs(806 * YScaleWidth).heightIs(600 * YScaleHeight);
    
    UILabel *dixiaL = [UILabel new];
    dixiaL.text = @"联系方式：点击复制微信号， 打开微信添加客服为好友";
    dixiaL.font = YSystemFont(16 * YScaleWidth);
    dixiaL.textColor = [JKUtil getColor:@"B0BBD4"];
    dixiaL.textAlignment = NSTextAlignmentCenter;
    [kefuV addSubview:dixiaL];
    dixiaL.sd_layout.bottomSpaceToView(kefuV, 20 * YScaleHeight).widthIs(460 * YScaleWidth).centerXEqualToView(kefuV).heightIs(26 * YScaleWidth);
    
    UILabel *shangL = [UILabel new];
    shangL.textColor = xuanziColor;
    shangL.text = @"服务时间：工作日8:30-17:30";
    shangL.backgroundColor = kbackColor;
    shangL.font = YSystemFont(20 * YScaleWidth);
    shangL.textAlignment = NSTextAlignmentCenter;
    shangL.layer.cornerRadius = 4;
    shangL.layer.borderColor = xuanziColor.CGColor;
    shangL.layer.borderWidth = 1;
    [kefuV addSubview:shangL];
    shangL.sd_layout.centerXEqualToView(kefuV).topSpaceToView(kefuV, 200 * YScaleHeight).widthIs(356 * YScaleWidth).heightIs(50 * YScaleWidth);
    
    UIView *midV = [UIView new];
    midV.backgroundColor = [JKUtil getColor:@"E9F1F6"];
    midV.layer.cornerRadius = 4;
    [kefuV addSubview:midV];
    midV.sd_layout.topSpaceToView(shangL, 20 * YScaleHeight).widthIs(356 * YScaleWidth).heightIs(50 * YScaleWidth).centerXEqualToView(kefuV);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconwechat"]];
    [midV addSubview:img];
    img.sd_layout.leftSpaceToView(midV, 33 * YScaleWidth).centerYEqualToView(midV).widthIs(40 * YScaleWidth).heightIs(32 * YScaleWidth);
    
    UILabel *detailL = [UILabel new];
    detailL.text = @"客服：123456789";
    detailL.textAlignment = NSTextAlignmentCenter;
    detailL.textColor = [JKUtil getColor:@"616E8D"];
    detailL.font = YSystemFont(20 * YScaleWidth);
    [midV addSubview:detailL];
    detailL.sd_layout.centerYEqualToView(midV).centerXEqualToView(midV).widthIs(200 * YScaleWidth).heightIs(28 * YScaleWidth);
    
    
    UIImageView *imgg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconcopy"]];
    [midV addSubview:imgg];
    imgg.sd_layout.rightSpaceToView(midV, 33 * YScaleWidth).centerYEqualToView(midV).widthIs(28 * YScaleWidth).heightEqualToWidth();

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [midV addSubview:btn];
    btn.sd_layout.rightEqualToView(midV).topEqualToView(midV).bottomEqualToView(midV).widthIs(60 * YScaleWidth);
    
}

//关于我们
- (void)setupView4{
    aboutV = [UIView new];
    aboutV.backgroundColor = kbackColor;
    [rightV addSubview:aboutV];
    aboutV.sd_layout.centerXEqualToView(rightV).centerYEqualToView(rightV).widthIs(806 * YScaleWidth).heightIs(600 * YScaleHeight);
    
    NSArray *nameArr = @[@"用户协议",@"隐私协议",@"证照信息"];
    for (int i = 0; i < nameArr.count; i++) {
        NoHighBtn *b = [NoHighBtn buttonWithType:UIButtonTypeCustom];
        [b setTitle:nameArr[i] forState:UIControlStateNormal];
        b.titleLabel.font = YSystemFont(18 * YScaleWidth);
        b.layer.cornerRadius = 4;
        [b setBackgroundColor:ClearColor];
        [b setTitleColor:xuanziColor forState:UIControlStateNormal];
        b.layer.borderColor = xuanziColor.CGColor;
        b.layer.borderWidth = 1;
        b.layer.masksToBounds = YES;
        [aboutV addSubview:b];
        b.frame = CGRectMake(57 * YScaleWidth + 236 * YScaleWidth * i, 44 * YScaleHeight, 220 * YScaleWidth, 50 * YScaleWidth);
        b.tag = i;
        [b addTarget:self action:@selector(aboutClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = klcolor;
    [aboutV addSubview:lineV];
    lineV.sd_layout.centerXEqualToView(aboutV).bottomSpaceToView(aboutV, 248 * YScaleWidth).widthIs(772 * YScaleWidth).heightIs(1);
    
    UILabel *huanbanL = [UILabel new];
    huanbanL.text = @"滑板车系列产品";
    huanbanL.font = YSystemFont(24 * YScaleWidth);
    huanbanL.textColor = chuziColor;
    [aboutV addSubview:huanbanL];
    huanbanL.sd_layout.leftSpaceToView(aboutV, 34 * YScaleWidth).widthIs(175 * YScaleWidth).heightIs(33 * YScaleWidth).topSpaceToView(lineV, 19 * YScaleWidth);
    
    UIImageView *banImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [aboutV addSubview:banImg];
    banImg.sd_layout.leftEqualToView(huanbanL).topSpaceToView(huanbanL, 20 * YScaleWidth).widthIs(100 * YScaleWidth).heightEqualToWidth();
    
    NoHighBtn *b = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [b setTitle:@"下载" forState:UIControlStateNormal];
    b.titleLabel.font = YSystemFont(18 * YScaleWidth);
    b.layer.cornerRadius = 4;
    [b setBackgroundColor:ClearColor];
    [b setTitleColor:korangeColor forState:UIControlStateNormal];
    b.layer.borderColor = korangeColor.CGColor;
    b.layer.borderWidth = 1;
    b.layer.masksToBounds = YES;
    [aboutV addSubview:b];
    b.sd_layout.leftEqualToView(banImg).topSpaceToView(banImg, 16 * YScaleWidth).widthIs(100 * YScaleWidth).heightIs(40 * YScaleWidth);
    [b addTarget:self action:@selector(xiazaiClick) forControlEvents:UIControlEventTouchUpInside];

    
}



#pragma mark - click
- (void)xiazaiClick{
    //滑板车背诵  id  1528921153
    
    NSString * url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?mt=8",@"1528921153"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)aboutClick:(UIButton *)btn{
    NSInteger aboutIndex = btn.tag;
    
    _YLwkwebView = [[WKWebView alloc]init];
    
    _YLwkwebView.backgroundColor = kstandardColor;
    _YLwkwebView.navigationDelegate = self;
    _YLwkwebView.UIDelegate = self;

    
    if(aboutIndex == 0){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yonghuxieyi" ofType:@"html" inDirectory:@"yonghuxieyi"];

        [_YLwkwebView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];

    }
    else if(aboutIndex == 1){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yinsixieyi" ofType:@"html" inDirectory:@"yinsixieyi"];

        [_YLwkwebView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    }
    else{
        [_YLwkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://id-photo-verify.com/leqi/"]]];
    }
    

    
    

    [aboutV addSubview:_YLwkwebView];
    _YLwkwebView.sd_layout.leftSpaceToView(aboutV, 14 * YScaleHeight).rightSpaceToView(aboutV, 14 * YScaleHeight).topSpaceToView(aboutV, 14 * YScaleHeight).bottomSpaceToView(aboutV, 14 * YScaleHeight);

    
    anothercloseBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [anothercloseBtn setBackgroundImage:[UIImage imageNamed:@"elementclosee"] forState:UIControlStateNormal];
    [aboutV addSubview:anothercloseBtn];
    anothercloseBtn.sd_layout.rightSpaceToView(aboutV, 24 * YScaleHeight).topSpaceToView(aboutV, 24 * YScaleHeight).widthIs(36 * YScaleWidth).heightEqualToWidth();
    [anothercloseBtn addTarget:self action:@selector(anothercloseClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)anothercloseClick{
    [_YLwkwebView removeFromSuperview];
    [anothercloseBtn removeFromSuperview];
    
    _YLwkwebView = nil;
    anothercloseBtn = nil;
}

- (void)back{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)caozuoClick:(UIButton *)Btn{
    NSInteger btnIndex = Btn.tag - 1000;
    
    if(Btn != selectedBtn){
        
        if(!Btn.selected){
            Btn.selected = YES;
            selectedBtn.selected = NO;
            
            //购买方案
            if(btnIndex == 0){
                goumaiV.hidden = NO;
                qingkuangV.hidden = YES;
                kefuV.hidden = YES;
                aboutV.hidden = YES;
            }
            
            //识字情况
            else if(btnIndex == 1){
                if(!qingkuangV){
                    [self setupView2];
                }
                
                goumaiV.hidden = YES;
                qingkuangV.hidden = NO;
                kefuV.hidden = YES;
                aboutV.hidden = YES;
            }
            
            //联系客服
            else if(btnIndex == 2){
                if(!kefuV){
                    [self setupView3];
                }
                
                goumaiV.hidden = YES;
                qingkuangV.hidden = YES;
                kefuV.hidden = NO;
                aboutV.hidden = YES;
            }
            
            //关于我们
            else if(btnIndex == 3){
                if(!aboutV){
                    [self setupView4];
                }
                
                goumaiV.hidden = YES;
                qingkuangV.hidden = YES;
                kefuV.hidden = YES;
                aboutV.hidden = NO;
            }

            
        }
        
        selectedBtn = Btn;
    }
    
}

//换名字点击
- (void)changeClick{
    YLogFunc
}

//支付点击
- (void)payClick{
    YLogFunc
    
    blackV.hidden = NO;
    closeBtn.hidden = NO;
    dengluV.hidden = NO;
}

- (void)closeClick{
    blackV.hidden = YES;
    closeBtn.hidden = YES;
    dengluV.hidden = YES;

    [self.view endEditing:YES];
}

//获取验证码
- (void)huoquclick{
    NSString *warnS = [NSString valiMobile:mobileTextF.text];
    if(warnS.length){
//        [self.view makeToast:warnS duration:2 position:@"center"];
        [SVProgressHUD showErrorWithStatus:warnS];
        return;
    }
    
    huoquBtn.enabled = NO;
    [self setRestTime];

    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = mobileTextF.text;
    
    YLog(@"%@",[NSString getBaseUrl:_URL_code withparam:param])
    
//    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [YLHttpTool GET:_URL_code parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){


        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];

    
    

}

- (void)setRestTime{
    //修改时间效果
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->huoquBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self->huoquBtn setTitleColor:[JKUtil getColor:@"1665FF"] forState:UIControlStateNormal];
                self->huoquBtn.enabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"重新发送（%.2ds）", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self->huoquBtn.enabled = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self->huoquBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
                [self->huoquBtn setTitleColor: [JKUtil getColor:@"B6B7BA"] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//登录
- (void)dengluClick{
    NSString *warnS = [NSString valiMobile:mobileTextF.text];
    if(warnS.length){
//        [self.view makeToast:warnS duration:2 position:@"center"];
        [SVProgressHUD showErrorWithStatus:warnS];
        return;
    }
    
    
    if(!codeTextF.text.length){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;;
    }
    
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = mobileTextF.text;
    param[@"captcha"] = codeTextF.text;
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
    
    YLog(@"%@",[NSString getBaseUrl:_URL_login withparam:param])
        
    [YLHttpTool POST:_URL_login parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){
            
            NSDictionary *d = dic[@"data"];
            [YUserDefaults setObject:d[@"name"] forKey:kusername];
            [YUserDefaults setObject:d[@"token"] forKey:ktoken];
            [YUserDefaults setBool:[d[@"is_member"] boolValue] forKey:kis_member];
            
            self->nameL.text = [YUserDefaults objectForKey:kusername];
            if([YUserDefaults boolForKey:kis_member]){
                self->vipImg.image = [UIImage imageNamed:@"vip"];
                self->vipL.text = @"有效期至2021.11.30";
                self->vipL.textColor = [JKUtil getColor:@"FF6112"];

            }
            else{
                self->vipImg.image = [UIImage imageNamed:@"notvip"];
                self->vipL.text = @"当前未开通会员";
                self->vipL.textColor = [JKUtil getColor:@"A6A6A6"];
            }
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];
}

//用户协议
- (void)xieyiclick{
    [self makewebViewWithurl:@"yonghuxieyi"];
}

//隐私政策
- (void)yinsiclick{
    [self makewebViewWithurl:@"yinsixieyi"];
}

- (void)makewebViewWithurl:(NSString *)xieyidizhi{
    _YLwkwebView = [[WKWebView alloc]init];
    _YLwkwebView.backgroundColor = kstandardColor;
    _YLwkwebView.navigationDelegate = self;
    _YLwkwebView.UIDelegate = self;

//    [_YLwkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:xieyidizhi ofType:@"html" inDirectory:xieyidizhi];

    [_YLwkwebView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];

    
    [dengluV addSubview:_YLwkwebView];
    _YLwkwebView.sd_layout.leftEqualToView(dengluV).rightEqualToView(dengluV).topEqualToView(dengluV).bottomEqualToView(dengluV);

    
    anothercloseBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [anothercloseBtn setBackgroundImage:[UIImage imageNamed:@"elementclose"] forState:UIControlStateNormal];
    [backV addSubview:anothercloseBtn];
    anothercloseBtn.sd_layout.leftSpaceToView(backV, (YScreenW - 620 * thisScale) * 0.5 + 620 * thisScale - 67 * thisScale).topSpaceToView(backV, (YScreenH - 516 * thisScale) * 0.5 - 27 * thisScale).widthIs(94 * thisScale).heightEqualToWidth();
    [anothercloseBtn addTarget:self action:@selector(anothercloseClick) forControlEvents:UIControlEventTouchUpInside];
}

//复制
- (void)copyClick{
    YLogFunc
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIView *v = tap.view;
    selectIndex = v.tag;
    
    if(v != selectedV){
        
        v.layer.borderColor = xuanziColor.CGColor;
        
        UILabel *label = v.subviews.firstObject;
        label.textColor = WhiteColor;
        label.backgroundColor = xuanziColor;
        
        UILabel *monlabel = v.subviews[1];
        monlabel.textColor = xuanziColor;
        
        UILabel *xial = v.subviews[2];
        xial.textColor = xuanziColor;

        
        if(selectedV){
            UILabel *selectL = selectedV.subviews.firstObject;
            selectL.textColor = chuziColor;
            selectL.backgroundColor = [JKUtil getColor:@"EEF8FF"];
            
            UILabel *monlabell = selectedV.subviews[1];
            monlabell.textColor = chuziColor;
            
            UILabel *xiall = selectedV.subviews[2];
            xiall.textColor = chuziColor;

            
            selectedV.layer.borderColor = [JKUtil getColor:@"C6D9FF"].CGColor;
        }
        
        selectedV = v;
        
    }
}

#pragma mark ————— collection代理方法 —————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WordCollectionViewCell class]) forIndexPath:indexPath];
    cell.mod = dataArr[indexPath.item];
    return cell;
}

//定义每个UICollectionView 的边距
//-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    //边距的顺序是 上左下右
//  return UIEdgeInsetsMake(0,0,0,30 * YScaleWidth);
//}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AllModel *selectedMod = dataArr[indexPath.item];

    if(selectedMod.is_learn){

        //网络请求数据
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
        param[@"word"] = selectedMod.word;
        param[@"id"] = [NSNumber numberWithInteger:selectedMod.ID];

        YLog(@"%@",[NSString getBaseUrl:_URL_fun withparam:param])


        [YLHttpTool POST:_URL_fun parameters:param progress:^(NSProgress *progress) {

        } success:^(id dic) {

            if([dic[@"code"] integerValue] == 200){

                NSDictionary *dict = dic[@"data"];


                FunViewController *vc = [[FunViewController alloc] init];
                vc.selectedMod = selectedMod;
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                vc.xuanzhongIndex = indexPath.item;

                vc.combine_words = dict[@"combine_words"];
                vc.similar_words = dict[@"similar_words"];
    //            vc.word_image = dict[@"word_image"];
    //            vc.word_video = dict[@"word_video"];


                vc.callBack = ^(NSInteger xuanzhongIndex) {

                };

                [self presentViewController:vc animated:YES completion:^{

                }];




            }

            else{
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                [SVProgressHUD dismissWithDelay:1.0];
            }

            YLog(@"%@",dic);
        } failure:^(NSError *error) {
            //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
        }];


    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
