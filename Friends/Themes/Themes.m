//
//  Themes.m
//  Friends
//
//  Created by Mary Milchenko on 05.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Themes.h"

@implementation Themes

- (id)initWithColor:(UIColor *)one andTwo:(UIColor *)two andThree:(UIColor *)three
{
    self = [super init];
    if (self) {
        _theme1 = one;
        _theme2 = two;
        _theme3 = three;
    }
    return self;
}

@end
