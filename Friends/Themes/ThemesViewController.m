//
//  ThemesViewController.m
//  Friends
//
//  Created by Mary Milchenko on 03.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController () <ThemesViewControllerDelegate>

@end

@implementation ThemesViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *firstColor = [[UIColor alloc] initWithRed:249.0f/255.0f green:232.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    UIColor *secondColor = [[UIColor alloc] initWithRed:16.0f/255.0f green:8.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    UIColor *thirdColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:253.0f/255.0f blue:209.0f/255.0f alpha:1.0f];
    
    Themes *theme = [[Themes alloc] initWithColor:firstColor andTwo:secondColor andThree:thirdColor];
    [self setModel:theme];

    [theme release];
    
}

- (void)setModel:(Themes*)theme{
    if (_model != theme){
        [theme retain];
        [_model release];
        _model = theme;
    }
    
}

- (Themes*)theme {
    return _model;
}

- (IBAction)setTheme1:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme1];
    self.view.backgroundColor = _model.theme1;
    self.navigationController.navigationBar.barTintColor = _model.theme1;
}

- (IBAction)setTheme2:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme2];
    self.view.backgroundColor = _model.theme2;
    self.navigationController.navigationBar.barTintColor = _model.theme2;
}

- (IBAction)setTheme3:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme3];
    self.view.backgroundColor = _model.theme3;
    self.navigationController.navigationBar.barTintColor = _model.theme3;
}


- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [closeBarItem release];
    [button1 release];
    [button2 release];
    [button3 release];
    [_model release];
    [super dealloc];
}
@end
