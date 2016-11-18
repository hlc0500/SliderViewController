//
//  SliderViewController.h
//  SliderViewController
//
//  Created by hlc on 16/11/18.
//  Copyright © 2016年 hlc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController<UIGestureRecognizerDelegate>

//中间视图控制器
@property (nonatomic,retain) UIViewController *mainVC;

//左侧视图控制器
@property (nonatomic,retain) UIViewController *leftVC;

//右侧视图控制器
@property (nonatomic,retain) UIViewController *rightVC;

@property (nonatomic,retain) UIView           *layerView;

//导航控制器
@property (nonatomic,retain) UINavigationController *navController;

@property (nonatomic,assign) CGFloat distance;

@property (nonatomic,assign) CGFloat leftDistance;

@property (nonatomic,assign) CGFloat menuCenterXStart;

@property (nonatomic,assign) CGFloat menuCenterXEnd;

@property (nonatomic,assign) CGFloat panStartX;

@property (nonatomic,assign) BOOL isClose;

@property (nonatomic,assign) BOOL isCloseLeftAndRight;

/**
 @brief 单例
 */
+ (SliderViewController*)sharedSliderController;
/**
 @brief 初始化侧滑控制器
 @param leftVC 右视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC andRightView:(UIViewController *)rightVC;

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;

- (void)showLeftViewController;

- (void)closeLeftViewController;

- (void)showRightViewController;

- (void)closeRightViewController;
@end

