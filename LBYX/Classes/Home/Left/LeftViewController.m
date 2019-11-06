//
//  LeftViewController.m
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.
//

#import "LeftViewController.h"
#import "HeadView.h"
#import "LeftCell.h"
#import "CommonAlertView.h"
#import "UIViewController+CWLateralSlide.h"
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tab_bottom;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//设置UI
-(void)setUI{ 
    [self setUpTab];
}
-(void)setUpTab{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth* 0.8, kScreenHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.scrollEnabled = NO;
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.tableView.bounds];
    [backImageView setImage:[UIImage imageNamed:@"bg"]];
    backImageView.contentMode =  UIViewContentModeScaleToFill;
    self.tableView.backgroundView=backImageView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    HeadView * head = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, kScreenHeight*0.3)];
    self.tableView.tableHeaderView  = head;
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftCell * cell = [LeftCell tempTableViewCellWith:tableView indexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [kUserDefaults setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"SELECTROW"];
    [kUserDefaults synchronize];
    if (indexPath.row==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
   else if (indexPath.row==1||indexPath.row==2) {
        NSArray * arr = @[@"ChangeLanguageController",@"setBlueController"];
         if (indexPath.row==2&&BApi.discoveredPeripheral == nil) {
             [self cw_pushViewController:[BlueSearchController new]];
         }else{
             [self cw_pushViewController:[self rotateClass:arr[indexPath.row-1]]];
         }
     }else if(indexPath.row==4){
         [ToolKit DaDianHua:KeFuPhone];
     }else if(indexPath.row == 3){
         [YTAlertUtil showTempInfo:LocalizedStaing(@"此功能正在开发中....")];
//         [CommonAlertView alertCommonHandler:^{
//
//         }];
     }
    [tableView reloadData];
} 
@end
