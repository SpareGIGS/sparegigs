//
//  AskSearchViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "AskSearchViewController.h"

@interface AskSearchViewController ()
{

}

@property (nonatomic, weak) IBOutlet UIButton *btnSearch;

- (IBAction)onSearch:(id)sender;
- (IBAction)onLater:(id)sender;

@end

@implementation AskSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.btnSearch.layer.cornerRadius = self.btnSearch.frame.size.height / 2; // this value vary as per your desire
    self.btnSearch.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (IBAction)onSearch:(id)sender
{
    [self gotoHome:YES];
}

- (IBAction)onLater:(id)sender
{
    [self gotoHome:NO];
}

- (void) gotoHome:(BOOL) needSearch
{
    [self performSegueWithIdentifier:@"Home" sender:nil];
}

@end
