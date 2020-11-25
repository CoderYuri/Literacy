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
    
    UICollectionView *collectionView;
}

@end

@implementation WordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

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
    
    UIView *midV = [UIView new];
    midV.backgroundColor = WhiteColor;
    [backV addSubview:midV];
    midV.sd_layout.leftEqualToView(backV).rightEqualToView(backV).topSpaceToView(topV, 0).heightIs(44 * YScaleWidth);
    
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcardpre"]];
    [midV addSubview:leftImg];
    leftImg.sd_layout.leftSpaceToView(midV, 160 * YScaleWidth).centerYEqualToView(midV).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    leftL = [UILabel new];
    leftL.text = @"已学习（1个）";
    leftL.textColor = [JKUtil getColor:@"3F4D6C"];
    leftL.font = YSystemFont(12 * YScaleWidth);
    [midV addSubview:leftL];
    leftL.sd_layout.leftSpaceToView(leftImg, 10 * YScaleWidth).centerYEqualToView(midV).widthIs(104 * YScaleWidth).heightIs(17);
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcarddefault"]];
    [midV addSubview:rightImg];
    rightImg.sd_layout.leftSpaceToView(leftImg, 110 * YScaleWidth).centerYEqualToView(midV).widthIs(38 * YScaleWidth).heightEqualToWidth();
    
    rightL = [UILabel new];
    rightL.text = @"未学习（1499个）";
    rightL.textColor = [JKUtil getColor:@"3F4D6C"];
    rightL.font = YSystemFont(12 * YScaleWidth);
    [midV addSubview:rightL];
    rightL.sd_layout.leftSpaceToView(rightImg, 10 * YScaleWidth).centerYEqualToView(midV).widthIs(200).heightIs(17);

    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(120 * YScaleWidth, 120 * YScaleWidth);
//    layout.minimumLineSpacing = 40 * YScaleHeight;
    
    
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,120 * YScaleHeight + 44 * YScaleWidth, YScreenW, YScreenH - 120 * YScaleHeight - 44 * YScaleWidth) collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(36 * YScaleWidth, 160 * YScaleWidth, 36 * YScaleWidth, 160 * YScaleWidth);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = FALSE;
    collectionView.backgroundColor = ClearColor;
    [collectionView registerClass:[WordCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([WordCollectionViewCell class])];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [backV addSubview:collectionView];
    
    
    
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
  return UIEdgeInsetsMake(0,0,0,40 * YScaleWidth);
}



- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    YLogFunc
}



#pragma mark - click
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
