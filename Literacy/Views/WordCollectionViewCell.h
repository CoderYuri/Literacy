//
//  WordCollectionViewCell.h
//  Literacy
//
//  Created by Yuri on 2020/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WordCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *ziLabel;

@property (nonatomic,strong) UIImageView *bgImg;

@property (nonatomic,strong) UIImageView *lockImg;

@property(nonatomic,strong)AllModel *mod;

@end

NS_ASSUME_NONNULL_END
