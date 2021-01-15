//
//  FuxiPlayViewController.m
//  Literacy
//
//  Created by Yuri on 2020/12/1.
//

#import "FuxiPlayViewController.h"

@interface FuxiPlayViewController (){
    UIView *backV;
    UIView *bufferV;
    
    NoHighBtn *labaBtn;
    NoHighBtn *nextBtn;
    NoHighBtn *backBtn;
    
    UIView *lightV;
    UIView *ziV;
    
    NSInteger rightIndex;
    
    NSDictionary *thisDict;
    BOOL ifback;
}

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation FuxiPlayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
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
    
    thisDict = self.fuxiArr[self.successCounts];
    [self setupView];
}

- (void)setupView{
    backV = self.view;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuxibg"]];
    if(isPad){
        img.frame = CGRectMake(0 , 0, YScreenW, YScreenH);
    }
    else{
        img.frame = CGRectMake(0, YScreenH - YScreenW * 0.75, YScreenW, YScreenW * 0.75);
    }
    [backV addSubview:img];
    
    UIView *coverV = [UIView new];
    coverV.backgroundColor = WhiteColor;
    coverV.alpha = 0.14;
    coverV.layer.cornerRadius = 4;
    [backV addSubview:coverV];
    coverV.sd_layout.centerXEqualToView(backV).topSpaceToView(backV, 120 * YScaleHeight).widthIs(1020 * YScaleWidth).bottomSpaceToView(backV, 30 * YScaleHeight);
    
    UIView *scheduleV = [UIView new];
    [backV addSubview:scheduleV];
    scheduleV.backgroundColor = ClearColor;
    scheduleV.sd_layout.rightSpaceToView(backV, 30 * YScaleWidth).topSpaceToView(backV, 30 * YScaleHeight).widthIs(191 * YScaleHeight).heightIs(62 * YScaleHeight);
    
    UIImageView *scheduleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuxischedule"]];
    [scheduleV addSubview:scheduleImg];
    scheduleImg.sd_layout.leftEqualToView(scheduleV).rightEqualToView(scheduleV).topEqualToView(scheduleV).bottomEqualToView(scheduleV);
    
    
    bufferV = [UIView new];
    [scheduleV addSubview:bufferV];
    bufferV.backgroundColor = ClearColor;
    [scheduleV addSubview:bufferV];
    bufferV.sd_layout.leftSpaceToView(scheduleV, 10 * YScaleHeight).centerYEqualToView(scheduleV).widthIs(154 * YScaleHeight).heightIs(46 * YScaleHeight);
    
    for (int i = 0; i < 5; i++) {
        UIView *v = [UIView new];
        v.backgroundColor = [JKUtil getColor:@"CAE6FF"];
        [bufferV addSubview:v];
        v.frame = CGRectMake(30 * YScaleHeight * i, 0, 26 * YScaleHeight, 46 * YScaleHeight);
    }
    
    [self setschedule];
    
    labaBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [labaBtn setBackgroundImage:[UIImage imageNamed:@"fuxiplay"] forState:UIControlStateNormal];
    [backV addSubview:labaBtn];
    labaBtn.sd_layout.leftSpaceToView(backV, 30 * YScaleWidth + 27 * YScaleHeight).bottomSpaceToView(backV,57 * YScaleHeight).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [labaBtn addTarget:self action:@selector(labaClick) forControlEvents:UIControlEventTouchUpInside];
    
    nextBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"fuxinext"] forState:UIControlStateNormal];
    [backV addSubview:nextBtn];
    nextBtn.sd_layout.rightSpaceToView(backV, 30 * YScaleWidth + 27 * YScaleHeight).bottomSpaceToView(backV,57 * YScaleHeight).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"iconback"] forState:UIControlStateNormal];
    [backV addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(backV, 27 * YScaleWidth).topSpaceToView(backV, 27 * YScaleWidth).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    labaBtn.hidden = YES;
    nextBtn.hidden = YES;
    backBtn.hidden = YES;
    
    ziV = [UIView new];
    [backV addSubview:ziV];
    ziV.backgroundColor = ClearColor;
    ziV.sd_layout.rightSpaceToView(backV, 96 * YScaleWidth).topSpaceToView(backV, 293 * YScaleHeight).widthIs(422 * YScaleHeight).heightIs(418 * YScaleHeight);
    
    NSMutableArray *ziArr = [NSMutableArray arrayWithArray:thisDict[@"similar_words"]];
    rightIndex = arc4random_uniform(4);
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.similar_words];
    [ziArr insertObject:thisDict[@"word"] atIndex:rightIndex];
    
    for (int i = 0; i < ziArr.count; i++) {
        UIView *v = [UIView new];
        v.backgroundColor = ClearColor;
        v.frame = CGRectMake(229 * YScaleHeight * (i % 2), 234 * YScaleHeight * (i / 2), 193 * YScaleHeight, 184 * YScaleHeight);
        [ziV addSubview:v];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuxiindex"]];
        [v addSubview:img];
        img.sd_layout.leftEqualToView(v).rightEqualToView(v).topEqualToView(v).bottomEqualToView(v);
        
        UILabel *ziL = [UILabel new];
        ziL.text = ziArr[i];
        ziL.font = [UIFont fontWithName:@"kaiti" size:72 * YScaleHeight];
        ziL.textColor = [JKUtil getColor:@"191949"];
        ziL.textAlignment = NSTextAlignmentCenter;
        [v addSubview:ziL];
        ziL.sd_layout.leftSpaceToView(v, 48 * YScaleHeight).topSpaceToView(v, 63 * YScaleHeight).widthIs(76 * YScaleHeight).heightIs(72 * YScaleHeight);
        
        v.tag = i;
        v.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [v addGestureRecognizer:tap];

    }
    
    lightV = [UIView new];
    lightV.backgroundColor = ClearColor;
    [backV addSubview:lightV];
//    lightV.sd_layout.leftSpaceToView(backV, 0 * YScaleWidth).topSpaceToView(backV, 0 * YScaleHeight).widthIs(513 * YScaleHeight).heightIs(760 * YScaleHeight);
    lightV.frame = CGRectMake(0, 0, 513 * YScaleHeight, 760 * YScaleHeight);
    
    UIImageView *lightoffImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuxilightoff"]];
    [lightV addSubview:lightoffImg];
    lightoffImg.sd_layout.leftEqualToView(lightV).rightEqualToView(lightV).topEqualToView(lightV).bottomEqualToView(lightV);
    
    
    UIView *ziV = [[UIImageView alloc] init];
    [lightV addSubview:ziV];
    ziV.sd_layout.leftSpaceToView(lightV, 105 * YScaleHeight).topSpaceToView(lightV, 371 * YScaleHeight).widthIs(234 * YScaleHeight).heightIs(262 * YScaleHeight);
    
    UIImageView *leftimg = [[UIImageView alloc] init];
    [leftimg sd_setImageWithURL:[NSURL URLWithString:thisDict[@"word_image"]]];
    [ziV addSubview:leftimg];
    leftimg.sd_layout.centerXEqualToView(ziV).centerYEqualToView(ziV).widthIs(349.333 * YScaleHeight).heightIs(262 * YScaleHeight);


    
}


#pragma mark - click
- (void)labaClick{
    
    NSString *webVideoPath = thisDict[@"word_audio"];
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];

    [self bofangwithUrl:@[webVideoUrl]];
    
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        [self.player stop];
        self.player = nil;
    };
}

- (void)nextClick{
    
    //复习完成 进入首页
//    if(self.successCounts == 5){
//    }
//    else{
//    }

    //进入下一个学习页面
    FuxiPlayViewController *vc = [[FuxiPlayViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.successCounts = self.successCounts;
    vc.fuxiArr = self.fuxiArr;
    [self presentViewController:vc animated:YES completion:^{
    }];
    
}

//修改成功灯数  然后确定亮灯
- (void)setschedule{
    for (int i = 0; i < 5; i++) {
        UIView *v = bufferV.subviews[i];

        if(i < self.successCounts){
            v.backgroundColor = [JKUtil getColor:@"24DA37"];
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    
    YLog(@"%ld----%ld",index,rightIndex)
    YLog(@"%ld",ziV.subviews.count)
    
    if(index == rightIndex){
        UIView *v = ziV.subviews[index];
        UIImageView *img = v.subviews.firstObject;
        img.image = [UIImage imageNamed:@"fuxiright"]; //fuxiright
        
        UILabel *L = v.subviews.lastObject;
        L.textColor = WhiteColor;
        
        [self rightClick];
    }
    else{
        UIView *v = ziV.subviews[index];
        UIImageView *img = v.subviews.firstObject;
        img.image = [UIImage imageNamed:@"fuxiwrong"]; //fuxiright
        
        UILabel *L = v.subviews.lastObject;
        L.textColor = WhiteColor;
    }

}

- (void)rightClick{
    UIView *v = ziV.subviews[rightIndex];
    
    //去掉所有的错字
    for (UIView *vv in ziV.subviews) {
        if(vv == v){
            
        }
        else{
            [vv removeFromSuperview];
        }
    }
    
    
    //改变正确的字的位置
    [UIView animateWithDuration:1 animations:^{
        v.mj_y = 134 * YScaleHeight;
        
        v.mj_x = 55 * YScaleWidth - 628 * (YScaleWidth - YScaleHeight);
        self->lightV.mj_x = 212 * YScaleWidth + 200 * (YScaleWidth - YScaleHeight);

    } completion:^(BOOL finished) {
        //选词正确 放一遍语音
        [self labaClick];
        
        //修改灯的颜色
        UIImageView *lightImg = lightV.subviews.firstObject;
        lightImg.image = [UIImage imageNamed:@"fuxilighton"];

        //下一个 播放按钮显示
        labaBtn.hidden = NO;
        nextBtn.hidden = NO;
        
        self.successCounts ++;
        [self setschedule];
        
        if(self.successCounts == 5){
            nextBtn.hidden = YES;
            backBtn.hidden = NO;
            
            //学习完成接口
//            [self fuxiOk];
        }
                
    }];
    
}

- (void)fuxiOk{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
    YLog(@"%@",[NSString getBaseUrl:_URL_FuxiCheck withparam:param])
    
    [YLHttpTool POST:_URL_FuxiCheck parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id dic) {
        
        if([dic[@"code"] integerValue] == 200){

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self back];
            });
            
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

- (void)back{
    if(!ifback){
        [(AppDelegate*)[UIApplication sharedApplication].delegate gotoMainVC];
        ifback = YES;

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
