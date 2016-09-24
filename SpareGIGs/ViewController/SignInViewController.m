//
//  SignInViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "SignInViewController.h"

#import "SignUpViewController.h"

#import "DataManager.h"

#import "ConnectionUtils.h"

@interface SignInViewController ()<SDKProtocol>
{
    BOOL _isFirstLoad;
}

@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtPwd;

@property (nonatomic, weak) IBOutlet UIImageView *ivEmail;
@property (nonatomic, weak) IBOutlet UIImageView *ivPwd;

- (IBAction)onSignUp:(id)sender;
- (IBAction)onSignIn:(id)sender;

- (IBAction)onForgotPwd:(id)sender;

- (IBAction)onFacebook:(id)sender;
- (IBAction)onTwitter:(id)sender;
- (IBAction)onGoogle:(id)sender;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _isFirstLoad = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isFirstLoad) {
        _isFirstLoad = NO;
        [self checkUserAccountState];
    }
}

- (void) checkUserAccountState
{
    if([[DataManager shareDataManager] isSignin]) {
        
        UserInfo *user = [[UserInfo alloc] initFromLocal];
        [[DataManager shareDataManager] login:user];
        
        [self gotoHome];
    } else if(![[DataManager shareDataManager] isSignup]) {
        [self onSignUp:nil];
    }
}

- (IBAction)onSignUp:(id)sender
{
    NSArray *controllers = [self.navigationController viewControllers];
    for (int index = 0 ; index < controllers.count; index ++) {
        UIViewController *controller = [controllers objectAtIndex:index];
        
        if([controller isKindOfClass:[SignUpViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            
            return;
        }
    }
    
    [self performSegueWithIdentifier:@"SignUp"  sender:nil];
}

- (IBAction)onSignIn:(id)sender
{
    [self.txtEmail resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    
    NSString *email = self.txtEmail.text;
    NSString *pwd = self.txtPwd.text;
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pwd = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(email.length == 0 || pwd.length == 0) {
        
        [self showAlert:APP_NAME withMsg:@"Please add a valid acount."];
        
        return ;
    }
    
    if(![DataManager NSStringIsValidEmail:email]) {
        
        [self showAlert:APP_NAME withMsg:@"Please input a valid email."];
        
        return ;
    }
    
    [self reqSignin:email isPwd:pwd];
}

- (IBAction)onForgotPwd:(id)sender
{
    [self.txtEmail resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    
    NSString *email = self.txtEmail.text;
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(![DataManager NSStringIsValidEmail:email]) {
        
        [self showAlert:APP_NAME withMsg:@"Please input a valid email."];
        
        return ;
    }
    
    [self reqForgotPwd:email];
}

- (IBAction)onFacebook:(id)sender
{
    [self loginToFacebook];
}

- (IBAction)onTwitter:(id)sender
{
    [self loginToTwitter];
}

- (IBAction)onGoogle:(id)sender
{
    [self loginToGoogle];
}

- (void) reqForgotPwd:(NSString *)email
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils forgotPwd:email];
}

- (void) completedReqForgotPwd
{
    [self showAlert:APP_NAME withMsg:@"Please check your email address. You can get a new password from there."];
}

- (void) reqSignin:(NSString *)email isPwd:(NSString *)pwd
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils signinWithEmail:email withPwd:pwd];
}

- (void) successLogin:(UserInfo *)user
{
    self.txtEmail.text = @"";
    self.txtPwd.text = @"";
    
    [[DataManager shareDataManager] login:user];
    
    if([user isCompleted]) {
        if([[DataManager shareDataManager] isPassedMakeMoney]) {
            [self runUIProcess:@selector(gotoHome)];
        } else {
            [self runUIProcess:@selector(gotoMakeMoney)];
        }
    } else {
        [self runUIProcess:@selector(gotoProfile)];
    }
}

- (void) gotoMakeMoney
{
    [self performSegueWithIdentifier:@"MakeMoney" sender:nil];
}

- (void) gotoProfile
{
    [self performSegueWithIdentifier:@"Profile" sender:nil];
}

- (void) gotoHome
{
    [self performSegueWithIdentifier:@"Home" sender:nil];
}

- (void) updateIcons
{
    NSString *email = self.txtEmail.text;
    NSString *pwd = self.txtPwd.text;
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pwd = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
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
}

#pragma mark --UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
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
    } else {
        [textField resignFirstResponder];
    }
    
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateIcons];
}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];
    
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    
    if(success) {
        NSObject *data = [res objectForKey:@"data"];
        
        if(data != nil && [data isKindOfClass:[NSArray class]]) { // login
            NSDictionary *userdata = [(NSArray *)data objectAtIndex:0];
            UserInfo *user = [[UserInfo alloc] initWithDictionary:userdata];
            
            [self successLogin:user];
        } else { // forgot pwd
            [self runUIProcess:@selector(completedReqForgotPwd)];
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

    [self showAlert:APP_NAME withMsg:@"Failed to request. Please check your network."];
}

@end
