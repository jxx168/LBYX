//
//  setBlueController.m
//  LBYX
//
//  Created by john on 2019/6/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import "setBlueController.h"
#import "CommonAlertView.h"
#import "NSData+FscKit.h"
@interface setBlueController () 
@property (weak, nonatomic) IBOutlet UILabel *lab_Name1;
 @end

@implementation setBlueController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedStaing(@"蓝牙");
//    self.api = [FscBleCentralApi defaultFscBleCentralApi];
//    self.api.moduleType = BLEMODULE;
//    self.lab_Name1.text = self.api.peripheral.name;
    self.lab_Name1.text = BApi.discoveredPeripheral.name;
 }

- (void)reflashView:(NSString *)string withStatus:(int)status {
    NSString *str = @"";
    if (status == 0) {
        str = @"修改成功";
    } else if (status == 1) {
        str = @"修改失败";
    } else {
        str = string;
    }
    [YTAlertUtil showTempInfo:str];
}
- (IBAction)btClick:(UIButton *)sender {
//    WeakSelf
//    NSMutableArray * inArr = [NSMutableArray array];
    [CommonAlertView alertCommonSignalTitle:self Handler:^(NSString * _Nonnull Name, NSString * _Nonnull Pin) {
        NSData * data;
        if (Name.length!=0) {
//            [inArr addObject:[NSString stringWithFormat:@"AT+NAME=%@",Name]];
            data =[[NSString stringWithFormat:@"01000600%@0000",[[Name trimmingAllspace] hexStringFromString]] hexToData];
        }
        if (Pin.length!=0) {
//            [inArr addObject:[NSString stringWithFormat:@"AT+PIN=%@",Pin]];
//            data =[[NSString stringWithFormat:@"02000400%@0000",[[Name trimmingAllspace] hexStringFromString]] hexToData];
        }
        [YTAlertUtil showHUDWithTitle:LocalizedStaing(@"指令处理中...")];
        [BApi writeChar:data response:YES];
//        [weakSelf.api send:data withResponse:YES withSendStatusBlock:^(NSData *data) {
//            NSLog(@"我输出了%@",data);
//        }];
    }]; 
} 
@end
