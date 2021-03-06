//
//  ThemesViewController.h
//  Friends
//
//  Created by Mary Milchenko on 03.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemesViewController : UIViewController {
    id <ThemesViewControllerDelegate> _delegate;
    Themes *_model;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    IBOutlet UIBarButtonItem *closeBarItem;
}

@property (nonatomic, assign)  id <ThemesViewControllerDelegate> delegate;
@property (nonatomic, retain)  Themes *model;

@end

NS_ASSUME_NONNULL_END

