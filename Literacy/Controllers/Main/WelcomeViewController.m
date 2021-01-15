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
#import "FuxiViewController.h"

#import <SafariServices/SafariServices.h>

@interface WelcomeViewController (){
    BOOL ifFuxi;
    BOOL iffangwan;
    
    UIView *xieyiCoverView;
    NSArray *fuxiArr;
}

@property (nonatomic,strong) NudeIn *xieyiLabel;
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
            
            //获取字库信息
            //网络请求数据
            param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
            YLog(@"%@",[NSString getBaseUrl:_URL_words withparam:param])
            
            [YLHttpTool GET:_URL_words parameters:param progress:^(NSProgress *progress) {
                
            } success:^(id dic) {
                
                if([dic[@"code"] integerValue] == 200){
                    
                    NSDictionary *d = dic[@"data"];
                    NSArray *array = d[@"words"];
                    [YUserDefaults setObject:array forKey:kziKu];
                    
                    [YUserDefaults setInteger:[d[@"free_words_num"]integerValue] forKey:kfree_words_num];
                    [YUserDefaults setInteger:[d[@"has_learn_num"] integerValue] forKey:khas_learn_num];

                    YLog(@"%@",dic)

                }
                
            } failure:^(NSError *error) {
                
            }];

            
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

- (void)fetchFuxi{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取字库信息
    //网络请求数据
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
    YLog(@"%@",[NSString getBaseUrl:_URL_ifFuxi withparam:param])
    
    [YLHttpTool POST:_URL_ifFuxi parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {
        
        if([dic[@"code"] integerValue] == 200){
            ifFuxi = YES;
            fuxiArr = [NSArray arrayWithArray:dic[@"data"]];

            if(iffangwan){
                FuxiViewController *vc = [[FuxiViewController alloc] init];
                vc.fuxiArr = fuxiArr;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:vc animated:YES completion:nil];
            }
            
            
        }
        else{
            ifFuxi = NO;
            
            if(iffangwan){
                [(AppDelegate*)[UIApplication sharedApplication].delegate gotoMainVC];
            }
                
        }
        
        YLog(@"%@",dic)
        
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
        if([YUserDefaults objectForKey:ktoken]){
            fuxiArr = [NSArray array];
            
            [self fetchFuxi];
        }
    }
    else{
        [self netWorkChangeEvent];
    }
    
    self.view.backgroundColor = [JKUtil getColor:@"0061E8"];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"launchimage"];
    img.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:img];
    img.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).topEqualToView(self.view);
    
    //新增温馨提示页面
    //第一次打开
    if(![YUserDefaults objectForKey:kxieyi]){
        [self xieyiyemian];
    }

    
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"滑板车识字" ofType:@"mp3"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];

    [self bofangwithUrl:@[localVideoUrl]];

    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [self.player stop];
        self.player = nil;
        iffangwan = YES;
        
        if([YUserDefaults objectForKey:kxieyi]){
            
            if(ifFuxi){
                FuxiViewController *vc = [[FuxiViewController alloc] init];
                vc.fuxiArr = fuxiArr;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:vc animated:YES completion:nil];
            }
            else{
                [(AppDelegate*)[UIApplication sharedApplication].delegate gotoMainVC];
            }
            
        }
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

#pragma mark - 协议页面
//首次进入app 协议页面
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

//用户协议
- (void)yonghuclick{
    [self shuxueti:^{
        SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://literacy.huabanche.club/literacy_user_agreement"]];
    //    safariVc.modalPresentationStyle = UIModalPresentationFullScreen;
    //    safariVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:safariVc animated:YES completion:^{
        }];
    }];
}

//隐私协议
- (void)yinsiclick{
    [self shuxueti:^{
        SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://literacy.huabanche.club/literacy_privacy"]];
    //    safariVc.modalPresentationStyle = UIModalPresentationFullScreen;
    //    safariVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:safariVc animated:YES completion:^{
        }];

    }];
}

//儿童隐私协议
- (void)ertongclick{

    [self shuxueti:^{
        
        SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://literacy.huabanche.club/children_privacy/"]];
    //    safariVc.modalPresentationStyle = UIModalPresentationFullScreen;
    //    safariVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:safariVc animated:YES completion:^{
        }];

    }];
}

- (void)shuxueti:(void (^)(void))completionBlock{
    __block UITextField *textF = [[UITextField alloc] init];
    
    NSInteger a = arc4random_uniform(20)+1;
    NSInteger b = arc4random_uniform(20)+1;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"为确保您是家长\n请回答以下问题" message:[NSString stringWithFormat:@"%ld + %ld = ?",a,b] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([textF.text integerValue] == (a + b)){
            if(completionBlock){
                completionBlock();
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"回答错误，请重试"];
            [SVProgressHUD dismissWithDelay:1];
            
        }

    }];
    
    [cancel setValue:kblackColor forKey:@"titleTextColor"];
    [confirm setValue:kblackColor forKey:@"titleTextColor"];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    

    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textF = textField;
        textF.backgroundColor = ClearColor;
        textF.keyboardType = UIKeyboardTypeNumberPad;
    }];
    

    [self presentViewController:alert animated:YES completion:nil];
    
}


//同意并进入
- (void)tongyi{
    [xieyiCoverView removeFromSuperview];
    xieyiCoverView = nil;
    
    [YUserDefaults setObject:@"keyi" forKey:kxieyi];
    
    if([YUserDefaults objectForKey:kuserid]){
        [(AppDelegate*)[UIApplication sharedApplication].delegate gotoMainVC];
    }
}

//不同意操作
- (void)butongyi{
    [SVProgressHUD showErrorWithStatus:@"请同意后使用App"];
    [SVProgressHUD dismissWithDelay:1];
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
