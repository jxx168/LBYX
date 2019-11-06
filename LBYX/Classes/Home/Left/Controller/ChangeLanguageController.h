//
//  ChangeLanguageController.h
//  LBYX
//
//  Created by john on 2019/6/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeLanguageController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray * arr_Data;//数据源数组
@end

@interface Changecell : UITableViewCell
@property (nonatomic,copy)NSString * name;
@property (nonatomic, strong) UILabel * lab_Name;
@property (nonatomic,strong) UIImageView * image_select;
@property (nonatomic,strong) UIView * view_line;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
NS_ASSUME_NONNULL_END
