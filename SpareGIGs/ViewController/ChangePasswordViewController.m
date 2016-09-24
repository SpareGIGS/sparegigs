//
//  ChangePasswordViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "DataManager.h"

#import "ConnectionUtils.h"

@interface ChangePasswordViewController ()<SDKProtocol>
{
    BOOL _isFirstLoad;
}

@property (nonatomic, weak) IBOutlet UITextField *txtOrignalPwd;
@property (nonatomic, weak) IBOutlet UITextField *txtNewPwd;
@property (nonatomic, weak) IBOutlet UITextField *txtConfirmPwd;

- (IBAction)onBack:(id)sender;

- (IBAction)onChangePassword:(id)sender;

@end

@implementation ChangePasswordViewController

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
    

}

- (IBAction)onBack:(id)sender
{
    [self hideKeyboard];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChangePassword:(id)sender
{
    NSString *oldPwd = self.txtOrignalPwd.text;
    NSString *newPwd = self.txtNewPwd.text;
    NSString *confirmPwd = self.txtConfirmPwd.text;
    
    oldPwd = [oldPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    newPwd = [newPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    confirmPwd = [confirmPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(oldPwd.length == 0 || newPwd.length == 0 || confirmPwd.length == 0) {
        
        [self showAlert:APP_NAME withMsg:@"Please input a valid password."];
        
        return ;
    }
    
    if(![newPwd isEqualToString:confirmPwd]) {
        
        [self showAlert:APP_NAME withMsg:@"Please input a correct confirm password."];
        
        return ;
    }
    
    [self hideKeyboard];
    
    [self reqChangePassword:oldPwd new:newPwd];
}

- (void) reqChangePassword:(NSString *)oldPwd new:(NSString *)newPwd
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils reqChangePwd:[DataManager shareDataManager].user.userid old:oldPwd new:newPwd];
}

- (void) completeChangePassword
{
    [self showAlert:APP_NAME withMsg:@"Changed your password."];
}

- (void) hideKeyboard
{
    [self.txtOrignalPwd resignFirstResponder];
    [self.txtNewPwd resignFirstResponder];
    [self.txtConfirmPwd resignFirstResponder];
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
    if(textField == self.txtOrignalPwd) {
        [self.txtNewPwd becomeFirstResponder];
    } else if(textField == self.txtNewPwd) {
        [self.txtConfirmPwd becomeFirstResponder];
    } else {
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
        [self completeChangePassword];
    } else {
        [self showAlert:APP_NAME withMsg:@"Failed to change your password. please check your original password."];
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];

    [self showAlert:APP_NAME withMsg:@"Failed to change your password."];
}

@end
