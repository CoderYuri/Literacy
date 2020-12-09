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
}

@end

@implementation MainViewController

- (void)fetch{
    
    NSArray *arr = [YUserDefaults objectForKey:kziKu];
    if(arr.count){
        dataArr = [AllModel mj_objectArrayWithKeyValuesArray:arr];
        [self setupView];

    }
    else{
        
        //网络请求数据
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"user_id"] = [YUserDefaults objectForKey:kuserid];
        YLog(@"%@",[NSString getBaseUrl:_URL_words withparam:param])
                
        [YLHttpTool GET:_URL_words parameters:param progress:^(NSProgress *progress) {
            
        } success:^(id dic) {

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
            
            YLog(@"%@",dic);
        } failure:^(NSError *error) {
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
            self->vipL.text = @"有效期至2021.11.30";
            vipL.alpha = 1;
            self->vipL.textColor = [JKUtil getColor:@"FF6112"];

        }
        else{
            self->vipImg.image = [UIImage imageNamed:@"notvip"];
            self->vipL.text = @"当前未开通会员";
            vipL.alpha = 0.8;
            self->vipL.textColor = [JKUtil getColor:@"17449C"];
        }
    }


}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = [NSMutableArray array];

    [self fetch];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}


- (void)setupView{
    backV = self.view;
    

    scrollV = [[UIScrollView alloc] init];
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
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
    
    NSInteger hasLearnCount = [YUserDefaults integerForKey:khas_learn_num] - 1;
    YLog(@"%ld",hasLearnCount)
    scrollV.contentOffset = CGPointMake(256 * YScaleHeight * hasLearnCount, 0);
    
    selectIndex = -1;
    gifCenterX = 363 * YScaleHeight + 256 * YScaleHeight * hasLearnCount;   //初始位置
//    gifView = [[UIImageView alloc] init];
    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"shaonv" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//    gifView.image = [UIImage sd_imageWithGIFData:imageData];
    
//    gifView = [[YFGIFImageView alloc] init];
//    gifView.gifData = imageData;
//    [gifView startGIFWithRunLoopMode:NSRunLoopCommonModes];
    
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
    
    [UIView animateWithDuration:Transformtimeinterval
                     animations:^{
        self->gifView.centerX = 363 * YScaleHeight;
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

#pragma mark - click
- (void)caozuoClick:(UIButton *)b{
    NSInteger ziIndex = b.superview.tag - 10000;
    YLog(@"%ld",ziIndex)
    
    
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
                
        //            * fabs(huadongjuli - gifView.centerX )/ 1080
                    [UIView animateWithDuration:Transformtimeinterval animations:^{
                        
                        self->gifView.centerX = huadongjuli;
                        
                    } completion:^(BOOL finished) {
                        
                        selectIndex = ziIndex;
                        [gifView stopAnimating];

                        FunViewController *vc = [[FunViewController alloc] init];
                        vc.selectedMod = selectedMod;
                        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        vc.xuanzhongIndex =self-> selectIndex;
                        
                        vc.combine_words = dict[@"combine_words"];
                        vc.similar_words = dict[@"similar_words"];
            //            vc.word_image = dict[@"word_image"];
            //            vc.word_video = dict[@"word_video"];

                        
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
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            [SVProgressHUD dismissWithDelay:1.0];
        }
        
        YLog(@"%@",dic);
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"网络连接失败" duration:2 position:@"center"];
    }];

 
}

- (void)ludengdianliang:(NSInteger)index{
    
    
    //点亮路灯
    for (UIView *v in scrollV.subviews) {
        if (v.tag == index)
        {
            UIImageView *img = v.subviews.firstObject;
            img.image = [UIImage imageNamed:@"lighton"];

            UIButton *b = v.subviews.lastObject;
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


/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *date8 = [self getCustomDateWithHour:fromHour];
    NSDate *date23 = [self getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %d:00-%d:00 之间！", fromHour, toHour);
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
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
