//
//  MyView.m
//  AlertView_Custom
//
//  Created by ST on 16/4/18.
//  Copyright © 2016年 xwh. All rights reserved.
//

#import "MyView.h"

@interface MyView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *labelName;
@property (strong, nonatomic) UILabel *labelPW;
@end

@implementation MyView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.labelName = [[UILabel alloc]init];
    [self addSubview:self.labelName];
    self.labelName.backgroundColor = [UIColor redColor];
    
    self.labelPW = [[UILabel alloc]init];
    [self addSubview:self.labelPW];
    self.labelPW.backgroundColor = [UIColor yellowColor];

    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    self.imageView.backgroundColor = [UIColor greenColor];

    float fLabelNameH = 20;
    float fLabelNameW = self.frame.size.width;
    
    self.labelName.frame = CGRectMake(0, 0, fLabelNameW, fLabelNameH);
    self.labelPW.frame = CGRectMake(0, fLabelNameH, fLabelNameW, fLabelNameH);
    self.imageView.frame = CGRectMake(0, fLabelNameH+fLabelNameH, fLabelNameW, self.frame.size.height-(fLabelNameH*2));
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}
- (void)setStrName:(NSString *)strName {
    _strName = strName;
    self.labelName.text = [NSString stringWithFormat:@"帳戶名:%@",strName];
}
- (void)setStrPW:(NSString *)strPW {
    _strPW = strPW;
    self.labelPW.text = [NSString stringWithFormat:@"密  碼:%@",strPW];
}

@end
