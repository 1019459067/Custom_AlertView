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
    /**
     *  无
     */
    ButtonPositionTypeNone = 0,
    /**
     *  左上角
     */
    ButtonPositionTypeLeft = 1 << 0,
    /**
     *  右上角
     */
    ButtonPositionTypeRight = 2 << 0
};
/**
 *  蒙板的背景色
 */
typedef NS_ENUM(NSInteger, ShadeBackgroundType) {
    /**
     *  渐变色
     */
    ShadeBackgroundTypeGradient = 0,
    /**
     *  固定色
     */
    ShadeBackgroundTypeSolid = 1 << 0
};

typedef void(^completeBlock)(void);
@interface XWHAlertView : NSObject
@property (assign, nonatomic) BOOL tapOutsideToDismiss;//点击蒙板是否弹出视图消失
@property (assign, nonatomic) ShadeBackgroundType shadeBackgroundType;//蒙板的背景色
@property (assign, nonatomic) ButtonPositionType closeButtonType;//关闭按钮的类型

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
