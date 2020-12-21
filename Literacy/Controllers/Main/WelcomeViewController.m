//
//  WelcomeViewController.m
//  Literacy
//
//  Created by Yuri on 2020/12/11.
//

#import "WelcomeViewController.h"

#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

#import "MainViewController.h"

@interface WelcomeViewController (){
    BOOL fangwan;
}

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

/*
 当前的网络状态
 */
@property(nonatomic,assign)int netWorkStatesCode;


@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

//- (ZFPlayerControlView *)controlView {
//    if (!_controlView) {
//        _controlView = [ZFPlayerControlView new];
//        _controlView.fastViewAnimated = YES;
//        _controlView.autoHiddenTimeInterval = 0;
//        _controlView.autoFadeTimeInterval = 2;
//        _controlView.prepareShowLoading = YES;
//        _controlView.prepareShowControlView = NO;
//    }
//    return _controlView;
//}

-(void)netWorkChangeEvent
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    self.netWorkStatesCode =AFNetworkReachabilityStatusUnknown;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netWorkStatesCode = status;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前使用的是流量模式");
                [self getuserID];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前使用的是wifi模式");
                [self getuserID];

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

#pragma mark - 释放应用
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"netWorkChangeEventNotification" object:nil];
}


- (void)getuserID{
    //网络请求数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    YLog(@"%@",[NSString getBaseUrl:_URL_userID withparam:param])
    
//    NSString *urlString = [_URL_userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [YLHttpTool GET:_URL_userID parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {

        if([dic[@"code"] integerValue] == 200){
            
            NSDictionary *d = dic[@"data"];
            [YUserDefaults setObject:d[@"user_id"] forKey:kuserid];
            
            [(AppDelegate*)[UIApplication sharedApplication].delegate gotoMainVC];
        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
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

    }];

        
}

- (void)bofangwithUrl:(NSArray *)urlArr{
    if(self.player){
        [self.player stop];
        self.player = nil;
    }

    self.player = [ZFPlayerController playerWithPlayerManager: [[ZFAVPlayerManager alloc] init] containerView:[UIView new]];

    self.player.assetURLs = urlArr;
    [self.player playTheIndex:0];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([YUserDefaults objectForKey:kuserid]){
    }
    else{
        [self netWorkChangeEvent];
    }
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"launchimage"];
    img.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:img];
    img.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).topEqualToView(self.view);
    
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"滑板车识字" ofType:@"mp3"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];

    [self bofangwithUrl:@[localVideoUrl]];

    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [self.player stop];
        self.player = nil;
        
        [(AppDelegate*)[UIApplication sharedApplication].delegate gotoMainVC];
    };


    
    /*
    _containerView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:WhiteColor]];
    [self.view addSubview:_containerView];
    _containerView.frame = CGRectMake(0, 0, YScreenW, YScreenH);

    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];

    playerManager.shouldAutoPlay = YES;
    
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    
    self.player.assetURLs = @[[NSURL fileURLWithPath:[[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"welcome" ofType:@"mp4"]]];
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];

    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        fangwan = YES;
        
        if([YUserDefaults objectForKey:kuserid]){
            [(AppDelegate*)[UIApplication sharedApplication].delegate gotoMainVC];
//            MainViewController *vc = [[MainViewController alloc] init];
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self presentViewController:vc animated:YES completion:nil];
        }
    };
     */
    
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
