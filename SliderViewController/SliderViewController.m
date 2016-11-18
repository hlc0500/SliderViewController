//
//  SliderViewController.m
//  SliderViewController
//
//  Created by hlc on 16/11/18.
//  Copyright © 2016年 hlc. All rights reserved.
//

#import "SliderViewController.h"

typedef enum state{
    KStateHome,
    KStateMenu
}state;

static const CGFloat viewSlideHorizonRatio = 0.75;
static const CGFloat viewHeightNarrowRatio = 0.80;
static const CGFloat menuStartNarrowRatio  = 0.70;

@interface SliderViewController ()

@property (nonatomic,assign)state sta;

@end

@implementation SliderViewController

/**
 @brief 单例
 */
+ (SliderViewController*)sharedSliderController
{
    static SliderViewController *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
    });
    
    return sharedSVC;
}

/**
 @brief 初始化侧滑控制器
 @param leftVC 右视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UINavigationController *)mainVC andRightView:(UIViewController *)rightVC{
    if(self == [super init]){
        self.navController = mainVC;
        self.leftVC   = leftVC;
        self.rightVC  = rightVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.sta = KStateHome;
    self.distance = 0;
    self.menuCenterXStart = self.view.frame.size.width * menuStartNarrowRatio / 2.0;
    self.menuCenterXEnd = self.view.center.x;
    self.leftDistance = self.view.frame.size.width * viewSlideHorizonRatio;
    
    self.leftVC.view.frame = [[UIScreen mainScreen] bounds];
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartNarrowRatio, menuStartNarrowRatio);
    self.leftVC.view.center = CGPointMake(self.menuCenterXStart, self.leftVC.view.center.y);
    [self.view addSubview:self.leftVC.view];
    
    self.rightVC.view.hidden = YES;
    
    [self initHomeLayerView];
}

//添加主页面透明层(为了不与UITableView之类的点击事件冲突)
-(void)initHomeLayerView{
    if(!_layerView){
        _layerView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _layerView.backgroundColor = [UIColor colorWithRed:169.0f/255.0f green:169.0f/255.0f blue:169.0f/255.0f alpha:0.7];
        _layerView.hidden = YES;
        [self.navController.view addSubview:_layerView];
        [self initTapGesture];
        [self initPanGesture];
    }
}

//添加点击回到首页
-(void)initTapGesture{
    UITapGestureRecognizer * _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftViewController)];
    _tapGestureRec.delegate = self;
    [self.layerView addGestureRecognizer:_tapGestureRec];
}

//添加滑动手势
-(void)initPanGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    
    //添加右侧手势
    UIPanGestureRecognizer *Rightpan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeRightViewMenu:)];
    [self.navController.view addGestureRecognizer:pan];
    [self.rightVC.view addGestureRecognizer:Rightpan];
    [self.view addSubview:self.navController.view];
    [self.view addSubview:self.rightVC.view];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(_isCloseLeftAndRight){
        return NO;
    }
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //当滑动水平x大于75时禁止滑动
    if(_isCloseLeftAndRight){
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartX = [recognizer locationInView:self.view].x;
    }
    CGFloat x = [recognizer translationInView:self.view].x;
    CGFloat dis = self.distance + x;
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if(_isClose){
            [self showHome];
            return;
        }
        if (dis >= self.view.frame.size.width * viewSlideHorizonRatio / 2.0) {
            [self showMenu];
        } else if(dis < 0){
            [self showRightViewMenu];
        }else{
            [self showHome];
        }
        return;
    }
    CGFloat proportion = (viewHeightNarrowRatio - 1) * dis / self.leftDistance + 1;
    if (proportion < viewHeightNarrowRatio || proportion > 1) {
        return;
    }
    self.navController.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);
    self.navController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
    CGFloat menuProportion = dis * (1 - menuStartNarrowRatio) / self.leftDistance + menuStartNarrowRatio;
    CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / self.leftDistance;
    self.leftVC.view.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y);
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
    
}
//打开右侧
-(void)showRightViewMenu{
    [UIView animateWithDuration:0.4 animations:^{
        self.navController.view.frame = CGRectMake(-self.view.frame.size.width, self.navController.view.frame.origin.y,self.navController.view.frame.size.width,self.navController.view.frame.size.height);
        self.rightVC.view.hidden = NO;
        self.rightVC.view.backgroundColor = [UIColor redColor];
        self.rightVC.view.frame = CGRectMake(0, self.navController.view.frame.origin.y, self.navController.view.frame.size.width, self.navController.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                     }];
}

//关闭右侧菜单
-(void)closeRightViewMenu:(UIPanGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.panStartX = [recognizer locationInView:self.view].x;
    }
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            self.navController.view.frame = CGRectMake(0, self.navController.view.frame.origin.y,self.navController.view.frame.size.width,self.navController.view.frame.size.height);
            [_rightVC.view setFrame:CGRectMake(self.navController.view.frame.size.width, self.navController.view.frame.origin.y, self.navController.view.frame.size.width, self.navController.view.frame.size.height)];
        } completion:^(BOOL finished){
            _rightVC.view.hidden = YES;
        }];
    }
}

//
-(void)showMenu{
    self.isClose = YES;
    self.distance = self.leftDistance;
    self.sta = KStateMenu;
    [self doSlide:viewHeightNarrowRatio];
}

//展示主界面
-(void)showHome{
    self.isClose = NO;
    self.distance = 0;
    self.sta = KStateHome;
    [self doSlide:1];
}

//实施自动滑动
- (void)doSlide:(CGFloat)proportion{
    [UIView animateWithDuration:0.3 animations:^{
        self.navController.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y);
        self.navController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
        
        CGFloat menuCenterX;
        CGFloat menuProportion;
        if (proportion == 1) {
            _layerView.hidden = YES;
            menuCenterX = self.menuCenterXStart;
            menuProportion = menuStartNarrowRatio;
        } else {
            _layerView.hidden = NO;
            menuCenterX = self.menuCenterXEnd;
            menuProportion = 1;
        }
        self.leftVC.view.center = CGPointMake(menuCenterX, self.view.center.y);
        self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
    } completion:^(BOOL finished) {
    }];
    
}

//展示左侧
- (void)showLeftViewController{
    [self showMenu];
}

//关闭左侧
- (void)closeLeftViewController{
    [self showHome];
}

//显示右侧
- (void)showRightViewController{
    [self showRightViewMenu];
}

//关闭右侧
- (void)closeRightViewControlle{
    [self closeRightViewControlle];
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
