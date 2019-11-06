//
//  CommonSoundViewController.h
//  LBYX
//
//  Created by Ant on 2019/6/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import "ChangeLanguageController.h"
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN



@interface SoundModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 声音 */
@property (nonatomic, assign) NSInteger soundValue;
/** 选中状态 */
@property (nonatomic, assign) BOOL isSelected;

@end



@interface CommonSoundViewController : ChangeLanguageController
@property(nonatomic, strong) NSArray<SoundModel *> *dataSource;

/**
 初始化数据源
 */
- (void)initDataSource;

/**
 tableView 的点击方法

 @param tableView tableView
 @param indexPath indexPath
 */
- (void)didSelectCellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;



@end

NS_ASSUME_NONNULL_END
