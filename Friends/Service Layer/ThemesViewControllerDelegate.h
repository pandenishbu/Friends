//
//  ThemesViewControllerDelegate.h
//  Friends
//
//  Created by Mary Milchenko on 03.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ThemesViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ThemesViewControllerDelegate <NSObject>
@optional
    - (void)themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end

NS_ASSUME_NONNULL_END
