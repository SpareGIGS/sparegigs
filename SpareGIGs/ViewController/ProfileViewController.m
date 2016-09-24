//
//  ProfileViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "ProfileViewController.h"

#import "VerificationViewController.h"

#import "DataManager.h"

#import "ConnectionUtils.h"

#import <MapKit/MapKit.h>

#import "AppDelegate.h"

#import "MNMRemoteImageView.h"

@interface ProfileViewController ()<SDKProtocol, VerificationDelegate, UIActionSheetDelegate>
{
    UserInfo *_user;
    
    UserInfo *_updatingUser;
}

@property (nonatomic, weak) IBOutlet UITextField *txtUsername;
@property (nonatomic, weak) IBOutlet UILabel *lblAddress;

@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtLocation;
@property (nonatomic, weak) IBOutlet UITextField *txtPhoneNumber;
@property (nonatomic, weak) IBOutlet UITextField *txtBusinessNumber;

@property (nonatomic, weak) IBOutlet UIView *viewProfile;
@property (nonatomic, weak) IBOutlet MNMRemoteImageView *ivProfile;

@property (nonatomic, weak) IBOutlet UIButton *btnBack;
@property (nonatomic, weak) IBOutlet UIButton *btnMakeMoney;

@property (nonatomic, weak) IBOutlet UIButton *btnVerify;

@property (nonatomic, weak) IBOutlet UIScrollView *svMain;
@property (nonatomic, weak) IBOutlet UIView *viewChangePassword;
@property (nonatomic, weak) IBOutlet UIButton *btnChangePassword;
@property (nonatomic, weak) IBOutlet UIView *viewMainInfo;

@property (nonatomic, weak) IBOutlet UIView *viewMap;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

- (IBAction)onBack:(id)sender;

- (IBAction)onUpdate:(id)sender;

- (IBAction)onLogout:(id)sender;
- (IBAction)onNext:(id)sender;

- (IBAction)onVerify:(id)sender;

- (IBAction)onChangePassword:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.viewProfile.layer.cornerRadius = self.viewProfile.frame.size.height / 2; // this value vary as per your desire
    self.viewProfile.clipsToBounds = YES;
    
    self.ivProfile.layer.cornerRadius = self.ivProfile.frame.size.height / 2; // this value vary as per your desire
    self.ivProfile.clipsToBounds = YES;
    
    self.viewMap.hidden = YES;
    self.viewMap.alpha = 0.0f;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    self.svMain.contentSize = CGSizeMake(self.svMain.frame.size.width, 310);
    self.viewChangePassword.frame = CGRectMake(self.viewChangePassword.frame.origin.x,
                                               self.viewChangePassword.frame.origin.y,
                                               self.svMain.frame.size.width,
                                               self.viewChangePassword.frame.size.height);
    
    self.viewMainInfo.frame = CGRectMake(self.viewMainInfo.frame.origin.x,
                                               self.viewMainInfo.frame.origin.y,
                                               self.svMain.frame.size.width - self.viewMainInfo.frame.origin.x * 2,
                                               self.viewMainInfo.frame.size.height);
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLocationFromMap)];
    [self.viewMap addGestureRecognizer:tapGesture1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.viewChangePassword.frame = CGRectMake(self.viewChangePassword.frame.origin.x,
                                               self.viewChangePassword.frame.origin.y,
                                               self.svMain.frame.size.width,
                                               self.viewChangePassword.frame.size.height);
    
    self.viewMainInfo.frame = CGRectMake(self.viewMainInfo.frame.origin.x,
                                               self.viewMainInfo.frame.origin.y,
                                               self.svMain.frame.size.width - 2 * self.viewMainInfo.frame.origin.x,
                                               self.viewMainInfo.frame.size.height);
    
    if(self._isFromHome) {
        self.btnBack.hidden = NO;
        self.btnMakeMoney.hidden = YES;
    } else {
        self.btnBack.hidden = YES;
        self.btnMakeMoney.hidden = NO;
    }
    
    self.btnVerify.hidden = YES;
    
    NSString *userid = [DataManager shareDataManager].user.userid;
    [self reqUser:userid];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void) loadUserInfo
{
    if([DataManager NSStringIsValidEmail:_user.email]) {
        self.txtEmail.text = _user.email;
        self.txtEmail.enabled = NO;
        self.btnVerify.hidden = YES;
    } else {
        self.txtEmail.text = @"";
        self.txtEmail.enabled = YES;
        self.btnVerify.hidden = NO;
    }
    
    [self.ivProfile displayImageFromURL:_user.profile completionHandler:nil];
    
    self.txtUsername.text = _user.username;
    
    self.txtLocation.text = _user.location;
    self.txtPhoneNumber.text = _user.phone;
    self.txtBusinessNumber.text = _user.businessphone;
    
    [self showAddressFromLocation:_user.location];
    
    if(_user.username == nil || _user.username.length == 0) {
        [self.txtUsername becomeFirstResponder];
    }
    
    self.btnChangePassword.hidden = (_user.socialType != 0);
}

- (void) showAddressFromLocation:(NSString *)location
{
    if(location.length == 0) {
        self.lblAddress.text = @"Not selected yet.";
    } else {
        NSArray *positions = [location componentsSeparatedByString:@","];
        
        if(positions.count != 2) {
            self.lblAddress.text = @"Not selected yet.";
        } else {
            
            self.lblAddress.text = @"Loading...";
            
            double lat = [[positions objectAtIndex:0] doubleValue];
            double lng = [[positions objectAtIndex:1] doubleValue];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            [DataManager getAddressWithLocation:location label:self.lblAddress];
        }
    }
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onUpdate:(id)sender
{
    [self hideKeyboard];
    
    if(_user == nil) {
        
        [self showAlert:APP_NAME withMsg:@"There is not user information. Please go back."];
        return;
    }
    
    if(![DataManager NSStringIsValidEmail:_user.email]) {
        
        [self showAlert:APP_NAME withMsg:@"Please verify your email address first."];
        
        return;
    }
    
    NSString *username = self.txtUsername.text;
    NSString *email = self.txtEmail.text;
    NSString *location = self.txtLocation.text;
    NSString *phone = self.txtPhoneNumber.text;
    NSString *businessphone = self.txtBusinessNumber.text;
    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    location = [location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    businessphone = [businessphone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(username.length == 0) {
        
        [self showAlert:APP_NAME withMsg:@"Please input your name."];
        
        return ;
    }
    
    if(location.length == 0) {
        
        [self showAlert:APP_NAME withMsg:@"Please select your location for service."];
        
        return ;
    }
    
    if(phone.length == 0) {
        
        [self showAlert:APP_NAME withMsg:@"Please select your phone number."];
        
        return ;
    }
    
    if(![DataManager NSStringIsValidEmail:email]) {
        
        [self showAlert:APP_NAME withMsg:@"Please input a valid email"];
        
        return ;
    }
    
    UserInfo *user = [[UserInfo alloc] init];
    user.userid = _user.userid;
    user.username = username;
    user.email = email;
    user.location = location;
    user.phone = phone;
    user.businessphone = businessphone;
    
    [self reqUdateUser:user];
}

- (IBAction)onLogout:(id)sender
{
    [self hideKeyboard];
    
    [[DataManager shareDataManager] logout];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onNext:(id)sender
{
    [self hideKeyboard];
    
    if(_user == nil) {
        
        [self showAlert:APP_NAME withMsg:@"There is not user information. Please go back."];
        return;
    }
    
    if(![DataManager NSStringIsValidEmail:_user.email]) {
        
        [self showAlert:APP_NAME withMsg:@"Please input your vaild email address."];
        
        return;
    }
    
    [self gotoGuide];
}

- (IBAction)onVerify:(id)sender
{
    [self hideKeyboard];
    
    if(_user == nil) {
        
        [self showAlert:APP_NAME withMsg:@"There is not user information. Please go back."];
        return;
    }
    
    [self reqVerify];
}

- (void) onChangePassword:(id)sender
{
    [self performSegueWithIdentifier:@"ChangePassword" sender:nil];
}

- (void) gotoGuide
{
    [self performSegueWithIdentifier:@"Guide" sender:nil];
}

- (void) reqVerify
{
    NSString *email = self.txtEmail.text;
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(![DataManager NSStringIsValidEmail:email]) {
        
        [self showAlert:APP_NAME withMsg:@"Please input your vaild email address."];
        
        return;
    }
    
    [self startActivityAnimation];
    
    self.reqType = 2;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils reqVerifyEmail:_user.userid withEmail:email];
}

- (void) gotoVerify
{
    NSString *email = self.txtEmail.text;
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    VerificationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VerificationViewController"];
    vc.delegate = self;
    vc.email = email;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) reqUser:(NSString *)userid
{
    [self startActivityAnimation];
    
    self.reqType = 0;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils reqUserInfo:userid];
}

- (void) gotUser:(UserInfo *)user
{
    _user = user;
    
    [self runUIProcess:@selector(loadUserInfo)];
}

- (void) reqUdateUser:(UserInfo *)user
{
    [self startActivityAnimation];
    
    self.reqType = 1;
    
    _updatingUser = user;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils reqUpdateUserInfo:user];
}

- (void) completeUpdateUser
{
    _user = _updatingUser;
    
    [self runUIProcess:@selector(loadUserInfo)];
    
    [[DataManager shareDataManager] updateUser:_user];
    
    [self showAlert:APP_NAME withMsg:@"Updated your informations."];
}

- (void) hideKeyboard
{
    [self animationMainView:NO];
    
    [self.txtUsername resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtLocation resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    [self.txtBusinessNumber resignFirstResponder];
}

- (void) animationMainView:(BOOL) isTop
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.svMain.frame = CGRectMake(0, 302 - (isTop ? 216 : 0), self.view.frame.size.width, self.svMain.frame.size.height);
    //[UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
    //animate off screen
    [UIView commitAnimations];
}

#pragma mark -Select Location

- (void) onLocation
{
    [self hideKeyboard];
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Select a location from"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Current Position"
                                                    otherButtonTitles:@"Map", nil];
    
    [actionsheet showInView:self.view];
}

- (void) selectCurrentPosition
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.txtLocation.text = [delegate getCurrentPosition];
    
    [self showAddressFromLocation:self.txtLocation.text];
}

- (void) selectFromMap
{
    [self showMapView];
}

- (void) showMapView
{
    self.viewMap.hidden = NO;
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewMap.alpha = 1.0f;
    [UIView setAnimationDidStopSelector:@selector(finishShowMapView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) finishShowMapView
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(delegate.currentLocation != nil) {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = delegate.currentLocation.coordinate;
        [self.mapView setRegion:region animated:YES];
    }
}

- (void) hideMapView
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewMap.alpha = 0.0f;
    [UIView setAnimationDidStopSelector:@selector(finishHideMapView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) finishHideMapView
{
    self.viewMap.hidden = YES;
}

- (void) selectLocationFromMap
{
    [self hideMapView];
    
    NSString *location = [NSString stringWithFormat:@"%+.6f,%+.6f", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude];
    self.txtLocation.text = location;
    
    [self showAddressFromLocation:location];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self selectCurrentPosition];
    } else if(buttonIndex == 1) {
        [self selectFromMap];
    }
}

#pragma mark --VerificationDelegate

- (void)verified:(UserInfo *)user
{

}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtLocation) {
        [self onLocation];
        return false;
    } else if(textField != self.txtUsername) {
        [self animationMainView:YES];
    }
    
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //[self updateIcons];
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.txtUsername) {
        [textField resignFirstResponder];
    } else if(textField == self.txtPhoneNumber) {
        [self.txtBusinessNumber becomeFirstResponder];
    } else if(textField == self.txtBusinessNumber) {
        if(self.txtEmail.enabled) {
            [self.txtEmail becomeFirstResponder];
        } else {
            [self animationMainView:NO];
            [textField resignFirstResponder];
        }
    } else if(textField == self.txtEmail) {
        
        [self animationMainView:NO];
        [textField resignFirstResponder];
    }
    
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];
    
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    
    if(success) {
        
        NSObject *data = [res objectForKey:@"data"];
        
        if(self.reqType == 0) { // get user info
            NSDictionary *userdata = [(NSArray *)data objectAtIndex:0];
            UserInfo *user = [[UserInfo alloc] initWithDictionary:userdata];
            
            [self gotUser:user];
        } else  if(self.reqType == 1) { // update user
            [self runUIProcess:@selector(completeUpdateUser)];
        } else if(self.reqType == 2) { // req verify
            [self runUIProcess:@selector(gotoVerify)];
        }
        
    } else {
        NSDictionary *data = [res objectForKey:@"data"];
        NSString *errorMsg = [data objectForKey:@"msg"];
        [self showAlert:APP_NAME withMsg:errorMsg];
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    [self showAlert:APP_NAME withMsg:@"Failed to register. please check your network."];
}

@end
