//
//  MeViewController.m
//  Literacy
//
//  Created by Yuri on 2020/11/20.
//

#import "MeViewController.h"
#import "WordCollectionViewCell.h"
#define kbackColor [JKUtil getColor:@"F4FAFF"]
#define klcolor [JKUtil getColor:@"E5EEFD"]
#define kocolor [JKUtil getColor:@"FF6112"]

@interface MeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UIView *backV;
    
    UIImageView *vipImg;
    
    UILabel *nameL;
    UILabel *vipL;
    
    UIButton *selectedBtn;
    UIView *selectedV;
    NSInteger selectIndex;
    
    //进行操作的View
    UIView *rightV;
    UIView *goumaiV;
    UIView *qingkuangV;
    UIView *kefuV;
    UIView *aboutV;
    
    UICollectionView *collectionView;
    UILabel *leftL;
    UILabel *rightL;
}

@property (nonatomic,strong) NudeIn *monL;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)setupView{
    backV = self.view;
    backV.backgroundColor = [JKUtil getColor:@"1665FF"];
    
    NoHighBtn *backBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"iconback"] forState:UIControlStateNormal];
    [backV addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(backV, 27 * YScaleWidth).topSpaceToView(backV, 27 * YScaleWidth).widthIs(66 * YScaleHeight).heightEqualToWidth();
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *midV = [UIView new];
    [backV addSubview:midV];
    midV.backgroundColor = WhiteColor;
    midV.sd_layout.centerXEqualToView(backV).bottomSpaceToView(backV, 30 * YScaleHeight).widthIs(1020 * YScaleWidth).heightIs(660 * YScaleHeight);
    
    UIView *leftV = [UIView new];
    [midV addSubview:leftV];
    leftV.backgroundColor = [JKUtil getColor:@"F2F9FF"];
    leftV.sd_layout.leftEqualToView(midV).bottomEqualToView(midV).topEqualToView(midV).widthIs(180 * YScaleWidth);
    
    
    ///个人信息
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elementuser"]];
    [leftV addSubview:userIcon];
    userIcon.sd_layout.leftSpaceToView(leftV, 11 * YScaleWidth).topSpaceToView(leftV, 30 * YScaleHeight).widthIs(50 * YScaleWidth).heightEqualToWidth();
    
    vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notvip"]];
    [leftV addSubview:vipImg];
    vipImg.sd_layout.leftSpaceToView(leftV, 45 * YScaleWidth).topSpaceToView(leftV, 30 * YScaleHeight + 35 * YScaleWidth).widthIs(18 * YScaleWidth).heightEqualToWidth();
    
    nameL = [UILabel new];
    nameL.text = @"宝宝0000";
    nameL.font = YSystemFont(16 * YScaleWidth);
    nameL.textColor = [JKUtil getColor:@"2A2D34"];
    [leftV addSubview:nameL];
    nameL.sd_layout.leftSpaceToView(leftV, 70 * YScaleWidth).topSpaceToView(leftV , 35 * YScaleHeight).heightIs(22 * YScaleWidth).widthIs(88 * YScaleWidth);
    
//    17449C  当前未开通会员
//    FF5E18  有效期至2021.11.30
    

    vipL = [UILabel new];
    vipL.textColor = [JKUtil getColor:@"A6A6A6"];
    vipL.text = @"当前未开通会员";
    
    vipL.font = YSystemFont(11 * YScaleWidth);
    [leftV addSubview:vipL];
    vipL.sd_layout.leftEqualToView(nameL).topSpaceToView(nameL, 3 * YScaleHeight).heightIs(16 * YScaleWidth).widthIs(108 * YScaleWidth);
    
    NSArray *namearr = @[@"购买方案",@"识字情况",@"联系客服",@"关于我们"];
    ///操作按钮
    for (int i = 0; i < 4; i++) {
        NoHighBtn *btn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = YSystemFont(20 * YScaleHeight);
        [btn setTitle:namearr[i] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageWithColor:klcolor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kocolor] forState:UIControlStateSelected];
        
        [btn setTitleColor:[JKUtil getColor:@"6B7CA4"] forState:UIControlStateNormal];
        [btn setTitleColor:WhiteColor forState:UIControlStateSelected];

        [leftV addSubview:btn];
        btn.frame = CGRectMake(0, 50 * YScaleWidth + 60 * YScaleHeight + 66 * YScaleHeight * i, 180 * YScaleWidth, 52 * YScaleHeight);
        
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(caozuoClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 0){
            [self caozuoClick:btn];
        }
    }
    
    
    rightV = [UIView new];
    [midV addSubview:rightV];
    rightV.backgroundColor = WhiteColor;
    rightV.sd_layout.rightEqualToView(midV).bottomEqualToView(midV).topEqualToView(midV).leftSpaceToView(leftV, 0);
    
    
    [self setupView1];
}

//购买方案
- (void)setupView1{
    goumaiV = [UIView new];
    goumaiV.backgroundColor = kbackColor;
    [rightV addSubview:goumaiV];
    goumaiV.sd_layout.centerXEqualToView(rightV).centerYEqualToView(rightV).widthIs(806 * YScaleWidth).heightIs(600 * YScaleHeight);

    NoHighBtn *payBtn = [NoHighBtn buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:kocolor];
    [payBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    payBtn.titleLabel.font = YSystemFont(24 * YScaleHeight);
    payBtn.layer.cornerRadius = 30 * YScaleHeight;
    payBtn.layer.masksToBounds = YES;
    [goumaiV addSubview:payBtn];
    payBtn.sd_layout.centerXEqualToView(goumaiV).bottomSpaceToView(goumaiV, 68 * YScaleHeight).widthIs(446 * YScaleHeight).heightIs(60 * YScaleHeight);
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = klcolor;
    [goumaiV addSubview:lineV];
    lineV.sd_layout.centerXEqualToView(goumaiV).bottomSpaceToView(payBtn, 51 * YScaleHeight).widthIs(760 * YScaleWidth).heightIs(1);
    
    NSArray *nameA = @[@"月卡会员：",@"永久会员："];
    NSArray *shangArr = @[@"1500+",@"3000+",@"1500+",@"不限次数"];
    NSArray *xiaArr = @[@"部编版汉字",@"常用词语",@"创意字卡",@"重新免费学习"];
    NSArray *numArr = @[@"8",@"45"];
    
    for (int i = 0; i < 2; i++) {
        UIView *v = [UIView new];
        [goumaiV addSubview:v];
        v.layer.borderColor = [JKUtil getColor:@"C6D9FF"].CGColor;
        v.layer.borderWidth = 1;
        v.layer.cornerRadius = 4;
        v.layer.masksToBounds = YES;
        v.backgroundColor = WhiteColor;
        v.frame = CGRectMake(24 * YScaleWidth + 384 * YScaleWidth * i, 80 * YScaleHeight, 364 * YScaleWidth, 300 * YScaleHeight);
        
        UILabel *nameL = [UILabel new];
        nameL.text = nameA[i];
        nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size: 32 * YScaleHeight];
        nameL.textColor = [JKUtil getColor:@"2E4476"];
        [v addSubview:nameL];
        nameL.sd_layout.leftSpaceToView(v, 24 * YScaleWidth).topSpaceToView(v, 32 * YScaleHeight).widthIs(210 * YScaleWidth).heightIs(45 * YScaleHeight);
        
        _monL = [NudeIn make:^(NUDTextMaker *make) {
            make.text(@"￥").fontName(@"Helvetica-Bold",30 * YScaleHeight).color(kocolor).attach();
            make.text(numArr[i]).fontName(@"Helvetica-Bold",60 * YScaleHeight).color(kocolor).attach();
        }];
        _monL.textAlignment = NSTextAlignmentRight;
        [v addSubview:_monL];
        _monL.sd_layout.rightSpaceToView(v, 23 * YScaleWidth).topSpaceToView(v, 15 * YScaleHeight).widthIs(100 * YScaleWidth).heightIs(84 * YScaleHeight);

        
        v.userInteractionEnabled = YES;
        v.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [v addGestureRecognizer:tap];

        if(i == 0){
            [self tapAction:tap];
        }
        
        UIView *lineVV = [UIView new];
        lineVV.backgroundColor = klcolor;
        [v addSubview:lineVV];
        lineVV.sd_layout.centerXEqualToView(v).topSpaceToView(v, 83 * YScaleHeight).widthIs(292 * YScaleWidth).heightIs(1);
        
        for (int j = 0; j < 4; j++) {
            UIView *vv = [UIView new];
            vv.backgroundColor = [JKUtil getColor:@"EEF8FF"];
            vv.layer.cornerRadius = 4;
            vv.layer.masksToBounds = YES;
            [v addSubview:vv];
            vv.frame = CGRectMake(24 * YScaleWidth + 164 * YScaleWidth * (j % 2), 119 * YScaleHeight + 70 * YScaleHeight * (j / 2), 152 * YScaleWidth, 60 * YScaleHeight);
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"card%i",j]]];
            [vv addSubview:img];
            img.sd_layout.leftSpaceToView(vv, 8 * YScaleWidth).centerYEqualToView(vv).widthIs(42 * YScaleHeight).heightEqualToWidth();
            
            UILabel *shangL = [UILabel new];
            shangL.text = shangArr[j];
            shangL.textColor = [JKUtil getColor:@"677A9F"];
            shangL.font = YSystemFont(16 * YScaleHeight);
            [vv addSubview:shangL];
            shangL.sd_layout.leftSpaceToView(img, 10 * YScaleWidth).topEqualToView(img).rightEqualToView(vv).heightIs(22 * YScaleHeight);
            
            UILabel *xiaL = [UILabel new];
            xiaL.text = xiaArr[j];
            xiaL.textColor = [JKUtil getColor:@"2E4476"];
            xiaL.font = YSystemFont(12 * YScaleHeight);
            [vv addSubview:xiaL];
            xiaL.sd_layout.leftSpaceToView(img, 10 * YScaleWidth).bottomEqualToView(img).rightEqualToView(vv).heightIs(22 * YScaleHeight);

            
        }

        
        
    }
    
}

//识字情况
- (void)setupView2{
    qingkuangV = [UIView new];
    qingkuangV.backgroundColor = WhiteColor;
    [rightV addSubview:qingkuangV];
    qingkuangV.sd_layout.leftEqualToView(rightV).rightEqualToView(rightV).topEqualToView(rightV).bottomEqualToView(rightV);
    
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcardpre"]];
    [qingkuangV addSubview:leftImg];
    leftImg.sd_layout.leftSpaceToView(qingkuangV, 94 * YScaleWidth).topSpaceToView(qingkuangV, 10 * YScaleHeight).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    leftL = [UILabel new];
    leftL.text = @"已学习（1个）";
    leftL.textColor = [JKUtil getColor:@"3F4D6C"];
    leftL.font = YSystemFont(12 * YScaleWidth);
    [qingkuangV addSubview:leftL];
    leftL.sd_layout.leftSpaceToView(leftImg, 10 * YScaleWidth).centerYEqualToView(leftImg).widthIs(104 * YScaleWidth).heightIs(17 * YScaleWidth);
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcarddefault"]];
    [qingkuangV addSubview:rightImg];
    rightImg.sd_layout.leftSpaceToView(leftImg, 110 * YScaleWidth).centerYEqualToView(leftImg).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    rightL = [UILabel new];
    rightL.text = @"未学习（1499个）";
    rightL.textColor = [JKUtil getColor:@"3F4D6C"];
    rightL.font = YSystemFont(12 * YScaleWidth);
    [qingkuangV addSubview:rightL];
    rightL.sd_layout.leftSpaceToView(rightImg, 10 * YScaleWidth).centerYEqualToView(leftImg).widthIs(200).heightIs(17 * YScaleWidth);
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(112 * YScaleWidth, 112 * YScaleWidth);
//    layout.minimumLineSpacing = 40 * YScaleHeight;
    
    
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(17 * YScaleWidth, 20 * YScaleHeight + 38 * YScaleWidth, 806 * YScaleWidth, 572 * YScaleHeight) collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(50 * YScaleHeight, 82 * YScaleWidth, 50 * YScaleHeight, 44 * YScaleWidth);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = FALSE;
    collectionView.backgroundColor = kbackColor;
    [collectionView registerClass:[WordCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([WordCollectionViewCell class])];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [qingkuangV addSubview:collectionView];
        
}


//联系客服
- (void)setupView3{
    kefuV = [UIView new];
    kefuV.backgroundColor = kbackColor;
    [rightV addSubview:kefuV];
    kefuV.sd_layout.centerXEqualToView(rightV).centerYEqualToView(rightV).widthIs(806 * YScaleWidth).heightIs(600 * YScaleHeight);
    
    UILabel *dixiaL = [UILabel new];
    dixiaL.text = @"联系方式：点击复制微信号， 打开微信添加客服为好友";
    dixiaL.font = YSystemFont(16 * YScaleHeight);
    dixiaL.textColor = [JKUtil getColor:@"B0BBD4"];
    dixiaL.textAlignment = NSTextAlignmentCenter;
    [kefuV addSubview:dixiaL];
    dixiaL.sd_layout.bottomSpaceToView(kefuV, 20 * YScaleHeight).widthIs(460 * YScaleWidth).centerXEqualToView(kefuV).heightIs(26 * YScaleHeight);
    
    UILabel *shangL = [UILabel new];
    shangL.textColor = [JKUtil getColor:@"1D69FF"];
    shangL.text = @"服务时间：工作日8:30-17:30";
    shangL.backgroundColor = kbackColor;
    shangL.font = YSystemFont(20 * YScaleHeight);
    shangL.textAlignment = NSTextAlignmentCenter;
    shangL.layer.cornerRadius = 4;
    shangL.layer.borderColor = [JKUtil getColor:@"1D69FF"].CGColor;
    shangL.layer.borderWidth = 1;
    [kefuV addSubview:shangL];
    shangL.sd_layout.centerXEqualToView(kefuV).topSpaceToView(kefuV, 200 * YScaleHeight).widthIs(356 * YScaleWidth).heightIs(50 * YScaleHeight);
    
    UIView *midV = [UIView new];
    midV.backgroundColor = [JKUtil getColor:@"E9F1F6"];
    midV.layer.cornerRadius = 4;
    [kefuV addSubview:midV];
    midV.sd_layout.topSpaceToView(shangL, 20 * YScaleHeight).widthIs(356 * YScaleWidth).heightIs(50 * YScaleHeight).centerXEqualToView(kefuV);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconwechat"]];
    [midV addSubview:img];
    img.sd_layout.leftSpaceToView(midV, 33 * YScaleWidth).centerYEqualToView(midV).widthIs(40 * YScaleHeight).heightIs(32 * YScaleHeight);
    
    UILabel *detailL = [UILabel new];
    detailL.text = @"客服：123456789";
    detailL.textAlignment = NSTextAlignmentCenter;
    detailL.textColor = [JKUtil getColor:@"616E8D"];
    detailL.font = YSystemFont(20 * YScaleHeight);
    [midV addSubview:detailL];
    detailL.sd_layout.centerYEqualToView(midV).centerXEqualToView(midV).widthIs(200 * YScaleWidth).heightIs(28 * YScaleHeight);
    
    
    UIImageView *imgg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconcopy"]];
    [midV addSubview:imgg];
    imgg.sd_layout.rightSpaceToView(midV, 33 * YScaleWidth).centerYEqualToView(midV).widthIs(28 * YScaleHeight).heightEqualToWidth();

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [midV addSubview:btn];
    btn.sd_layout.rightEqualToView(midV).topEqualToView(midV).bottomEqualToView(midV).widthIs(60 * YScaleWidth);
    
}

//关于我们
- (void)setupView4{
    aboutV = [UIView new];
    aboutV.backgroundColor = kbackColor;
    [rightV addSubview:aboutV];
    aboutV.sd_layout.centerXEqualToView(rightV).centerYEqualToView(rightV).widthIs(806 * YScaleWidth).heightIs(600 * YScaleHeight);
    
}



#pragma mark - click
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)caozuoClick:(UIButton *)Btn{
    NSInteger btnIndex = Btn.tag - 1000;
    
    if(Btn != selectedBtn){
        
        if(!Btn.selected){
            Btn.selected = YES;
            selectedBtn.selected = NO;
            
            //购买方案
            if(btnIndex == 0){
                goumaiV.hidden = NO;
                qingkuangV.hidden = YES;
                kefuV.hidden = YES;
                aboutV.hidden = YES;
            }
            
            //识字情况
            else if(btnIndex == 1){
                if(!qingkuangV){
                    [self setupView2];
                }
                
                goumaiV.hidden = YES;
                qingkuangV.hidden = NO;
                kefuV.hidden = YES;
                aboutV.hidden = YES;
            }
            
            //联系客服
            else if(btnIndex == 2){
                if(!kefuV){
                    [self setupView3];
                }
                
                goumaiV.hidden = YES;
                qingkuangV.hidden = YES;
                kefuV.hidden = NO;
                aboutV.hidden = YES;
            }
            
            //关于我们
            else if(btnIndex == 3){
                if(!aboutV){
                    [self setupView4];
                }
                
                goumaiV.hidden = YES;
                qingkuangV.hidden = YES;
                kefuV.hidden = YES;
                aboutV.hidden = NO;
            }

            
        }
        
        selectedBtn = Btn;
    }
    
}

- (void)payClick{
    YLogFunc
}

- (void)copyClick{
    YLogFunc
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIView *v = tap.view;
    selectIndex = v.tag;
    
    if(v != selectedV){
        
        v.layer.borderColor = kocolor.CGColor;
        
        UILabel *label = v.subviews.firstObject;
        label.textColor = kocolor;
        
        if(selectedV){
            UILabel *selectL = selectedV.subviews.firstObject;
            selectL.textColor = [JKUtil getColor:@"2E4476"];
            selectedV.layer.borderColor = [JKUtil getColor:@"C6D9FF"].CGColor;
        }
        
        selectedV = v;
        
    }
}

#pragma mark ————— collection代理方法 —————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WordCollectionViewCell class]) forIndexPath:indexPath];
    
    return cell;
}

//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //边距的顺序是 上左下右
  return UIEdgeInsetsMake(0,0,0,30 * YScaleWidth);
}



- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    YLogFunc
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
