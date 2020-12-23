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
    
    UIView *lightV;
    UIView *ziV;
}

@end

@implementation FuxiPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        
        if(i <= self.successCounts){
            v.backgroundColor = [JKUtil getColor:@"24DA37"];
        }
    }
    
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
   
    
    labaBtn.hidden = YES;
    nextBtn.hidden = YES;
    
    lightV = [UIView new];
    lightV.backgroundColor = ClearColor;
    [backV addSubview:lightV];
    lightV.sd_layout.leftSpaceToView(backV, 96 * YScaleWidth).topSpaceToView(backV, 176 * YScaleHeight).widthIs(417 * YScaleHeight).heightIs(583 * YScaleHeight);
    
    UIImageView *lightoffImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuxidefault"]];
    [lightV addSubview:lightoffImg];
    lightoffImg.sd_layout.leftEqualToView(lightV).rightEqualToView(lightV).topEqualToView(lightV).bottomEqualToView(lightV);
    
    UIImageView *ziImg = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:YRandomColor]];
    [lightV addSubview:ziImg];
    ziImg.sd_layout.leftSpaceToView(lightV, 9 * YScaleHeight).topSpaceToView(lightV, 195 * YScaleHeight).widthIs(234 * YScaleHeight).heightIs(262 * YScaleHeight);
    
    ziV = [UIView new];
    [backV addSubview:ziV];
    ziV.backgroundColor = ClearColor;
    ziV.sd_layout.rightSpaceToView(backV, 96 * YScaleWidth).topSpaceToView(backV, 293 * YScaleHeight).widthIs(422 * YScaleHeight).heightIs(418 * YScaleHeight);
    
    for (int i = 0; i < 4; i++) {
        UIView *v = [UIView new];
        v.backgroundColor = ClearColor;
        v.frame = CGRectMake(229 * YScaleHeight * (i % 2), 234 * YScaleHeight * (i / 2), 193 * YScaleHeight, 184 * YScaleHeight);
        [ziV addSubview:v];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuxiindex"]];
        [v addSubview:img];
        img.sd_layout.leftEqualToView(v).rightEqualToView(v).topEqualToView(v).bottomEqualToView(v);
        
        UILabel *ziL = [UILabel new];
        ziL.text = @"人";
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
    
    
    
}


#pragma mark - click
- (void)labaClick{
    YLogFunc
}

- (void)nextClick{
    YLogFunc
}

//修改成功灯数  然后确定亮灯
- (void)setschedule{
    for (int i = 0; i < 5; i++) {
        UIView *v = bufferV.subviews[i];

        if(i <= self.successCounts){
            v.backgroundColor = [JKUtil getColor:@"24DA37"];
        }
        
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    
    YLog(@"%ld",index)
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
