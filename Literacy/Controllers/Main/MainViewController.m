//
//  MainViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/16.
//

#import "MainViewController.h"
#import <UIImageView-PlayGIF-umbrella.h>
#import "MainCollectionViewCell.h"
#import "WordsViewController.h"
#import "MeViewController.h"
#import "FunViewController.h"

#import "UIImage+GIF.h"

#define Transformtimeinterval 1.0
@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    UIView *backV;
    
    UIImageView *bgImg;
    UIImageView *vipImg;
    
    UILabel *nameL;
    UILabel *vipL;
    
    UIImageView *gifView;
    UICollectionView *collectionView;
    UIScrollView *scrollV;
    NSMutableArray *dataArr;
    
    //gif的x值
    CGFloat gifCenterX;
    CGFloat lastOffSetX;
}

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    dataArr = [NSMutableArray array];
    
    NSArray *ziArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
    

    
//    [[SDAnimatedImagePlayer alloc] initWithProvider:]
//
    //    ,@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"
    
    for (int i = 0; i < ziArr.count; i++) {
        AllModel *mod = [AllModel new];
        mod.title = ziArr[i];
        [dataArr addObject:mod];
    }

    
    [self setupView];
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
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
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
        v.tag = 10000 + i;
        v.backgroundColor = ClearColor;
        [scrollV addSubview:v];
        v.frame = CGRectMake(320 * YScaleHeight + 256 * YScaleHeight * i, 0, 256 * YScaleHeight, 384 * YScaleHeight);
        v.mj_y = YScreenH - 196 * YScaleWidth - 384 * YScaleHeight + 42 * YScaleWidth;

//        if(isPad){
//        }
//        else if(Height_Bottom){
//            v.mj_y = 0 * YScaleWidth;
//        }
//        else{
//            v.mj_y = 72 * YScaleWidth;
//        }

        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightdoff"]];
        [v addSubview:img];
        img.sd_layout.leftEqualToView(v).rightEqualToView(v).topEqualToView(v).bottomEqualToView(v);

        AllModel *mod = dataArr[i];
        
        UILabel *ziL = [UILabel new];
        ziL.text = mod.title;
        ziL.font = [UIFont fontWithName:@"kaiti" size:70 * YScaleHeight];
        ziL.textColor = BlackColor;
        ziL.textAlignment = NSTextAlignmentCenter;
        [v addSubview:ziL];
        ziL.sd_layout.centerXEqualToView(v).topSpaceToView(v, 192 * YScaleHeight).widthIs(73 * YScaleHeight).heightIs(70 * YScaleHeight);
        
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caozuoClick:)];
        tap.numberOfTapsRequired = 1;
        [v addGestureRecognizer:tap];

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
    
    gifCenterX = 267 * YScaleHeight * 0.5;
    gifView = [[UIImageView alloc] init];
    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"shaonv" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    gifView.image = [UIImage sd_imageWithGIFData:imageData];
    
    [backV addSubview:gifView];
    gifView.frame = CGRectMake(0, 0,267 * YScaleHeight, 282 * YScaleHeight);
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
    nameL.text = @"宝宝0000";
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
- (void)caozuoClick:(UITapGestureRecognizer *)tap{
    NSInteger selectIndex = tap.view.tag - 10000;
    YLog(@"%ld",selectIndex)
    
    
    for (UIView *v in scrollV.subviews) {
        if (v.tag == tap.view.tag)
        {
            
            if(gifView.centerX > v.centerX - scrollV.contentOffset.x){
                gifView.transform = CGAffineTransformMakeScale(-1.0, 1.0);//水平翻转
            }

            else{
                gifView.transform = CGAffineTransformMakeScale(1.0, 1.0);//水平翻转
            }
            
            [UIView animateWithDuration:Transformtimeinterval animations:^{
                self->gifView.centerX = v.centerX - self->scrollV.contentOffset.x;
                self->gifCenterX = v.centerX;

            } completion:^(BOOL finished) {
                
                FunViewController *vc = [[FunViewController alloc] init];
                vc.selectedMod = self->dataArr[selectIndex];
//                [self.navigationController pushViewController:vc animated:YES];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;


//                UIModalTransitionStyleCoverVertical = 0,
//                UIModalTransitionStyleFlipHorizontal API_UNAVAILABLE(tvos),
//                UIModalTransitionStyleCrossDissolve,
//                UIModalTransitionStylePartialCurl
                
                [self presentViewController:vc animated:YES completion:^{
                    
                }];
            }];
            


        }
    }

    //变亮
//    for (UIView *v in scrollV.subviews) {
//        if (v.tag == tap.view.tag)
//        {
//            UILabel *label = v.subviews[1];
//            label.textColor = WhiteColor;
//
//            UIImageView *img = v.subviews.firstObject;
//            img.image = [UIImage imageNamed:@"lighton"];
//
//
//        }
//    }
    
    
}


- (void)ziClick{
    WordsViewController *vc = [[WordsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapAction{
    MeViewController *meVc = [[MeViewController alloc] init];
    [self.navigationController pushViewController:meVc animated:YES];
}

#pragma mark ————— scrollView代理方法 —————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    

    if(gifView.centerX < -256 * YScaleHeight * 0.5){
        gifView.centerX = -256 * YScaleHeight * 0.5;
    }
    
    else if(gifView.centerX > YScreenW + 256 * YScaleHeight * 0.5){
        gifView.centerX = YScreenW + 256 * YScaleHeight * 0.5;
    }
    else{
        //对人物调整
        gifView.centerX = gifCenterX - scrollView.contentOffset.x;
    }
    
    
    YLog(@"%f---%f----%f----%f",gifView.centerX,gifCenterX,256 * YScaleHeight * dataArr.count + 640 * YScaleHeight,256 * YScaleHeight * dataArr.count + 640 * YScaleHeight-YScreenW)
    
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