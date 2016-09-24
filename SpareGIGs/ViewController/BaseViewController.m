//
//  BaseViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "BaseViewController.h"

#import "DataManager.h"

#import "SVProgressHUD.h"

#import "ConnectionUtils.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "SCTwitter.h"

#import <GoogleSignIn/GoogleSignIn.h>
#import <Google/SignIn.h>
#import <MessageUI/MessageUI.h>

@interface BaseViewController ()<SDKProtocol, GIDSignInDelegate, GIDSignInUIDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{

}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void) showAlert:(NSString *) title withMsg:(NSString *)msg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) startActivityAnimation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        });
    });
}

- (void) stopActivityAnimation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

- (void) runUIProcess:(nullable SEL) act
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:act];
        });
    });
}

- (void) loginWithSocialType:(int)socialType withEmail:(NSString *)email withId:(NSString *)userid image:(NSString *)profile
{    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils signinWithSocial:userid withEmail:email image:profile withType:[NSString stringWithFormat:@"%d", socialType]];
}

- (void) sendEmailWith:(NSString *)email subject:(NSString *)subject body:(NSString *)message
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:@[email]];
        [mail setSubject:subject];
        [mail setMessageBody:message isHTML:NO];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        [self showAlert:APP_NAME withMsg:@"This device cannot send email"];
    }
}

- (void) sendSMS:(NSString *) phoneNumber message:(NSString *)message
{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[phoneNumber];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void) callPhoneNumber:(NSString *) phoneNumber
{
    NSString *url = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark Login to Facebook

- (void) loginToFacebook
{
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
        
        [self getFacebookUserInfo];
        
    } else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error)
                                    {
                                        [self showAlert:APP_NAME withMsg:@"Failed to sign in to Facebook."];
                                    }
                                    else if (result.isCancelled)
                                    {
                                        [self showAlert:APP_NAME withMsg:@"Canceled to sign in to Facebook."];
                                    }
                                    else
                                    {
                                        NSLog(@"Login Sucessfull");
                                        // Share link text on face book
                                        
                                        [self getFacebookUserInfo];
                                    }
                                }];
    }
}

- (void) getFacebookUserInfo
{
    [self startActivityAnimation];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
             
             NSString *email = [result objectForKey:@"email"];
             NSString *userid = [result objectForKey:@"id"];
             NSString *profile = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", userid];
             
             [self loginWithSocialType:LOGIN_WITH_FACEBOOK withEmail:email withId:userid image:profile];
            
         } else {
             [self stopActivityAnimation];
             
             [self showAlert:APP_NAME withMsg:@"Failed to get information from Facebook."];
         }
     }];
}

#pragma mark Login to Twitter

- (void) loginToTwitter
{
    [SCTwitter loginViewControler:self callback:^(BOOL success, id result){
        if (success) {
            NSLog(@"Login is Success -  %i", success);
            
            [self getTwitterUserInformation];
        } else {
            [self showAlert:APP_NAME withMsg:@"Failed to log in to Twitter."];
        }
    }];
}

- (void) getTwitterUserInformation
{
    [self startActivityAnimation];
    
    [SCTwitter getUserInformationCallback:^(BOOL success, id result) {
        if (success) {
            //Return array NSDictonary
            NSLog(@"%@", result);
            
            NSString *userid = [result objectForKey:@"id_str"];
            NSString *profile = [result objectForKey:@"profile_image_url"];
            if(profile == nil) profile = @"";
            
            [self loginWithSocialType:LOGIN_WITH_TWITTER withEmail:@"" withId:userid image:profile];
        }else {
            [self stopActivityAnimation];
            [self showAlert:APP_NAME withMsg:@"Failed to get information from Twitter."];
        }
    }];
}

#pragma mark Login to Google

- (void) loginToGoogle
{
    [[GIDSignIn sharedInstance] signIn];
}

#pragma mark - GIDSignInDelegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *email = user.profile.email;
    NSString *profile = @"";
    if([user.profile hasImage]) {
        NSUInteger dimension = round(120 * [[UIScreen mainScreen] scale]);
        profile = [[user.profile imageURLWithDimension:dimension] absoluteString] ;
    }
    
    [self startActivityAnimation];
    [self loginWithSocialType:LOGIN_WITH_GOOGLE withEmail:email withId:userId image:profile];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    
    [self showAlert:APP_NAME withMsg:@"Failed to log in to Google."];
}

#pragma mark MailDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];

}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
}


@end
