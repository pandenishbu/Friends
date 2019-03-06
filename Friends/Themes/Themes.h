//
//  UIButton+Themes.h
//  Friends
//
//  Created by Mary Milchenko on 03.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Themes : NSObject

@property (strong, nonatomic) UIColor *theme1;
@property (strong, nonatomic) UIColor *theme2;
@property (strong, nonatomic) UIColor *theme3;

- (id) initWithColor: (UIColor*)one andTwo:(UIColor*)two andThree:(UIColor*)three;

@end
