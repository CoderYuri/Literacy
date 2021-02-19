//
//  MainViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/16.
//

#import "MainViewController.h"
#import "MainCollectionViewCell.h"
#import "WordsViewController.h"
#import "MeViewController.h"

#import "UIImage+GIF.h"
#import "YFGIFImageView.h"

#define lightVWidth (256 * YScaleHeight)
#define lightVHeight (417 * YScaleHeight)
#define lightVMargin (110 * YScaleHeight)
#define chushicenterX (183 * YScaleHeight)
//183
//630+43

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    UIView *backV;
    
    UIImageView *bgImg;
//    UIImageView *vipImg;
    
    UILabel *nameL;
    UILabel *vipL;
    
    UIImageView *IconVipImg;
    
    YYAnimatedImageView *gifView;
    UICollectionView *collectionView;
    UIScrollView *scrollV;
    NSMutableArray *dataArr;
    
    //gif的x值
    CGFloat gifCenterX;
    CGFloat lastOffSetX;
    
    NSInteger selectIndex;
    BOOL ifNoanimation;
    
    
    CGFloat thisScale;
    UIView *jiazhangV;
    UIView *BlackJZV;
    UIView *zhongwenV;
    UIView *shuziV;
    NSMutableArray *rightArr;
    NSInteger successCounts;

    //是否移动中
    BOOL ifyidong;
    //是否能移动
    BOOL ifcanYidong;

    //家长页 抖动
    BOOL ifjiazhangdoudong;
    
    //人物头像
    UIImageView *userIcon;
    
    //提示图
    LOTAnimationView *tishiAnimation;
    
    UIView *xuexiBackV;
    UIImageView *zhongImg;
    UILabel *zishuNumL;
    
    //gif加载
    UIView *LoadingBackV;
    YYAnimatedImageView *loadingView;
    
    FunViewController *fuxiVc;
}
//chuqutaijiuleyaokougongqiande
@property (nonatomic,strong) NudeIn *numLabel;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerController *backgroundplayer;

@end

@implementation MainViewController

//播放音频
- (void)bofangwithUrl:(NSArray *)urlArr{
    if(self.player){
        [self.player stop];
        self.player = nil;
    }
    
    self.player = [ZFPlayerController playerWithPlayerManager: [[ZFAVPlayerManager alloc] init] containerView:[UIView new]];
    
    ZFPlayerControlView *v = [ZFPlayerControlView new];
    self.player.controlView = v;
    [v showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModePortrait];


    self.player.assetURLs = urlArr;
    [self.player playTheIndex:0];
}



- (void)beijingyinyue{
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"一起旅行" ofType:@"mp3"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    
    self.backgroundplayer = [ZFPlayerController playerWithPlayerManager: [[ZFAVPlayerManager alloc] init] containerView:[UIView new]];
    
    ZFPlayerControlView *v = [ZFPlayerControlView new];
    self.backgroundplayer.controlView = v;
    [v showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModePortrait];
    
    self.backgroundplayer.assetURLs = @[localVideoUrl];
    [self.backgroundplayer playTheIndex:0];

    self.backgroundplayer.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [self.backgroundplayer playTheIndex:0];
    };

}
//zhutouzaici
//获取字库
- (void)fetch{
    
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    if(arr.count){
        dataArr = [AllModel mj_objectArrayWithKeyValuesArray:arr];
        [self setupView];
    }
    
    /*
    else{
        
        [self loading];
        
        //网络请求数据
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
        YLog(@"%@",[NSString getBaseUrl:_URL_words withparam:param])
        
        [YLHttpTool GET:_URL_words parameters:param progress:^(NSProgress *progress) {
            
        } success:^(id dic) {
            YLog(@"%@",dic)

            [self removeLoading];

            if([dic[@"code"] integerValue] == 200){
                
                NSDictionary *d = dic[@"data"];
                NSArray *array = d[@"words"];
                self->dataArr = [AllModel mj_objectArrayWithKeyValuesArray:array];
                [YUserDefaults setObject:array forKey:kziKu];
                
                [YUserDefaults setInteger:[d[@"free_words_num"]integerValue] forKey:kfree_words_num];
                [YUserDefaults setInteger:[d[@"has_learn_num"] integerValue] forKey:khas_learn_num];

                [self setupView];

            }
            
        } failure:^(NSError *error) {
            [self removeLoading];
            //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
            if(error.code == -1009){
                NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"网络" ofType:@"mp3"];
                NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
                [self bofangwithUrl:@[localVideoUrl]];
                
                self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                    [self.player stop];
                    self.player = nil;
                };
            }

            yitianhuashuibantian
     buzhidaosmshihhuixiehao
        }];

        
    }
     */
}

//更新本地用户信息
- (void)fetchuserInfo{
    if(![YUserDefaults objectForKey:ktoken]){
        return;
    }
    
    
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    YLog(@"%@",[NSString getBaseUrl:_URL_userInfo withparam:param])
        
    [YLHttpTool POST:_URL_userInfo parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){
            NSDictionary *d = dic[@"data"];
            
            if([d[@"has_learn_num"] integerValue] != [YUserDefaults integerForKey:khas_learn_num]){
                           
                //重新赋值  已学习个数
                [YUserDefaults setInteger:[d[@"has_learn_num"] integerValue] forKey:khas_learn_num];

                [self setnumLwithstring];
                [self gengxingdeng];
            }
            
            YLog(@"%d",[YUserDefaults boolForKey:kis_member])
            
            if([d[@"is_member"] boolValue] != [YUserDefaults boolForKey:kis_member]){
                
                [YUserDefaults setBool:[d[@"is_member"] boolValue] forKey:kis_member];
                
                [self gengxingdeng];
            }
//yuri
            [YUserDefaults setObject:d[@"name"] forKey:kusername];
            [YUserDefaults setObject:d[@"expire_time"] forKey:kexpiretime];
            [YUserDefaults setBool:[d[@"has_purchase"] boolValue] forKey:khas_purchase];
            [YUserDefaults setObject:d[@"member_type"] forKey:kmembertype];
            [YUserDefaults setObject:d[@"member_type"] forKey:kmembertype];
            [YUserDefaults setInteger:[d[@"has_learn_num"] integerValue] forKey:khas_learn_num];

            [self setnumLwithstring];
            [self shouyeyemianrefresh];
//            joanna
        }
        
        else if ([dic[@"code"] integerValue] == 401){
            [SVProgressHUD showErrorWithStatus:@"您的账户已在第三台设备登录，请确认账户信息安全"];
            [SVProgressHUD dismissWithDelay:3];

            [self weidengluCaozuo];
        }
//paonaerqul
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    self.backgroundplayer.viewControllerDisappear = YES;

    if(self.player){
        [self.player stop];
        self.player = nil;
    }
    
    [self.backgroundplayer.currentPlayerManager pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.player.viewControllerDisappear = NO;
    self.backgroundplayer.viewControllerDisappear = NO;
    
    [self setnumLwithstring];
    [self fetchuserInfo];
    [self.backgroundplayer.currentPlayerManager play];
}

//首页数据刷新
- (void)shouyeyemianrefresh{
    if([YUserDefaults objectForKey:kusername]){
        
        self->nameL.text = [YUserDefaults objectForKey:kusername];
        if([YUserDefaults boolForKey:kis_member]){
//            self->vipImg.image = [UIImage imageNamed:@"vip"];
            
            YLog(@"---%ld---",[self expiretimeYear])
            
            vipL.hidden = YES;
            IconVipImg.hidden = NO;
            
            NSString *cardType = [YUserDefaults objectForKey:kmembertype];
            if([cardType isEqualToString:@"月卡"]){
                IconVipImg.image = [UIImage imageNamed:@"vipmonth"];

            }
            else if([cardType isEqualToString:@"年卡"]){
                IconVipImg.image = [UIImage imageNamed:@"vipyear"];

            }
            else if([cardType isEqualToString:@"永久"]){
                IconVipImg.image = [UIImage imageNamed:@"viplongest"];

            }

            

//            self->vipL.text = [NSString stringWithFormat:@"有效期至%@",[YUserDefaults objectForKey:kexpiretime]];
//
//            vipL.alpha = 1;
//            self->vipL.textColor = [JKUtil getColor:@"FF6112"];
            

        }
        else{
            vipL.hidden = NO;
            IconVipImg.hidden = YES;
            
//            self->vipImg.image = [UIImage imageNamed:@"notvip"];
            vipL.alpha = 0.8;
            self->vipL.textColor = [JKUtil getColor:@"17449C"];
            if([YUserDefaults boolForKey:khas_purchase]){
                self->vipL.text = @"您的会员已到期";
            }
            else{
                self->vipL.text = @"当前未开通会员";
            }

        }
    }
    

}

- (NSInteger)expiretimeYear{
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy.MM.dd";

    // 截止时间字符串格式
    NSString *expireDateStr = [YUserDefaults objectForKey:kexpiretime];
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];

    return dateCom.year;
}

- (void)dealloc{
    // 移除监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//对首页灯的亮暗情况  进行处理
- (void)gengxingdeng{
    
    //修改字库数据
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    NSMutableArray *array = [AllModel mj_objectArrayWithKeyValuesArray:arr];
    
    for (int i = 0; i < [YUserDefaults integerForKey:khas_learn_num]; i++) {
        AllModel *mod = array[i];
        mod.is_learn = YES;
        [array replaceObjectAtIndex:i withObject:mod];
    }
    
    NSArray *dictArr = [AllModel mj_keyValuesArrayWithObjectArray:array];
    [YUserDefaults setObject:dictArr forKey:kziKu];
    
    //对数据列表进行刷新
    YLogFunc
    NSInteger hasLearnCount = [YUserDefaults integerForKey:khas_learn_num];
    YLog(@"%ld",hasLearnCount)

    NSInteger lockCounts;
    NSInteger mianfeiCounts = [YUserDefaults integerForKey:kfree_words_num];
    if(hasLearnCount > mianfeiCounts){
        lockCounts = hasLearnCount;
    }
    else{
        lockCounts = mianfeiCounts;
    }
    
    
    //1.先把所有灯关掉
    for (int i = 0; i < arr.count; i++) {
        
        for (UIView *v in scrollV.subviews) {
            if (v.tag == i + 10000)
            {
                UIImageView *img = v.subviews.firstObject;
                img.image = [UIImage imageNamed:@"lightoff"];
                
                UIButton *b = v.subviews[1];
                [b setTitleColor:BlackColor forState:UIControlStateNormal];
            }
        }

    }


    //2.把已学习的灯打开
    for (int i = 0; i < hasLearnCount; i++) {
        
        for (UIView *v in scrollV.subviews) {
            if (v.tag == i + 10000)
            {
                UIImageView *img = v.subviews.firstObject;
                img.image = [UIImage imageNamed:@"lighton"];

                UIButton *b = v.subviews[1];
                [b setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }

    }
    
    //3.根据购买情况 对后面的字进行锁
    [self lockHoumian];
    
//    NSInteger hasLearnCount = [YUserDefaults integerForKey:khas_learn_num];
    //学了0-1个字的时候  都是在初始0的位置
//    if(hasLearnCount){
//        hasLearnCount -= 1;
//    }
    
    selectIndex = hasLearnCount - 1;
    scrollV.scrollEnabled = NO;

//    gifCenterX = 673 * YScaleHeight + (lightVMargin + lightVWidth) * hasLearnCount;
//
//    if(hasLearnCount){
//        scrollV.contentOffset = CGPointMake((lightVMargin + lightVWidth) * hasLearnCount + 630 * YScaleHeight - lightVMargin, 0);
//    }

    if(hasLearnCount){
        NSInteger shijiCount = hasLearnCount - 1;
        
        scrollV.contentOffset = CGPointMake((lightVMargin + lightVWidth) * shijiCount + 497 * YScaleHeight, 0);
        
        gifCenterX = 673 * YScaleHeight + (lightVWidth + lightVMargin) * shijiCount;//初始位置
        
        //清空小手指
        for (UIView *v in scrollV.subviews) {
            if (v.tag == 10000)
            {
                if(v.subviews.count == 5){
                    UIImageView *img = v.subviews.lastObject;
                    [img removeFromSuperview];
                    img = nil;
                }
                
            }
        }


    }
    else{
        gifCenterX = chushicenterX;
        
        //清空小手指
        for (UIView *v in scrollV.subviews) {
            if (v.tag == 10000)
            {
                if(v.subviews.count == 4){
                    tishiAnimation = [LOTAnimationView animationNamed:@"Mainhint"];
                    [v addSubview:tishiAnimation];
                    tishiAnimation.frame = CGRectMake(129 * YScaleHeight, 235 * YScaleHeight, 103 * YScaleHeight, 111 * YScaleHeight);
                    
                    tishiAnimation.userInteractionEnabled = NO;
                    tishiAnimation.loopAnimation = YES;
                    [tishiAnimation play];

                }
                
            }
        }

        
    }

    
    gifView.transform = CGAffineTransformMakeScale(1.0, 1.0);//水平翻转

    [UIView animateWithDuration:Transformtimeinterval animations:^{
        ifyidong = YES;
        self->gifView.centerX = chushicenterX;
    } completion:^(BOOL finished) {
        ifyidong = NO;
        scrollV.scrollEnabled = YES;
    }];
}

//登录成功后 对首页进行刷新
- (void)plusClick:(NSNotification *)note{
    [self gengxingdeng];
    
    scrollV.contentOffset = CGPointMake(0, 0);

    if(gifView){
        [gifView removeFromSuperview];
        gifView = nil;
    }
    
    UIImage *image;
    if([YUserDefaults boolForKey:kifshaonNan]){
        image = [YYImage imageNamed:@"shaonan.gif"];
    }
    else{
        image = [YYImage imageNamed:@"shaonv.gif"];
    }
    
    gifView = [[YYAnimatedImageView alloc] initWithImage:image];
    [gifView startAnimating];
    scrollV.scrollEnabled = NO;
    
    [backV addSubview:gifView];
    gifView.frame = CGRectMake( - 267 * YScaleHeight, 0, 267 * YScaleHeight, 282 * YScaleHeight);
    gifView.mj_y = YScreenH - 282 * YScaleHeight - 88 * YScaleHeight;
    
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        ifyidong = YES;
        self->gifView.centerX = chushicenterX;
    } completion:^(BOOL finished) {
        ifyidong = NO;
        scrollV.scrollEnabled = YES;
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    backV = self.view;

//    dataArr = [NSMutableArray array];
    rightArr = [NSMutableArray array];
    successCounts = 0;
    ifcanYidong = YES;
    ifyidong = YES;
    ifjiazhangdoudong = YES;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center addObserver:self selector:@selector(plusClick:) name:@"refresh" object:nil];
    
//    [self fetch];
    [self fetchIcon];
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    dataArr = [AllModel mj_objectArrayWithKeyValuesArray:arr];
    [self setupView];

    //监听网络变化
    [self netWorkChangeEvent];
}

- (void)netWorkChangeEvent{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前使用的是流量模式");
                [self zixuewan];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前使用的是wifi模式");
                [self zixuewan];

                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"断网了");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"变成了未知网络状态");
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netWorkChangeEventNotification" object:@(status)];
    }];
    [manager.reachabilityManager startMonitoring];

}

//有网的时候 把已学的字 后台同步
- (void)zixuewan{
    if([YUserDefaults objectForKey:kquerenzi]){
        [self querenzhiqianzi];
    }
}

- (void)querenzhiqianzi{
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
    param[@"word"] = [YUserDefaults objectForKey:kquerenzi];
    param[@"id"] = [NSNumber numberWithInteger:[YUserDefaults integerForKey:kquerenID]];

    YLog(@"%@",[NSString getBaseUrl:_URL_Success withparam:param])
        
    [YLHttpTool POST:_URL_Success parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){
            
            NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
            [defs removeObjectForKey:kquerenzi];
            [defs removeObjectForKey:kquerenID];
            [defs synchronize];
            
        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];

}


- (void)fetchIcon{
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];

    YLog(@"%@",[NSString getBaseUrl:_URL_IconFenxi withparam:param])
    
//    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [YLHttpTool GET:_URL_IconFenxi parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){

        }
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        
        if(error.code == -1009 || error.code == -1020){
            NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"网络" ofType:@"mp3"];
            NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
            [self bofangwithUrl:@[localVideoUrl]];
            
            self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                [self.player stop];
                self.player = nil;
            };
        }

    }];
//    yaofenglaaaaaaaaaa
}

- (void)setupView{
    //背景音乐
    [self beijingyinyue];
    
    scrollV = [[UIScrollView alloc] init];
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.backgroundColor = WhiteColor;
    scrollV.delegate = self;
    double zongchangdu = (lightVMargin + lightVWidth) * dataArr.count + 950 * YScaleHeight - lightVMargin;
    scrollV.contentSize = CGSizeMake(zongchangdu , YScreenH);
    [backV addSubview: scrollV];
    scrollV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
    
    
    NSInteger bgCounts = 1 + zongchangdu / YScreenW;
    
    for (int i = 0 ; i < bgCounts; i++) {
        
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg%d",(i%8)+1]]];
        [scrollV addSubview:img];
  
//        img.frame = CGRectMake(YScreenW * i, 0, YScreenW, YScreenH);
//        img.contentMode = UIViewContentModeScaleAspectFill;
        if(isPad){
            img.frame = CGRectMake(YScreenW * i, 0, YScreenW, YScreenH);
        }
        else{
//            img.frame = CGRectMake(YScreenW * i, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
            img.frame = CGRectMake(YScreenW * i, -50 * YScaleHeight, YScreenW, YScreenW * 0.75);
        }
    }
    
    UIImageView *lupaiImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originstation"]];
    [scrollV addSubview:lupaiImg];
    lupaiImg.frame = CGRectMake(10 * YScaleHeight, YScreenH - 356 * YScaleHeight, 122 * YScaleHeight, 172 * YScaleHeight);
    
    for (int i = 0 ; i < bgCounts; i++) {
        
        UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"road"]];
        [scrollV addSubview:roadImg];
        roadImg.frame = CGRectMake(YScreenW * i, YScreenH - 196 * YScaleHeight, YScreenW, 196 * YScaleHeight);

    }
    
    BOOL ifmemeber = [YUserDefaults boolForKey:kis_member];
    NSInteger lockCounts;
    NSInteger mianfeiCounts = [YUserDefaults integerForKey:kfree_words_num];
    NSInteger haslearnCounts = [YUserDefaults integerForKey:khas_learn_num];
    if(haslearnCounts > mianfeiCounts){
        lockCounts = haslearnCounts;
    }
    else{
        lockCounts = mianfeiCounts;
    }
    
    

    for (int i = 0 ; i < dataArr.count; i++) {
        UIView *v = [UIView new];
        v.backgroundColor = ClearColor;
        [scrollV addSubview:v];
        v.frame = CGRectMake(630 * YScaleHeight + (lightVWidth + lightVMargin) * i, 0, lightVWidth, lightVHeight);
        v.mj_y = YScreenH - 196 * YScaleHeight - lightVHeight + 42 * YScaleHeight;
        v.tag = 10000 + i;

//        if(isPad){
//        }
//        else if(Height_Bottom){
//            v.mj_y = 0 * YScaleWidth;
//        }
//        else{
//            v.mj_y = 72 * YScaleWidth;
//        }

        AllModel *mod = dataArr[i];

        UIImageView *img = [[UIImageView alloc] init];
        [v addSubview:img];
        img.sd_layout.leftEqualToView(v).rightEqualToView(v).topEqualToView(v).bottomEqualToView(v);

        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:mod.word forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"kaiti" size:70 * YScaleHeight];
        [btn setEnlargeEdgeWithTop:30 * YScaleHeight right:30 * YScaleHeight bottom:30 * YScaleHeight left:30 * YScaleHeight];
        [v addSubview:btn];
        btn.sd_layout.centerXEqualToView(v).topSpaceToView(v, 177 * YScaleHeight).widthIs(73 * YScaleHeight).heightIs(98 * YScaleHeight);
        [btn addTarget:self action:@selector(caozuoClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *numImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementnumber"]];
        [v addSubview:numImg];
        numImg.sd_layout.centerXEqualToView(v).topSpaceToView(v, 283 * YScaleHeight).widthIs(74 * YScaleHeight).heightIs(43 * YScaleHeight);
        
        UILabel *numL = [UILabel new];
        numL.text = [NSString stringWithFormat:@"%04d",i + 1];
        numL.font = YSystemFont(18 * YScaleHeight);
        numL.textAlignment = NSTextAlignmentCenter;
        numL.textColor = [JKUtil getColor:@"1665FF"];
        [v addSubview:numL];
        numL.sd_layout.centerXEqualToView(v).topSpaceToView(v, 297 * YScaleHeight).widthIs(54 * YScaleHeight).heightIs(25 * YScaleHeight);
        
        
        if(mod.is_learn){
            img.image = [UIImage imageNamed:@"lighton"];
            [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
        else{
            img.image = [UIImage imageNamed:@"lightoff"];
            [btn setTitleColor:BlackColor forState:UIControlStateNormal];
        }

        
        //锁的页面
        if(!ifmemeber){
            if(i > (lockCounts - 1)){
                UIImageView *lockImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                [v addSubview:lockImg];
                lockImg.sd_layout.centerXEqualToView(v).topSpaceToView(v, 171 * YScaleHeight).widthIs(112 * YScaleHeight).heightEqualToWidth();
            }
        }
        
        
        if(haslearnCounts == 0){
            if(i == 0){
                tishiAnimation = [LOTAnimationView animationNamed:@"Mainhint"];
                [v addSubview:tishiAnimation];
                tishiAnimation.frame = CGRectMake(129 * YScaleHeight, 235 * YScaleHeight, 103 * YScaleHeight, 111 * YScaleHeight);
                
                tishiAnimation.userInteractionEnabled = NO;
                tishiAnimation.loopAnimation = YES;
                [tishiAnimation play];
            }
        }
        


        
        
//        UILabel *ziL = [UILabel new];
//        ziL.text = mod.title;
//        ziL.font = [UIFont fontWithName:@"kaiti" size:70 * YScaleHeight];
//        ziL.textColor = BlackColor;
//        ziL.textAlignment = NSTextAlignmentCenter;
//        [v addSubview:ziL];
//        ziL.sd_layout.centerXEqualToView(v).topSpaceToView(v, 192 * YScaleHeight).widthIs(73 * YScaleHeight).heightIs(70 * YScaleHeight);
//        ziL.tag = 10000 + i;

//        ziL.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caozuoClick:)];
//        tap.numberOfTapsRequired = 1;
//        [ziL addGestureRecognizer:tap];

    }
     
    
    
    /*
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(256 * YScaleWidth, 384 * YScaleWidth);
    layout.minimumLineSpacing = 0;
    
    
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(320 * YScaleWidth, 0, 256 * YScaleWidth * dataArr.count, 384 * YScaleWidth) collectionViewLayout:layout];
    
    
    if(isPad){
        collectionView.mj_y = 272 * YScaleWidth;
    }
    else{
        collectionView.mj_y = 72 * YScaleWidth;
    }
    
//    collectionView.contentInset = UIEdgeInsetsMake(0, 320 * YScaleWidth, 0, 320 * YScaleWidth);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = FALSE;
    collectionView.backgroundColor = ClearColor;
    [collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MainCollectionViewCell class])];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [scrollV addSubview:collectionView];
    */
    
    NSInteger hasLearnCount = [YUserDefaults integerForKey:khas_learn_num];
    YLog(@"%ld",hasLearnCount)
    
    
    //学了0-1个字的时候  都是在初始0的位置
//    if(hasLearnCount){
//        hasLearnCount -= 1;
//    }
    
    selectIndex = hasLearnCount - 1;
    
//    scrollV.contentOffset = CGPointMake((lightVWidth + lightVMargin) * hasLearnCount + 630 * YScaleHeight - lightVMargin, 0);
    if(hasLearnCount){
        NSInteger shijiCount = hasLearnCount - 1;
        
        scrollV.contentOffset = CGPointMake((lightVMargin + lightVWidth) * shijiCount + 497 * YScaleHeight, 0);
        
        gifCenterX = 673 * YScaleHeight + (lightVWidth + lightVMargin) * shijiCount;//初始位置
    }
    else{
        gifCenterX = chushicenterX;
    }

    
//    UIImage *image = [YYImage imageNamed:@"shaonv.gif"];
    UIImage *image;
    if([YUserDefaults boolForKey:kifshaonNan]){
        image = [YYImage imageNamed:@"shaonan.gif"];
    }
    else{
        image = [YYImage imageNamed:@"shaonv.gif"];
    }
    
    gifView = [[YYAnimatedImageView alloc] initWithImage:image];
    [gifView startAnimating];
    scrollV.scrollEnabled = NO;
    
    [backV addSubview:gifView];
    gifView.frame = CGRectMake( - 267 * YScaleHeight, 0, 267 * YScaleHeight, 282 * YScaleHeight);
    gifView.mj_y = YScreenH - 282 * YScaleHeight - 88 * YScaleHeight;

//    if(isPad){
//        gifView.mj_y = 434 * YScaleWidth;
//    }
//    else if(Height_Bottom){
//        gifView.mj_y = 124 * YScaleWidth;
//    }
//    else{
//        gifView.mj_y = 234 * YScaleWidth;
//    }
    
    [self setshangV];  //YScaleWidth
    
    

    
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        ifyidong = YES;
        self->gifView.centerX = chushicenterX;
    } completion:^(BOOL finished) {
        scrollV.scrollEnabled = YES;
        
        //app下载之后只播放一次
        if([YUserDefaults integerForKey:khas_learn_num] < 1){
            //    播放录音
            NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"开始今天的学习吧" ofType:@"mp3"];
            NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
            [self bofangwithUrl:@[localVideoUrl]];
            
            self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                ifyidong = NO;

                [self.player stop];
                self.player = nil;
            };

        }
        else{
            ifyidong = NO;
        }

        
    }];
        
}

//上面两个view
- (void)setshangV{
    UIView *headV = [UIView new];
    [backV addSubview:headV];
    headV.sd_layout.leftSpaceToView(backV, 38 * YScaleWidth).topSpaceToView(backV, 38 * YScaleWidth).widthIs(203 * YScaleWidth).heightIs(92 * YScaleWidth);
    
    headV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    [headV addGestureRecognizer:tap];

    
    UIImageView *headBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headbg"]];
    [headV addSubview:headBg];
    headBg.sd_layout.leftEqualToView(headV).rightEqualToView(headV).topEqualToView(headV).bottomEqualToView(headV);
    
    userIcon = [[UIImageView alloc] init];
    if([YUserDefaults boolForKey:kifshaonNan]){
        userIcon.image = [UIImage imageNamed:@"usernan"];
    }
    else{
        userIcon.image = [UIImage imageNamed:@"usernv"];
    }
    [headV addSubview:userIcon];
    userIcon.sd_layout.leftSpaceToView(headV, 5 * YScaleWidth).topSpaceToView(headV, 5 * YScaleWidth).bottomSpaceToView(headV, 5 * YScaleWidth).widthIs(82 * YScaleWidth);
    
    NoHighBtn *userBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [headV addSubview:userBtn];
    [userBtn addTarget:self action:@selector(nannvclick) forControlEvents:UIControlEventTouchUpInside];
    userBtn.sd_layout.leftEqualToView(userIcon).rightEqualToView(userIcon).topEqualToView(userIcon).bottomEqualToView(userIcon);
    
    
//    vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notvip"]];
//    [headV addSubview:vipImg];
//    vipImg.sd_layout.bottomSpaceToView(headV, 3 * YScaleWidth).leftSpaceToView(headV, 59 * YScaleWidth).widthIs(28 * YScaleWidth).heightEqualToWidth();
    
    nameL = [UILabel new];
    nameL.text = @"未登录";
    nameL.font = YSystemFont(14 * YScaleWidth);
    nameL.textColor = WhiteColor;
    [headV addSubview:nameL];
    nameL.sd_layout.rightSpaceToView(headV, 3 * YScaleWidth).topSpaceToView(headV , 25 * YScaleWidth).heightIs(20 * YScaleWidth).widthIs(100 * YScaleWidth);
    
//    17449C  当前未开通会员
//    FF5E18  有效期至2021.11.30
    

    vipL = [UILabel new];
    vipL.backgroundColor = WhiteColor;
    
    vipL.textColor = [JKUtil getColor:@"17449C"];
    vipL.alpha = 0.8;
    vipL.text = @"当前未开通会员";
    
    vipL.font = YSystemFont(9 * YScaleWidth);
    vipL.layer.cornerRadius = 10 * YScaleWidth;
    vipL.layer.masksToBounds = YES;
    vipL.textAlignment = NSTextAlignmentCenter;
    [headV addSubview:vipL];
    vipL.sd_layout.rightSpaceToView(headV, 12 * YScaleWidth).bottomSpaceToView(headV , 25 * YScaleWidth).heightIs(20 * YScaleWidth).widthIs(96 * YScaleWidth);
    
    IconVipImg = [[UIImageView alloc] init];
    [headV addSubview:IconVipImg];
    IconVipImg.sd_layout.rightSpaceToView(headV, 26 * YScaleWidth).bottomSpaceToView(headV , 21 * YScaleWidth).heightIs(28 * YScaleWidth).widthIs(84 * YScaleWidth);
    IconVipImg.hidden = YES;
    
    
    NoHighBtn *ziBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [ziBtn setBackgroundImage:[UIImage imageNamed:@"elementfont"] forState:UIControlStateNormal];
    [backV addSubview:ziBtn];
    ziBtn.sd_layout.rightSpaceToView(backV, 38 * YScaleWidth).topSpaceToView(backV, 38 * YScaleWidth).widthIs(76 * YScaleWidth).heightIs(90 * YScaleWidth);
    [ziBtn addTarget:self action:@selector(ziClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    zishuNumL = [UILabel new];
//    NSString *geshu = [NSString stringWithFormat:@"%ld",(long)[YUserDefaults integerForKey:khas_learn_num]];
    zishuNumL.textAlignment = NSTextAlignmentCenter;
    zishuNumL.textColor = [JKUtil getColor:@"0378FE"];
    [ziBtn addSubview:zishuNumL];
    zishuNumL.sd_layout.leftSpaceToView(ziBtn, 8 * YScaleWidth).topSpaceToView(ziBtn, 40 * YScaleWidth).rightSpaceToView(ziBtn, 0).heightIs(24 * YScaleWidth);
    [self setnumLwithstring];
}

- (void)setnumLwithstring{
    
    NSString *geshu = [NSString stringWithFormat:@"%ld",(long)[YUserDefaults integerForKey:khas_learn_num]];
    NSInteger firstZi = 19 - geshu.length;
    NSInteger SecondZi = 13 - geshu.length;
    
//    if(geshu.length == 1){
//        firstZi = 18;
//        SecondZi = 12;
//    }
//    else if(geshu.length == 2){
//        firstZi = 17;
//        SecondZi = 10;
//    }
//    else if(geshu.length == 3){
//        firstZi = 16;
//        SecondZi = 9;
//    }
//    else if(geshu.length == 4){
//        firstZi = 15;
//        SecondZi = 8;
//    }
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@个",geshu]];
    
    //富文本的属性通过字典的形式传入
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont fontWithName:@"Helvetica-Bold" size:firstZi * YScaleWidth],NSFontAttributeName,//字体
                                   nil];
    
    NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont fontWithName:@"Helvetica-Bold" size:SecondZi * YScaleWidth],NSFontAttributeName,//字体
                                   nil];

    [attributedStr addAttributes:attributeDict range:NSMakeRange(0, geshu.length)];
    [attributedStr addAttributes:attributeDict1 range:NSMakeRange(geshu.length, 1)];

    zishuNumL.attributedText = attributedStr;

    
}

- (void)nannvclick{
    if(ifyidong){
        return;
    }
    
    if([YUserDefaults boolForKey:kifshaonNan]){
        [YUserDefaults setBool:NO forKey:kifshaonNan];
        
        gifView.image = [YYImage imageNamed:@"shaonv.gif"];
        userIcon.image = [UIImage imageNamed:@"usernv"];

    }
    else{
        [YUserDefaults setBool:YES forKey:kifshaonNan];
        
        gifView.image = [YYImage imageNamed:@"shaonan.gif"];
        userIcon.image = [UIImage imageNamed:@"usernan"];

    }
}

- (void)loading{
    LoadingBackV = [UIView new];
    LoadingBackV.backgroundColor = BlackColor;
    LoadingBackV.alpha = 0.6;
    [backV addSubview:LoadingBackV];
    LoadingBackV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);

    
    UIImage *image = [YYImage imageNamed:@"loading.gif"];
    loadingView = [[YYAnimatedImageView alloc] initWithImage:image];
    [backV addSubview:loadingView];
    loadingView.sd_layout.centerYEqualToView(backV).centerXEqualToView(backV).widthIs(330 * YScaleHeight).heightIs(140 * YScaleHeight);
}

- (void)removeLoading{
    [LoadingBackV removeFromSuperview];
    LoadingBackV = nil;
    
    [loadingView removeFromSuperview];
    loadingView = nil;
}

#pragma mark - click
//选中某个路灯进行学习操作
- (void)caozuoClick:(UIButton *)b{
    NSInteger ziIndex = b.superview.tag - 10000;

//    不是会员
//    if(![YUserDefaults boolForKey:kis_member]){
//        //未学习的字
//        if(ziIndex > ([YUserDefaults integerForKey:kfree_words_num] - 1)){
//
//            [self tapAction];
//            return;
//        }
//    }
    
    if([YUserDefaults integerForKey:khas_learn_num] == 0){
        if(ziIndex > 0){
            if(ifyidong){
                return;
            }
        }
    }
    
    
    else{
        if(ifyidong){
            return;
        }
    }
    
    
    if(!ifcanYidong){
        return;
    }
    

    if(ziIndex <= [YUserDefaults integerForKey:khas_learn_num]){
        [self loading];
    }
    
    
    AllModel *selectedMod = dataArr[ziIndex];

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
            //不同字的时候  才开始动画
            for (UIView *v in scrollV.subviews) {
                if (v.tag == b.superview.tag)
                {
                    
                    if(gifView.centerX > v.centerX - scrollV.contentOffset.x){
                        gifView.transform = CGAffineTransformMakeScale(-1.0, 1.0);//水平翻转
                    }

                    else{
                        gifView.transform = CGAffineTransformMakeScale(1.0, 1.0);//水平翻转
                    }
                    
        //            CGFloat timeInterval;
        //            if(ziIndex == 0){
        //                timeInterval = 0;;
        //            }
        //            else{
        //                timeInterval = Transformtimeinterval;
        //            }
                    
                    CGFloat zhiqiancenterX = gifCenterX;
                    //确定在图 左边还是右边
                    if(selectIndex < ziIndex){
                        self->gifCenterX = v.centerX - 85 * YScaleHeight;
                    }
                    else if(selectIndex > ziIndex){
                        self->gifCenterX = v.centerX + 85 * YScaleHeight;
                    }
                    
                    YLog(@"%f",gifCenterX)
                    
                    double shijijuli = fabs(gifCenterX - zhiqiancenterX);
                    
                    if(shijijuli > YScreenW){
                        shijijuli = YScreenW;
                    }
                    
                    CGFloat timeterval = shijijuli / YScreenW * 3;
                    
                    //最短间隔
                    if(timeterval < 2){
                        timeterval = 2;
                    }

                    
                    NSInteger haslearnCounts = [YUserDefaults integerForKey:khas_learn_num];

//                    CGFloat huadongjuli;
//                    if(haslearnCounts){
                    CGFloat huadongjuli = self->gifCenterX - self->scrollV.contentOffset.x;
//                    }
//                    else{
//                        huadongjuli = 673 * YScaleHeight;
//                    }
                
                    scrollV.scrollEnabled = NO;
        //            * fabs(huadongjuli - gifView.centerX )/ 1080
                    [UIView animateWithDuration:timeterval animations:^{
                        
                        ifyidong = YES;
                        self->gifView.centerX = huadongjuli;
                        
                        
                    } completion:^(BOOL finished) {
                        
                        ifyidong = NO;
                        ifcanYidong = YES;
                        
                        scrollV.scrollEnabled = YES;
                        selectIndex = ziIndex;
//                        [gifView stopAnimating];

                        FunViewController *vc = [[FunViewController alloc] init];
                        vc.selectedMod = selectedMod;
                        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        vc.xuanzhongIndex =self-> selectIndex;
                        
                        vc.combine_words = dict[@"combine_words"];
                        vc.similar_words = dict[@"similar_words"];
                        vc.word_image = [NSString stringWithFormat:@"%@",dict[@"word_image"]];
                        vc.word_video = [NSString stringWithFormat:@"%@",dict[@"word_video"]];
                        vc.word_audio = [NSString stringWithFormat:@"%@",dict[@"word_audio"]];
                        vc.words_audios = dict[@"words_audios"];
                        vc.ifFuxi = NO;
                        
                        vc.callBack = ^(NSInteger xuanzhongIndex) {
                    //                    self->ifNoanimation = YES;
                            [self ludengdianliang:xuanzhongIndex + 10000];
                        };
                        
                        fuxiVc = vc;
                        [self huancun];
                        
                    }];


                    

                }
            }
            
            
            
                        
            

        }
        
        else{
//            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
//            [SVProgressHUD dismissWithDelay:1.0];
            [self removeLoading];

            if ([dic[@"code"] integerValue] == 413) {
                //    播放录音
                NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"按顺序学习" ofType:@"mp3"];
                NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
                
                
                [self bofangwithUrl:@[localVideoUrl]];
                
                self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                    [self.player stop];
                    self.player = nil;
                };
                
                
                [self xuexiyemian];
                //回到之前所在地
                
            }
            
            
            //没购买   跳购买页面
            else if ([dic[@"code"] integerValue] == 415 || [dic[@"code"] integerValue] == 416){
                
                /*
                //    播放录音
                NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"解锁更多汉字" ofType:@"mp3"];
                NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
                
                [self bofangwithUrl:@[localVideoUrl]];
                
                self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                    [self.player stop];
                    self.player = nil;
                };
                 */

                if([dic[@"code"] integerValue] == 415){
                    [self xiugaixinxi];
                }
                else{
                    [self gotomewithLuyin];
                }
                
            }
            
            
            //未登录  或者
            else if ([dic[@"code"] integerValue] == 401){
                [SVProgressHUD showErrorWithStatus:@"您的账户已在第三台设备登录，请确认账户信息安全"];
                [SVProgressHUD dismissWithDelay:3];

                [self weidengluCaozuo];
            }
            
            
            
            
        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];

        [self removeLoading];

        if(error.code == -1009 || error.code == -1020){
            NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"网络" ofType:@"mp3"];
            NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
            [self bofangwithUrl:@[localVideoUrl]];
            
            self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                [self.player stop];
                self.player = nil;
            };
        }
        
//        [LoadingBackV removeFromSuperview];
//        LoadingBackV = nil;

    }];

 
}

- (void)huancun{
    // 获取cache目录路径
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    
    NSString *directoryPath = [[cachesDir stringByAppendingPathComponent:renduwanDic] copy];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
          [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    __block NSInteger wangluoSuccessCounts = 0;
    
    NSArray *nameArr = @[videoname,audioname,ziqianname,zihouname,ziimgname];
    NSArray *urlArr = @[fuxiVc.word_video,fuxiVc.word_audio,fuxiVc.words_audios.firstObject,fuxiVc.words_audios.lastObject,fuxiVc.word_image];

    for (int i = 0; i < nameArr.count; i++) {
        
        AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
        NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", directoryPath, nameArr[i]];
        NSURL *url = [NSURL URLWithString:urlArr[i]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *task =
        [manger downloadTaskWithRequest:request
                                progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            
                                    return [NSURL fileURLWithPath:fullPath];
            
                                }
                       completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        
            YLog(@"%d----%ld",i,wangluoSuccessCounts)

            wangluoSuccessCounts++;
            
            if(wangluoSuccessCounts == 5){
                [self removeLoading];
                
                [self presentViewController:fuxiVc animated:YES completion:^{
                }];

            }

            
                       }];
        [task resume];

    }
    
}


- (void)xuexiyemian{
    if(xuexiBackV){
        return;
    }
    
    BlackJZV = [UIView new];
    BlackJZV.backgroundColor = [JKUtil getColor:@"131313"];
    BlackJZV.alpha = 0.8;
    [backV addSubview:BlackJZV];
    BlackJZV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
    
    xuexiBackV = [UIView new];
    xuexiBackV.backgroundColor = ClearColor;
    [backV addSubview:xuexiBackV];
    xuexiBackV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
    
//    xuexiBackV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closexuexiyemian)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [xuexiBackV addGestureRecognizer:tap];

    
    zhongImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupxuexi"]];
    [xuexiBackV addSubview:zhongImg];
    zhongImg.userInteractionEnabled = YES;
    zhongImg.sd_layout.centerXEqualToView(xuexiBackV).centerYEqualToView(xuexiBackV).widthIs(560 * YScaleWidth).heightIs(320 * YScaleWidth);

    UIButton *closeB = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [closeB setBackgroundImage:[UIImage imageNamed:@"elementclose"] forState:UIControlStateNormal];
    [xuexiBackV addSubview:closeB];
    closeB.sd_layout.leftSpaceToView(zhongImg, -87 * YScaleWidth).bottomSpaceToView(zhongImg, -81 * YScaleHeight).widthIs(88 * YScaleWidth).heightEqualToWidth();
    [closeB addTarget:self action:@selector(closexuexiyemian) forControlEvents:UIControlEventTouchUpInside];

    UIButton *xuexiB = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [xuexiB setBackgroundImage:[UIImage imageNamed:@"Mainxuexi"] forState:UIControlStateNormal];
    [xuexiBackV addSubview:xuexiB];
    xuexiB.sd_layout.centerXEqualToView(xuexiBackV).topSpaceToView(zhongImg, -65 * YScaleHeight).widthIs(260 * YScaleWidth).heightIs(60 * YScaleWidth);
    [xuexiB addTarget:self action:@selector(gotoxuexi) forControlEvents:UIControlEventTouchUpInside];


}

#pragma mark - 点击的代理
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ([touch.view isDescendantOfView:zhongImg]) {
        return NO;
    }

    return YES;
}


- (void)gotoxuexi{
    [self closexuexiyemian];
    
    scrollV.contentOffset = CGPointMake(gifCenterX - chushicenterX, 0);
    gifView.transform = CGAffineTransformMakeScale(1.0, 1.0);//水平翻转

    
    NSInteger hasLearnCount = [YUserDefaults integerForKey:khas_learn_num];
    UIView *v = [scrollV viewWithTag:10000 + hasLearnCount];

    UIButton *b = v.subviews[1];

    [self caozuoClick:b];
    
}

- (void)closexuexiyemian{
    [xuexiBackV removeFromSuperview];
    xuexiBackV = nil;
    
    [BlackJZV removeFromSuperview];
    BlackJZV = nil;
    
    if(self.player){
        [self.player stop];
        self.player = nil;
    }
}

//清空旧数据
- (void)weidengluCaozuo{
    //清空旧数据
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    [defs removeObjectForKey:khas_learn_num];
    [defs removeObjectForKey:kusername];
    [defs removeObjectForKey:ktoken];
    [defs removeObjectForKey:kis_member];
    [defs removeObjectForKey:kexpiretime];
    [defs removeObjectForKey:khas_purchase];
    [defs removeObjectForKey:kuserid];
    
//    zishuNumL.text = [NSString stringWithFormat:@"%d",0];
    [self setnumLwithstring];

    [defs synchronize];
    
    //修改字库数据
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    NSMutableArray *array = [AllModel mj_objectArrayWithKeyValuesArray:arr];
    
    for (AllModel *mod in array) {
        mod.is_learn = NO;
    }
    NSArray *dictArr = [AllModel mj_keyValuesArrayWithObjectArray:array];
    [YUserDefaults setObject:dictArr forKey:kziKu];
    
    nameL.text = @"未登录";
//    vipImg.image = [UIImage imageNamed:@"notvip"];
    vipL.alpha = 0.8;
    vipL.textColor = [JKUtil getColor:@"17449C"];
    self->vipL.hidden = NO;
    self->vipL.text = @"当前未开通会员";
    IconVipImg.hidden = YES;
    
    [self plusClick:nil];
//    [self gengxingdeng];
    
    //获取新的userid
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if(isPad){
        param[@"device"] = @"iPad";
    }
    else{
        param[@"device"] = @"iPhone";
    }
    param[@"origin"] = @"app store";

    YLog(@"%@",[NSString getBaseUrl:_URL_userID withparam:param])
    
//    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [YLHttpTool GET:_URL_userID parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){
            
            NSDictionary *d = dic[@"data"];
            [YUserDefaults setObject:d[@"user_id"] forKey:kuserid];
            
            //跳转购买页
            


        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        
        
    }];

}

//之后修改信息
- (void)xiugaixinxi{
    
    [YUserDefaults setBool:NO forKey:kis_member];
    [YUserDefaults setBool:YES forKey:khas_purchase];

    vipL.hidden = NO;
    IconVipImg.hidden = YES;
    
    vipL.text = @"您的会员已到期";
    vipL.alpha = 0.8;

    //未学习字锁定
    [self lockHoumian];

    //跳转购买页
    [self gotomewithLuyin];

}

//进入个人中心页面 有录音
- (void)gotomewithLuyin{
    //设置家长view
    [self setJiaZhangView];

    
    /*
    MeViewController *meVc = [[MeViewController alloc] init];
//    [self.navigationController pushViewController:meVc animated:YES];
//    meVc.ifluyin = YES;
    meVc.modalPresentationStyle = UIModalPresentationFullScreen;
    meVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:meVc animated:YES completion:nil];
     */
}

//不是会员的时候  对后面的路灯进行封锁
- (void)lockHoumian{
    NSArray *arr = [YUserDefaults objectForKey:kziKu];

    NSInteger lockCounts;
    NSInteger mianfeiCounts = [YUserDefaults integerForKey:kfree_words_num];
    NSInteger haslearnCounts = [YUserDefaults integerForKey:khas_learn_num];
    if(haslearnCounts > mianfeiCounts){
        lockCounts = haslearnCounts;
    }
    else{
        lockCounts = mianfeiCounts;
    }
    
//    for (UIView *v in scrollV.subviews) {
//        if (v.subviews.count == 5)
//        {
//            UIImageView *img = v.subviews[4];
//            [img removeFromSuperview];
//            img = nil;
//
//        }
//    }

        
    for (UIView *v in scrollV.subviews) {
        if (v.tag > 10000)
        {
            if(v.subviews.count == 5){
                UIImageView *img = v.subviews.lastObject;
                [img removeFromSuperview];
                img = nil;
            }
            
        }
    }


    
    //对后面的锁进行处理
    //是会员  去掉锁
    if([YUserDefaults boolForKey:kis_member]){

        
    }
    
    //不是会员 加上锁
    else{

        for (NSInteger i = lockCounts; i < arr.count; i++) {
            
            for (UIView *v in scrollV.subviews) {
                if (v.tag == i + 10000)
                {
                    
                    UIImageView *lockImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    [v addSubview:lockImg];
                    lockImg.sd_layout.centerXEqualToView(v).topSpaceToView(v, 171 * YScaleHeight).widthIs(112 * YScaleHeight).heightEqualToWidth();
                    
                }
            }

        }
    }
}

//学习完成之后  点亮路灯
- (void)ludengdianliang:(NSInteger)index{
    
//    if(index == 10000){
//        for (UIView *v in scrollV.subviews) {
//            if (v.tag == 10000)
//            {
//                LOTAnimationView *im = v.subviews.lastObject;
//                [im removeFromSuperview];
//            }
//        }
//    }

    //点亮路灯
    /*
    for (UIView *v in scrollV.subviews) {
        if (v.tag == index)
        {
            UIImageView *img = v.subviews.firstObject;
            img.image = [UIImage imageNamed:@"lighton"];

            UIButton *b = v.subviews[1];
            [b setTitleColor:WhiteColor forState:UIControlStateNormal];

        }
    }
     */
    
    [self gengxingdeng];
}

//进入学习记录页面
- (void)ziClick{
    if(ifyidong){
        return;
    }
    
//    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"光标" ofType:@"wav"];
//    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
//
//    [self bofangwithUrl:@[localVideoUrl]];
//
//    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
//        [self.player stop];
//        self.player = nil;
        
        WordsViewController *vc = [[WordsViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    //    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];

//    };
    
}

//进入个人中心
- (void)tapAction{
    [self setJiaZhangView];

    /*
    MeViewController *meVc = [[MeViewController alloc] init];
//    [self.navigationController pushViewController:meVc animated:YES];
    meVc.modalPresentationStyle = UIModalPresentationFullScreen;
    meVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:meVc animated:YES completion:nil];
     */
}

- (void)gotoMeVC{
    MeViewController *meVc = [[MeViewController alloc] init];
    meVc.modalPresentationStyle = UIModalPresentationFullScreen;
    meVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:meVc animated:YES completion:nil];
}

#pragma mark ————— scrollView代理方法 —————
//页面滑动时候的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    gifView.centerX = gifCenterX - scrollView.contentOffset.x;

    if(gifView.centerX < -lightVWidth * 0.5){
        gifView.centerX = -lightVWidth * 0.5;
    }

    else if(gifView.centerX > YScreenW + lightVWidth * 0.5){
        gifView.centerX = YScreenW + lightVWidth * 0.5;
    }
    
    
    //在滑动范围内操作
    if((scrollView.contentOffset.x >= 0) && (scrollView.contentOffset.x <= ((lightVWidth + lightVMargin) * dataArr.count + 950 * YScaleHeight - lightVMargin - YScreenW - 1))){
        
        //第一个字 必须一直向右
        if(gifCenterX > 758 * YScaleHeight){
            //调整人物方向
            if((scrollView.contentOffset.x - lastOffSetX) > 0) {
//                NSLog(@"正在向左滑动");
                gifView.transform = CGAffineTransformMakeScale( 1.0, 1.0);//水平翻转
             }else{
//                NSLog(@"正在向右滑动");
                 gifView.transform = CGAffineTransformMakeScale(-1.0, 1.0);//水平翻转
            }
           lastOffSetX = scrollView.contentOffset.x;

        }
        else{
            gifView.transform = CGAffineTransformMakeScale(1.0, 1.0);//水平翻转
        }

        
        
    }
    
    
//    YLog(@"%f",scrollView.contentOffset.x)
    
    
    //对 scrollview的内容控制  不要超出范围
    if(scrollView.contentOffset.x < 0){
        scrollView.contentOffset = CGPointZero;
    }
    
    else if(scrollView.contentOffset.x >= ((lightVWidth + lightVMargin) * dataArr.count + 950 * YScaleHeight - lightVMargin - YScreenW))
    {
        scrollView.contentOffset = CGPointMake(((lightVWidth + lightVMargin) * dataArr.count + 950 * YScaleHeight - lightVMargin - YScreenW), 0);
    }
        
}

//家长控制页面
- (void)setJiaZhangView{
    if(ifyidong){
        return;
    }
    
    if(BlackJZV){
        return;
    }
    
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"解锁更多汉字" ofType:@"mp3"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    [self bofangwithUrl:@[localVideoUrl]];
    
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [self.player stop];
        self.player = nil;
    };
    
    if(isPad){
        thisScale = YScaleWidth;
    }
    else{
        if([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom){
            thisScale = YScaleWidth * 0.7;
        }
        else{
            thisScale = YScaleWidth * 0.8;
        }
    }
    
    BlackJZV = [UIView new];
    BlackJZV.backgroundColor = kblackColor;
    BlackJZV.alpha = 0.6;
    [backV addSubview:BlackJZV];
    BlackJZV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeJiazhang)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [BlackJZV addGestureRecognizer:tap];

    
    jiazhangV = [UIView new];
    jiazhangV.backgroundColor = ClearColor;
    [backV addSubview:jiazhangV];
//    jiazhangV.sd_layout.centerXEqualToView(backV).widthIs(729 * thisScale).heightIs(539 * thisScale).topSpaceToView(backV, 128 * YScaleHeight);
    
    jiazhangV.frame = CGRectMake((YScreenW - 729 * thisScale)/2, 128 * YScaleHeight, 729 * thisScale, 539 * thisScale);

    YLog(@"%@",jiazhangV)


    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verificationbox"]];
    [jiazhangV addSubview:img];
    img.sd_layout.leftEqualToView(jiazhangV).rightEqualToView(jiazhangV).topEqualToView(jiazhangV).bottomEqualToView(jiazhangV);
    
    UIButton *closeB = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [closeB setBackgroundImage:[UIImage imageNamed:@"elementclose"] forState:UIControlStateNormal];
    [jiazhangV addSubview:closeB];
    closeB.frame = CGRectMake(620 * thisScale, -29 * thisScale, 94 * thisScale, 94 * thisScale);
    [closeB addTarget:self action:@selector(closeJiazhang) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *Label = [UILabel new];
    Label.text = @"家长验证，请依次点击";
    Label.textColor = [JKUtil getColor:@"344366"];
    Label.font = YSystemFont(24 * thisScale);
    [jiazhangV addSubview:Label];
    Label.sd_layout.leftSpaceToView(jiazhangV, 120 * thisScale).topSpaceToView(jiazhangV, 64 * thisScale).widthIs(248 * thisScale).heightIs(34 * thisScale);
    
    [self setzhongwen];
    
    shuziV = [UIView new];
    shuziV.backgroundColor = ClearColor;
    [jiazhangV addSubview:shuziV];
//    shuziV.sd_layout.leftSpaceToView(jiazhangV, 194 * thisScale).topSpaceToView(jiazhangV, 138 * thisScale).widthIs(340 * thisScale).heightIs(300 * thisScale);
    shuziV.frame = CGRectMake(194 * thisScale, 138 * thisScale, 340 * thisScale, 300 * thisScale);
    
    
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [btn setTitleColor:[JKUtil getColor:@"0A45BA"] forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[UIImage imageWithColor:[JKUtil getColor:@"1665FF"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[JKUtil getColor:@"4B80E8"]] forState:UIControlStateSelected];
        btn.tag = i;
        [btn setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:50 * thisScale];

        
        [shuziV addSubview:btn];
        btn.frame = CGRectMake(130 * thisScale * (i % 3), 110 * thisScale * (i / 3), 80 * thisScale, 80 * thisScale);
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
}

- (void)btnClick:(UIButton *)b{
    NSNumber *seleIndex = [NSNumber numberWithInteger:b.tag];
    
    if(successCounts > 2){
        return;
    }

    if([seleIndex isEqualToNumber:rightArr[successCounts]]){
        b.selected = YES;
        successCounts ++;
    }
    else{
        
//        UIView *v = jiazhangV;
        
        if(!ifjiazhangdoudong){
            return;
        }
        
        ifjiazhangdoudong = NO;
        
        YLog(@"%@",jiazhangV)
        jiazhangV.transform=CGAffineTransformIdentity;

        
        srand([[NSDate date] timeIntervalSince1970]);
        float rand=(float)random();
        CFTimeInterval t=rand*0.0000000001;
        
        [UIView animateWithDuration:0.1 delay:t options:0  animations:^
         {
            jiazhangV.transform = CGAffineTransformMakeRotation(-0.05);
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
              {
                 jiazhangV.transform = CGAffineTransformMakeRotation(0.05);
              } completion:^(BOOL finished) {}];
         }];
        

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
             {
                jiazhangV.transform = CGAffineTransformIdentity;
             } completion:^(BOOL finished) {
                 ifjiazhangdoudong = YES;
                 
                 successCounts = 0;
                 [self setzhongwen];
                 for (UIButton *b in shuziV.subviews) {
                     b.selected = NO;
                 }

             }];

        });
         
        
//        successCounts = 0;
//        [self setzhongwen];
//        for (UIButton *b in shuziV.subviews) {
//            b.selected = NO;
//        }

        
    }

    YLog(@"%ld",successCounts)
    
    if(successCounts == 3){
        //成功之后的操作

        successCounts = 0;
        [rightArr removeAllObjects];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //家长页面消失
            [self closeJiazhang];

            //进入个人中心
            [self gotoMeVC];

        });
    }
    
    
}


- (void)setzhongwen{
    if(zhongwenV){
        [zhongwenV removeFromSuperview];
        zhongwenV = nil;
    }
    
    if(rightArr.count){
        [rightArr removeAllObjects];
    }
    
    zhongwenV = [UIView new];
    [jiazhangV addSubview:zhongwenV];
    zhongwenV.backgroundColor = WhiteColor;
//    zhongwenV.sd_layout.rightSpaceToView(jiazhangV, 115 * thisScale).topSpaceToView(jiazhangV, 46 * thisScale).widthIs(230 * thisScale).heightIs(70 * thisScale);
    zhongwenV.frame = CGRectMake(384 * thisScale, 46 * thisScale, 230 * thisScale, 70 * thisScale);
    
    NSMutableArray *zhongArr = [NSMutableArray arrayWithArray:@[@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"]];
    NSMutableArray *tagsArr = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        UILabel *L = [UILabel new];
        NSInteger num = arc4random_uniform(9 - i);
        L.text = zhongArr[num];
        [zhongArr removeObjectAtIndex:num];
        
        L.textAlignment = NSTextAlignmentCenter;
        L.font = [UIFont fontWithName:@"Helvetica-Bold" size:50 * thisScale];
        L.textColor = [JKUtil getColor:@"FF5E18"];
        [zhongwenV addSubview:L];
        L.frame = CGRectMake(80 * thisScale * i, 0, 70 * thisScale, 70 * thisScale);
        
        YLog(@"------%ld",num)
        
        [tagsArr addObject:[NSNumber numberWithInteger:num]];
        
//        if(i > 0){
//            NSNumber *thisNum = rightArr[i - 1];
//            YLog(@"%ld",[thisNum integerValue])
//            if(num >= [thisNum integerValue]){
//                [rightArr addObject:[NSNumber numberWithInteger:(num + i)]];
//                YLog(@"%ld",num)
//            }
//            else{
//                [rightArr addObject:[NSNumber numberWithInteger:num]];
//
//                YLog(@"%ld",num)
//            }
//        }
//        else{
//            [rightArr addObject:];
//            YLog(@"%ld",num)
//        }
        
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [arr addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 0; i < 3; i++) {
        NSNumber *thisNum = tagsArr[i];
        NSInteger thisInt = [thisNum integerValue];
                
        if(i > 0){
            NSNumber *rightNum = arr[thisInt];
            [rightArr addObject:rightNum];
        }
        else{
            [rightArr addObject:tagsArr[0]];
        }
        
        [arr removeObjectAtIndex:thisInt];
        
    }
    
}

- (void)closeJiazhang{
    [BlackJZV removeFromSuperview];
    BlackJZV = nil;
    
    [jiazhangV removeFromSuperview];
    jiazhangV = nil;
}



/*
#pragma mark ————— collection代理方法 —————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MainCollectionViewCell class]) forIndexPath:indexPath];
    cell.mod = dataArr[indexPath.item];
    
    return cell;
}

//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //边距的顺序是 上左下右
  return UIEdgeInsetsMake(0,0,0,0);
}



- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    AllModel *mod = dataArr[indexPath.row];
//    YLog(@"%@",mod.title)
    
    YLog(@"%ld",indexPath.row)
}
*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
