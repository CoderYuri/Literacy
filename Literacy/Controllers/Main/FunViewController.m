//
//  FunViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/25.
//

#import "FunViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

//AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];// url：网络视频的连接
//
//float second = asset.duration.value/asset.duration.timescale;
//
//NSLog(@"second---:%f", second);// 视频秒数

@interface FunViewController ()<UIScrollViewDelegate>{
    UIView *backV;
    UIScrollView *scrollV;
    UIImageView *gifView;
    CGFloat gifCenterX;
    
    UIView *yidongV;
    
    UIImageView *renCoverImg;

    UIView *renV;
    UIView *dianshiV;
    UILabel *leftCiL;
    UILabel *rightCiL;
    
    UIView *duV;
    UIView *cikaV;
    UIImageView *huatongImg;
    
    UIView *wanV;
    UIView *okV1;
    UIView *okV2;
    NSInteger successIndex;  //成功个数
    NSInteger rightIndex;    //正确字的位置
    
    UIView *successV;
    CGFloat roadH;
    CGFloat ludengY;
    
    //播放器
    AVPlayer *avPlayer;
    AVPlayerItem * songItem;
    AVPlayerViewController *avPlayerVC;
}

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) AVPictureInPictureController *vc;



@end

@implementation FunViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}


- (void)setupView{
    backV = self.view;

    scrollV = [[UIScrollView alloc] init];
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.delegate = self;
    scrollV.scrollEnabled = NO;
    scrollV.contentSize = CGSizeMake(4 * YScreenW , YScreenH);
    [backV addSubview: scrollV];
    scrollV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
    
//    if(isPad)
//        roadH = YScreenH - 237 * YScaleHeight ;
//    else
//        roadH = YScreenH - 337 * YScaleHeight ;
//
    if(isPad){
        roadH = YScreenH - 237 * YScaleHeight ;
        ludengY = 224 * YScaleHeight;
    }
    
    else{
        ludengY = 174 * YScaleHeight;
        roadH = YScreenH - 287 * YScaleHeight ;
    }
    
    
    
    
    [self setRenV];
    [self setduV];
    [self setwanV];
    [self setsuccessV];
    
    
//    gifView = [[UIImageView alloc] init];
//    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"shaonv" ofType:@"gif"];
//    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//    gifView.image = [UIImage sd_imageWithGIFData:imageData];
    
    UIImage *image = [YYImage imageNamed:@"shaonv.gif"];
    gifView = [[YYAnimatedImageView alloc] initWithImage:image];
    [gifView startAnimating];

    
    [scrollV addSubview:gifView];
    gifView.frame = CGRectMake(-267 * YScaleHeight, 0,267 * YScaleHeight, 282 * YScaleHeight);
//    gifView.mj_y = YScreenH - 282 * YScaleHeight - 188 * YScaleHeight;
    
    if(isPad)
        gifView.mj_y = YScreenH - 282 * YScaleHeight - 188 * YScaleHeight;
    else{
        gifView.mj_y = YScreenH - 282 * YScaleHeight - 218 * YScaleHeight;
    }

    
    renCoverImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backCover"]];
    [backV addSubview:renCoverImg];
    renCoverImg.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
    renCoverImg.hidden = YES;

    
    NoHighBtn *backBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"iconback"] forState:UIControlStateNormal];
    [backV addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(backV, 27 * YScaleWidth).topSpaceToView(backV, 27 * YScaleWidth).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *shangV = [UIView new];
    shangV.backgroundColor = [JKUtil getColor:@"ECF9FF"];
    shangV.alpha = 0.4;
    shangV.layer.cornerRadius = 6 * YScaleWidth;
    shangV.layer.masksToBounds = YES;
    [backV addSubview:shangV];
    shangV.sd_layout.rightSpaceToView(backV, 30 * YScaleWidth).topSpaceToView(backV, 40 * YScaleWidth).widthIs(150 * YScaleWidth).heightIs(40 * YScaleWidth);

    UIView *youshangV = [UIView new];
    youshangV.backgroundColor = ClearColor;
    youshangV.layer.cornerRadius = 6 * YScaleWidth;
    youshangV.layer.masksToBounds = YES;
    [backV addSubview:youshangV];
    youshangV.sd_layout.rightSpaceToView(backV, 30 * YScaleWidth).topSpaceToView(backV, 40 * YScaleWidth).widthIs(150 * YScaleWidth).heightIs(40 * YScaleWidth);
    
    yidongV = [UIView new];
    yidongV.backgroundColor = korangeColor;
    yidongV.layer.cornerRadius = 6 * YScaleWidth;
    yidongV.layer.masksToBounds = YES;
    [youshangV addSubview:yidongV];
    yidongV.frame = CGRectMake(5 * YScaleWidth, 0, 40 * YScaleWidth, 40 * YScaleWidth);
    
    NSArray *nameA = @[@"认",@"读",@"玩"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [UILabel new];
        label.textColor = WhiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = nameA[i];
        label.font = YSystemFont(20 * YScaleWidth);
        label.frame = CGRectMake(50 * YScaleWidth * i, 0, 50 * YScaleWidth, 40 * YScaleWidth);
        [youshangV addSubview:label];
    }
    
    [self renyemian];
    
    
    //初始进入页面  开始认  动画
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        

//    });

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        self->gifView.centerX = 250 * YScaleWidth;

    } completion:^(BOOL finished) {
        [self->gifView stopAnimating];
        //加载电视机 放动画  完成之后进入下个页面
        
        [self dianshiVjiazai];
//        [self duVjiazai];
        
    }];

    
}


- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 0;
        _controlView.autoFadeTimeInterval = 0.1;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
//        _controlView.customDisablePanMovingDirection = YES;
    }
    return _controlView;
}


#pragma mark -- 认  页面操作
- (void)renyemian{
    dianshiV = [UIView new];
    [backV addSubview:dianshiV];
    dianshiV.sd_layout.centerXEqualToView(backV).bottomSpaceToView(backV, 5 * YScaleHeight).widthIs(852 * YScaleHeight).heightIs(731 * YScaleHeight);
    dianshiV.hidden = YES;
    
    UIImageView *tvImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementtv"]];
    [dianshiV addSubview:tvImg];
    tvImg.sd_layout.leftEqualToView(dianshiV).rightEqualToView(dianshiV).topEqualToView(dianshiV).bottomEqualToView(dianshiV);
    
    _containerView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:WhiteColor]];
    [dianshiV addSubview:_containerView];
    _containerView.frame = CGRectMake(98 * YScaleHeight, 128 * YScaleHeight, 656 * YScaleHeight, 492 * YScaleHeight);

    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];

    playerManager.shouldAutoPlay = YES;
    
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
    
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self
//               selector:@selector(applicationDidEnterBackground:)
//                   name:UIApplicationDidEnterBackgroundNotification
//                 object:nil];
    
}

- (void)dianshiVjiazai{
    /*
    //步骤1：获取视频路径
    //本地视频路径
//    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"ren" ofType:@"mp4"];
//    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    NSString *webVideoPath = self.word_video;
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    //步骤2：创建AVPlayer
    avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    avPlayerVC.showsPlaybackControls = NO;
    avPlayerVC.allowsPictureInPicturePlayback = YES;
//    avPlayerVC.view.backgroundColor = WhiteColor;
    //特别注意:AVPlayerViewController不能作为局部变量被释放，否则无法播放成功
    //解决1.AVPlayerViewController作为属性
    //解决2:使用addChildViewController，AVPlayerViewController作为子视图控制器
    [self addChildViewController:avPlayerVC];
    [dianshiV addSubview:avPlayerVC.view];
    //步骤4：设置播放器视图大小
    avPlayerVC.view.backgroundColor = ClearColor;
//    avPlayerVC.view.sd_layout.centerXEqualToView(dianshiV).topSpaceToView(dianshiV, 128 * YScaleHeight).widthIs(656 * YScaleHeight).heightIs(492 * YScaleHeight);
    avPlayerVC.view.frame = CGRectMake(98 * YScaleHeight, 128 * YScaleHeight, 656 * YScaleHeight, 492 * YScaleHeight);
    */
    dianshiV.hidden = NO;

    
    if([self.word_video containsString:@"http"]){
        
        
        self.player.assetURLs = @[[NSURL URLWithString:self.word_video]];
        [self.player playTheIndex:0];

        self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
            
            [UIView animateWithDuration:1 animations:^{
                [self->dianshiV removeFromSuperview];
                dianshiV = nil;

                self->renCoverImg.hidden = YES;
                
            } completion:^(BOOL finished) {
                self.player = nil;
                self.controlView = nil;
                
                [gifView startAnimating];
                [self ducaozuo];

            }];

        };
        
        self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {

            
            NSString *currentT = [NSString stringWithFormat:@"%.0f",currentTime];
            if([currentT integerValue] == 23){
                
                YLogFunc
                CATransition *anim = [CATransition animation];
                anim.type = @"fade";
                //        anim.subtype = kCATransitionFromRight;
                anim.duration = 1;
                [leftCiL.layer addAnimation:anim forKey:nil];
            
                leftCiL.hidden = NO;
            
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                    //延迟0.5s  开始消失
                    [rightCiL.layer addAnimation:anim forKey:nil];
                    rightCiL.hidden = NO;
            
            
                });

            }



        };
        
        
    }
    


    
    
    leftCiL = [self setZiLabel];
    leftCiL.text = self.combine_words.firstObject;
    [dianshiV addSubview:leftCiL];
    leftCiL.sd_layout.leftSpaceToView(dianshiV, 81 * YScaleHeight).bottomSpaceToView(dianshiV, 145 * YScaleHeight).widthIs(345 * YScaleHeight).heightIs(126 * YScaleHeight);
    
    rightCiL = [self setZiLabel];
    rightCiL.text = self.combine_words.lastObject;
    [dianshiV addSubview:rightCiL];
    rightCiL.sd_layout.rightSpaceToView(dianshiV, 81 * YScaleHeight).bottomSpaceToView(dianshiV, 145 * YScaleHeight).widthIs(345 * YScaleHeight).heightIs(126 * YScaleHeight);
    
    leftCiL.hidden = YES;
    rightCiL.hidden = YES;


    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.1]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath: @"transform.translation"];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(372 * YScaleWidth + 120 * YScaleHeight - YScreenW * 0.5, -180 * YScaleHeight)];

//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    //将多个basic动画事件添加到数组中 可以同时执行多个动画
    //自动的执行动画组当中的所有动画
    group.removedOnCompletion = NO;
    group.fillMode = @"forwards";
    // 动画选项设定
    group.duration = 1; // 动画持续时间
    group.repeatCount = 1; // 重复次数
    group.animations = @[animation,anim];
    [dianshiV.layer addAnimation:group forKey:nil];

    self->renCoverImg.hidden = NO;

    

    
}

//通知事件

- (void)applicationDidEnterBackground:(NSNotification *)notification {
//    [self.player enterFullScreen:YES animated:YES];
    
//    ZFAVPlayerManager *manager = (ZFAVPlayerManager *)self.player.currentPlayerManager;
//    AVPictureInPictureController *vc = [[AVPictureInPictureController alloc] initWithPlayerLayer:manager.avPlayerLayer];
//    self.vc = vc;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.vc startPictureInPicture];
//    });

    
    YLogFunc
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UILabel *)setZiLabel{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"kaiti" size:90 * YScaleHeight];
    label.textColor = [JKUtil getColor:@"2A2D34"];
    
    return label;
}

#pragma mark -- 读 页面操作
//进入读页面
- (void)ducaozuo{

//    [UIView animateWithDuration:Transformtimeinterval animations:^{
//        self->gifView.centerX =  - 134 * YScaleWidth + YScreenW;
//    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:Transformtimeinterval animations:^{
            
            [self->scrollV setContentOffset:CGPointMake(YScreenW, 0)];
            self->yidongV.mj_x = 55 * YScaleWidth;
            self->gifView.centerX =  250 * YScaleWidth + YScreenW;

        } completion:^(BOOL finished) {
            

            [gifView stopAnimating];
            //读的画面操作
            [self duVjiazai];

            
        }];
//    }];


}

- (void)duVjiazai{
    cikaV = [UIView new];
    [backV addSubview:cikaV];
    cikaV.sd_layout.centerXEqualToView(backV).bottomSpaceToView(backV, 120 * YScaleHeight).widthIs(922 * YScaleHeight).heightIs(550 * YScaleHeight);
    
    UIImageView *ciImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementbook"]];
    [cikaV addSubview:ciImg];
    ciImg.sd_layout.leftEqualToView(cikaV).rightEqualToView(cikaV).topEqualToView(cikaV).bottomEqualToView(cikaV);

    UIView *imgV = [UIView new];
    [cikaV addSubview:imgV];
    imgV.frame = CGRectMake(59 * YScaleHeight, 48 * YScaleHeight, 340 * YScaleHeight, 289 * YScaleHeight);
    
    UIImageView *leftimg = [[UIImageView alloc] init];
    [leftimg sd_setImageWithURL:[NSURL URLWithString:self.word_image]];
    [imgV addSubview:leftimg];
    leftimg.sd_layout.centerXEqualToView(imgV).centerYEqualToView(imgV).widthIs(340 * YScaleHeight * 1.5).heightIs(289 * YScaleHeight * 1.5);
    
//    leftimg.center = imgV.center;
//    leftimg.size = CGSizeMake(408 * YScaleHeight, 346.8 * YScaleHeight);

    
    UILabel *ziL = [self setZiLabel];
    ziL.font = [UIFont fontWithName:@"kaiti" size:200 * YScaleHeight];
    ziL.text = self.selectedMod.word;
    [cikaV addSubview:ziL];
    ziL.sd_layout.rightSpaceToView(cikaV, 76 * YScaleHeight).topSpaceToView(cikaV, 90 * YScaleHeight).widthIs(300 * YScaleHeight).heightIs(200 * YScaleHeight);
    
    UILabel *leftL = [self setZiLabel];
    leftL.text = self.combine_words.firstObject;
    [cikaV addSubview:leftL];
    leftL.sd_layout.leftSpaceToView(cikaV, 59 * YScaleHeight).bottomSpaceToView(cikaV, 75 * YScaleHeight).widthIs(340 * YScaleHeight).heightIs(90 * YScaleHeight);
    
    UILabel *rightL = [self setZiLabel];
    rightL.text = self.combine_words.lastObject;
    [cikaV addSubview:rightL];
    rightL.sd_layout.rightSpaceToView(cikaV, 59 * YScaleHeight).bottomSpaceToView(cikaV, 75 * YScaleHeight).widthIs(340 * YScaleHeight).heightIs(90 * YScaleHeight);
    
    UIImage *image = [YYImage imageNamed:@"huatong.gif"];
    huatongImg = [[YYAnimatedImageView alloc] initWithImage:image];
    [cikaV addSubview:huatongImg];
    huatongImg.frame = CGRectMake(360 * YScaleHeight, 670 * YScaleHeight, 201 * YScaleHeight, 255 * YScaleHeight);

    
    cikaV.hidden = YES;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CATransition *anim = [CATransition animation];
        anim.type = @"cube";
//        anim.type = kCATransitionFade;
        anim.duration = 1;
        [self->cikaV.layer addAnimation:anim forKey:nil];

        self->renCoverImg.hidden = NO;
        self->cikaV.hidden = NO;

    });
    
    
//    播放录音
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"跟我读" ofType:@"mp3"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    
//    NSString *webVideoPath = self.word_video;
//    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    
    [self bofangwithUrl:localVideoUrl];
    
    YLog(@"%ld",[self durationWithVideo:localVideoUrl]);

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification  object:songItem];


    //加载话筒  上升
//    [UIView animateWithDuration:[self durationWithVideo:localVideoUrl] animations:^{
//        YLogFunc
//
//    } completion:^(BOOL finished) {
//
//
//        [UIView animateWithDuration:1 animations:^{
//            [self->cikaV removeFromSuperview];
//            cikaV = nil;
//
//            self->renCoverImg.hidden = YES;
//
//
//        } completion:^(BOOL finished) {
//            [gifView startAnimating];
//            [self wancaozuo];
//
//        }];
//
//
//    }];
        
    

}

- (void)bofangwithUrl:(NSURL *)url{
    if(avPlayer){
        [avPlayer pause];
        avPlayer = nil;
    }
    
    songItem  = [[AVPlayerItem alloc]initWithURL:url];
    avPlayer = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [avPlayer play];
}


- (void)playbackFinished:(NSNotification *)notice {
    YLogFunc
    
    [UIView animateWithDuration:2 animations:^{
        self->huatongImg.mj_y = 415 * YScaleHeight;

    } completion:^(BOOL finished) {
        [huatongImg startAnimating];

        [UIView animateWithDuration:3 animations:^{
        } completion:^(BOOL finished) {
                    [huatongImg stopAnimating];
            
                    
                    [UIView animateWithDuration:1 animations:^{
                        [self->cikaV removeFromSuperview];
                        cikaV = nil;
            
                        self->renCoverImg.hidden = YES;
            
            
                    } completion:^(BOOL finished) {
                        [gifView startAnimating];
                        [self wancaozuo];
            
                    }];

        }];
        
    }];

    

    

    
    //再放一遍录音
    
    
}

- (NSUInteger)durationWithVideo:(NSURL *)videoUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    
    return second;
}

#pragma mark -- 玩 页面操作

- (void)wancaozuo{
    
//    [UIView animateWithDuration:Transformtimeinterval animations:^{
//        self->gifView.centerX =  - 134 * YScaleWidth + YScreenW * 2;
//    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:Transformtimeinterval animations:^{
            self->gifView.centerX = 100 * YScaleWidth + YScreenW * 2;

            [self->scrollV setContentOffset:CGPointMake(YScreenW * 2, 0)];
            self->yidongV.mj_x = 105 * YScaleWidth;

        } completion:^(BOOL finished) {
            [gifView stopAnimating];
            
        }];
//    }];

}



- (void)successCaozuo{
    
//    [UIView animateWithDuration:Transformtimeinterval animations:^{
//        self->gifView.centerX =  - 134 * YScaleWidth + YScreenW * 3;
//    } completion:^(BOOL finished) {
       
        [UIView animateWithDuration:3 animations:^{
            
            [self->scrollV setContentOffset:CGPointMake(YScreenW * 3, 0)];
            self->gifView.centerX = 90 * YScaleHeight + 764 * YScaleWidth + YScreenW * 3;

        } completion:^(BOOL finished) {
            
            [gifView stopAnimating];
            //成功接口
            [self successFetch];

            
        }];
//    }];


}

- (void)successFetch{
    
    if(self.xuanzhongIndex < [YUserDefaults integerForKey:khas_learn_num]){
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
    param[@"word"] = self.selectedMod.word;
    param[@"id"] = [NSNumber numberWithInteger:self.selectedMod.ID];

    YLog(@"%@",[NSString getBaseUrl:_URL_Success withparam:param])
    
//    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [YLHttpTool POST:_URL_Success parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){
            
            NSArray *arr = [YUserDefaults objectForKey:kziKu];
            NSMutableArray *array = [AllModel mj_objectArrayWithKeyValuesArray:arr];
            AllModel *mod = array[self.xuanzhongIndex];
            mod.is_learn = YES;
            [array replaceObjectAtIndex:self.xuanzhongIndex withObject:mod];
            
            NSArray *dictArr = [AllModel mj_keyValuesArrayWithObjectArray:array];
            [YUserDefaults setObject:dictArr forKey:kziKu];
            
            //播放语音
            [YUserDefaults setInteger:(self.xuanzhongIndex + 1) forKey:khas_learn_num];
            
            if(self.callBack){
                self.callBack(self.xuanzhongIndex);
            }
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];

}


#pragma mark -- View init
- (void)setRenV{
    renV = [UIView new];
    [scrollV addSubview:renV];
    renV.frame = CGRectMake(0, 0, YScreenW, YScreenH);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg7"]];
    [renV addSubview:img];
    
    if(isPad){
        img.frame = CGRectMake(0, 0, YScreenW, YScreenH);
    }
    else{
        img.frame = CGRectMake(0, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
    }
    
    
    UIImageView *imgg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funknow"]];
    [renV addSubview:imgg];
    imgg.frame = CGRectMake(372 * YScaleWidth, ludengY, 180 * YScaleHeight, 364 * YScaleHeight);
    
    
    UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funroad"]];
    [renV addSubview:roadImg];
    roadImg.frame = CGRectMake(0, roadH, YScreenW, 237 * YScaleWidth);
    

}

- (void)setduV{
    duV = [UIView new];
    [scrollV addSubview:duV];
    duV.frame = CGRectMake(YScreenW, 0, YScreenW, YScreenH);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg8"]];
    [duV addSubview:img];
    
    if(isPad){
        img.frame = CGRectMake(0, 0, YScreenW, YScreenH);
    }
    else{
        img.frame = CGRectMake(0, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
    }
    
    
    UIImageView *imgg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funread"]];
    [duV addSubview:imgg];
    imgg.frame = CGRectMake(372 * YScaleWidth, ludengY, 180 * YScaleHeight, 364 * YScaleHeight);
    
    
    UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funroad1"]];
    [duV addSubview:roadImg];
    roadImg.frame = CGRectMake(0, roadH, YScreenW, 237 * YScaleWidth);
    
}

- (void)setwanV{
    wanV = [UIView new];
    [scrollV addSubview:wanV];
    wanV.frame = CGRectMake(YScreenW * 2, 0, YScreenW, YScreenH);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    [wanV addSubview:img];
    
    if(isPad){
        img.frame = CGRectMake(0, 0, YScreenW, YScreenH);
    }
    else{
        img.frame = CGRectMake(0, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
    }
    
    
    //添加下面的路
    
    UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementroad1"]];
    [wanV addSubview:roadImg];
    roadImg.frame = CGRectMake(0, roadH, 529 * YScaleWidth, 237 * YScaleWidth);
    
    NSString *qianS = self.combine_words.firstObject;
    
    NSString *s1 = [qianS substringWithRange:NSMakeRange(0, 1)];
    
    UIView *fankunV;
    if([s1 isEqualToString:self.selectedMod.word]){
        fankunV = [self fangkuiVwithName:s1 andifnormal:NO];
        
        okV1 = fankunV;
        okV1.hidden = YES;
    }
    else{
        fankunV = [self fangkuiVwithName:s1 andifnormal:YES];
    }
    
    //217  377  676 836
    [wanV addSubview:fankunV];
    fankunV.sd_layout.leftSpaceToView(wanV, 217 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

//    UIView *fankunV1 = [self fangkuiVwithName:@"们" andifnormal:YES];
    NSString *s2 = [qianS substringWithRange:NSMakeRange(1, 1)];
    
    UIView *fankunV1;
    if([s2 isEqualToString:self.selectedMod.word]){
        fankunV1 = [self fangkuiVwithName:s2 andifnormal:NO];
        
        okV1 = fankunV1;
        okV1.hidden = YES;
    }
    else{
        fankunV1 = [self fangkuiVwithName:s2 andifnormal:YES];
    }
    [wanV addSubview:fankunV1];
    fankunV1.sd_layout.leftSpaceToView(wanV, 377 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

    
    
    UIImageView *roadImg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementroad2"]];
    [wanV addSubview:roadImg2];
    roadImg2.frame = CGRectMake(529 * YScaleWidth, roadH, 189 * YScaleWidth, 237 * YScaleWidth);
    
    UIImageView *roadImg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementroad3"]];
    [wanV addSubview:roadImg3];
    roadImg3.frame = CGRectMake(718 * YScaleWidth, roadH, 270 * YScaleWidth, 237 * YScaleWidth);
    
    NSString *houS = self.combine_words.lastObject;

    NSString *s3 = [houS substringWithRange:NSMakeRange(0, 1)];
    
    UIView *fankunV2;
    if([s3 isEqualToString:self.selectedMod.word]){
        fankunV2 = [self fangkuiVwithName:s3 andifnormal:NO];
        
        okV2 = fankunV2;
        okV2.hidden = YES;
    }
    else{
        fankunV2 = [self fangkuiVwithName:s3 andifnormal:YES];
    }

    
    //133  237 415 501
    [wanV addSubview:fankunV2];
    fankunV2.sd_layout.leftSpaceToView(wanV, 676 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

//    UIView *fankunV3 = [self fangkuiVwithName:@"民" andifnormal:YES];
    NSString *s4 = [houS substringWithRange:NSMakeRange(1, 1)];
    
    UIView *fankunV3;
    if([s4 isEqualToString:self.selectedMod.word]){
        fankunV3 = [self fangkuiVwithName:s4 andifnormal:NO];
        
        okV2 = fankunV3;
        okV2.hidden = YES;

    }
    else{
        fankunV3 = [self fangkuiVwithName:s4 andifnormal:YES];
    }

    
    [wanV addSubview:fankunV3];
    fankunV3.sd_layout.leftSpaceToView(wanV, 836 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

    

    UIImageView *roadImg4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementroad4"]];
    [wanV addSubview:roadImg4];
    roadImg4.frame = CGRectMake(988 * YScaleWidth, roadH, 92 * YScaleWidth, 237 * YScaleWidth);
    
    
    
    NSInteger counts = 4;
    UIView *ziBackV = [UIView new];
    [wanV addSubview:ziBackV];
    ziBackV.backgroundColor = ClearColor;
    ziBackV.sd_layout.topSpaceToView(wanV, 137 * YScaleHeight).centerXEqualToView(wanV).widthIs(counts * 156 * YScaleWidth + (counts - 1) * 48 * YScaleWidth).heightIs(156 * YScaleWidth);
    
    rightIndex = arc4random_uniform(4);
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.similar_words];
    [arr insertObject:self.selectedMod.word atIndex:rightIndex];
    
    
    for (int i = 0; i < counts; i++) {
        UIView *v = [UIView new];
        v.backgroundColor = ClearColor;
        [ziBackV addSubview:v];
        v.frame = CGRectMake(204 * YScaleWidth * i, 0, 156 * YScaleWidth, 156 * YScaleWidth);
        
        v.userInteractionEnabled = YES;
        v.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caozuoClick:)];
        tap.numberOfTapsRequired = 1;
        [v addGestureRecognizer:tap];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wanbackground"]];
        [v addSubview:img];
        img.sd_layout.leftEqualToView(v).rightEqualToView(v).topEqualToView(v).bottomEqualToView(v);

        UILabel *label = [UILabel new];
        label.text = arr[i];
        label.textColor = WhiteColor;
        label.font = [UIFont fontWithName:@"kaiti" size:80 * YScaleWidth];
        [v addSubview:label];
        label.sd_layout.centerXEqualToView(v).topSpaceToView(v, 38 * YScaleWidth).widthIs(84 * YScaleWidth).heightIs(80 * YScaleWidth);

    }
    

    
}

///动画轨迹  选择某个字
- (void)caozuoClick:(UITapGestureRecognizer *)tap{

    NSInteger ziIndex = tap.view.tag;
    
    if(ziIndex != rightIndex){
        UIView *v = tap.view;
        
        srand([[NSDate date] timeIntervalSince1970]);
        float rand=(float)random();
        CFTimeInterval t=rand*0.0000000001;
        
        [UIView animateWithDuration:0.1 delay:t options:0  animations:^
         {
            v.transform=CGAffineTransformMakeRotation(-0.05);
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
              {
                 v.transform=CGAffineTransformMakeRotation(0.05);
              } completion:^(BOOL finished) {}];
         }];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
             {
                 v.transform=CGAffineTransformIdentity;
             } completion:^(BOOL finished) {}];
            
        });
        
        
        //选错提示音
        
        
        return;
    }
    
    if(successIndex > 1){
        return;
    }
    
    
    NSInteger counts = 4;
    CGFloat leftMargin = (YScreenW -  (counts * 158 * YScaleWidth + (counts - 1) * 48 * YScaleWidth))/2;

    UIView *v = [UIView new];
    v.frame = CGRectMake(204 * YScaleWidth * ziIndex + leftMargin, 137 * YScaleHeight, 156 * YScaleWidth, 156 * YScaleWidth);
    [wanV addSubview:v];

    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wanbackground"]];
    [v addSubview:img];
    img.sd_layout.leftEqualToView(v).rightEqualToView(v).topEqualToView(v).bottomEqualToView(v);

    UILabel *label = [UILabel new];
    label.text = self.selectedMod.word;
    label.textColor = WhiteColor;
    label.font = [UIFont fontWithName:@"kaiti" size:80 * YScaleWidth];
    [v addSubview:label];
    label.sd_layout.centerXEqualToView(v).topSpaceToView(v, 38 * YScaleWidth).widthIs(84 * YScaleWidth).heightIs(80 * YScaleWidth);

    if(successIndex == 0){
        [UIView animateWithDuration:0.5 animations:^{
            v.center = okV1.center;
            
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
            self->okV1.hidden = NO;
        }];
    }
    
    else if (successIndex == 1){
        [UIView animateWithDuration:0.5 animations:^{
            v.center = okV2.center;
            
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
            self->okV2.hidden = NO;
            
            //一段成功的音乐
            
            
            [UIView animateWithDuration:1 animations:^{
                [gifView startAnimating];

            } completion:^(BOOL finished) {
                //缓缓进入  成功页
                [self successCaozuo];
            }];
        }];
    }
    
    

    successIndex ++;

}
    
    
- (UIView *)fangkuiVwithName:(NSString *)name andifnormal:(BOOL)ifnormal{
    UIView *zhanweiV = [UIView new];
    zhanweiV.backgroundColor = ClearColor;
    zhanweiV.frame = CGRectMake(0, 0, 114 * YScaleWidth, 114 * YScaleWidth);

    UIImageView *img = [[UIImageView alloc] init];
    [zhanweiV addSubview:img];
    img.sd_layout.leftEqualToView(zhanweiV).rightEqualToView(zhanweiV).topEqualToView(zhanweiV).bottomEqualToView(zhanweiV);
    
    UILabel *label = [UILabel new];
    label.text = name;
    label.font = [UIFont fontWithName:@"kaiti" size:80 * YScaleWidth];
    [zhanweiV addSubview:label];
    label.sd_layout.leftSpaceToView(zhanweiV, 36 * YScaleWidth).bottomSpaceToView(zhanweiV, 38 * YScaleWidth).widthIs(84 * YScaleWidth).heightIs(80 * YScaleWidth);
    
    
    if(ifnormal){
        img.image = [UIImage imageNamed:@"wannormal"];
        label.textColor = [JKUtil getColor:@"492B19"];
    }
    else{
        img.image = [UIImage imageNamed:@"wanpre"];
        label.textColor = WhiteColor;
    
    }
    return zhanweiV;;
}

- (void)setsuccessV{
    successV = [UIView new];
    [scrollV addSubview:successV];
    successV.frame = CGRectMake(YScreenW * 3, 0, YScreenW, YScreenH);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg2"]];
    [successV addSubview:img];
    

    //添加下面的路
    UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funroad2"]];
    [successV addSubview:roadImg];
    roadImg.frame = CGRectMake(0, roadH, YScreenW, 237 * YScaleWidth);
    
    UIImageView *imgg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementflag"]];
    [successV addSubview:imgg];
    imgg.frame = CGRectMake(764 * YScaleWidth, 0, 180 * YScaleHeight, 328 * YScaleHeight);
    
    if(isPad){
        img.frame = CGRectMake(0, 0, YScreenW, YScreenH);
        imgg.mj_y = 293 * YScaleHeight;

    }
    else{
        img.frame = CGRectMake(0, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
        imgg.mj_y = 263 * YScaleHeight;
    }

}


#pragma mark - click
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(self.player){
        self.player = nil;
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
