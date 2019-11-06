//
//  HomeController.m
//  LBYX
//
//  Created by john on 2019/5/31.
//  Copyright © 2019 qt. All rights reserved.

#import "HomeController.h"
#import "MaxSoundViewController.h"
#import "EngineSoundViewController.h"
#import "VolumeViewController.h"
#import "CircleView.h"
#import <Foundation/Foundation.h>
#import "BlueSearchController.h"
#import "UIViewController+CWLateralSlide.h"
#import "LeftViewController.h"
#import "BtnView.h"
#define VolumVoiceNum @"VolumVoiceNum"
#define EngineVoiceNum @"EngineVoiceNum"
#define MaxVoiceNum @"MaxVoiceNum"
#define VoiceNum @"VoiceNum"
#define VoiceType  @"VoiceType"
static NSString * VolumStr = @"07";
static NSString * EngineStr = @"06";
static NSString * MaxStr = @"08";  //04 03 05
@interface HomeController ()<BtnViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_Top;
@property (weak, nonatomic) IBOutlet UIView *view_roate;//旋转的view
@property (weak, nonatomic) IBOutlet UIView *view_circle;
@property (weak, nonatomic) IBOutlet UIView *view_circleSmall;
@property (weak, nonatomic) IBOutlet UIButton *btn_open;
@property (nonatomic,copy) NSString * setVolumStr;//当前设置后内外混响音
@property (nonatomic,assign) CGFloat currentRadio;//当前旋转的角度
@property (nonatomic,strong)CircleView * circleView;
@property (nonatomic,strong)BluetoothTool * bApi;
@property (nonatomic,strong) BtnView * btnView;//顶部btn试图
//中心管理者
@property (nonatomic,strong) LeftViewController *leftVC; // 强引用，可以避免每次显示抽屉都去创建
@property (nonatomic, strong)NSMutableDictionary * dic;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.title = LocalizedStaing(@"激活音量");
    [self.view_Top addSubview:self.btnView];
    self.dic = [kUserDefaults objectForKey:VoiceNum]?[NSMutableDictionary dictionaryWithDictionary:[kUserDefaults objectForKey:VoiceNum]]:[NSMutableDictionary dictionary];
    self.setVolumStr = [kUserDefaults objectForKey:VoiceType]?[kUserDefaults objectForKey:VoiceType]:@"";
    self.btnView.versionStatus = self.setVolumStr;
    UIButton * btn = [UIButton itemWithRectTarget:self action:@selector(maskAnimationFromLeft) image:@"icon_menu" title:nil withRect:CGRectMake(0, 0, 44, 44)];
    [self initBarItem:btn withType:0];
    [self initSetFanView];//设置外围的扇环形
    [self initCircleColor];//设置内圆的边框 圆角背景色
    self.bApi = [[BluetoothTool shareBlueTooth] init];
    [self setNotiFation];
    [self registGes];
}
/**
 添加通知监听
 */
-(void)setNotiFation{
    [kNotificationCenter addObserver:self selector:@selector(SetVolum:) name:KNotiSetVolum object:nil];
    [kNotificationCenter addObserver:self selector:@selector(CloseVersion) name:KNotiVersionClose object:nil];
    [kNotificationCenter addObserver:self selector:@selector(SetStatus:) name:KNotiVersionStatus object:nil];
}
/**
 获取到设备信息后显示功能状态
 */
-(void)SetStatus:(NSNotification *)noti{
    NSLog(@"%@",noti.object[@"status"]);
    [self setVersonStatus:noti.object[@"status"]];
}
//设备已断开
-(void)CloseVersion{
    [self closeBtn];
    [self.navigationController pushViewController:[BlueSearchController new] animated:YES];
}
//设置
-(void)SetVolum:(NSNotification *)noti{
    NSLog(@"%@",noti.object[@"type"]);
    NSString * str = noti.object[@"type"];
    //    04 内音 03 外音 05 混响   07内音调节音量完成 06 外音调节音量完成 08 混响调节音量完成
    if ([str isEqualToString:@"04"] || [str isEqualToString:@"03"] || [str isEqualToString:@"05"]) {//内音调节成功后音量
        [self.dic setValue:[NSString stringWithFormat:@"%f",self.currentRadio] forKey:[str isEqualToString:@"04"]?VolumVoiceNum:[str isEqualToString:@"03"]?EngineVoiceNum:MaxVoiceNum];
    }
    if ([str isEqualToString:@"07"] || [str isEqualToString:@"06"] || [str isEqualToString:@"08"]) {
        if (![str isEqualToString:[kUserDefaults objectForKey:VoiceType]]) {
            self.setVolumStr = str;
            self.btn_open.selected = NO;
            self.btnView.versionStatus = str;
            [self closeBtn];
            [kUserDefaults setObject:str forKey:VoiceType];
        }
    }
    [kUserDefaults setObject:self.dic forKey:VoiceNum];
    [kUserDefaults synchronize];
}
-(void)setVersonStatus:(NSString *)status{
    self.btnView.versionStatus = status;
}
/**
音量开关点击事件
 */
- (IBAction)btn_open:(UIButton *)sender {
//    ISSearchController
    if ([self.setVolumStr isEqualToString:@"08"]) {
        return [YTAlertUtil showTempInfo:LocalizedStaing(@"此功能正在开发中....")];
    }
    float startAngles = -270;
    NSMutableDictionary * dic = (NSMutableDictionary *)[kUserDefaults objectForKey:VoiceNum];
    NSLog(@"当前调节为：%@===%@",self.setVolumStr,dic);
    if (dic&&dic.count!=0) {
        if ([self.setVolumStr isEqualToString:VolumStr] && [[dic allKeys] containsObject:@"VolumVoiceNum"]) {
            startAngles = [dic[VolumVoiceNum] floatValue];
        }else if ([self.setVolumStr isEqualToString:EngineStr] && [[dic allKeys] containsObject:@"EngineVoiceNum"]){
            startAngles = [dic[EngineVoiceNum] floatValue];
        }else if ([self.setVolumStr isEqualToString:MaxStr] && [[dic allKeys] containsObject:@"MaxVoiceNum"]){
            startAngles = [dic[MaxVoiceNum] floatValue];
        }
    }
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self closeBtn];
    }else{
        CGAffineTransform rotate = CGAffineTransformMakeRotation(startAngles/180.0 * M_PI);
        [self.view_roate setTransform:rotate];
        self.view_circleSmall.layer.borderColor = KHexColor(@"#19F5EA").CGColor;
        self.view_circleSmall.backgroundColor = KRGBColor(23, 65, 131);
        self.circleView.knobValue = startAngles;
     }
}
//开关关闭状态
-(void)closeBtn{
    self.btn_open.selected = NO;
    self.circleView.knobValue =  -270;
    [self initCircleColor];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(90/180.0 * M_PI);
    [self.view_roate setTransform:rotate];
}
/**
 初始化圆形边框颜色 背景色
 */
-(void)initCircleColor{
    self.view_circleSmall.layer.cornerRadius = (kScreenWidth-128)/2;
    self.view_circleSmall.layer.borderColor = KRGBColor(47, 72, 135).CGColor;
    self.view_circleSmall.layer.borderWidth = 1;
    self.view_circleSmall.layer.masksToBounds = YES;
    self.view_circleSmall.backgroundColor = [UIColor clearColor];
}

/**
 初始化扇形
 */
-(void)initSetFanView{
    self.circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-68), (kScreenWidth-68))];
    self.circleView.backgroundColor = [UIColor clearColor];
    [self.view_circle addSubview:self.circleView];
//    self.circleView.knobValue = -270;//设置起始点
//    self.circleView.progress = 0.8;
    self.circleView.isSHowShadow = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.circleView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.circleView addGestureRecognizer:panGesture];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(90/180.0 * M_PI);
    [self.view_roate setTransform:rotate];
}
- (void)tapEvent:(UIGestureRecognizer *)tapGesture
{
    if (!self.btn_open.selected) {
        return;
    }
    CGPoint point;
    point = [tapGesture locationInView:self.view_circle];
    if ([tapGesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        [self pointConvert:point closeAnimation:YES tapGesture:tapGesture];
    }else{
        [self pointConvert:point closeAnimation:NO tapGesture:tapGesture];
    }
}
//  转动到某一角度
- (void)pointConvert:(CGPoint)point closeAnimation:(BOOL)closeAnimation tapGesture:(UIGestureRecognizer *)tapGesture
{
    CGFloat x0 = CGRectGetWidth(self.view_circle.frame)/2;
    CGFloat y0 = CGRectGetHeight(self.view_circle.frame)/2;
    CGFloat x1 = point.x;
    CGFloat y1 = point.y;
    
    CGFloat angle = atan((y1 - y0)/(x1 - x0));
    CGFloat radius = radiansToDegrees(angle);
    
    typedef enum {
        areaLeftUp,
        areaLeftDown,
        areaRightUp,
        AreaRightDown,
    }AreaEnum;
    
    AreaEnum pointInArea;
    if (x1 < x0 && y1 < y0) {
        pointInArea = areaLeftUp;
    }
    else if(x1 < x0 && y1 >= y0){
        pointInArea = areaLeftDown;
    }
    else if (x1 >= x0 && y1 < y0){
        pointInArea = areaRightUp;
        radius = 180 + radius;
    }
    else if (x1 >= x0 && y1 >= y0){
        pointInArea = AreaRightDown;
        radius = 180 + radius;
    }
    CGFloat knobA = radius;
    knobA = radius >  startAngleValue ? radius  :  startAngleValue;
    knobA = radius < -(180 + endAngleValue) ? -(180 + endAngleValue) : radius;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(knobA/180.0 * M_PI);
    [self.view_roate setTransform:rotate];
    
    CGFloat radiousCurrent = 0.0;float voiceNum=0;
    if (radius>=90&&radius<=270) {
        radiousCurrent = knobA - 90;
    }else if(radius>=-90&&radius<=0){
        radiousCurrent =fabs(180 + fabs(knobA + 90));
    }else{
        radiousCurrent = 270 + radius;
    }
    voiceNum = radiousCurrent / 3.6;
    self.circleView.progress = voiceNum/100.0f;

    
    
    //  设置弧线路径
//    self.circleView.knobValue = knobA;
//    if (tapGesture.state == UIGestureRecognizerStateEnded || tapGesture.state == UIGestureRecognizerStateCancelled) {
//        CGFloat radiousCurrent = 0.0;float voiceNum=0;
//        if (radius>=90&&radius<=270) {
//            radiousCurrent = knobA - 90;
//        }else if(radius>=-90&&radius<=0){
//            radiousCurrent =fabs(180 + fabs(knobA + 90));
//        }else{
//            radiousCurrent = 270 + radius;
//        }
//        voiceNum = radiousCurrent / 3.6;
//        NSString * hex = [NSString getHexByDecimal:voiceNum];
//        if ([self.setVolumStr isEqualToString:VolumStr]) {
//            hex = [NSString stringWithFormat:@"04000200%@%@0000",hex,hex];
//        }else if ([self.setVolumStr isEqualToString:EngineStr]){
//            hex = [NSString stringWithFormat:@"03000200%@%@0000",hex,hex];
//        }else if ([self.setVolumStr isEqualToString:MaxStr]){
//            hex = [NSString stringWithFormat:@"05000200%@%@0000",hex,hex];
//        }
//        self.circleView.progress = voiceNum/100.0f;
////        [YTAlertUtil showHUDWithTitle:LocalizedStaing(@"指令处理中...")];
////        [BApi writeChar:[hex hexToData] response:YES];
//        self.currentRadio = radius;
//        NSLog(@"我结束了%f==%f==%f==%f",radius,radiousCurrent,voiceNum,        self.circleView.progress);
//    }
}
- (void)btnClickDelegate:(NSInteger)tag{
    ISSearchController
    NSArray <UIViewController *>*controllersArray =  @[[EngineSoundViewController new],[VolumeViewController new],  [MaxSoundViewController new]];
    NSInteger index = tag-500;
    if (index > controllersArray.count-1) {
        return;
    }
    UIViewController *vc = controllersArray[index];
    [self.navigationController pushViewController:vc animated:YES];
} 
#pragma MARK ------------- 侧滑菜单
//注册手势
-(void)registGes{
    // 注册手势驱动
    WeakSelf
    [self cw_registerShowIntractiveWithEdgeGesture:YES transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf maskAnimationFromLeft];
        }
    }];
}
// 遮盖在上从左侧划出
- (void)maskAnimationFromLeft{
    // 调用这个方法
    [self cw_showDrawerViewController:self.leftVC animationType:CWDrawerAnimationTypeMask configuration:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self TanBlueNoOpen];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
//懒加载UI
- (LeftViewController *)leftVC {
    if (_leftVC == nil) {
        _leftVC = [LeftViewController new];
    }
    return _leftVC;
}
-(BtnView *)btnView{
    if (_btnView == nil) {
        _btnView = [[NSBundle mainBundle] loadNibNamed:@"BtnView" owner:nil options:nil][0];
        _btnView.Bdelegate = self;
//        _btnView.backgroundColor = [UIColor redColor];
    }
    return _btnView;
}
@end
