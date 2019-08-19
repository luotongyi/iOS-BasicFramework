//
//  MineController.m
//  BasicFramework
//
//  Created by luoty on 2019/5/14.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MineController.h"

@interface MineController ()

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 250, 50, 50)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(poView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 150, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)pushView{
    [self.navigationController pushViewController:[MineController new] animated:YES];
}

- (void)poView{
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
