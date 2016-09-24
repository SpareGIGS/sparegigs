//
//  MakeMoneyViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MakeMoneyViewController.h"

#import "HomeViewController.h"
#import "DataManager.h"

#import <QuartzCore/QuartzCore.h>

@interface MakeMoneyViewController ()

@property (nonatomic, weak) IBOutlet UIButton *btnYes;
@property (nonatomic, weak) IBOutlet UIButton *btnSkip;

- (IBAction)onAskSearch:(id)sender;
- (IBAction)onHome:(id)sender;

@end

@implementation MakeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.btnYes.layer.cornerRadius = self.btnYes.frame.size.height / 2; // this value vary as per your desire
    self.btnYes.clipsToBounds = YES;
    
    self.btnSkip.layer.cornerRadius = self.btnYes.frame.size.height / 2; // this value vary as per your desire
    self.btnSkip.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[DataManager shareDataManager] passedMakeMoney];
}

- (IBAction)onAskSearch:(id)sender
{
    [self gotoAskSearch];
}

- (IBAction)onHome:(id)sender
{
    [self gotoHome];
}

- (void) gotoAskSearch
{
    [self performSegueWithIdentifier:@"AskSearch" sender:nil];
}

- (void) gotoHome
{
    HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    vc.needToAddService = YES;
    
    [self.navigationController pushViewController:vc animated:NO];
}

@end
