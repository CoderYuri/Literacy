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
#import <SafariServices/SafariServices.h>

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    UIView *backV;
    
    UIImageView *bgImg;
    UIImageView *vipImg;
    
    UILabel *nameL;
    UILabel *vipL;
    
    YYAnimatedImageView *gifView;
    UICollectionView *collectionView;
    UIScrollView *scrollV;
    NSMutableArray *dataArr;
    
    //gif的x值
    CGFloat gifCenterX;
    CGFloat lastOffSetX;
    
    NSInteger selectIndex;
    BOOL ifNoanimation;
    
    //gif加载
    UIView *LoadingBackV;
    UIView *xieyiCoverView;
}

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic,strong) NudeIn *xieyiLabel;

@end

@implementation MainViewController

- (void)bofangwithUrl:(NSArray *)urlArr{
    if(self.player){
        [self.player stop];
        self.player = nil;
    }

    self.player = [ZFPlayerController playerWithPlayerManager: [[ZFAVPlayerManager alloc] init] containerView:[UIView new]];

    self.player.assetURLs = urlArr;
    [self.player playTheIndex:0];
}


- (void)fetch{
    
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    if(arr.count){
        dataArr = [AllModel mj_objectArrayWithKeyValuesArray:arr];
        [self setupView];

    }
    else{
        
        [self loading];
        
        //网络请求数据
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
        YLog(@"%@",[NSString getBaseUrl:_URL_words withparam:param])
        
        [YLHttpTool GET:_URL_words parameters:param progress:^(NSProgress *progress) {
            
        } success:^(id dic) {
            
            [self removeLoading];

            if([dic[@"code"] integerValue] == 200){
                
                NSDictionary *d = dic[@"data"];
                NSArray *array = d[@"words"];
                self->dataArr = [AllModel mj_objectArrayWithKeyValuesArray:array];
                [YUserDefaults setObject:array forKey:kziKu];
                
                [YUserDefaults setInteger:[d[@"free_words_num"]integerValue] forKey:kfree_words_num];
                [YUserDefaults setInteger:[d[@"has_learn_num"] integerValue] forKey:khas_learn_num];

                YLog(@"%@",dic)
                [self setupView];

            }
            
        } failure:^(NSError *error) {
            [self removeLoading];
            //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
        }];

        
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([YUserDefaults objectForKey:kusername]){
        
        self->nameL.text = [YUserDefaults objectForKey:kusername];
        if([YUserDefaults boolForKey:kis_member]){
            self->vipImg.image = [UIImage imageNamed:@"vip"];
            self->vipL.text = [NSString stringWithFormat:@"有效期至%@",[YUserDefaults objectForKey:kexpiretime]];
            vipL.alpha = 1;
            self->vipL.textColor = [JKUtil getColor:@"FF6112"];
            

        }
        else{
            self->vipImg.image = [UIImage imageNamed:@"notvip"];
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


- (void)dealloc
{
    // 移除监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//登录成功后 对首页进行刷新
- (void)plusClick:(NSNotification *)note{
    NSArray *arr = [YUserDefaults objectForKey:kziKu];

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
    
    [self lockHoumian];
    
    //学了0-1个字的时候  都是在初始0的位置
    if(hasLearnCount){
        hasLearnCount -= 1;
    }
    
    selectIndex = hasLearnCount;
    
    scrollV.contentOffset = CGPointMake(256 * YScaleHeight * hasLearnCount, 0);
    gifCenterX = 363 * YScaleHeight + 256 * YScaleHeight * hasLearnCount;
    
    if(gifView){
        [gifView removeFromSuperview];
        gifView = nil;
    }
    
    UIImage *image = [YYImage imageNamed:@"shaonv.gif"];
    gifView = [[YYAnimatedImageView alloc] initWithImage:image];
    [gifView startAnimating];
    
    [backV addSubview:gifView];
    gifView.frame = CGRectMake( - 267 * YScaleHeight, 0, 267 * YScaleHeight, 282 * YScaleHeight);
    gifView.mj_y = YScreenH - 282 * YScaleHeight - 88 * YScaleWidth;
    
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        self->gifView.centerX = 363 * YScaleHeight;
    } completion:^(BOOL finished) {
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];

    dataArr = [NSMutableArray array];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center addObserver:self selector:@selector(plusClick:) name:@"refresh" object:nil];


    [self fetch];
}

- (void)xieyiyemian{
    CGFloat thisScale;
    thisScale = YScaleWidth;

//    if(isPad){
//        thisScale = YScaleWidth;
//    }
//    else{
//        thisScale = YScaleWidth * 0.8;
//    }
    
    xieyiCoverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    xieyiCoverView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.55];

    [self.view addSubview:xieyiCoverView];
    
    
    UIView *xieyiMidV = [UIView new];
    xieyiMidV.backgroundColor = WhiteColor;
    xieyiMidV.layer.cornerRadius = 4;
    xieyiMidV.layer.masksToBounds = YES;
    [xieyiCoverView addSubview:xieyiMidV];
    xieyiMidV.sd_layout.centerXEqualToView(xieyiCoverView).centerYEqualToView(xieyiCoverView).widthIs(560 * thisScale).heightIs(394 * thisScale);
    
    UILabel *namexieyiL  = [UILabel new];
    namexieyiL.text = @"温馨提示";
//        namexieyiL.font = YSystemFont(17);
    namexieyiL.font = [UIFont fontWithName:@"Helvetica-Bold" size:26 * thisScale];
    namexieyiL.textColor = kblackColor;
    namexieyiL.textAlignment = NSTextAlignmentCenter;
    [xieyiMidV addSubview:namexieyiL];
    namexieyiL.sd_layout.topSpaceToView(xieyiMidV, 30 * thisScale).centerXEqualToView(xieyiMidV).widthIs(300).heightIs(38 * thisScale);
    
    UILabel *huanyingL  = [UILabel new];
    huanyingL.text = @"欢迎来到滑板车识字App。";
    huanyingL.font = YSystemFont(18 * thisScale);
    huanyingL.textColor = kblackColor;
    [xieyiMidV addSubview:huanyingL];
    huanyingL.sd_layout.topSpaceToView(namexieyiL, 24 * thisScale).leftSpaceToView(xieyiMidV, 40 * thisScale).widthIs(300).heightIs(27 * thisScale);

    
    //反馈label
    _xieyiLabel = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(18* thisScale).attach();

    make.text(@"感谢您的下载和使用，我们非常重视您的个人信息和隐私保护，为了更好的保障您的权益，在使用本产品前，请认真阅读《").color(kblackColor).attach();
        make.text(@"用户协议").color([JKUtil getColor:@"1D69FF"]).link(self , @selector(yonghuclick)).attach();
        make.text(@"》、《").color(kblackColor).attach();
        make.text(@"用户隐私政策").color([JKUtil getColor:@"1D69FF"]).link(self , @selector(yinsiclick)).attach();
        make.text(@"》、《").color(kblackColor).attach();
        make.text(@"儿童用户隐私政策").color([JKUtil getColor:@"1D69FF"]).link(self , @selector(ertongclick)).attach();
        make.text(@"》的全部内容，同意并接受全部条款后即可开始使用我们的产品和服务。").color(kblackColor).attach();
        
    }];
    
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:_xieyiLabel.text];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:5];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_xieyiLabel.text length])];
//    [_xieyiLabel setAttributedText:attributedString1];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;     //行间距
//    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:18* thisScale], NSParagraphStyleAttributeName:paragraphStyle};
//    _xieyiLabel.attributedText = [[NSAttributedString alloc] initWithString:_xieyiLabel.text attributes:attributes];
    
    [xieyiMidV addSubview:_xieyiLabel];
    _xieyiLabel.sd_layout.topSpaceToView(huanyingL, 20 * thisScale).widthIs(480 * thisScale).heightIs(135 * thisScale).centerXEqualToView(xieyiMidV);
        
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:[JKUtil getColor:@"8295A9"] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[JKUtil getColor:@"EEF2F8"]];
    btn1.titleLabel.font = YSystemFont(26 * thisScale);
    [btn1 addTarget:self action:@selector(butongyi) forControlEvents:UIControlEventTouchUpInside];
    [xieyiMidV addSubview:btn1];
    btn1.sd_layout.leftSpaceToView(xieyiMidV, 40 * thisScale).bottomSpaceToView(xieyiMidV, 30 * thisScale).widthIs(230 * thisScale).heightIs(60 * thisScale);
    btn1.layer.cornerRadius = 30 * thisScale;
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"同意" forState:UIControlStateNormal];
    [btn2 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[JKUtil getColor:@"1D69FF"]];
    btn2.titleLabel.font = YSystemFont(26 * thisScale);
    [btn2 addTarget:self action:@selector(tongyi) forControlEvents:UIControlEventTouchUpInside];
    [xieyiMidV addSubview:btn2];
    btn2.sd_layout.rightSpaceToView(xieyiMidV, 40 * thisScale).bottomSpaceToView(xieyiMidV, 30 * thisScale).widthIs(230 * thisScale).heightIs(60 * thisScale);
    btn2.layer.cornerRadius = 30 * thisScale;
}

- (void)yonghuclick{
    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://literacy.huabanche.club/literacy_user_agreement"]];
//    safariVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    safariVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:safariVc animated:YES completion:nil];

}

- (void)yinsiclick{
    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://literacy.huabanche.club/literacy_privacy"]];
//    safariVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    safariVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:safariVc animated:YES completion:nil];

}

- (void)ertongclick{
    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://literacy.huabanche.club/children_privacy/"]];
//    safariVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    safariVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:safariVc animated:YES completion:nil];

}

- (void)tongyi{
    [xieyiCoverView removeFromSuperview];
    xieyiCoverView = nil;
    
    [YUserDefaults setObject:@"keyi" forKey:kxieyi];
    
    [self setupView];
}

- (void)butongyi{
    [SVProgressHUD showErrorWithStatus:@"请同意后使用App"];
    [SVProgressHUD dismissWithDelay:1];
}


- (void)setupView{
    backV = self.view;
    
    //新增温馨提示页面
    //第一次打开
    if(![YUserDefaults objectForKey:kxieyi]){
        [self xieyiyemian];
        return;
    }

    
    scrollV = [[UIScrollView alloc] init];
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.backgroundColor = RedColor;
    scrollV.delegate = self;
    double zongchangdu = 256 * YScaleHeight * dataArr.count + 640 * YScaleHeight;
    scrollV.contentSize = CGSizeMake(zongchangdu , YScreenH);
    [backV addSubview: scrollV];
    scrollV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
    
    
    NSInteger bgCounts = 1 + zongchangdu / YScreenW;
    
    for (int i = 0 ; i < bgCounts; i++) {
        
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg%d",(i%8)+1]]];
        [scrollV addSubview:img];
        
        if(isPad){
            img.frame = CGRectMake(YScreenW * i, 0, YScreenW, YScreenH);
        }
        else{
            img.frame = CGRectMake(YScreenW * i, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
        }
        
        
        UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"road"]];
        [scrollV addSubview:roadImg];
        roadImg.frame = CGRectMake(YScreenW * i, YScreenH - YScreenW * 196/1080, YScreenW, YScreenW * 196/1080);
        
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
        v.frame = CGRectMake(320 * YScaleHeight + 256 * YScaleHeight * i, 0, 256 * YScaleHeight, 384 * YScaleHeight);
        v.mj_y = YScreenH - 196 * YScaleWidth - 384 * YScaleHeight + 42 * YScaleWidth;
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
        btn.sd_layout.centerXEqualToView(v).topSpaceToView(v, 192 * YScaleHeight).widthIs(73 * YScaleHeight).heightIs(70 * YScaleHeight);
        [btn addTarget:self action:@selector(caozuoClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
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
    if(hasLearnCount){
        hasLearnCount -= 1;
    }
    
    selectIndex = hasLearnCount;
    
    scrollV.contentOffset = CGPointMake(256 * YScaleHeight * hasLearnCount, 0);
    gifCenterX = 363 * YScaleHeight + 256 * YScaleHeight * hasLearnCount;   //初始位置
    
    UIImage *image = [YYImage imageNamed:@"shaonv.gif"];
    gifView = [[YYAnimatedImageView alloc] initWithImage:image];
    [gifView startAnimating];
    
    [backV addSubview:gifView];
    gifView.frame = CGRectMake( - 267 * YScaleHeight, 0, 267 * YScaleHeight, 282 * YScaleHeight);
    gifView.mj_y = YScreenH - 282 * YScaleHeight - 88 * YScaleWidth;

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
        self->gifView.centerX = 363 * YScaleHeight;
    } completion:^(BOOL finished) {
        
        //app下载之后只播放一次
        if(![YUserDefaults objectForKey:koneVoice]){
            //    播放录音
            NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"开始今天的学习吧" ofType:@"mp3"];
            NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
            [self bofangwithUrl:@[localVideoUrl]];
            
            self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                [self.player stop];
                self.player = nil;
            };

            [YUserDefaults setObject:@"you" forKey:koneVoice];
        }

        
    }];
        
}


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
    
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementuser"]];
    [headV addSubview:userIcon];
    userIcon.sd_layout.leftSpaceToView(headV, 5 * YScaleWidth).topSpaceToView(headV, 5 * YScaleWidth).bottomSpaceToView(headV, 5 * YScaleWidth).widthIs(82 * YScaleWidth);
    
    vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notvip"]];
    [headV addSubview:vipImg];
    vipImg.sd_layout.bottomSpaceToView(headV, 3 * YScaleWidth).leftSpaceToView(headV, 59 * YScaleWidth).widthIs(28 * YScaleWidth).heightEqualToWidth();
    
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
    
    NoHighBtn *ziBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [ziBtn setBackgroundImage:[UIImage imageNamed:@"elementfont"] forState:UIControlStateNormal];
    [backV addSubview:ziBtn];
    ziBtn.sd_layout.rightSpaceToView(backV, 38 * YScaleWidth).topSpaceToView(backV, 38 * YScaleWidth).widthIs(76 * YScaleWidth).heightIs(90 * YScaleWidth);
    [ziBtn addTarget:self action:@selector(ziClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)loading{
    LoadingBackV = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LoadingBackV.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.3];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:LoadingBackV];

    NSString *filepath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"loading"ofType:@"gif"];
    NSData *imagedata = [NSData dataWithContentsOfFile:filepath];
    UIImageView *loadImg = [[UIImageView alloc] init];
    loadImg.image= [UIImage sd_imageWithGIFData:imagedata];
    [LoadingBackV addSubview:loadImg];
    loadImg.sd_layout.centerYEqualToView(LoadingBackV).centerXEqualToView(LoadingBackV).widthIs(330 * YScaleHeight).heightIs(140 * YScaleHeight);

}

- (void)removeLoading{
    [LoadingBackV removeFromSuperview];
    LoadingBackV = nil;
}

#pragma mark - click
- (void)caozuoClick:(UIButton *)b{
    NSInteger ziIndex = b.superview.tag - 10000;
    YLog(@"%ld",ziIndex)
    
    //不是会员
//    if(![YUserDefaults boolForKey:kis_member]){
//        //未学习的字
//        if(ziIndex > ([YUserDefaults integerForKey:kfree_words_num] - 1)){
//
//            [self tapAction];
//            return;
//        }
//    }
    
    AllModel *selectedMod = dataArr[ziIndex];

    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
    param[@"word"] = selectedMod.word;
    param[@"id"] = [NSNumber numberWithInteger:selectedMod.ID];
        
    YLog(@"%@",[NSString getBaseUrl:_URL_fun withparam:param])
    
    
    [YLHttpTool POST:_URL_fun parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {
        
//        [LoadingBackV removeFromSuperview];
//        LoadingBackV = nil;


        if([dic[@"code"] integerValue] == 200){
            
            NSDictionary *dict = dic[@"data"];
        
            
            //不同字的时候  才开始动画
            if(ziIndex != selectIndex)
                [gifView startAnimating];


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
                    
                    //确定在图 左边还是右边
                    if(selectIndex < ziIndex){
                        self->gifCenterX = v.centerX - 85 * YScaleHeight;
                    }
                    else if(selectIndex > ziIndex){
                        self->gifCenterX = v.centerX + 85 * YScaleHeight;
                    }
                    
                    CGFloat huadongjuli = self->gifCenterX - self->scrollV.contentOffset.x;
                
                    scrollV.scrollEnabled = NO;
        //            * fabs(huadongjuli - gifView.centerX )/ 1080
                    [UIView animateWithDuration:Transformtimeinterval animations:^{
                        
                        self->gifView.centerX = huadongjuli;
                        
                    } completion:^(BOOL finished) {
                        
                        scrollV.scrollEnabled = YES;
                        selectIndex = ziIndex;
                        [gifView stopAnimating];

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

                        
                        vc.callBack = ^(NSInteger xuanzhongIndex) {
                    //                    self->ifNoanimation = YES;
                            [self ludengdianliang:xuanzhongIndex + 10000];
                        };
                        
                        [self presentViewController:vc animated:YES completion:^{

                        }];

                    }];


                    

                }
            }
            
            
            
            
            
            
            
            
            
            
            

        }
        
        else{
//            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
//            [SVProgressHUD dismissWithDelay:1.0];
            
            if ([dic[@"code"] integerValue] == 413) {
                //    播放录音
                NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"按顺序学习" ofType:@"mp3"];
                NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
                
                
                [self bofangwithUrl:@[localVideoUrl]];
                
                self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                    [self.player stop];
                    self.player = nil;
                };

                
    
            }
            
            
            //没购买   跳购买页面
            else if ([dic[@"code"] integerValue] == 415 || [dic[@"code"] integerValue] == 416){
                
                //    播放录音
                NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"解锁更多汉字" ofType:@"mp3"];
                NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
                
                [self bofangwithUrl:@[localVideoUrl]];
                
                self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
                    [self.player stop];
                    self.player = nil;
                };

                if([dic[@"code"] integerValue] == 415){
                    [self fetchuserInfo];
                }
                else{
                    [self tapAction];

                }
            }
            
            
            //未登录  或者
            else if ([dic[@"code"] integerValue] == 401){
                
                //清空旧数据
                NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
                
                [defs removeObjectForKey:khas_learn_num];
                [defs removeObjectForKey:kusername];
                [defs removeObjectForKey:ktoken];
                [defs removeObjectForKey:kis_member];
                [defs removeObjectForKey:kexpiretime];
                [defs removeObjectForKey:khas_purchase];
                [defs removeObjectForKey:kuserid];
                
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
                vipImg.image = [UIImage imageNamed:@"notvip"];
                vipL.alpha = 0.8;
                vipL.textColor = [JKUtil getColor:@"17449C"];
                self->vipL.text = @"当前未开通会员";
                
                [self plusClick:nil];
                
                //获取新的userid
                //网络请求数据
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                
                YLog(@"%@",[NSString getBaseUrl:_URL_userID withparam:param])
                
            //    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [YLHttpTool GET:_URL_userID parameters:param progress:^(NSProgress *progress) {
                    
                } success:^(id dic) {

                    if([dic[@"code"] integerValue] == 200){
                        
                        NSDictionary *d = dic[@"data"];
                        [YUserDefaults setObject:d[@"user_id"] forKey:kuserid];
                        
                        //跳转购买页
                        [self tapAction];


                    }
                    
                    YLog(@"%@",dic);
                } failure:^(NSError *error) {
                    //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
                }];

                
            }
            
            
            
            
            
        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
        
//        [LoadingBackV removeFromSuperview];
//        LoadingBackV = nil;

    }];

 
}

- (void)fetchuserInfo{
    /*
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    YLog(@"%@",[NSString getBaseUrl:_URL_userInfo withparam:param])
    
//    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [YLHttpTool POST:_URL_userInfo parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){

            NSDictionary *d = dic[@"data"];
            [YUserDefaults setObject:d[@"name"] forKey:kusername];
            [YUserDefaults setBool:[d[@"is_member"] boolValue] forKey:kis_member];
            [YUserDefaults setObject:d[@"expire_time"] forKey:kexpiretime];

            nameL.text = [YUserDefaults objectForKey:kusername];
            if([YUserDefaults boolForKey:kis_member]){
                self->vipImg.image = [UIImage imageNamed:@"vip"];
                self->vipL.text = [NSString stringWithFormat:@"有效期至%@",[YUserDefaults objectForKey:kexpiretime]];
                vipL.alpha = 1;
                self->vipL.textColor = [JKUtil getColor:@"FF6112"];
                
            }
            else{
                self->vipImg.image = [UIImage imageNamed:@"notvip"];
                self->vipL.text = @"当前未开通会员";
                vipL.alpha = 0.8;
                self->vipL.textColor = [JKUtil getColor:@"17449C"];
            }
            
            //未学习字锁定
            [self lockHoumian];
                 
            //跳转购买页
            [self tapAction];
            
        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];
    */
    
    [YUserDefaults setBool:NO forKey:kis_member];
    [YUserDefaults setBool:YES forKey:khas_purchase];

    vipL.text = @"您的会员已到期";
    vipL.alpha = 0.8;

    //未学习字锁定
    [self lockHoumian];

    //跳转购买页
    [self tapAction];

}

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
    
    for (UIView *v in scrollV.subviews) {
        if (v.subviews.count == 3)
        {
            UIImageView *img = v.subviews.lastObject;
            [img removeFromSuperview];
            img = nil;

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


- (void)ludengdianliang:(NSInteger)index{
    
    
    //点亮路灯
    for (UIView *v in scrollV.subviews) {
        if (v.tag == index)
        {
            UIImageView *img = v.subviews.firstObject;
            img.image = [UIImage imageNamed:@"lighton"];

            UIButton *b = v.subviews[1];
            [b setTitleColor:WhiteColor forState:UIControlStateNormal];

        }
    }
    
}

- (void)ziClick{
    WordsViewController *vc = [[WordsViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tapAction{
    MeViewController *meVc = [[MeViewController alloc] init];
//    [self.navigationController pushViewController:meVc animated:YES];
    meVc.modalPresentationStyle = UIModalPresentationFullScreen;
    meVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:meVc animated:YES completion:nil];
}

#pragma mark ————— scrollView代理方法 —————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    gifView.centerX = gifCenterX - scrollView.contentOffset.x;

    if(gifView.centerX < -256 * YScaleHeight * 0.5){
        gifView.centerX = -256 * YScaleHeight * 0.5;
    }
    
    else if(gifView.centerX > YScreenW + 256 * YScaleHeight * 0.5){
        gifView.centerX = YScreenW + 256 * YScaleHeight * 0.5;
    }
    
    
    //在滑动范围内操作
    if((scrollView.contentOffset.x >= 0) && (scrollView.contentOffset.x <= (256 * YScaleHeight * dataArr.count + 640 * YScaleHeight - YScreenW - 1))){
        
        //第一个字 必须一直向右
        if(gifCenterX > 448 * YScaleHeight){
            //调整人物方向
            if((scrollView.contentOffset.x - lastOffSetX) > 0) {
                NSLog(@"正在向左滑动");
                gifView.transform = CGAffineTransformMakeScale( 1.0, 1.0);//水平翻转
             }else{
                NSLog(@"正在向右滑动");
                 gifView.transform = CGAffineTransformMakeScale(-1.0, 1.0);//水平翻转
            }
           lastOffSetX = scrollView.contentOffset.x;

        }
        else{
            gifView.transform = CGAffineTransformMakeScale(1.0, 1.0);//水平翻转
        }

        
        
    }
    
    
    YLog(@"%f",scrollView.contentOffset.x)
    
    
    //对 scrollview的内容控制  不要超出范围
    if(scrollView.contentOffset.x < 0){
        scrollView.contentOffset = CGPointZero;
    }
    
    else if(scrollView.contentOffset.x >= (256 * YScaleHeight * dataArr.count + 640 * YScaleHeight - YScreenW))
    {
        scrollView.contentOffset = CGPointMake((256 * YScaleHeight * dataArr.count + 640 * YScaleHeight - YScreenW), 0);
    }
        
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
