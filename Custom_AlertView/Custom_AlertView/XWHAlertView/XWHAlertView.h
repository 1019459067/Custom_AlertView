//
//  XWHAlertView.h
//  Test_AlertView
//
//  Created by ST on 16/3/23.
//  Copyright © 2016年 xwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  关闭按钮的位置
 */
typedef NS_ENUM(NSInteger, ButtonPositionType) {
    ButtonPositionTypeNone = 0,
    ButtonPositionTypeLeft = 1 << 0,
    ButtonPositionTypeRight = 2 << 0
};
/**
 *  蒙板的背景色
 */
typedef NS_ENUM(NSInteger, ShadeBackgroundType) {
    ShadeBackgroundTypeGradient = 0,
    ShadeBackgroundTypeSolid = 1 << 0
};

typedef void(^completeBlock)(void);

@interface XWHAlertView : NSObject

@property (assign, nonatomic) BOOL tapOutsideToDismiss;//点击蒙板是否弹出视图消失
@property (assign, nonatomic) ShadeBackgroundType shadeBackgroundType;//蒙板的背景色 default is 0
@property (assign, nonatomic) ButtonPositionType closeButtonType;//关闭按钮的类型 default is 0

/**
 *  创建一个实例
 */
+ (XWHAlertView *)sharedInstance;

/**
 *  弹出要展示的View
 *
 *  @param presentView show view
 *  @param animated    是否动画
 */
- (void)showWithPresentView:(UIView *)viewShow animated:(BOOL)animated;

@end
