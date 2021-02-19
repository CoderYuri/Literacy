//
//  FuxiViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/30.
//

#import "FuxiViewController.h"
#import "FuxiPlayViewController.h"

@interface FuxiViewController (){
    UIView *backV;
    UIButton *loginBtn;
}

@property (nonatomic, strong) ZFPlayerController *player;

@end

@implementation FuxiViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    
    if(self.player){
        [self.player stop];
        self.player = nil;
    }
}

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
               selector:@selector(applicationDidBecomeActive:)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
               selector:@selector(applicationDidEnterBackground:)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];

    [self setupView];
    
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"开始充电" ofType:@"mp3"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    [self bofangwithUrl:@[localVideoUrl]];
    
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [self.player stop];
        self.player = nil;
    };
    
}

- (void)setupView{
    backV = self.view;
    
    CGFloat thisScale;
    if(isPad){
        thisScale = YScaleWidth;
    }
    else{
        if([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom){
            thisScale = YScaleWidth * 0.8;
        }
        else{
            thisScale = YScaleWidth * 0.9;
        }
    }
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    if(isPad){
        img.frame = CGRectMake(0 , 0, YScreenW, YScreenH);
    }
    else{
        img.frame = CGRectMake(0, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
    }
    [backV addSubview:img];

    
    UIImageView *renCoverImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backCover"]];
    [backV addSubview:renCoverImg];
    renCoverImg.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);

    UIImageView *fuImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup"]];
    [backV addSubview:fuImg];
    fuImg.sd_layout.centerXEqualToView(backV).centerYEqualToView(backV).widthIs(560 * thisScale).heightIs(438 * thisScale);
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"开始充电" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:korangeColor];
    loginBtn.titleLabel.font = YSystemFont(22 * thisScale);
    [loginBtn addTarget:self action:@selector(fuxiClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 29 * thisScale;
    loginBtn.layer.masksToBounds = YES;
    [backV addSubview:loginBtn];
    loginBtn.sd_layout.centerXEqualToView(backV).topSpaceToView(fuImg, -41 * thisScale).widthIs(310 * thisScale).heightIs(58 * thisScale);
    
    [self doudongBtn];
}

- (void)doudongBtn{
    srand([[NSDate date] timeIntervalSince1970]);
    float rand= (float)random();
    CFTimeInterval t = rand * 0.0000000001;
    
    [UIView animateWithDuration:1 delay:t options:0 animations:^
     {
        loginBtn.transform = CGAffineTransformMakeScale(0.95, 0.95);;
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
          {
             loginBtn.transform = CGAffineTransformMakeScale(1.05, 1.05);;
          } completion:^(BOOL finished) {}];
     }];
}

//app进入前台
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self doudongBtn];
}


//app进入后台
- (void)applicationDidEnterBackground:(NSNotification *)notification {
//    loginBtn.transform = CGAffineTransformIdentity;
    loginBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);;
}


- (void)fuxiClick{
    FuxiPlayViewController *vc = [[FuxiPlayViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.successCounts = 0;
    vc.fuxiArr = self.fuxiArr;
    [self presentViewController:vc animated:YES completion:^{
    }];
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
