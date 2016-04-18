//
//  ViewController.m
//  Custom_AlertView
//
//  Created by ST on 16/3/23.
//  Copyright © 2016年 xwh. All rights reserved.
//

#import "ViewController.h"
#import "XWHAlertView.h"
#import "MyView.h"
@interface ViewController ()

@property (strong, nonatomic) MyView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.contentView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
//    self.contentView.backgroundColor = [UIColor greenColor];
    self.contentView.strName = @"1019459067";
    self.contentView.strPW = @"深南大道";
    self.contentView.image = [UIImage imageNamed:@"20141108162654_xthYT.jpg"];
}
- (IBAction)onAction:(id)sender {

    [XWHAlertView sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[XWHAlertView sharedInstance] showWithPresentView:_contentView animated:animationTypeZoom];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
