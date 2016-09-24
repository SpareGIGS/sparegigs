//
//  SignUpViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "VerificationViewController.h"

#import "AppDelegate.h"

#import "DataManager.h"

#import "ConnectionUtils.h"

#import <MapKit/MapKit.h>


@interface SignUpViewController ()<SDKProtocol, VerificationDelegate, UIActionSheetDelegate>
{
    BOOL _isAcceptedTerm;
    
    UserInfo *_registerUser;
    UserInfo *_verifiedUser;
}

@property (nonatomic, weak) IBOutlet UIView *mainView;

@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtPwd;
@property (nonatomic, weak) IBOutlet UITextField *txtPhoneNumber;
@property (nonatomic, weak) IBOutlet UITextField *txtLocation;

@property (nonatomic, weak) IBOutlet UIImageView *ivEmail;
@property (nonatomic, weak) IBOutlet UIImageView *ivPwd;
@property (nonatomic, weak) IBOutlet UIImageView *ivZip;
@property (nonatomic, weak) IBOutlet UIImageView *ivPhoneNumber;

@property (nonatomic, weak) IBOutlet UIButton *btnTerm;

@property (nonatomic, weak) IBOutlet UIView *viewMap;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onSignUp:(id)sender;
- (IBAction)onSignIn:(id)sender;

- (IBAction)onFacebook:(id)sender;
- (IBAction)onTwitter:(id)sender;
- (IBAction)onGoogle:(id)sender;

- (IBAction)onAcceptTerm:(id)sender;
- (IBAction)onOpenTerm:(id)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _isAcceptedTerm = false;
    
    self.viewMap.hidden = YES;
    self.viewMap.alpha = 0.0f;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainView)];
    [self.mainView addGestureRecognizer:tapGesture];
    
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
    
    if(_verifiedUser != nil) {
        [[DataManager shareDataManager] login:_verifiedUser];
        [self runUIProcess:@selector(gotoProfile)];
    }
}

- (IBAction)onBack:(id)sender
{
    [self tapMainView];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender
{
    [self tapMainView];
}

- (IBAction)onSignUp:(id)sender
{
    [self tapMainView];
    
    NSString *email = self.txtEmail.text;
    NSString *pwd = self.txtPwd.text;
    NSString *phone = self.txtPhoneNumber.text;
    NSString *location = self.txtLocation.text;
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pwd = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    location = [location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(email.length == 0 || pwd.length == 0 || location.length == 0 || phone.length == 0) {
        
        [self showAlert:APP_NAME withMsg:@"Please add a valid acount"];
        
        return ;
    }
    
    if(![DataManager NSStringIsValidEmail:email]) {
        
        [self showAlert:APP_NAME withMsg:@"Please input a valid email"];
        
        return ;
    }
    
    if(pwd.length < PWD_MIN_LENGTH) {
        
        [self showAlert:APP_NAME withMsg:@"Please input a valid password. Password has to include at least 3 charactors."];
        
        return ;
    }
    
    if(!_isAcceptedTerm) {
        
        [self showAlert:APP_NAME withMsg:@"Please read Terms and Conditions, and accept it."];
        
        return ;
    }
    
    UserInfo *user = [[UserInfo alloc] init];
    user.email = email;
    user.pwd = pwd;
    user.location = location;
    user.phone = phone;
    
    [self reqSignup:user];
}

- (IBAction)onSignIn:(id)sender
{
    [self tapMainView];
    
    [self onBack:nil];
}

- (IBAction)onFacebook:(id)sender
{
    [self tapMainView];
    
    [self loginToFacebook];
}

- (IBAction)onTwitter:(id)sender
{
    [self tapMainView];
    
    [self loginToTwitter];
}

- (IBAction)onGoogle:(id)sender
{
    [self tapMainView];
    
    [self loginToGoogle];
}

- (IBAction)onAcceptTerm:(id)sender
{
    _isAcceptedTerm = !_isAcceptedTerm;
    
    if(_isAcceptedTerm) {
        [self.btnTerm setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
    } else {
        [self.btnTerm setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    }
}

- (IBAction)onOpenTerm:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.com"]];
}

- (void) reqSignup:(UserInfo *)user
{
    [self startActivityAnimation];
    
    _registerUser = user;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils registerUser:user];
}

- (void) successRegister
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:@"Please verify your email. you will get a code via your email address."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self runUIProcess:@selector(gotoVerify)];
                             
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) successLoginWithSocial:(UserInfo *)user
{
    [[DataManager shareDataManager] login:user];
    
    if([user isCompleted]) {
        if([[DataManager shareDataManager] isPassedMakeMoney]) {
            [self gotoHome];
        } else {
            [self gotoMakeMoney];
        }
    } else {
        [self gotoProfile];
    }
}

- (void) gotoVerify
{
    VerificationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VerificationViewController"];
    vc.delegate = self;
    vc.email = _registerUser.email;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) gotoProfile
{
    [self performSegueWithIdentifier:@"Profile" sender:nil];
}

- (void) gotoMakeMoney
{
    [self performSegueWithIdentifier:@"MakeMoney" sender:nil];
}

- (void) gotoHome
{
    [self performSegueWithIdentifier:@"Home" sender:nil];
}

- (void) updateIcons
{
    NSString *email = self.txtEmail.text;
    NSString *pwd = self.txtPwd.text;
    NSString *phone = self.txtPhoneNumber.text;
    NSString *location = self.txtLocation.text;
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pwd = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    location = [location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([DataManager NSStringIsValidEmail:email]) {
        self.ivEmail.image = [UIImage imageNamed:@"icon_email_act"];
    } else {
        self.ivEmail.image = [UIImage imageNamed:@"icon_email"];
    }
    
    if(pwd.length >= PWD_MIN_LENGTH) {
        self.ivPwd.image = [UIImage imageNamed:@"icon_pwd_act"];
    } else {
        self.ivPwd.image = [UIImage imageNamed:@"icon_pwd"];
    }
    
    if(location.length > 0) {
        self.ivZip.image = [UIImage imageNamed:@"icon_zip_act"];
    } else {
        self.ivZip.image = [UIImage imageNamed:@"icon_zip"];
    }
    
    if(phone.length > 0) {
        self.ivPhoneNumber.image = [UIImage imageNamed:@"icon_phone_act"];
    } else {
        self.ivPhoneNumber.image = [UIImage imageNamed:@"icon_phone"];
    }
}

- (void) animationMainView:(BOOL) isTop
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    [self.mainView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - (isTop ? 120 : 0))];
    //[UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) tapMainView
{
    [self.txtEmail resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    [self.txtLocation resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    [self.mainView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    //[UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
    //animate off screen
    [UIView commitAnimations];
}

#pragma mark -Select Location

- (void) onLocation
{
    [self tapMainView];
    
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
    
    [self updateIcons];
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
    
    [self updateIcons];
}

#pragma mark --VerificationDelegate

- (void)verified:(UserInfo *)user
{
    _verifiedUser = user;
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtLocation) {
        [self onLocation];
        return false;
    }
    
    [self animationMainView:YES];
    
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //[self updateIcons];
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.txtEmail) {
        [self.txtPwd becomeFirstResponder];
    } else if(textField == self.txtPwd) {
        [self.txtPhoneNumber becomeFirstResponder];
    } else if(textField == self.txtPhoneNumber) {
        [textField resignFirstResponder];
        
        [self animationMainView:FALSE];
    }
    
    [self updateIcons];
    
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateIcons];
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

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];
    
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    NSObject *data = [res objectForKey:@"data"];
    
    if(success) {
        if([data isKindOfClass:[NSArray class]]) { // logged in with social
            
            NSDictionary *userData = [(NSArray *)data objectAtIndex:0];
            UserInfo *user = [[UserInfo alloc] initWithDictionary:userData];
            
            [self successLoginWithSocial:user];
        } else {
            [self successRegister];
        }
    } else {
        NSString *errorMsg = [(NSDictionary*)data objectForKey:@"msg"];
        
        [self showAlert:APP_NAME withMsg:errorMsg];
    }
    
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    [self showAlert:APP_NAME withMsg:@"Failed to register. please check your network."];
}


@end
