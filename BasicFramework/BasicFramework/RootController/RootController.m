//
//  RootController.m
//  BasicFramework
//
//  Created by luoty on 2019/5/14.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "RootController.h"
#import "MLTabBarController.h"

#import "HomeController.h"
#import "HomeDetailController.h"
#import "MineController.h"

@interface RootController ()
{
    MLTabBarController *tabController;
}

@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSplashImage];
}

- (void)initSplashImage{
    //启动图片处理
    
    
    //启动图片处理完了，加载tabBar
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initTabControllers];
    });
}

- (void)initTabControllers{
    if (tabController) {
        tabController = nil;
    }
    
    tabController = [MLTabBarController new];
    
    HomeController *home = [HomeController new];
    MLNavigationController *homeNav = [[MLNavigationController alloc]initWithRootViewController:home];
    
    HomeDetailController *homeDetail = [HomeDetailController new];
    MLNavigationController *homeDetailNav = [[MLNavigationController alloc]initWithRootViewController:homeDetail];
    
    MineController *mine = [MineController new];
    MLNavigationController *mineNav = [[MLNavigationController alloc]initWithRootViewController:mine];
    
    NSArray *controllers = @[homeNav,homeDetailNav,mineNav];
    NSArray *titles = @[@"首页",@"详情",@"我的"];
    NSArray *colors = @[UIColor.lightGrayColor,UIColor.lightGrayColor,UIColor.lightGrayColor];
    NSArray *selectedColors = @[UIColor.redColor,UIColor.purpleColor,UIColor.cyanColor];
    NSArray *images = @[@"icon_home_",@"icon_home_",@"icon_home_"];
    NSArray *selectedImages = @[@"icon_home_sign",@"icon_home_sign",@"icon_home_sign"];
    
    [tabController addControllers:controllers titles:titles colors:colors selectedColors:selectedColors images:images selectedImages:selectedImages];
    
    [self.view addSubview:tabController.view];
}


@end
