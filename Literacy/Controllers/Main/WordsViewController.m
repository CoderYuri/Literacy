//
//  WordsViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/20.
//

#import "WordsViewController.h"
#import "WordCollectionViewCell.h"

@interface WordsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UIView *backV;
    
    UILabel *leftL;
    UILabel *rightL;
    NSMutableArray *dataArr;
    
    UICollectionView *collectionView;
    
    FunViewController *fuxiVc;
}

@property (nonatomic, strong) ZFPlayerController *player;

@end

@implementation WordsViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = [NSMutableArray array];
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    
    if(arr.count){
        dataArr = [AllModel mj_objectArrayWithKeyValuesArray:arr];
        [self setupView];
    }
}

//页面加载
- (void)setupView{
    backV = self.view;
    
    UIView *topV = [UIView new];
    
    UIColor *topColor = [JKUtil getColor:@"1665FF"];
    UIColor *bottomColor = [JKUtil getColor:@"3A7DFF"];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(YScreenW, 120 * YScaleWidth)];
    topV.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    
    [backV addSubview:topV];
    topV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).heightIs(120 * YScaleHeight);
    
    NoHighBtn *backBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"iconback"] forState:UIControlStateNormal];
    [topV addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(topV, 27 * YScaleWidth).centerYEqualToView(topV).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];

    
    UIView *midV = [UIView new];
    midV.backgroundColor = WhiteColor;
    [backV addSubview:midV];
    midV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topSpaceToView(topV, 0).heightIs(44 * YScaleWidth);
    
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcardpre"]];
    [midV addSubview:leftImg];
    leftImg.sd_layout.leftSpaceToView(midV, 160 * YScaleWidth).centerYEqualToView(midV).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    NSInteger yixuexiCounts = [YUserDefaults integerForKey:khas_learn_num];
    NSInteger weixuexiCounts = dataArr.count - yixuexiCounts;
    
    leftL = [UILabel new];
    leftL.text = [NSString stringWithFormat:@"已学习（%ld个）",yixuexiCounts];
    leftL.textColor = [JKUtil getColor:@"3F4D6C"];
    leftL.font = YSystemFont(12 * YScaleWidth);
    [midV addSubview:leftL];
    leftL.sd_layout.leftSpaceToView(leftImg, 10 * YScaleWidth).centerYEqualToView(midV).widthIs(104 * YScaleWidth).heightIs(17);
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcarddefault"]];
    [midV addSubview:rightImg];
    rightImg.sd_layout.leftSpaceToView(leftImg, 110 * YScaleWidth).centerYEqualToView(midV).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    rightL = [UILabel new];
    rightL.text = [NSString stringWithFormat:@"未学习（%ld个）",weixuexiCounts];
    rightL.textColor = [JKUtil getColor:@"3F4D6C"];
    rightL.font = YSystemFont(12 * YScaleWidth);
    [midV addSubview:rightL];
    rightL.sd_layout.leftSpaceToView(rightImg, 10 * YScaleWidth).centerYEqualToView(midV).widthIs(200).heightIs(17);

    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(120 * YScaleWidth, 120 * YScaleWidth);
    layout.minimumInteritemSpacing = 39 * YScaleWidth;
    layout.minimumLineSpacing = 32 * YScaleWidth;

    
    
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,120 * YScaleHeight + 44 * YScaleWidth, YScreenW, YScreenH - 120 * YScaleHeight - 44 * YScaleWidth) collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(36 * YScaleWidth, 160 * YScaleWidth, 36 * YScaleWidth, 160 * YScaleWidth);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = FALSE;
    collectionView.backgroundColor = ClearColor;
    [collectionView registerClass:[WordCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([WordCollectionViewCell class])];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [backV addSubview:collectionView];
    
    NSInteger numCounts = dataArr.count / 10;
    
    for (int i = 0; i < numCounts; i++) {
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%d",(i + 1) * 10];
        label.textColor = [JKUtil getColor:@"1D69FF"];
        label.alpha = 0.3;
        label.font = YSystemFont(22 * YScaleWidth);
        label.textAlignment = NSTextAlignmentRight;
        
        [collectionView addSubview:label];
        label.frame = CGRectMake( - 86 * YScaleWidth, 197 * YScaleWidth + 304 * YScaleWidth * i, 55 * YScaleWidth, 30 * YScaleWidth);
        
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
//  return UIEdgeInsetsMake(32 * YScaleWidth,0,0,40 * YScaleWidth);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AllModel *selectedMod = dataArr[indexPath.item];

    if(selectedMod.is_learn){

        [SVProgressHUD showWithStatus:@"加载中..."];
        
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
                vc.word_image = [NSString stringWithFormat:@"%@",dict[@"word_image"]];
                vc.word_video = [NSString stringWithFormat:@"%@",dict[@"word_video"]];
                vc.word_audio = [NSString stringWithFormat:@"%@",dict[@"word_audio"]];
                vc.words_audios = dict[@"words_audios"];
                vc.ifFuxi = YES;

                vc.callBack = ^(NSInteger xuanzhongIndex) {

                };
                self->fuxiVc = vc;
                
                //音视频图片 缓存
                [self huancun];
                
            }

            else{
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                [SVProgressHUD dismissWithDelay:1.0];
            }

            YLog(@"%@",dic);
        } failure:^(NSError *error) {
            //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
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


    }

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
                [SVProgressHUD dismiss];

                [self presentViewController:fuxiVc animated:YES completion:^{
                }];

            }

            
                       }];
        [task resume];

    }
    
}


//播放录音
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



#pragma mark - click
- (void)back{
//    [self.navigationController popViewControllerAnimated:YES];
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
