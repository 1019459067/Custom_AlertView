//
//  XWHAlertView.m
//  Test_AlertView
//
//  Created by ST on 16/3/23.
//  Copyright © 2016年 xwh. All rights reserved.
//

#import "XWHAlertView.h"

//遮罩
@interface ShadeView : UIView

@end





/**
 *  自定义 VC
 */
@interface CustomViewControllor : UIViewController
@property (strong, nonatomic) ShadeView *viewShade;
@end

/**
 *  自定义 View
 */
@interface CustomView : UIView
@property (weak, nonatomic) CALayer *styleLayer;
//@property (strong, nonatomic) UIColor *popBackgroundColor;
@end

@interface XWHAlertView ()
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomViewControllor *customVC;
@property (strong, nonatomic) CustomView *customView;
@end
@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        CALayer *styleLayer = [[CALayer alloc] init];
        styleLayer.cornerRadius = 4;
        styleLayer.shadowColor= [[UIColor whiteColor] CGColor];
        styleLayer.shadowOffset = CGSizeMake(0, 0);
        styleLayer.shadowOpacity = 0.5;
        styleLayer.borderWidth = 1;
        styleLayer.borderColor = [[UIColor whiteColor] CGColor];
        styleLayer.frame = CGRectInset(self.bounds, 12, 12);
        [self.layer addSublayer:styleLayer];
        self.styleLayer = styleLayer;
    }
    return self;
}

//- (void)setPopBackgroundColor:(UIColor *)popBackgroundColor {
//    if(_popBackgroundColor != popBackgroundColor){
//        _popBackgroundColor = popBackgroundColor;
//        self.styleLayer.backgroundColor = [popBackgroundColor CGColor];
//    }
//}

@end

@implementation XWHAlertView

+ (XWHAlertView *)sharedInstance
{
    static XWHAlertView *xwhAlertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xwhAlertView = [[XWHAlertView alloc]init];
    });
    return xwhAlertView;
}
- (instancetype)init {
    if (self = [super init]) {
        self.tapOutsideToDismiss = YES;
    }
    return self;
}

- (void)showWithPresentView:(UIView *)viewShow animated:(BOOL)animated {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //add VC
    self.customVC = [[CustomViewControllor alloc]init];
    self.window.rootViewController = self.customVC;
    
    CGFloat padding = 15;
    //CGRectInset  将原来的矩形放大或者缩小，＋表示缩小；－表示放大
    CGRect rectContainer = CGRectInset(viewShow.bounds, -padding, -padding);
    //round() 舍入为最近的整数（四舍五入）
    rectContainer.origin.x = round(CGRectGetMidX(self.window.bounds) - CGRectGetMidX(rectContainer));
    rectContainer.origin.y = round(CGRectGetMidY(self.window.bounds) - CGRectGetMidY(rectContainer));
    
    //add view
    self.customView = [[CustomView alloc]initWithFrame:rectContainer];
    [self.customVC.view addSubview:self.customView];
    
    //add viewShow
    viewShow.frame = (CGRect){padding,padding,viewShow.bounds.size};
    [self.customView addSubview:viewShow];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window makeKeyAndVisible];
    });
}
- (void)hideAnimated:(BOOL)animated withCompletionBlock:(void(^)())completion
{
    [self cleanup];
//    if(!animated){
//        [self cleanup];
//        return;
//    }

}
- (void)cleanup
{
    [self.customView removeFromSuperview];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    [self.customVC.viewShade removeFromSuperview];
    [self.customVC removeFromParentViewController];
    [self.window removeFromSuperview];
    self.window = nil;
}

@end





#pragma mark - 遮罩 implementation

@implementation ShadeView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([XWHAlertView sharedInstance].shadeBackgroundType == ShadeBackgroundTypeSolid)
    {
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    }
    else
    {
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([XWHAlertView sharedInstance].tapOutsideToDismiss) {
        [[XWHAlertView sharedInstance] hideAnimated:YES withCompletionBlock:nil];
    }
}

@end




#pragma mark - 自定义VC implementation

@implementation CustomViewControllor

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.viewShade = [[ShadeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    self.viewShade.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.viewShade.opaque = NO;
    [self.view addSubview:self.viewShade];
}
@end
