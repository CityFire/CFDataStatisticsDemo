//
//  HomeViewController.m
//  CFDataStatisticsDemo
//
//  Created by wjc on 16/11/3.
//  Copyright © 2016年 CityFire. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Home";
}

- (IBAction)FavouritePressed:(id)sender {
    
}

- (IBAction)SharePressed:(id)sender {
    
}

- (IBAction)DetailPressed:(id)sender {
    DetailViewController *detail = [DetailViewController new];
    detail.title = NSStringFromClass([DetailViewController class]);
    detail.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
