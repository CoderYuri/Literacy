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
}

@end

@implementation FuxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
}

- (void)setupView{
    backV = self.view;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
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
    fuImg.sd_layout.centerXEqualToView(backV).topSpaceToView(backV, 190 * YScaleHeight).widthIs(560 * YScaleHeight).heightIs(438 * YScaleHeight);
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"立即充电" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:korangeColor];
    loginBtn.titleLabel.font = YSystemFont(22 * YScaleHeight);
    [loginBtn addTarget:self action:@selector(fuxiClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 29 * YScaleHeight;
    loginBtn.layer.masksToBounds = YES;
    [backV addSubview:loginBtn];
    loginBtn.sd_layout.centerXEqualToView(backV).topSpaceToView(backV, 587 * YScaleHeight).widthIs(310 * YScaleWidth).heightIs(58 * YScaleHeight);


}

- (void)fuxiClick{
    FuxiPlayViewController *vc = [[FuxiPlayViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    vc.successCounts = 3;
    
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
