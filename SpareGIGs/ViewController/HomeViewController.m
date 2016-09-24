//
//  HomeViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "HomeViewController.h"

#import "ProfileViewController.h"
#import "ProvidedServiceViewController.h"
#import "SearchServiceViewController.h"
#import "HireHistoryViewController.h"
#import "FavoriteViewController.h"

#import "DataManager.h"

@interface HomeViewController ()<UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIView *viewSearch;
@property (nonatomic, weak) IBOutlet UITextField *txtSearch;

@property (nonatomic, weak) IBOutlet UIView *viewAdvise;
@property (nonatomic, weak) IBOutlet UIScrollView *svMain;

- (IBAction)onProfile:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onSearch:(id)sender;
- (IBAction)onMessageRoom:(id)sender;
- (IBAction)onFavoriteProviders:(id)sender;
- (IBAction)onServicesOffered:(id)sender;
- (IBAction)onOfferHistory:(id)sender;
- (IBAction)onHireHistory:(id)sender;

- (IBAction)onFeedback:(id)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.viewSearch.layer.cornerRadius = 5; // this value vary as per your desire
    self.viewSearch.clipsToBounds = YES;
    self.viewSearch.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewSearch.layer.borderWidth = 1.0f;
    
    self.viewAdvise.layer.cornerRadius = 5; // this value vary as per your desire
    self.viewAdvise.clipsToBounds = YES;
    self.viewAdvise.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewAdvise.layer.borderWidth = 1.0f;
    
    self.viewAdvise.hidden = YES;
    self.svMain.frame = CGRectMake(self.svMain.frame.origin.x,
                                   self.viewAdvise.frame.origin.y,
                                   self.svMain.frame.size.width,
                                   self.view.frame.size.height - self.viewAdvise.frame.origin.y - 60);
    self.svMain.contentSize = CGSizeMake(self.svMain.frame.size.width, 360);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkPreprocess];
}

- (void) checkPreprocess
{
    if(self.needToAddService) {
        self.needToAddService = NO;
        [self showProvidedServices:YES];
    } else if(self.needToSearchService) {
        self.needToSearchService = NO;
        [self showSearchServices:YES keyword:@""];
    }
}

- (IBAction)onMenu:(id)sender
{
    [self.txtSearch resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Logout", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)onProfile:(id)sender
{
    [self.txtSearch resignFirstResponder];
    
    [self gotoProfile];
}

- (IBAction)onSearch:(id)sender
{
    [self.txtSearch resignFirstResponder];
    
    [self showSearchServices:YES keyword:self.txtSearch.text];
}

- (IBAction)onMessageRoom:(id)sender
{
    [self gotoMessageRooms];
}

- (IBAction)onFavoriteProviders:(id)sender
{
    [self gotoFavoritesScreen];
}

- (IBAction)onServicesOffered:(id)sender
{
    [self showProvidedServices:YES];
}

- (IBAction)onOfferHistory:(id)sender
{
    [self showOfferHistoryScreen];
}

- (IBAction)onHireHistory:(id)sender
{
    [self showHireHisotryScreen];
}

- (IBAction)onFeedback:(id)sender
{
    [self.txtSearch resignFirstResponder];
    
    [self sendFeedback];
}

- (void) sendFeedback
{
    [self sendEmailWith:CONTACT_EMAIL subject:@"Feedback for SpareGIGS app" body:@""];
}

- (void)onLogout
{
    [[DataManager shareDataManager] logout];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onProvidedService
{
    [self showProvidedServices:YES];
}

- (void)onSearchServices
{
    [self showSearchServices:YES keyword:@""];
}

- (void) gotoProfile
{
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    vc._isFromHome = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) showProvidedServices:(BOOL)animation
{
    ProvidedServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProvidedServiceViewController"];
    
    [self.navigationController pushViewController:vc animated:animation];
}

- (void) showSearchServices:(BOOL)animation keyword:(NSString *)keyword
{
    [DataManager shareDataManager].searchFilterInfo.keyword = keyword;
    
    SearchServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchServiceViewController"];
    
    [self.navigationController pushViewController:vc animated:animation];
}

- (void) showHireHisotryScreen
{
    HireHistoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HireHistoryViewController"];
    vc.fromClient = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) showOfferHistoryScreen
{
    HireHistoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HireHistoryViewController"];
    vc.fromClient = NO;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) gotoFavoritesScreen
{
    FavoriteViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) gotoMessageRooms
{
    [self performSegueWithIdentifier:@"MessageRoom" sender:nil];
}

#pragma mark --UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self onSearch:nil];
    
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self onLogout];
    }
}

@end
