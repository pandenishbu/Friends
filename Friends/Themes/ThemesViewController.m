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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *firstColor = [[UIColor alloc] initWithRed:230.0f/255.0f green:209.0f/255.0f blue:223.0f/255.0f alpha:1.0f];
    UIColor *secondColor = [[UIColor alloc] initWithRed:207.0f/255.0f green:222.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    UIColor *thirdColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:253.0f/255.0f blue:209.0f/255.0f alpha:1.0f];
    
    Themes *theme = [[Themes alloc] initWithColor:firstColor andTwo:secondColor andThree:thirdColor];
    [self setModel:theme];

    [theme release];
    
    button1.backgroundColor = _model.theme1;
    button2.backgroundColor = _model.theme2;
    button3.backgroundColor = _model.theme3;
    
    
}

- (void)setModel:(Themes *)model{
    if (_model != model){
        [model retain];
        [_model release];
        _model = model;
    }
    
}

- (Themes*)model {
    return _model;
}

-(void)setDelegate:(id<ThemesViewControllerDelegate>)delegate{
    _delegate = delegate;
}

- (id<ThemesViewControllerDelegate>)delegate {
    return _delegate;
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
