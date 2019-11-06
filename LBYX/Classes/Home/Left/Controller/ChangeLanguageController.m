//
//  ChangeLanguageController.m
//  LBYX
//
//  Created by john on 2019/6/3.
//  Copyright © 2019 qt. All rights reserved.
//

#import "ChangeLanguageController.h"
@class Changecell;
@interface ChangeLanguageController ()

@end
@implementation ChangeLanguageController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LocalizedStaing(@"语言选择");
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self setTableview];
    _arr_Data = @[LocalizedStaing(@"中文"),LocalizedStaing(@"英文")];;
}
-(void)setArr_Data:(NSArray *)arr_Data{
    _arr_Data = arr_Data;
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_Data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Changecell * cell = [Changecell tempTableViewCellWith:tableView indexPath:indexPath];
    NSInteger index = 0;
    if ([[ChangLanguage userLanguage] isEqualToString:ZHHANS]) {
        index = 0;
    }else{
        index = 1;
    }
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    cell.lab_Name.text = self.arr_Data[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * languageStr = [ChangLanguage userLanguage];
    NSArray * langArr = @[ZHHANS,EN];
    if ([languageStr isEqualToString:langArr[indexPath.row]]) {
        return;
    }
     [ChangLanguage setUserLanguage:langArr[indexPath.row]]; 
    [kNotificationCenter postNotificationName:KNotiChaneLanguage object:nil];
}
//初始化tab
-(void)setTableview{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 57;
    self.tableView.backgroundColor = [UIColor clearColor];
//    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.tableView.bounds];
//    [backImageView setImage:[UIImage imageNamed:@"BG"]];
//    self.tableView.backgroundView=backImageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {  make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(@(0));
        }
    }];
}
@end

#pragma mark -----Changecell------
static NSArray * arr;
@implementation Changecell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.lab_Name];
        [self addSubview:self.image_select];
        [self addSubview:self.view_line];
    }
    return self;
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    Changecell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[Changecell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _lab_Name.frame = CGRectMake(26, 0, kScreenWidth-64, self.height);
    _image_select.frame =CGRectMake(kScreenWidth-38, self.contentView.height/2-7.5, 15, 15);
    _view_line.frame =CGRectMake(0, self.contentView.height-1, kScreenWidth, 1);
}

-(UILabel *)lab_Name{
    if (!_lab_Name) {
        _lab_Name = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_Name.font = kSystemFont(15);
        _lab_Name.textColor = KHexColor(@"#091537");
    }
    return _lab_Name;
}
-(UIImageView *)image_select{
    if (!_image_select) {
        _image_select = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _image_select;
}
-(UIView *)view_line{
    if (!_view_line) {
        _view_line = [[UIView alloc] initWithFrame:CGRectZero];
        _view_line.backgroundColor = KHexColor(@"#E2E4EA");
    }
    return _view_line;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.image_select.image = kImage_Named(@"button_Single election");
    }else
         self.image_select.image = kImage_Named(@"button");
}
@end
