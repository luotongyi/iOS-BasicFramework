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
    
    UIView *aa = [[UIView alloc]initWithFrame:CGRectMake(10, 90, 50, 50)];
    aa.backgroundColor = [UIColor blueColor];
    [self.view addSubview:aa];
    
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
