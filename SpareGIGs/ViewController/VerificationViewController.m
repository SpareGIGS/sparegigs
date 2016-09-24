//
//  VerificationViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "VerificationViewController.h"

#import "DataManager.h"

#import "ConnectionUtils.h"
#import "SVProgressHUD.h"

@interface VerificationViewController ()<SDKProtocol>
{
    
}

@property (nonatomic, weak) IBOutlet UITextField *txtCode;

- (IBAction)onBack:(id)sender;
- (IBAction)onVerify:(id)sender;

@end

@implementation VerificationViewController

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

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onVerify:(id)sender
{
    [self.txtCode resignFirstResponder];
    
    NSString *code = self.txtCode.text;
    
    code = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(code.length == 0) {
        
        [self showRequireValidCodeAlert];
        
        return ;
    }
    
    if(self.email == nil) {
        
        [self showAlert:APP_NAME withMsg:@"There is no user information. Please go back."];
        
        return;
    }
    
    [self reqVerify:code];
}

- (void) reqVerify:(NSString *)code
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils verifyWithEmail:self.email withCode:code];
}

- (void) verified:(UserInfo *)user
{
    [self.delegate verified:user];
    
    [self showAlert:APP_NAME withMsg:@"Your email address is verified."];
}

- (void) showRequireValidCodeAlert
{
    [self showAlert:APP_NAME withMsg:@"Please add a valid code"];
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
    
    return true;
}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];
    
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    NSObject *data = [res objectForKey:@"data"];
    
    if(success) {
        NSDictionary *userdata = [(NSArray *)data objectAtIndex:0];
        UserInfo *user = [[UserInfo alloc] initWithDictionary:userdata];
        
        [self verified:user];
    } else {
        NSString *errorMsg = [(NSDictionary *)data objectForKey:@"msg"];
        [self showAlert:APP_NAME withMsg:errorMsg];
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    [self showAlert:APP_NAME withMsg:@"Failed to register. please check your network."];
}

@end
