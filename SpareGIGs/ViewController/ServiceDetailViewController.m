//
//  ServiceDetailViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "ServiceDetailViewController.h"

#import "ScheduleTableViewCell.h"

#import "DataManager.h"

#import "ConnectionUtils.h"

enum {
    PICKER_TYPE_NONE = 0,
    PICKER_TYPE_RADIUS,
    PICKER_TYPE_RATE
};

@interface ServiceDetailViewController ()<SDKProtocol, UIActionSheetDelegate>
{
    UserServiceInfo *_editingServiceInfo;
    
    NSInteger _editingScheduleIndex;
}

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UITextView *txtDesc;

@property (nonatomic, weak) IBOutlet UITextField *txtMoreInfo;

@property (nonatomic, weak) IBOutlet UILabel *lblRadius;
@property (nonatomic, weak) IBOutlet UILabel *lblRate;

@property (nonatomic, weak) IBOutlet UIScrollView *svMain;
@property (nonatomic, weak) IBOutlet UIView *viewMain;

@property (nonatomic, weak) IBOutlet UIView *viewSchedules;
@property (nonatomic, weak) IBOutlet UIView *viewEditSchedule;

@property (nonatomic, weak) IBOutlet UITableView *tvSchedules;

@property (nonatomic, weak) IBOutlet UIView *viewPickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, weak) IBOutlet UIButton *btnAnytime;

@property (nonatomic, weak) IBOutlet UIButton *btnStarttime;
@property (nonatomic, weak) IBOutlet UIButton *btnEndtime;

@property (nonatomic, weak) IBOutlet UIButton *btnAnyDays;
@property (nonatomic, weak) IBOutlet UIButton *btnMonday;
@property (nonatomic, weak) IBOutlet UIButton *btnTuesday;
@property (nonatomic, weak) IBOutlet UIButton *btnWedneday;
@property (nonatomic, weak) IBOutlet UIButton *btnThursday;
@property (nonatomic, weak) IBOutlet UIButton *btnFriday;
@property (nonatomic, weak) IBOutlet UIButton *btnSaturday;
@property (nonatomic, weak) IBOutlet UIButton *btnSunday;

@property (nonatomic, weak) IBOutlet UIView *viewTimePickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *timePickerView;


- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onUpdate:(id)sender;
- (IBAction)onReturn:(id)sender;

- (IBAction)onChangeRadius:(id)sender;
- (IBAction)onChangeRate:(id)sender;

- (IBAction)onAddSchedule:(id)sender;
- (IBAction)onDeleteSchedule:(id)sender;

- (IBAction)onAnytime:(id)sender;
- (IBAction)onStarttime:(id)sender;
- (IBAction)onEndtime:(id)sender;

- (IBAction)onDates:(id)sender;

@end

@implementation ServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.viewSchedules.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewSchedules.layer.borderWidth = 1.0f;
    
    self.viewPickerView.hidden = YES;
    self.viewPickerView.alpha = 0.0f;
    
    self.viewTimePickerView.hidden = YES;
    self.viewTimePickerView.alpha = 0.0f;
    
    _editingScheduleIndex = -1;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)];
    [self.viewPickerView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePickerView)];
    [self.viewTimePickerView addGestureRecognizer:gesture1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
    if(_editingServiceInfo == nil) {
        _editingServiceInfo = [self.userService clone];
    }
    
    [self loadServiceInfo];
}

- (void) loadServiceInfo
{
    if(_editingServiceInfo == nil)
        return;
    
    [self repositionViews];
    
    self.lblTitle.text = [NSString stringWithFormat:@"Details for %@", _editingServiceInfo.service_name];
    
    if(_editingServiceInfo.service_description == nil || _editingServiceInfo.service_description.length == 0) {
        self.txtDesc.text = PLACEHOLD_SERVICE_DESCRIPTION;
    } else {
        self.txtDesc.text = _editingServiceInfo.service_description;
    }
    
    self.lblRadius.text = [NSString stringWithFormat:@"%d (Miles)", _editingServiceInfo.service_radius];
    self.txtMoreInfo.text = _editingServiceInfo.service_more_info;
    
    NSArray *arySchedule = _editingServiceInfo.service_schedule;
    if(arySchedule.count > 0) {
        
        if(_editingScheduleIndex < 0) {
            _editingScheduleIndex = 0;
        } else if(_editingScheduleIndex >= arySchedule.count) {
            _editingScheduleIndex = (int)arySchedule.count  - 1;
        }
    } else {
        _editingScheduleIndex = -1;
    }
    
    [self.tvSchedules reloadData];
    
    [self loadCurrentEditingSchedule];
}

- (void) loadCurrentEditingSchedule
{
    UserServiceScheduleInfo *schedule = [self getCurrentEditingSchedule];
    
    if(schedule == nil) return;
    
    self.lblRate.text = [NSString stringWithFormat:@"$%d /hr", schedule.user_service_rate];
    
    if(schedule.user_service_anytime == 1) {
        [self.btnAnytime setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
    } else {
        [self.btnAnytime setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    }
    
    [self.btnStarttime setTitle:schedule.startTime forState:UIControlStateNormal];
    [self.btnEndtime setTitle:schedule.endTime forState:UIControlStateNormal];
    
    if(schedule.aryDates.count == 0) {
        [self.btnAnyDays setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        
        [self.btnMonday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        [self.btnTuesday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        [self.btnWedneday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        [self.btnThursday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        [self.btnFriday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        [self.btnSaturday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        [self.btnSunday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    } else {
        [self.btnAnyDays setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        
        if([schedule.aryDates containsObject:@"1"])
            [self.btnMonday setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        else
            [self.btnMonday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        
        if([schedule.aryDates containsObject:@"2"])
            [self.btnTuesday setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        else
            [self.btnTuesday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        
        if([schedule.aryDates containsObject:@"3"])
            [self.btnWedneday setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        else
            [self.btnWedneday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        
        if([schedule.aryDates containsObject:@"4"])
            [self.btnThursday setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        else
            [self.btnThursday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        
        if([schedule.aryDates containsObject:@"5"])
            [self.btnFriday setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        else
            [self.btnFriday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        
        if([schedule.aryDates containsObject:@"6"])
            [self.btnSaturday setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        else
            [self.btnSaturday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
        
        if([schedule.aryDates containsObject:@"7"])
            [self.btnSunday setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        else
            [self.btnSunday setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    }
}

- (void) repositionViews
{
    float heightSchedulesView = 60 + _editingServiceInfo.service_schedule.count * CELL_SCHEDULE_HEIGHT;
    
    self.viewSchedules.frame = CGRectMake(self.viewSchedules.frame.origin.x, self.viewSchedules.frame.origin.y,
                                          self.viewSchedules.frame.size.width, heightSchedulesView);
    
    self.viewEditSchedule.frame = CGRectMake(self.viewEditSchedule.frame.origin.x, self.viewSchedules.frame.origin.y + heightSchedulesView,
                                             self.viewEditSchedule.frame.size.width, self.viewEditSchedule.frame.size.height);
    
    self.svMain.contentSize = CGSizeMake(self.svMain.frame.size.width, self.viewEditSchedule.frame.origin.y + self.viewEditSchedule.frame.size.height);
    self.viewMain.frame = CGRectMake(0, 0, self.svMain.contentSize.width, self.svMain.contentSize.height);
}

- (IBAction)onBack:(id)sender
{
    [self hideKeyboard];
    
    [self back];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender
{
    [self hideKeyboard];
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"What do you want."
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Apply to all", nil];
    
    [actionsheet showInView:self.view];
}

- (IBAction)onUpdate:(id)sender
{
    [self hideKeyboard];
    
    _editingServiceInfo.service_description = self.txtDesc.text;
    _editingServiceInfo.service_more_info = self.txtMoreInfo.text;
    
    [self reqUpdateService:NO];
}

- (IBAction)onReturn:(id)sender
{
    [self hideKeyboard];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:@"You will lose current datas. \nAre you sure."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             [self runUIProcess:@selector(returnToOrigin)];
                        }];
    
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onChangeRadius:(id)sender
{
    int radius = _editingServiceInfo.service_radius;
    
    [self showPickerViewWithType:PICKER_TYPE_RADIUS defaultValue:radius];
}

- (IBAction)onChangeRate:(id)sender
{
    NSArray *arySchedule = _editingServiceInfo.service_schedule;
    
    if(_editingScheduleIndex < arySchedule.count) {
        
        UserServiceScheduleInfo *schedule = [arySchedule objectAtIndex:_editingScheduleIndex];
        
        int rate = schedule.user_service_rate;
        
        [self showPickerViewWithType:PICKER_TYPE_RATE defaultValue:rate];
    }
}

- (IBAction)onAddSchedule:(id)sender
{
    [self hideKeyboard];
    
    UserServiceScheduleInfo *schedule = [[UserServiceScheduleInfo alloc] init];
    schedule.user_service_id = _editingServiceInfo.user_service_id;
    
    [_editingServiceInfo.service_schedule addObject:schedule];
    
    _editingScheduleIndex = _editingServiceInfo.service_schedule.count - 1;
    
    [self loadServiceInfo];
}

- (IBAction)onDeleteSchedule:(id)sender
{
    [self hideKeyboard];
    
    if(_editingScheduleIndex > -1 && _editingScheduleIndex < _editingServiceInfo.service_schedule.count) {
        [_editingServiceInfo.service_schedule removeObjectAtIndex:_editingScheduleIndex];
    }
    
    if(_editingServiceInfo.service_schedule.count == 0) {
        _editingScheduleIndex = -1;
    }
    
    _editingScheduleIndex = MIN(_editingServiceInfo.service_schedule.count - 1, _editingScheduleIndex);
    
    [self loadServiceInfo];
}

- (IBAction)onAnytime:(id)sender
{
    [self hideKeyboard];
    
    UserServiceScheduleInfo *schedule = [self getCurrentEditingSchedule];
    
    if(schedule == nil) return;
    
    schedule.user_service_anytime = 1 - schedule.user_service_anytime;
    
    [self loadServiceInfo];
}

- (IBAction)onStarttime:(id)sender
{
    UserServiceScheduleInfo *schedule = [self getCurrentEditingSchedule];
    
    if(schedule == nil) return;
    
//    if(schedule.user_service_anytime == 1) {
//        
//        [self showAlert:APP_NAME withMsg:@"You can't select a time on \"Any Time\" mode."];
//        
//        return;
//    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:TIME_FORMAT];
    
    NSDate *startTime = [formatter dateFromString:schedule.startTime];
    
    [self showTimePickerViewWithType:0 time:startTime];
}

- (IBAction)onEndtime:(id)sender
{
    UserServiceScheduleInfo *schedule = [self getCurrentEditingSchedule];
    
    if(schedule == nil) return;
    
//    if(schedule.user_service_anytime == 1) {
//        
//        [self showAlert:APP_NAME withMsg:@"You can't select a time on \"Any Time\" mode."];
//        
//        return;
//    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:TIME_FORMAT];
    
    NSDate *endTime = [formatter dateFromString:schedule.endTime];
    
    [self showTimePickerViewWithType:1 time:endTime];
}

- (IBAction)onDates:(id)sender
{
    [self hideKeyboard];
    
    UserServiceScheduleInfo *schedule = [self getCurrentEditingSchedule];
    
    if(schedule == nil) return;
    
    NSInteger date = ((UIButton *)sender).tag;
    
    if(date == 0) {
        [schedule.aryDates removeAllObjects];
    } else {
        NSString *dateString = [NSString stringWithFormat: @"%ld", (long)date];
        NSInteger indexOfObject = [schedule.aryDates indexOfObject:dateString];
        
        if(indexOfObject != NSNotFound) {
            [schedule.aryDates removeObjectAtIndex:indexOfObject];
        } else {
            [schedule.aryDates addObject:dateString];
        }
        
        if(schedule.aryDates.count == 7) {
            [schedule.aryDates removeAllObjects];
        }
    }
    
    [self loadServiceInfo];
}

- (UserServiceScheduleInfo *) getCurrentEditingSchedule
{
    NSArray *arySchedule = _editingServiceInfo.service_schedule;
    
    if(_editingScheduleIndex < 0 || _editingScheduleIndex >= arySchedule.count)
        return nil;
    
    UserServiceScheduleInfo *schedule = [arySchedule objectAtIndex:_editingScheduleIndex];
    
    return schedule;
}

- (void) returnToOrigin
{
    _editingServiceInfo = [self.userService clone];
    
    [self loadServiceInfo];
}

- (void) pickedRateAndRadius:(NSInteger)type value:(NSInteger)valueIndex
{
    if(type == PICKER_TYPE_RADIUS) {
        _editingServiceInfo.service_radius = (int)valueIndex + 1;
    } else if(type == PICKER_TYPE_RATE) {
        NSArray *arySchedule = _editingServiceInfo.service_schedule;
        
        if(_editingScheduleIndex < arySchedule.count) {
            
            UserServiceScheduleInfo *schedule = [arySchedule objectAtIndex:_editingScheduleIndex];
            
            schedule.user_service_rate = ((int)valueIndex + 1) * 2;
        }
    }
    
    [self loadServiceInfo];
}

- (void) showPickerViewWithType:(int)type defaultValue:(int) value
{
    [self hideKeyboard];
    
    self.pickerView.tag = type;
    [self.pickerView reloadAllComponents];
    
    int row = 0;
    if(type == PICKER_TYPE_RADIUS) {
        row = value - 1;
    } else if(type == PICKER_TYPE_RATE) {
        row = value / 2 - 1;
    }
    
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
    
    [self pickedRateAndRadius:self.pickerView.tag value:[self.pickerView selectedRowInComponent:0]];
}

- (void) pickedTime:(UIDatePicker *)picker
{
    UserServiceScheduleInfo *schedule = [self getCurrentEditingSchedule];
    if(schedule == nil) return;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:TIME_FORMAT];
    
    NSDate *date = picker.date;
    NSString *time = [formatter stringFromDate:date];
    
    NSInteger tag = picker.tag;
    if(tag == 0) {
        schedule.startTime = time;
    } else {
        schedule.endTime = time;
    }
    
    [self loadServiceInfo];
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

- (void) reqUpdateService:(BOOL) applyAll
{
    [self startActivityAnimation];
    
    self.reqType = REQ_UPDATE_SERVICE;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils reqUpdateUserService:_editingServiceInfo applyAll:applyAll];
}

- (void) completedUpdateService
{
    [self.userService copyDataWith:_editingServiceInfo];

    [self showAlert:APP_NAME withMsg:@"The service detail has been updated."];
}

- (void) reqDeleteService
{
    [self startActivityAnimation];
    
    self.reqType = REQ_DELETE_SERVICE;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils reqDeleteUserService:_editingServiceInfo.user_service_id];
}

- (void) completedDeleteService
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:@"The service is deleted."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             [self runUIProcess:@selector(back)];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) hideKeyboard
{
    [self.txtDesc resignFirstResponder];
    [self.txtMoreInfo resignFirstResponder];
}

#pragma mark UIPickViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger type = pickerView.tag;
    
    if(type == PICKER_TYPE_RADIUS) {
        return 30;
    } else if(type == PICKER_TYPE_RATE) {
        return 30;
    }
    
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    
    NSInteger type = pickerView.tag;
    
    if(type == PICKER_TYPE_RADIUS) {
        title = [NSString stringWithFormat:@"%d", (int)(row + 1)];
    } else if(type == PICKER_TYPE_RATE) {
        title = [NSString stringWithFormat:@"%d", (int)(row + 1) * 2];
    }
    
    return title;
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _editingServiceInfo.service_schedule.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_SCHEDULE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(_editingScheduleIndex == indexPath.row) {
        cell.viewMain.backgroundColor = [UIColor colorWithRed:240.0f / 255.0f green:240.0f / 255.0f  blue:240.0f / 255.0f alpha:1.0f];
    } else {
        cell.viewMain.backgroundColor = [UIColor whiteColor];
    }
    
    UserServiceScheduleInfo *schedule = [_editingServiceInfo.service_schedule objectAtIndex:indexPath.row];
    
    cell.lblRate.text = [NSString stringWithFormat:@"$%d/hr", schedule.user_service_rate];
    cell.lblDates.text = [DataManager getDatesString:schedule.aryDates];
    
    if(schedule.user_service_anytime == 1)
        cell.lblTime.text = @"Any Time";
    else
        cell.lblTime.text = [NSString stringWithFormat:@"%@ to %@", schedule.startTime, schedule.endTime];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _editingScheduleIndex = indexPath.row;
    
    [self loadServiceInfo];
}

#pragma mark -- UITextFieldDelegate

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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _editingServiceInfo.service_more_info = self.txtMoreInfo.text;
}

#pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *currentDesc = self.txtDesc.text;
    if(![currentDesc isEqualToString:PLACEHOLD_SERVICE_DESCRIPTION]) {
        _editingServiceInfo.service_description = self.txtDesc.text;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *currentDesc = self.txtDesc.text;
    
    if([currentDesc isEqualToString:PLACEHOLD_SERVICE_DESCRIPTION]) {
        self.txtDesc.text = @"";
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSString *currentDesc = self.txtDesc.text;
    
    if(currentDesc.length == 0) {
        self.txtDesc.text = PLACEHOLD_SERVICE_DESCRIPTION;
    }
    
    return YES;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.txtDesc resignFirstResponder];
}

#pragma mark Manage Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"Keyboard is active.");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.svMain.contentInset = contentInsets;
    self.svMain.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.txtMoreInfo.frame.origin) ) {
//        [self.svMain scrollRectToVisible:self.txtMoreInfo.frame animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSLog(@"Keyboard is hidden");
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.svMain.contentInset = contentInsets;
    self.svMain.scrollIndicatorInsets = contentInsets;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self reqDeleteService];
    } else if(buttonIndex == 1) {
        [self reqUpdateService:YES];
    }
}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];
    
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    
    if(success) {
        
        if(self.reqType == REQ_UPDATE_SERVICE) {
            [self completedUpdateService];
        } else if(self.reqType == REQ_DELETE_SERVICE) {
            [self completedDeleteService];
        }
        
    } else {
        
        if(self.reqType == REQ_UPDATE_SERVICE) {
            [self showAlert:APP_NAME withMsg:@"Failed to update your service."];
        } else if(self.reqType == REQ_DELETE_SERVICE) {
            [self showAlert:APP_NAME withMsg:@"Failed to delete your service."];
        }
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    if(self.reqType == REQ_UPDATE_SERVICE) {
        [self showAlert:APP_NAME withMsg:@"Failed to update your service."];
    } else if(self.reqType == REQ_DELETE_SERVICE) {
        [self showAlert:APP_NAME withMsg:@"Failed to delete your service."];
    }
}

@end
