//
//  ViewController.m
//  FMEditor
//
//  Created by mc on 16/7/28.
//  Copyright © 2016年 Scorpion. All rights reserved.
//

#import "ViewController.h"
#import "XZPostMainViewController.h"

@interface ViewController () <XZPostMainViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    CGFloat btnW = 60.f;
    
    button.frame = CGRectMake((self.view.frame.size.width - btnW)/2, (self.view.frame.size.height - btnW)/2, btnW, btnW);
    
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(addButonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addButonClick {
    
    XZPostMainViewController *viewC = [[XZPostMainViewController alloc]init];
    viewC.arrayDataDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - XZPostMainViewControllerDelegate
- (void)returnBackSizeArray:(NSArray *)sizeAray imageArray:(NSArray *)imageArray title:(NSString *)title {
    NSLog(@"%@", sizeAray);
    NSLog(@"%@", imageArray);
    NSLog(@"%@", title);
}

@end
