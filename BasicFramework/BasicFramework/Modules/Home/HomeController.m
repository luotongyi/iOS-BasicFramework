//
//  HomeController.m
//  BasicFramework
//
//  Created by luoty on 2019/5/14.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "HomeController.h"
#import "MineController.h"
#import "HomeDetailController.h"

#import "MLTabBar.h"

#import "MLAFHTTPRequest.h"
#import "SVProgressHUD.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navBar.navBarHidden  = YES;
    self.navBar.navBackgroundColor = UIColor.orangeColor;
    self.navBar.navTitle = @"首页";
//    self.navBar.navAlpha = .5f;
    self.navBar.navBackgroundImage = [UIImage imageNamed:@"titleBgX"];
    
    UIView *aa = [[UIView alloc]initWithFrame:CGRectMake(10, self.navBar.baseViewY-20, 50, 50)];
    aa.backgroundColor = [UIColor blueColor];
    [self.view addSubview:aa];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 150, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 250, 50, 50)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(pushView1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"push1" style:(UIBarButtonItemStylePlain) target:self action:@selector(pushView1)];
    self.navigationItem.rightBarButtonItem=item;

    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"push2" style:(UIBarButtonItemStylePlain) target:self action:@selector(pushView)];

    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"push3" style:(UIBarButtonItemStylePlain) target:self action:@selector(pushView)];

    self.navigationItem.leftBarButtonItems = @[item1,item2];
    
    MLNavBarItem *btn2 = [MLNavBarItem new];
    [btn2 setItemHandler:^{
        NSLog(@"2222");
    }];
    btn2.itemTitle = @"11";
//    [btn2 setTitle:@"11" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    
    MLNavBarItem *btn3 = [MLNavBarItem new];
    [btn3 setItemHandler:^{
        NSLog(@"33333");
    }];
    [btn3 setTitle:@"22" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor blueColor];
    
    MLNavBarItem *btn4 = [MLNavBarItem new];
    [btn4 setItemHandler:^{
        NSLog(@"44444");
    }];
    [btn4 setTitle:@"33" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor redColor];
    
    MLNavBarItem *btn5 = [MLNavBarItem new];
    [btn5 setItemHandler:^{
        NSLog(@"55555");
    }];
    [btn5 setTitle:@"44" forState:UIControlStateNormal];
    btn5.backgroundColor = [UIColor blueColor];
    
    [self testReqeust];
}

- (void)testReqeust{
 
    
    
}

- (void)pushView{
    [self.navigationController pushViewController:[HomeController new] animated:YES];
}

- (void)pushView1{
    [self.navigationController pushViewController:[HomeDetailController new] animated:YES];
}

-(void)popView1{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
