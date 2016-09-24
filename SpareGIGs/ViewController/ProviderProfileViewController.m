//
//  ProviderProfileViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "ProviderProfileViewController.h"

#import "MNMRemoteImageView.h"

#import "DataManager.h"

#import "ConnectionUtils.h"

@interface ProviderProfileViewController ()<SDKProtocol>
{
    int _favorState;
}

@property (nonatomic, weak) IBOutlet UILabel *lblUsername;
@property (nonatomic, weak) IBOutlet UILabel *lblAddress;

@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtLocation;
@property (nonatomic, weak) IBOutlet UITextField *txtPhoneNumber;
@property (nonatomic, weak) IBOutlet UITextField *txtBusinessNumber;

@property (nonatomic, weak) IBOutlet UIView *viewProfile;
@property (nonatomic, weak) IBOutlet MNMRemoteImageView *ivProfile;

@property (nonatomic, weak) IBOutlet UIImageView *ivStar1;
@property (nonatomic, weak) IBOutlet UIImageView *ivStar2;
@property (nonatomic, weak) IBOutlet UIImageView *ivStar3;
@property (nonatomic, weak) IBOutlet UIImageView *ivStar4;
@property (nonatomic, weak) IBOutlet UIImageView *ivStar5;

@property (nonatomic, weak) IBOutlet UIScrollView *svInfo;
@property (nonatomic, weak) IBOutlet UIView *viewInfo;

@property (nonatomic, weak) IBOutlet UIButton *btnFavorite;

@property (nonatomic, weak) IBOutlet UIButton *btnPhoneDial;
@property (nonatomic, weak) IBOutlet UIButton *btnPhoneSMS;

@property (nonatomic, weak) IBOutlet UIButton *btnBusinessDial;
@property (nonatomic, weak) IBOutlet UIButton *btnBusinessSMS;

- (IBAction)onBack:(id)sender;

- (IBAction)onDial:(id)sender;
- (IBAction)onSMS:(id)sender;

- (IBAction)onPhoneDial:(id)sender;
- (IBAction)onPhoneSMS:(id)sender;

- (IBAction)onPhoneBusinessDial:(id)sender;
- (IBAction)onPhoneBusinessSMS:(id)sender;

- (IBAction)onEmail:(id)sender;

- (IBAction)onAction:(id)sender;

@end

@implementation ProviderProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.viewProfile.layer.cornerRadius = self.viewProfile.frame.size.height / 2; // this value vary as per your desire
    self.viewProfile.clipsToBounds = YES;
    
    self.ivProfile.layer.cornerRadius = self.ivProfile.frame.size.height / 2; // this value vary as per your desire
    self.ivProfile.clipsToBounds = YES;
    
    _favorState = FAVOR_STATE_NONE;
    
    self.svInfo.contentSize = CGSizeMake(self.svInfo.frame.size.width, 250);
    self.viewInfo.frame = CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.svInfo.frame.size.width, self.viewInfo.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reqFavoriteState];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void) loadUserInfo
{
    [self.ivProfile displayImageFromURL:self.provider.profile completionHandler:nil];
    
    self.lblUsername.text = self.provider.username;
    
    self.txtPhoneNumber.text = self.provider.phone;
    if(self.provider.phone.length > 0) {
        self.btnPhoneDial.hidden = NO;
        self.btnPhoneSMS.hidden = NO;
    } else {
        self.btnPhoneDial.hidden = YES;
        self.btnPhoneSMS.hidden = YES;
    }
    
    self.txtBusinessNumber.text = self.provider.businessphone;
    if(self.provider.businessphone.length > 0) {
        self.btnBusinessSMS.hidden = NO;
        self.btnBusinessDial.hidden = NO;
    } else {
        self.btnBusinessSMS.hidden = YES;
        self.btnBusinessDial.hidden = YES;
    }
    
    self.txtEmail.text = self.provider.email;
    
    self.txtLocation.text = self.provider.location;
    
    [self showAddressFromLocation:self.provider.location];
    
    self.btnFavorite.hidden = (_favorState == FAVOR_STATE_NONE);
    [self.btnFavorite setTitle:(_favorState == FAVOR_STATE_FAVORITE ? @"Unfavorite" : @"Favorite") forState:UIControlStateNormal];
}

- (void) showAddressFromLocation:(NSString *)location
{
    if(location.length == 0) {
        self.lblAddress.text = @"None";
    } else {
        NSArray *positions = [location componentsSeparatedByString:@","];
        
        if(positions.count != 2) {
            self.lblAddress.text = @"None.";
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

- (IBAction)onDial:(id)sender
{
    if(self.provider.phone.length > 0) {
        [self callPhoneNumber:self.provider.phone];
    } else if(self.provider.businessphone.length > 0){
        [self callPhoneNumber:self.provider.businessphone];
    }
}

- (IBAction)onSMS:(id)sender
{
    if(self.provider.phone.length > 0) {
        [self sendSMS:self.provider.phone message:@""];
    } else if(self.provider.businessphone.length > 0){
        [self sendSMS:self.provider.businessphone message:@""];
    }
}

- (IBAction)onPhoneDial:(id)sender
{
    [self callPhoneNumber:self.provider.phone];
}

- (IBAction)onPhoneSMS:(id)sender
{
    [self sendSMS:self.provider.phone message:@""];
}

- (IBAction)onPhoneBusinessDial:(id)sender
{
    [self callPhoneNumber:self.provider.businessphone];
}

- (IBAction)onPhoneBusinessSMS:(id)sender
{
    [self sendSMS:self.provider.businessphone message:@""];
}

- (IBAction)onEmail:(id)sender
{
    [self sendEmailWith:self.provider.email subject:@"" body:@""];
}

- (IBAction)onAction:(id)sender
{
    if(_favorState == FAVOR_STATE_FAVORITE) {
        [self reqUnFavoriteUser];
    } else if(_favorState == FAVOR_STATE_UNFAVORITE) {
        [self reqFavoriteUser];
    }
}

- (void) reqFavoriteState
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_CHECK_FAVOR;
    
    NSString *myId = [DataManager shareDataManager].user.userid;
    [connectionUtils checkFavorUser:myId opp:self.provider.userid];
}

- (void) completedFavoriteState:(NSObject *)res
{
    NSLog(@"%@", res);
    
    if([res isKindOfClass:[NSDictionary class]]) {
        int status = [[(NSDictionary *)res objectForKey:@"status"] intValue];
        
        if(status == 0) {
            _favorState = FAVOR_STATE_UNFAVORITE;
        } else {
            _favorState = FAVOR_STATE_FAVORITE;
        }
    } else {
        _favorState = FAVOR_STATE_NONE;
    }
    
    [self loadUserInfo];
}

- (void) reqFavoriteUser
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_ADD_FAVOR;
    
    NSString *myId = [DataManager shareDataManager].user.userid;
    [connectionUtils addFavorUser:myId opp:self.provider.userid];
}

- (void) completeReqFavoriteUser
{
    _favorState = FAVOR_STATE_FAVORITE;
    
    [self loadUserInfo];
}

- (void) reqUnFavoriteUser
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_REMOVE_FAVOR;
    
    NSString *myId = [DataManager shareDataManager].user.userid;
    [connectionUtils deleteFavorUser:myId opp:self.provider.userid];
}

- (void) completeReqUnFavoriteUser
{
    _favorState = FAVOR_STATE_UNFAVORITE;
    
    [self loadUserInfo];
}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];
    
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    
    if(success) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            dispatch_async(dispatch_get_main_queue(), ^{
                NSObject *data = [res objectForKey:@"data"];
                
                if(self.reqType == REQ_CHECK_FAVOR) {
                    [self completedFavoriteState:data];
                } else if(self.reqType == REQ_ADD_FAVOR) {
                    [self completeReqFavoriteUser];
                } else if(self.reqType == REQ_REMOVE_FAVOR) {
                    [self completeReqUnFavoriteUser];
                }
            });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.reqType == REQ_CHECK_FAVOR) {
                    _favorState = FAVOR_STATE_NONE;
                    [self loadUserInfo];
                } else if(self.reqType == REQ_ADD_FAVOR) {

                } else if(self.reqType == REQ_REMOVE_FAVOR) {

                }
            });
        });
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.reqType == REQ_CHECK_FAVOR) {
                _favorState = FAVOR_STATE_NONE;
                [self loadUserInfo];
            } else if(self.reqType == REQ_ADD_FAVOR) {
                
            } else if(self.reqType == REQ_REMOVE_FAVOR) {
                
            }
        });
    });
}

@end
