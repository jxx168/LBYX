//
//  CommonSoundViewController.m
//  LBYX
//
//  Created by Ant on 2019/6/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import "CommonSoundViewController.h"

@implementation SoundModel

@end

@implementation CommonSoundViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self initDataSource];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SoundModel *model = self.dataSource[indexPath.row];
    
    Changecell * cell = [Changecell tempTableViewCellWith:tableView indexPath:indexPath];
    
    model.isSelected ? [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] animated:NO scrollPosition:UITableViewScrollPositionNone] : nil;
    
    cell.lab_Name.text = model.title;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectCellWithTableView:tableView atIndexPath:indexPath];
    
}



- (void)initDataSource {}

- (void)didSelectCellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {}


@end
