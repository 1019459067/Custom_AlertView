//
//  ViewController.m
//  Custom_AlertView
//
//  Created by ST on 16/3/23.
//  Copyright © 2016年 xwh. All rights reserved.
//

#import "ViewController.h"
#import "XWHAlertView.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    self.contentView.backgroundColor = [UIColor redColor];

}
- (IBAction)onAction:(id)sender {

    [[XWHAlertView sharedInstance] showWithPresentView:_contentView animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
