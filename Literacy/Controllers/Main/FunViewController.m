//
//  FunViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/25.
//

#import "FunViewController.h"
#define Transformtimeinterval 1.0

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


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
    
    UIView *duV;
    UIView *cikaV;
    UIImageView *huatongImg;
    
    UIView *wanV;
    UIView *okV1;
    UIView *okV2;
    NSInteger successIndex;
    
    UIView *successV;
    CGFloat roadH;
    CGFloat ludengY;
}

@end

@implementation FunViewController

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
    
    
    //初始进入页面  开始认  动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:Transformtimeinterval animations:^{
            self->gifView.centerX = 250 * YScaleWidth;

        } completion:^(BOOL finished) {
            [self->gifView stopAnimating];
            //加载电视机 放动画  完成之后进入下个页面
            [self dianshiVjiazai];
//            [self wancaozuo];
            
        }];

    });

}


#pragma mark -- 认  页面操作
- (void)dianshiVjiazai{
    
    dianshiV = [UIView new];
    [backV addSubview:dianshiV];
    dianshiV.sd_layout.centerXEqualToView(backV).bottomSpaceToView(backV, 5 * YScaleHeight).widthIs(852 * YScaleHeight).heightIs(731 * YScaleHeight);
    
    UIImageView *tvImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementtv"]];
    [dianshiV addSubview:tvImg];
    tvImg.sd_layout.leftEqualToView(dianshiV).rightEqualToView(dianshiV).topEqualToView(dianshiV).bottomEqualToView(dianshiV);
    
    //步骤1：获取视频路径
    //本地视频路径
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"ren" ofType:@"mp4"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    
//    NSString *webVideoPath = @"http://api.junqingguanchashi.net/yunpan/bd/c.php?vid=/junqing/1213.mp4";
//    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:localVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    avPlayerVC.showsPlaybackControls = NO;
//    avPlayerVC.view.backgroundColor = WhiteColor;
    //特别注意:AVPlayerViewController不能作为局部变量被释放，否则无法播放成功
    //解决1.AVPlayerViewController作为属性
    //解决2:使用addChildViewController，AVPlayerViewController作为子视图控制器
    [self addChildViewController:avPlayerVC];
    [dianshiV addSubview:avPlayerVC.view];
    //步骤4：设置播放器视图大小
    avPlayerVC.view.backgroundColor = ClearColor;
    avPlayerVC.view.sd_layout.centerXEqualToView(dianshiV).topSpaceToView(dianshiV, 128 * YScaleHeight).widthIs(656 * YScaleHeight).heightIs(492 * YScaleHeight);
    
    UILabel *leftL = [self setZiLabel];
    leftL.text = @"人类";
    [dianshiV addSubview:leftL];
    leftL.sd_layout.leftSpaceToView(dianshiV, 81 * YScaleHeight).bottomSpaceToView(dianshiV, 145 * YScaleHeight).widthIs(345 * YScaleHeight).heightIs(126 * YScaleHeight);
    
    UILabel *rightL = [self setZiLabel];
    rightL.text = @"人物";
    [dianshiV addSubview:rightL];
    rightL.sd_layout.rightSpaceToView(dianshiV, 81 * YScaleHeight).bottomSpaceToView(dianshiV, 145 * YScaleHeight).widthIs(345 * YScaleHeight).heightIs(126 * YScaleHeight);
    
    leftL.hidden = YES;
    rightL.hidden = YES;


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

    
//    dianshiV.hidden = YES;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        CATransition *anim = [CATransition animation];
//        anim.type = @"cube";
////        anim.type = kCATransitionFade;
//        anim.duration = 1;
//        [dianshiV.layer addAnimation:anim forKey:nil];
//
//        self->renCoverImg.hidden = NO;
//        dianshiV.hidden = NO;
//
//    });


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [avPlayer play];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CATransition *anim = [CATransition animation];
        anim.type = @"fade";
        //        anim.subtype = kCATransitionFromRight;
        anim.duration = 2;
        [leftL.layer addAnimation:anim forKey:nil];

        leftL.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            //延迟0.5s  开始消失
            [rightL.layer addAnimation:anim forKey:nil];
            rightL.hidden = NO;

            
            //动画完成之后  开始页面消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:1 animations:^{
                    [self->dianshiV removeFromSuperview];
                    dianshiV = nil;

                    self->renCoverImg.hidden = YES;
                    

                } completion:^(BOOL finished) {
                    [gifView startAnimating];
                    [self ducaozuo];

                }];

                
            });
            
        });

        
    });
    
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
    
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        [self->scrollV setContentOffset:CGPointMake(YScreenW, 0)];
        self->yidongV.mj_x = 55 * YScaleWidth;
        
    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:2 animations:^{
        self->gifView.centerX = 250 * YScaleWidth + YScreenW;
    } completion:^(BOOL finished) {
        [gifView stopAnimating];
        //读的画面操作
        [self duVjiazai];
    }];


}

- (void)duVjiazai{
    cikaV = [UIView new];
    [backV addSubview:cikaV];
    cikaV.sd_layout.centerXEqualToView(backV).bottomSpaceToView(backV, 120 * YScaleHeight).widthIs(922 * YScaleHeight).heightIs(550 * YScaleHeight);
    
    UIImageView *ciImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementbook"]];
    [cikaV addSubview:ciImg];
    ciImg.sd_layout.leftEqualToView(cikaV).rightEqualToView(cikaV).topEqualToView(cikaV).bottomEqualToView(cikaV);

    UIImageView *leftimg = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:YRandomColor]];
    [cikaV addSubview:leftimg];
    leftimg.sd_layout.leftSpaceToView(cikaV, 59 * YScaleHeight).topSpaceToView(cikaV, 48 * YScaleHeight).widthIs(340 * YScaleHeight).heightIs(289 * YScaleHeight);
    
    UILabel *ziL = [self setZiLabel];
    ziL.font = [UIFont fontWithName:@"kaiti" size:200 * YScaleHeight];
    ziL.text = @"人";
    [cikaV addSubview:ziL];
    ziL.sd_layout.rightSpaceToView(cikaV, 76 * YScaleHeight).topSpaceToView(cikaV, 90 * YScaleHeight).widthIs(300 * YScaleHeight).heightIs(200 * YScaleHeight);
    
    UILabel *leftL = [self setZiLabel];
    leftL.text = @"人类";
    [cikaV addSubview:leftL];
    leftL.sd_layout.leftSpaceToView(cikaV, 59 * YScaleHeight).bottomSpaceToView(cikaV, 75 * YScaleHeight).widthIs(340 * YScaleHeight).heightIs(90 * YScaleHeight);
    
    UILabel *rightL = [self setZiLabel];
    rightL.text = @"人物";
    [cikaV addSubview:rightL];
    rightL.sd_layout.rightSpaceToView(cikaV, 59 * YScaleHeight).bottomSpaceToView(cikaV, 75 * YScaleHeight).widthIs(340 * YScaleHeight).heightIs(90 * YScaleHeight);
    
    UIImage *image = [YYImage imageNamed:@"huatong.gif"];
    huatongImg = [[YYAnimatedImageView alloc] initWithImage:image];
    [cikaV addSubview:huatongImg];
    huatongImg.frame = CGRectMake(360 * YScaleHeight, 670 * YScaleHeight, 201 * YScaleHeight, 255 * YScaleHeight);
    [huatongImg startAnimating];

    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //加载话筒  上升
        [UIView animateWithDuration:1 animations:^{
            self->huatongImg.mj_y = 415 * YScaleHeight;
        } completion:^(BOOL finished) {
            
            //播放录音

            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:1 animations:^{
                    [self->cikaV removeFromSuperview];
                    cikaV = nil;

                    self->renCoverImg.hidden = YES;
                    

                } completion:^(BOOL finished) {
                    [gifView startAnimating];
                    [self wancaozuo];

                }];

                
                
            });
            
            
        }];
        
    });
    

}


#pragma mark -- 玩 页面操作

- (void)wancaozuo{
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        
        [self->scrollV setContentOffset:CGPointMake(YScreenW * 2, 0)];
        self->yidongV.mj_x = 105 * YScaleWidth;

    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:2 animations:^{
        self->gifView.centerX = 100 * YScaleWidth + YScreenW * 2;
    } completion:^(BOOL finished) {
        [gifView stopAnimating];

    }];

}



- (void)successCaozuo{
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        
        [self->scrollV setContentOffset:CGPointMake(YScreenW * 3, 0)];

    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:3 animations:^{
        self->gifView.centerX = 90 * YScaleHeight + 764 * YScaleWidth + YScreenW * 3;
    } completion:^(BOOL finished) {
        
        //成功之后操作  调用接口  返回。。
        [gifView stopAnimating];

    }];

}

#pragma mark -- View init

- (void)setRenV{
    renV = [UIView new];
    [scrollV addSubview:renV];
    renV.frame = CGRectMake(0, 0, YScreenW, YScreenH);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
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
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
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
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
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
    
    
    UIView *fankunV = [self fangkuiVwithName:@"人" andifnormal:NO];
    //217  377  676 836
    [wanV addSubview:fankunV];
    fankunV.sd_layout.leftSpaceToView(wanV, 217 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

    UIView *fankunV1 = [self fangkuiVwithName:@"们" andifnormal:YES];
    [wanV addSubview:fankunV1];
    fankunV1.sd_layout.leftSpaceToView(wanV, 377 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

    
    
    UIImageView *roadImg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementroad2"]];
    [wanV addSubview:roadImg2];
    roadImg2.frame = CGRectMake(529 * YScaleWidth, roadH, 189 * YScaleWidth, 237 * YScaleWidth);
    
    UIImageView *roadImg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementroad3"]];
    [wanV addSubview:roadImg3];
    roadImg3.frame = CGRectMake(718 * YScaleWidth, roadH, 270 * YScaleWidth, 237 * YScaleWidth);
    
    UIView *fankunV2 = [self fangkuiVwithName:@"人" andifnormal:NO];
    //133  237 415 501
    [wanV addSubview:fankunV2];
    fankunV2.sd_layout.leftSpaceToView(wanV, 676 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

    UIView *fankunV3 = [self fangkuiVwithName:@"民" andifnormal:YES];
    [wanV addSubview:fankunV3];
    fankunV3.sd_layout.leftSpaceToView(wanV, 836 * YScaleWidth).topSpaceToView(wanV, roadH + 16 * YScaleWidth).widthIs(190 * YScaleWidth).heightEqualToWidth();

    

    UIImageView *roadImg4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementroad4"]];
    [wanV addSubview:roadImg4];
    roadImg4.frame = CGRectMake(988 * YScaleWidth, roadH, 92 * YScaleWidth, 237 * YScaleWidth);
    
    okV1 = fankunV;
    okV2 = fankunV2;
    okV1.hidden = YES;
    okV2.hidden = YES;
    
    
    NSInteger counts = 4;
    UIView *ziBackV = [UIView new];
    [wanV addSubview:ziBackV];
    ziBackV.backgroundColor = ClearColor;
    ziBackV.sd_layout.topSpaceToView(wanV, 137 * YScaleHeight).centerXEqualToView(wanV).widthIs(counts * 156 * YScaleWidth + (counts - 1) * 48 * YScaleWidth).heightIs(156 * YScaleWidth);
    
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
        label.text = @"人";
        label.textColor = WhiteColor;
        label.font = [UIFont fontWithName:@"kaiti" size:80 * YScaleWidth];
        [v addSubview:label];
        label.sd_layout.centerXEqualToView(v).topSpaceToView(v, 38 * YScaleWidth).widthIs(84 * YScaleWidth).heightIs(80 * YScaleWidth);

    }
    

    
}

///动画轨迹
- (void)caozuoClick:(UITapGestureRecognizer *)tap{

    NSInteger ziIndex = tap.view.tag;
    
    if(ziIndex != 1){
        YLogFunc
        //选错提示音
        return;
    }
    
    if(successIndex > 1){
        return;
    }
    
    
    NSInteger counts = 3;
    CGFloat leftMargin = (YScreenW -  (counts * 158 * YScaleWidth + (counts - 1) * 48 * YScaleWidth))/2;

    UIView *v = [UIView new];
    v.frame = CGRectMake(204 * YScaleWidth * ziIndex + leftMargin, 137 * YScaleWidth, 156 * YScaleWidth, 156 * YScaleWidth);
    [wanV addSubview:v];

    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wanbackground"]];
    [v addSubview:img];
    img.sd_layout.leftEqualToView(v).rightEqualToView(v).topEqualToView(v).bottomEqualToView(v);

    UILabel *label = [UILabel new];
    label.text = @"人";
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
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [gifView startAnimating];
                //缓缓进入  成功页
                [self successCaozuo];

            });
            
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
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
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
    
    if(self.callBack){
        self.callBack(self.xuanzhongIndex);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
