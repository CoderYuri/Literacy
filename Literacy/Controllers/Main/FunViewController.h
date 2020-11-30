//
//  FunViewController.h
//  Literacy
//
//  Created by Yuri on 2020/11/25.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FunViewController : BaseViewController
@property(nonatomic,strong) AllModel *selectedMod;

@property(nonatomic,assign) NSInteger xuanzhongIndex;
@property (nonatomic, strong) void(^callBack)(NSInteger xuanzhongIndex);
@end

NS_ASSUME_NONNULL_END
