//
//  XWHAlertView.m
//  Test_AlertView
//
//  Created by ST on 16/3/23.
//  Copyright © 2016年 xwh. All rights reserved.
//

#import "XWHAlertView.h"

static CGFloat const kDefaultCloseButtonPadding = 15.0f;

static NSTimeInterval const kFadeInAnimationDuration = 0.5;
static NSTimeInterval const kTransformPart1AnimationDuration = 0.25;
static NSTimeInterval const kTransformPart2AnimationDuration = 0.38;

/**
 * 遮罩
 */
@interface ShadeView : UIView

@end

/**
 *  自定义的button
 */
@interface CloseButton : UIButton

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
@property (strong, nonatomic) CloseButton *btnClose;
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
        self.bTapOutsideToDismiss = YES;
    }
    return self;
}

- (void)setCloseButtonType:(ButtonPositionType)closeButtonType
{
    _closeButtonType = closeButtonType;
    if (closeButtonType == ButtonPositionTypeNone) {
        [self.btnClose setHidden:YES];
    } else {
        [self.btnClose setHidden:NO];
        
        CGRect closeFrame = self.btnClose.frame;
        if(closeButtonType == ButtonPositionTypeRight){
            
            closeFrame.origin.x = round(CGRectGetWidth(self.customView.frame) - kDefaultCloseButtonPadding - CGRectGetWidth(closeFrame)/2);
        } else {
            closeFrame.origin.x = 0;
        }
        self.btnClose.frame = closeFrame;
    }
}
- (void)setBTapOutsideToDismiss:(BOOL)bTapOutsideToDismiss {
    _bTapOutsideToDismiss = bTapOutsideToDismiss;
}
- (void)showWithPresentView:(UIView *)viewShow animated:(AnimationType)animationType {
    
    _animationType = animationType;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //add VC
    self.customVC = [[CustomViewControllor alloc]init];
    self.window.rootViewController = self.customVC;
    
    // padding  值不同可能 viewShow 位置不居中
    CGFloat padding = 0;
    
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
//    NSLog(@"viewShow1 = %@",NSStringFromCGRect(viewShow.frame));
//
//    self.customView.backgroundColor = [UIColor greenColor];
//    NSLog(@"viewShow2 = %@",NSStringFromCGRect(self.customView.frame));

    //add close button
    self.btnClose = [[CloseButton alloc]init];
    [self.btnClose addTarget:self action:@selector(onActionClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.customView addSubview:self.btnClose];
    [self setCloseButtonType:self.closeButtonType];

    
        [self.window makeKeyAndVisible];
        switch (animationType) {
            case animationTypeNone:
                break;
            case animationTypeWave:
            {
                self.customVC.viewShade.alpha = 0;
                [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                    self.customVC.viewShade.alpha = 1;
                }];
                self.customView.alpha = 0;
                self.customView.layer.shouldRasterize = YES;
                self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
                [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                    self.customView.alpha = 1;
                    self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.25 animations:^{
                        self.customView.alpha = 0.5;
                        self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.customView.alpha = 1;
                            self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                        } completion:^(BOOL finished2) {
                            self.customView.layer.shouldRasterize = NO;
                        }];
                        
                    }];
                }];
            }
            case animationTypeZoom:
            {
                self.customVC.viewShade.alpha = 0;
                self.customView.alpha = 0.2;
                self.customView.layer.shouldRasterize = YES;
                self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
                [UIView animateWithDuration:0.38 animations:^{
                    self.customVC.viewShade.alpha = 1;
                    self.customView.alpha = 1;
                    self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                }];
            }
                break;
            default:
                break;
        }
}
- (void)resetViewsFrameWith:(CGSize)size {
    NSLog(@"viewShow = %@,%@",NSStringFromCGRect(self.customView.frame),NSStringFromCGSize(size));
}
- (void)onActionClose:(CloseButton *)sender
{
    [self hideWithCompletionBlock:nil];
}

- (void)hideWithCompletionBlock:(void(^)())completion
{
    AnimationType animationTemp = self.animationType;
    switch (animationTemp) {
        case animationTypeNone:
            [self cleanup];
            break;
        case animationTypeWave:
        {
            self.customVC.viewShade.alpha = 1;
            self.customView.alpha = 1;
            self.customView.layer.shouldRasterize = YES;
            self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                self.customView.alpha = 0.75;
                self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.25 animations:^{
                    self.customView.alpha = 1;
                    self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.25, 1.25);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.customView.alpha = 1;
                        self.customVC.viewShade.alpha = 0.3;
                        self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                    } completion:^(BOOL finished2) {
                        self.customView.layer.shouldRasterize = NO;
                        [self cleanup];
                        if(completion){
                            completion();
                        }
                    }];
                    
                }];
            }];
        }
            break;
        case animationTypeZoom:
        {
            self.customVC.viewShade.alpha = 1;
            self.customView.alpha = 1;
            self.customView.layer.shouldRasterize = YES;
            self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            [UIView animateWithDuration:0.25 animations:^{
                self.customVC.viewShade.alpha = 0.3;
                self.customView.alpha = 0.3;
                self.customView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.25, 0.25);
            } completion:^(BOOL finished) {
                [self cleanup];
                if(completion){
                    completion();
                }
            }];
        }
            break;
        default:
            break;
    }

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





@implementation CloseButton

- (instancetype)init {
    if (self = [super initWithFrame:(CGRect){0, 0, 32, 32}]) {
        [self setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    }
    return self;
}
@end


#pragma mark - 遮罩 implementation

@implementation ShadeView

- (void)drawRect:(CGRect)rect {
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
    if ([XWHAlertView sharedInstance].bTapOutsideToDismiss) {
        [[XWHAlertView sharedInstance] hideWithCompletionBlock:nil];
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
    
    self.viewShade = [[ShadeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.viewShade.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.viewShade.opaque = NO;
    [self.view addSubview:self.viewShade];
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;

}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [[XWHAlertView sharedInstance] resetViewsFrameWith:size];
}
@end
