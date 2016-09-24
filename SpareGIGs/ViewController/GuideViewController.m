//
//  GuideViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "GuideViewController.h"

#import "DataManager.h"
#import "UserInfo.h"

@interface GuideViewController ()
{
    BOOL _isLoaded;
}

- (IBAction)onMakeMoney:(id)sender;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (IBAction)onMakeMoney:(id)sender
{
    [self gotoMakeMoney];
}


- (void) showGuide
{
    
}

- (void) gotoMakeMoney
{
    [self performSegueWithIdentifier:@"MakeMoney"  sender:nil];
}

@end
