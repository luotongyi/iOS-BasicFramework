//
//  MLTabBarController.h
//  BasicFramework
//
//  Created by luoty on 2019/5/20.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTabBar.h"

NS_ASSUME_NONNULL_BEGIN

///支持中间凸出的特殊按钮
@interface MLTabBarController : UITabBarController<MLTabBarDelegate>

@property (nonatomic, strong) MLTabBar *mlTabBar;

/// colors和selectedColors可为nil，使用默认颜色
- (void)addControllers:(NSArray<UIViewController *> *)controllers
                titles:(NSArray<NSString *> *)titles
                colors:(NSArray<UIColor *> *)colors
        selectedColors:(NSArray<UIColor *> *)selectedColors
                images:(NSArray<NSString *> *)images
        selectedImages:(NSArray<NSString *> *)selectedImages;

@end

NS_ASSUME_NONNULL_END
