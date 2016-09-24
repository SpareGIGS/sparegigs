//
//  HireProviderViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "HireProviderViewController.h"

#import "DataManager.h"

#import "ConnectionUtils.h"

@interface HireProviderViewController ()<SDKProtocol>
{
}

@property (nonatomic, weak) IBOutlet UIView *viewMain;
@property (nonatomic, weak) IBOutlet UIScrollView *svMain;

@property (nonatomic, weak) IBOutlet UILabel *lblProviderName;
@property (nonatomic, weak) IBOutlet UITextView *txtTerm;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;
@property (nonatomic, weak) IBOutlet UILabel *lblStartDate;
@property (nonatomic, weak) IBOutlet UILabel *lblEndDate;

@property (nonatomic, weak) IBOutlet UIView *viewPickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, weak) IBOutlet UIView *viewTimePickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *timePickerView;

@property (nonatomic, weak) IBOutlet UIView *viewRate;
@property (nonatomic, weak) IBOutlet UIButton *btnChangeRate;

@property (nonatomic, weak) IBOutlet UIView *viewStartDate;
@property (nonatomic, weak) IBOutlet UIButton *btnChangeStartDate;

@property (nonatomic, weak) IBOutlet UIView *viewEndDate;
@property (nonatomic, weak) IBOutlet UIButton *btnChangeEndDate;

@property (nonatomic, weak) IBOutlet UIButton *btnYes;
@property (nonatomic, weak) IBOutlet UIButton *btnNo;

@property (nonatomic, weak) IBOutlet UILabel *lblState;

@property (nonatomic, weak) IBOutlet UIView *viewReview;
@property (nonatomic, weak) IBOutlet UITextView *txtReview;

@property (nonatomic, weak) IBOutlet UIButton *btnStar1;
@property (nonatomic, weak) IBOutlet UIButton *btnStar2;
@property (nonatomic, weak) IBOutlet UIButton *btnStar3;
@property (nonatomic, weak) IBOutlet UIButton *btnStar4;
@property (nonatomic, weak) IBOutlet UIButton *btnStar5;


- (IBAction)onBack:(id)sender;

@end

@implementation HireProviderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initInfo];
    
    self.viewRate.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewRate.layer.borderWidth = 1.0f;
    
    self.viewStartDate.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewStartDate.layer.borderWidth = 1.0f;
    
    self.viewEndDate.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewEndDate.layer.borderWidth = 1.0f;
    
    self.viewPickerView.hidden = YES;
    self.viewPickerView.alpha = 0.0f;
    
    self.viewTimePickerView.hidden = YES;
    self.viewTimePickerView.alpha = 0.0f;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)];
    [self.viewPickerView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePickerView)];
    [self.viewTimePickerView addGestureRecognizer:gesture1];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.svMain addGestureRecognizer:gesture2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadInfo];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void) initInfo
{
    if(self.hireInfo == nil) {
        self.hireInfo = [[HireInfo alloc] init];
        if(self.room) {
            self.hireInfo.roomId = self.room.roomId;
            self.hireInfo.client = self.room.client;
            self.hireInfo.provider = self.room.provider;
        }
    }
}

- (void) loadInfo
{
    self.viewMain.frame = CGRectMake(0, 0, self.svMain.frame.size.width, 490);
    self.svMain.contentSize = CGSizeMake(self.svMain.frame.size.width, 500);
    
    if([self.hireInfo isClient]) {
        self.lblProviderName.text = [NSString stringWithFormat:@"Service Provider: %@", self.hireInfo.provider.username ];
    } else {
        self.lblProviderName.text = [NSString stringWithFormat:@"Service Seeker: %@", self.hireInfo.client.username ];
    }
    
    self.txtTerm.text = self.hireInfo.contactTerm;
    
    self.lblPrice.text = [NSString stringWithFormat:@"$%d /hr", (int)self.hireInfo.price];
    
    self.lblStartDate.text = self.hireInfo.startDate;
    self.lblEndDate.text = self.hireInfo.endDate;
    
    self.btnChangeRate.hidden = (self.hireInfo.state != HIRE_STATE_NONE);
    self.btnChangeStartDate.hidden = (self.hireInfo.state != HIRE_STATE_NONE);
    self.btnChangeEndDate.hidden = (self.hireInfo.state != HIRE_STATE_NONE);
    self.txtTerm.editable = (self.hireInfo.state == HIRE_STATE_NONE);
    
    self.lblState.frame = CGRectMake(self.lblState.frame.origin.x, 300, self.lblState.frame.size.width, self.lblState.frame.size.height);
    self.viewReview.hidden = YES;
    self.txtReview.editable = NO;
    
    if(self.hireInfo.state == HIRE_STATE_NONE) {
        self.lblState.text = @"";
        if([self.hireInfo.provider.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
            self.btnYes.hidden = YES;
            self.btnNo.hidden = YES;
        } else {
            [self.btnYes setTitle:@"Submit Offer" forState:UIControlStateNormal];
            self.btnYes.frame = CGRectMake(0, 0, self.view.frame.size.width, self.btnYes.frame.size.height);
            self.btnYes.hidden = NO;
            self.btnNo.hidden = YES;
        }
    } else if(self.hireInfo.state == HIRE_STATE_PENDDING) {
        self.lblState.text = @"Pedding";
        if([self.hireInfo.provider.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
            [self.btnYes setTitle:@"Accept" forState:UIControlStateNormal];
            self.btnYes.frame = CGRectMake(self.view.frame.size.width / 2 - 1, 0, self.view.frame.size.width / 2 + 2, self.btnYes.frame.size.height);
            self.btnYes.hidden = NO;
            [self.btnNo setTitle:@"Decline" forState:UIControlStateNormal];
            self.btnNo.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.btnYes.frame.size.height);
            self.btnNo.hidden = NO;
        } else {
            self.btnYes.hidden = YES;
            self.btnNo.hidden = YES;
        }
    }  else if(self.hireInfo.state == HIRE_STATE_ACCEPTED) {
        self.lblState.text = @"Accepted";
        if([self.hireInfo.provider.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
            self.btnYes.hidden = YES;
            [self.btnNo setTitle:@"Delete" forState:UIControlStateNormal];
            self.btnNo.frame = CGRectMake(0, 0, self.view.frame.size.width, self.btnYes.frame.size.height);
            self.btnNo.hidden = NO;
        } else {
            self.viewReview.frame = CGRectMake(self.viewReview.frame.origin.x, 300, self.viewReview.frame.size.width, self.viewReview.frame.size.height);
            self.viewReview.hidden = NO;
            self.lblState.frame = CGRectMake(self.lblState.frame.origin.x,
                                             self.viewReview.frame.origin.y + self.viewReview.frame.size.height + 10,
                                             self.lblState.frame.size.width,
                                             self.lblState.frame.size.height);
            
            self.txtReview.editable = YES;
            
            [self.btnYes setTitle:@"Submit a review" forState:UIControlStateNormal];
            self.btnYes.frame = CGRectMake(self.view.frame.size.width / 2 - 1, 0, self.view.frame.size.width / 2 + 1, self.btnYes.frame.size.height);
            self.btnYes.hidden = NO;
            [self.btnNo setTitle:@"Delete" forState:UIControlStateNormal];
            self.btnNo.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.btnYes.frame.size.height);
            self.btnNo.hidden = NO;
        }
    } else if(self.hireInfo.state == HIRE_STATE_DECLINED) {
        self.lblState.text = @"Declined";
        self.btnYes.hidden = YES;
        [self.btnNo setTitle:@"Delete" forState:UIControlStateNormal];
        self.btnNo.frame = CGRectMake(0, 0, self.view.frame.size.width, self.btnYes.frame.size.height);
        self.btnNo.hidden = NO;
    } else if(self.hireInfo.state == HIRE_STATE_REVIED) {
        self.lblState.text = @"Reviewed";

        self.viewReview.frame = CGRectMake(self.viewReview.frame.origin.x, 300, self.viewReview.frame.size.width, self.viewReview.frame.size.height);
        self.viewReview.hidden = NO;
        self.lblState.frame = CGRectMake(self.lblState.frame.origin.x,
                                         self.viewReview.frame.origin.y + self.viewReview.frame.size.height + 10,
                                         self.lblState.frame.size.width,
                                         self.lblState.frame.size.height);
        
        self.btnYes.hidden = YES;
        [self.btnNo setTitle:@"Delete" forState:UIControlStateNormal];
        self.btnNo.frame = CGRectMake(0, 0, self.view.frame.size.width, self.btnYes.frame.size.height);
        self.btnNo.hidden = NO;
    }
    
    self.txtReview.text = self.hireInfo.review;
    
    UIImage *yellowStar = [UIImage imageNamed:@"profile_icon_star"];
    UIImage *blackStar = [UIImage imageNamed:@"icon_rate_black"];
    [self.btnStar5 setBackgroundImage:(self.hireInfo.rating > 4 ? yellowStar : blackStar) forState:UIControlStateNormal];
    [self.btnStar4 setBackgroundImage:(self.hireInfo.rating > 3 ? yellowStar : blackStar) forState:UIControlStateNormal];
    [self.btnStar3 setBackgroundImage:(self.hireInfo.rating > 2 ? yellowStar : blackStar) forState:UIControlStateNormal];
    [self.btnStar2 setBackgroundImage:(self.hireInfo.rating > 1 ? yellowStar : blackStar) forState:UIControlStateNormal];
    [self.btnStar1 setBackgroundImage:(self.hireInfo.rating > 0 ? yellowStar : blackStar) forState:UIControlStateNormal];
}

- (IBAction)onBack:(id)sender
{
    [self hideKeyboard];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) hideKeyboard
{
    [self.txtTerm resignFirstResponder];
    [self.txtReview resignFirstResponder];
}

- (IBAction)onYes:(id)sender
{
    [self hideKeyboard];
    
    if(self.hireInfo.state == HIRE_STATE_NONE) {
        if([self.hireInfo.client.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
            [self onSubmitOffer];
        }
    } else if(self.hireInfo.state == HIRE_STATE_PENDDING) {
        if([self.hireInfo.provider.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
            [self onAccept];
        }
    }  else if(self.hireInfo.state == HIRE_STATE_ACCEPTED) {
        if([self.hireInfo.client.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
            [self onWriteReview];
        }
    } else if(self.hireInfo.state == HIRE_STATE_DECLINED) {

    } else if(self.hireInfo.state == HIRE_STATE_REVIED) {

    }
}

- (IBAction)onNo:(id)sender
{
    [self hideKeyboard];
    
    if(self.hireInfo.state == HIRE_STATE_NONE) {

    } else if(self.hireInfo.state == HIRE_STATE_PENDDING) {
        if([self.hireInfo.provider.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
            [self onDecline];
        }
    }  else if(self.hireInfo.state == HIRE_STATE_ACCEPTED) {
        [self onDelete];
    } else if(self.hireInfo.state == HIRE_STATE_DECLINED) {
        [self onDelete];
    } else if(self.hireInfo.state == HIRE_STATE_REVIED) {
        [self onDelete];
    }
}

- (void) onSubmitOffer
{
    if(self.hireInfo.contactTerm.length == 0) {
        [self showAlert:APP_NAME withMsg:@"Please input a contact term."];
        return;
    }
    
    if(self.hireInfo.startDate.length == 0) {
        [self showAlert:APP_NAME withMsg:@"Please select a start date."];
        return;
    }
    
    [self reqSubmitOffer];
}

- (void) reqSubmitOffer
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_HIRE_SUBMIT_OFFER;
    
    [connectionUtils createOffer:[self.hireInfo getDictionary]];
}

- (void) completedSubmitOffer:(NSObject *)res
{
    NSLog(@"%@", res);
    
    if([res isKindOfClass:[NSArray class]]) {
        NSArray *aryData = (NSArray *)res;
        if(aryData.count > 0) {
            NSDictionary *offer = [aryData objectAtIndex:0];
            
            self.hireInfo = [[HireInfo alloc] initWithDictionary:offer];
        }
    }
    
    [self loadInfo];
}

- (IBAction)onStar:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.hireInfo.rating = button.tag;
    
    [self loadInfo];
}

- (void) onDecline
{
    [self reqUpdateOffer:self.hireInfo.hireId state:HIRE_STATE_DECLINED];
}

- (void) onAccept
{
    [self reqUpdateOffer:self.hireInfo.hireId state:HIRE_STATE_ACCEPTED];
}

- (void) onDelete
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:@"Are you sure to delete this offer?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             [self reqDeleteOffer];
                         }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) reqDeleteOffer
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_HIRE_DELETE;
    
    [connectionUtils deleteHire:[DataManager shareDataManager].user.userid offer:self.hireInfo.hireId];
}

- (void) completedDeleteOffer
{
    [self onBack:nil];
}

- (void) onWriteReview
{
    if(self.hireInfo.review.length == 0) {
        [self showAlert:APP_NAME withMsg:@"Please write a review."];
        return;
    }
    
    if(self.hireInfo.rating == 0) {
        [self showAlert:APP_NAME withMsg:@"Please make a rating."];
        return;
    }
    
    [self reqWriteReview];
}

- (void) reqWriteReview
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_HIRE_UPDATE_OFFER;
    
    [connectionUtils writeReview:self.hireInfo.hireId state:HIRE_STATE_REVIED review:self.hireInfo.review rating:self.hireInfo.rating];
}

- (void) reqUpdateOffer:(NSString *)offerId state:(int)state
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;

    self.reqType = REQ_HIRE_UPDATE_OFFER;
    
    [connectionUtils updateOffer:offerId state:state];
}

- (void) completedUpdateOffer:(NSObject *) res
{
    NSLog(@"%@", res);
    
    if([res isKindOfClass:[NSArray class]]) {
        NSArray *aryData = (NSArray *)res;
        if(aryData.count > 0) {
            NSDictionary *offer = [aryData objectAtIndex:0];
            
            self.hireInfo = [[HireInfo alloc] initWithDictionary:offer];
        }
    }
    
    [self loadInfo];
}

- (void) moveMainView:(BOOL) toTop
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    //position off screen
    
    self.svMain.frame = CGRectMake(self.svMain.frame.origin.x,
                                   self.svMain.frame.origin.y,
                                   self.svMain.frame.size.width,
                                   self.view.frame.size.height - self.svMain.frame.origin.y - (toTop ? 216 + 48 : 48));
    
    if(toTop) {
        [UIView setAnimationDidStopSelector:@selector(finishMoveMainView)];
    }
    //animate off screen
    [UIView commitAnimations];
}

- (void) finishMoveMainView
{
    [self.svMain setContentOffset:CGPointMake(0, self.svMain.contentSize.height - self.svMain.frame.size.height) animated:YES];
}

#pragma mark Pick Date

- (IBAction)onStarttime:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:SEARCH_DATE_FORMAT];
    
    NSDate *startTime = [NSDate date];
    if(self.hireInfo.startDate.length > 0) {
        [formatter dateFromString:self.hireInfo.startDate];
    }
    
    [self showTimePickerViewWithType:0 time:startTime];
}

- (IBAction)onEndtime:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:SEARCH_DATE_FORMAT];
    
    NSDate *endTime = [NSDate date];
    if(self.hireInfo.endDate.length > 0) {
        [formatter dateFromString:self.hireInfo.startDate];
    }
    
    [self showTimePickerViewWithType:1 time:endTime];
}

- (void) showTimePickerViewWithType:(int)type time:(NSDate *) time
{
    [self hideKeyboard];
    
    self.timePickerView.tag = type;
    [self.timePickerView setDate:time];
    
    self.viewTimePickerView.hidden = NO;
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewTimePickerView.alpha = 1.0f;
    //[UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) hideTimePickerView
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewTimePickerView.alpha = 0.0f;
    [UIView setAnimationDidStopSelector:@selector(finishHideTimePickView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) finishHideTimePickView
{
    self.viewTimePickerView.hidden = YES;
    
    [self pickedTime:self.timePickerView];
}

- (void) pickedTime:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:SEARCH_DATE_FORMAT];
    
    NSDate *date = picker.date;
    NSString *time = [formatter stringFromDate:date];
    
    NSInteger tag = picker.tag;
    if(tag == 0) {
        self.hireInfo.startDate = time;
    } else {
        self.hireInfo.endDate = time;
    }
    
    [self loadInfo];
}

#pragma mark Change Rate

- (IBAction)onChangeRate:(id)sender
{
    [self showPickerView:self.hireInfo.price];
}

- (void) showPickerView:(NSInteger) value
{
    [self hideKeyboard];
    
    [self.pickerView reloadAllComponents];
    
    NSInteger row = value / 2 - 1;
    
    if(row < 0 || row > 30) {
        row = 0;
    }
    
    [self.pickerView selectRow:row inComponent:0 animated:YES];
    
    self.viewPickerView.hidden = NO;
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewPickerView.alpha = 1.0f;
    //[UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) hidePickerView
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewPickerView.alpha = 0.0f;
    [UIView setAnimationDidStopSelector:@selector(finishHidePickView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) finishHidePickView
{
    self.viewPickerView.hidden = YES;
    
    [self pickedRate:[self.pickerView selectedRowInComponent:0]];
}

- (void) pickedRate:(NSInteger)valueIndex
{
    self.hireInfo.price = ((int)valueIndex + 1) * 2;
    
    [self loadInfo];
}

#pragma mark UIPickViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return 30;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [NSString stringWithFormat:@"%d", (int)(row + 1) * 2];
    
    return title;
}

#pragma mark -- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(self.txtReview == textView) {
        [self moveMainView:YES];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(self.txtTerm == textView) {
        self.hireInfo.contactTerm = self.txtTerm.text;
    } else  if(self.txtReview == textView) {
        self.hireInfo.review = self.txtReview.text;
    }
    
    [self moveMainView:NO];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{

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
                
                if(self.reqType == REQ_HIRE_SUBMIT_OFFER) {
                    [self completedSubmitOffer:data];
                } else if(self.reqType == REQ_HIRE_UPDATE_OFFER) {
                    [self completedUpdateOffer:data];
                } else if(self.reqType == REQ_HIRE_DELETE) {
                    [self completedDeleteOffer];
                }
            });
        });
        
    } else {
        if(self.reqType == REQ_HIRE_SUBMIT_OFFER) {
            [self showAlert:APP_NAME withMsg:@"Failed to submit offer."];
        } else if(self.reqType == REQ_HIRE_UPDATE_OFFER) {
            [self showAlert:APP_NAME withMsg:@"Failed to update a offer."];
        } else if(self.reqType == REQ_HIRE_DELETE) {
            [self showAlert:APP_NAME withMsg:@"Failed to delte a offer."];
        }
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    if(self.reqType == REQ_HIRE_SUBMIT_OFFER) {
        [self showAlert:APP_NAME withMsg:@"Failed to submit offer."];
    } else if(self.reqType == REQ_HIRE_UPDATE_OFFER) {
        [self showAlert:APP_NAME withMsg:@"Failed to update a offer."];
    } else if(self.reqType == REQ_HIRE_DELETE) {
        [self showAlert:APP_NAME withMsg:@"Failed to delte a offer."];
    }
}

@end
