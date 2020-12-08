//
//  WordCollectionViewCell.m
//  Literacy
//
//  Created by Yuri on 2020/11/20.
//

#import "WordCollectionViewCell.h"

@implementation WordCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {

        self.contentView.backgroundColor = ClearColor;
        
        self.bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordcarddefault"]];
        [self.contentView addSubview:self.bgImg];
        self.bgImg.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topEqualToView(self.contentView).bottomEqualToView(self.contentView);

        
        self.ziLabel = [[UILabel alloc] init];
        self.ziLabel.font = [UIFont fontWithName:@"kaiti" size:75 * YScaleWidth];
        self.ziLabel.text = @"大";
        self.ziLabel.textColor = kblackColor;
        self.ziLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.ziLabel];
        self.ziLabel.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).widthIs(78 * YScaleWidth).heightIs(74 * YScaleWidth);
        
    }
    return self;
}

- (void)setMod:(AllModel *)mod{
    self.ziLabel.text = mod.word;
}


@end
