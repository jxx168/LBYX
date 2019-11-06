//
//  VolumeViewController.m
//  LBYX
//
//  Created by Ant on 2019/6/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import "VolumeViewController.h"

static NSString * const kUserDefaultsVolume = @"kUserDefaultsVolume";
@interface VolumeViewController ()
@property (nonatomic,copy)NSArray * arr_ZL;
@end

@implementation VolumeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.arr_ZL = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07"];
}
- (void)initDataSource
{
   self.title = LocalizedStaing(@"内部音");
    NSArray *tmpArray = @[
                          @{@"title": @"A", @"soundValue": @1},
                          @{@"title": @"B", @"soundValue": @2},
                          @{@"title": @"C", @"soundValue": @3, @"isSelected": @NO},
                          @{@"title": @"D", @"soundValue": @4},
                          @{@"title": @"E", @"soundValue": @5},
                          @{@"title": @"F", @"soundValue": @5},
                          @{@"title": @"G", @"soundValue": @5}
                          ];
    NSArray *localMaxSoundArray = (NSArray *)[kUserDefaults objectForKey:kUserDefaultsVolume];
    
    NSArray <NSDictionary *>*soundArray = localMaxSoundArray.count ? localMaxSoundArray : tmpArray;
    
    self.dataSource = [SoundModel mj_objectArrayWithKeyValuesArray:soundArray];
}


- (void)didSelectCellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    
    [self.dataSource enumerateObjectsUsingBlock:^(SoundModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    
    SoundModel *model = self.dataSource[indexPath.row];
    model.isSelected = YES;
    [YTAlertUtil showHUDWithTitle:LocalizedStaing(@"指令处理中...")];
    NSData * data1 = [[NSString stringWithFormat:@"07000100%@0000",self.arr_ZL[indexPath.row]] hexToData];
    //    NSData * data =[[NSString stringWithFormat:@"06000100%@0000",[[self.arr_ZL[indexPath.row] trimmingAllspace] hexStringFromString]] hexToData];
//    [BlueApi send:data1 withResponse:YES withSendStatusBlock:^(NSData *data) {
//
//    }];
    [BApi writeChar:data1 response:YES];
    [kUserDefaults setObject:[SoundModel mj_keyValuesArrayWithObjectArray:self.dataSource] forKey:kUserDefaultsVolume];
    [kUserDefaults synchronize];
}
@end
