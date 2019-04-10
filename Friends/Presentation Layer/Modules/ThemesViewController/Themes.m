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

- (void)setTheme1:(UIColor *)theme1 {
    if (_theme1 != theme1) {
        [theme1 retain];
        [_theme1 release];
        
        _theme1 = theme1;
    }
}

- (void)setTheme2:(UIColor *)theme2 {
    if (_theme2 != theme2) {
        [theme2 retain];
        [_theme2 release];
        
        _theme2 = theme2;
    }
}

- (void)setTheme3:(UIColor *)theme3 {
    if (_theme3 != theme3) {
        [theme3 retain];
        [_theme3 release];
        
        _theme3 = theme3;
    }
}

-(UIColor*)theme1{
    return _theme1;
}

-(UIColor*)theme2{
    return _theme2;
}

-(UIColor*)theme3{
    return _theme3;
}


-(void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    
    [super dealloc];
}

@end
