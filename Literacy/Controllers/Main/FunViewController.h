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

@property(nonatomic,strong) NSArray *similar_words;

@property(nonatomic,strong) NSArray *combine_words;

@property(nonatomic,copy) NSString *word_image;

@property(nonatomic,copy) NSString *word_video;

@property(nonatomic,copy) NSString *word_audio;

@property(nonatomic,strong) NSArray *words_audios;

@property(nonatomic,assign)BOOL ifFuxi;

@end

NS_ASSUME_NONNULL_END
