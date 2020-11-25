//
//  FunViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/25.
//

#import "FunViewController.h"
#define Transformtimeinterval 1.0

@interface FunViewController ()<UIScrollViewDelegate>{
    UIView *backV;
    UIScrollView *scrollV;
    UIImageView *gifView;
    CGFloat gifCenterX;
    
    UIView *yidongV;
    
    UIView *renV;
    UIView *duV;
    UIView *wanV;
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
    scrollV.contentSize = CGSizeMake(3 * YScreenW , YScreenH);
    [backV addSubview: scrollV];
    scrollV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topEqualToView(backV).bottomEqualToView(backV);
    
    
    [self setRenV];
    [self setduV];
    [self setwanV];
    
    
    gifView = [[UIImageView alloc] init];
    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"shaonv" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    gifView.image = [UIImage sd_imageWithGIFData:imageData];
    
    [scrollV addSubview:gifView];
    gifView.frame = CGRectMake(-267 * YScaleHeight, 0,267 * YScaleHeight, 282 * YScaleHeight);
    gifView.mj_y = YScreenH - 282 * YScaleHeight - 188 * YScaleHeight;
    
    
    NoHighBtn *backBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"iconback"] forState:UIControlStateNormal];
    [backV addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(backV, 27 * YScaleWidth).topSpaceToView(backV, 27 * YScaleWidth).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *shangV = [UIView new];
    shangV.backgroundColor = [JKUtil getColor:@"ECF9FF"];
    shangV.alpha = 0.4;
    shangV.layer.cornerRadius = 6 * YScaleHeight;
    shangV.layer.masksToBounds = YES;
    [backV addSubview:shangV];
    shangV.sd_layout.rightSpaceToView(backV, 30 * YScaleWidth).topSpaceToView(backV, 40 * YScaleWidth).widthIs(150 * YScaleHeight).heightIs(40 * YScaleHeight);

    UIView *youshangV = [UIView new];
    youshangV.backgroundColor = ClearColor;
    youshangV.layer.cornerRadius = 6 * YScaleHeight;
    youshangV.layer.masksToBounds = YES;
    [backV addSubview:youshangV];
    youshangV.sd_layout.rightSpaceToView(backV, 30 * YScaleWidth).topSpaceToView(backV, 40 * YScaleWidth).widthIs(150 * YScaleHeight).heightIs(40 * YScaleHeight);
    
    yidongV = [UIView new];
    yidongV.backgroundColor = [JKUtil getColor:@"FF5E18"];
    yidongV.layer.cornerRadius = 6 * YScaleHeight;
    yidongV.layer.masksToBounds = YES;
    [youshangV addSubview:yidongV];
    yidongV.frame = CGRectMake(5 * YScaleHeight, 0, 40 * YScaleHeight, 40 * YScaleHeight);
    
    NSArray *nameA = @[@"认",@"读",@"玩"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [UILabel new];
        label.textColor = WhiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = nameA[i];
        label.font = YSystemFont(20 * YScaleHeight);
        label.frame = CGRectMake(50 * YScaleHeight * i, 0, 50 * YScaleHeight, 40 * YScaleHeight);
        [youshangV addSubview:label];
    }
    
    
    //初始进入页面  开始认  动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:Transformtimeinterval animations:^{
            self->gifView.centerX = 250 * YScaleHeight;

        } completion:^(BOOL finished) {

            //加载电视机 放动画  完成之后进入下个页面
            YLogFunc
            
            [self ducaozuo];
        }];

    });

}


- (void)ducaozuo{
    
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        
        [self->scrollV setContentOffset:CGPointMake(YScreenW, 0)];
        self->yidongV.mj_x = 55 * YScaleHeight;
        
    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:2 animations:^{
        self->gifView.centerX = 250 * YScaleHeight + YScreenW;
    } completion:^(BOOL finished) {
        
        //读的画面操作
        
        [self wancaozuo];
    }];


}

- (void)wancaozuo{
    [UIView animateWithDuration:Transformtimeinterval animations:^{
        
        [self->scrollV setContentOffset:CGPointMake(YScreenW * 2, 0)];
        self->yidongV.mj_x = 105 * YScaleHeight;

    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:2 animations:^{
        self->gifView.centerX = 250 * YScaleHeight + YScreenW * 2;
    } completion:^(BOOL finished) {
        
        //玩的画面操作
        
    }];

}



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
    imgg.frame = CGRectMake(372 * YScaleHeight, 224 * YScaleHeight, 180 * YScaleHeight, 364 * YScaleHeight);
    
    
    UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funroad"]];
    [renV addSubview:roadImg];
    roadImg.frame = CGRectMake(0, YScreenH - 237 * YScaleHeight, YScreenW, 237 * YScaleWidth);
    

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
    imgg.frame = CGRectMake(372 * YScaleHeight, 224 * YScaleHeight, 180 * YScaleHeight, 364 * YScaleHeight);
    
    
    UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funroad1"]];
    [duV addSubview:roadImg];
    roadImg.frame = CGRectMake(0, YScreenH - 237 * YScaleHeight, YScreenW, 237 * YScaleWidth);
    
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
    
    UIImageView *roadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funroad1"]];
    [duV addSubview:roadImg];
    roadImg.frame = CGRectMake(0, YScreenH - 237 * YScaleHeight, YScreenW, 237 * YScaleWidth);

}


#pragma mark - click
- (void)back{
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
