//
//  AppDelegate.m
//  SliderViewController
//
//  Created by hlc on 16/11/18.
//  Copyright © 2016年 hlc. All rights reserved.
//

#import "AppDelegate.h"
#import "SliderViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor blackColor];
    
    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor redColor];
    
    ViewController *vc3 = [[ViewController alloc]init];
    vc3.view.backgroundColor = [UIColor orangeColor];
    
    [SliderViewController sharedSliderController].leftVC = vc1;
    [SliderViewController sharedSliderController].rightVC = vc2;
    [SliderViewController sharedSliderController].mainVC = vc3;
    
    [SliderViewController sharedSliderController].navController = [[UINavigationController alloc]initWithRootViewController:[SliderViewController sharedSliderController].mainVC];
    
    self.window.rootViewController = [SliderViewController sharedSliderController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
