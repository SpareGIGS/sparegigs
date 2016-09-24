//
//  MessageViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MessageViewController.h"

#import "HireProviderViewController.h"
#import "ProviderProfileViewController.h"

#import "ConnectionUtils.h"
#import "DataManager.h"

#import "MessageInfo.h"

#import "MyMessageTableViewCell.h"
#import "MessageTableViewCell.h"

#define KEYBOARD_HEIGHT 216
#define MESSAGE_VIEW_MIN_HEIGHT 56

@interface MessageViewController ()<SDKProtocol, UIActionSheetDelegate>
{
    NSTimer *_timer;

    NSString *_lastGetMessageTime;
    
    NSString *_sendingMsg;
}

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIView *viewMain;

@property (nonatomic, weak) IBOutlet UITableView *tvMessages;

@property (nonatomic, weak) IBOutlet UIView *viewMessage;
@property (nonatomic, weak) IBOutlet UITextView *txtMessage;

@property (nonatomic, retain) NSMutableArray *aryMessages;

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onSend:(id)sender;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.aryMessages == nil) {
        self.aryMessages = [[NSMutableArray alloc] init];
    }
    
    self.txtMessage.text = PLACEHOLD_TYPE_MESSAGE;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performHideKeyboard)];
    [self.tvMessages addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopGetMessageTimer];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadRoomInfo];
    [self runGetMessageTimer];
}

- (void) loadRoomInfo
{
    self.lblTitle.text = [self.room getOpportunityName];
}

- (void) loadMessages:(BOOL) scrollToBottom
{
    [self.tvMessages reloadData];
    
    if(scrollToBottom) {
        [self scrollToBottomWithTableView];
    }
}

- (IBAction)onBack:(id)sender
{
    [self back];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender
{
    [self.txtMessage resignFirstResponder];
    
    if([self.room isClient]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"View Profile", @"Send Email", @"Dial Phone", @"Hire Provider", nil];
        
        [actionSheet showInView:self.view];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"View Profile", @"Send Email", @"Dial Phone", nil];
        
        [actionSheet showInView:self.view];
    }
}

- (IBAction)onSend:(id)sender
{
    [self onSendMessage];
}

- (void) onSendMessage
{
    NSString *message = self.txtMessage.text;
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(message.length == 0) {
        self.txtMessage.text = @"";
        return;
    }
    
    [self startActivityAnimation];
    
    _sendingMsg = message;
    if(self.reqType == REQ_NONE) {
        [self sendMessage];
    }
}

- (void) onHireProvider
{
    HireProviderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HireProviderViewController"];
    vc.room = self.room;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onDecline:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    MessageInfo *message = [self.aryMessages objectAtIndex:index];
    
    if([message isOffer]) {
        [self reqUpdateOffer:message.offerId state:HIRE_STATE_DECLINED];
    }
    
    message.offerState = HIRE_STATE_DECLINED;
    
    [self loadMessages:NO];
}

- (void) onAccept:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    MessageInfo *message = [self.aryMessages objectAtIndex:index];
    
    if([message isOffer]) {
        [self reqUpdateOffer:message.offerId state:HIRE_STATE_ACCEPTED];
    }
    
    message.offerState = HIRE_STATE_ACCEPTED;
    
    [self loadMessages:NO];
}

- (void) onViewProfile
{
    ProviderProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderProfileViewController"];
    vc.provider = [self.room getOpportunity];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onSendEmail
{
    NSString *email = [self.room getOpportunityEmail];
    
    [self sendEmailWith:email subject:@"" body:@""];
}

- (void) onDialPhone
{
    NSString *phone = [self.room getOpportunityPhoneNumber];
    
    [self callPhoneNumber:phone];
}

- (void) sendMessage
{
    if(_sendingMsg == nil) {
        [self stopActivityAnimation];
        return;
    }
    
    if(self.reqType != REQ_NONE)
        return;
    
    [self stopGetMessageTimer];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_SEND_MESSAGE;
    
    [connectionUtils sendMessage:self.room.roomId
                            user:[DataManager shareDataManager].user.userid
                         message:_sendingMsg];
}

- (void) completedSendMessage
{
    _sendingMsg = nil;
    self.reqType = REQ_NONE;
    
    self.txtMessage.text = @"";
    
    [self runGetMessageTimer];
}

- (void) shownKeyboard:(BOOL) isShown
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewMain.frame = CGRectMake(self.viewMain.frame.origin.x,
                                     self.viewMain.frame.origin.y,
                                     self.viewMain.frame.size.width,
                                     self.view.frame.size.height - self.viewMain.frame.origin.y - (isShown ? KEYBOARD_HEIGHT : 0));
    
    [self updateUI];

    //animate off screen
    [UIView commitAnimations];
}

- (void) performHideKeyboard
{
    [self.txtMessage resignFirstResponder];
}

- (void) updateUI
{
    CGSize textViewSize = [self.txtMessage.text sizeWithFont:self.txtMessage.font
                                           constrainedToSize:CGSizeMake(self.txtMessage.frame.size.width, FLT_MAX)
                                               lineBreakMode:UILineBreakModeTailTruncation];
    
    float messageViewHeight = textViewSize.height + 40;
    if(messageViewHeight < MESSAGE_VIEW_MIN_HEIGHT) messageViewHeight = MESSAGE_VIEW_MIN_HEIGHT;
    
    self.tvMessages.frame = CGRectMake(self.tvMessages.frame.origin.x,
                                       self.tvMessages.frame.origin.y,
                                       self.tvMessages.frame.size.width,
                                       self.viewMain.frame.size.height - messageViewHeight);
    
    self.viewMessage.frame = CGRectMake(self.viewMessage.frame.origin.x,
                                        self.viewMain.frame.size.height - messageViewHeight,
                                        self.viewMessage.frame.size.width,
                                        messageViewHeight);
    
    [self scrollToBottomWithTableView];
}

- (void) scrollToBottomWithTableView
{
    if(self.aryMessages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.aryMessages.count - 1) inSection:0];
        
        [self.tvMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void) runGetMessageTimer
{
    [self stopGetMessageTimer];
    
    [self getMessages];
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateGettingMessageTimer) userInfo:nil repeats:YES];
}

- (void) stopGetMessageTimer
{
    if(_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) updateGettingMessageTimer
{
    [self getMessages];
}

- (void) getMessages
{
    if(self.reqType != REQ_NONE) return;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_GET_MESSAGES;
    
    [connectionUtils getMessages:self.room.roomId
                            last:[self getLastMessageTime]];
}

- (void) completedGetMessages:(NSDictionary *)res
{
    NSLog(@"%@", res);
    
    NSString *lastGetTime = [res objectForKey:@"last_get_time"];
    if(lastGetTime != nil && lastGetTime.length > 0) {
        _lastGetMessageTime = lastGetTime;
    }
    NSObject *data = [res objectForKey:@"data"];
    
    BOOL isAnyData = NO;
    if([data isKindOfClass:[NSArray class]]) {
        NSArray *aryData = (NSArray *)data;
        for (int index = 0 ; index < aryData.count ; index ++) {
            NSDictionary *message = [aryData objectAtIndex:index];
            MessageInfo *messageInfo = [[MessageInfo alloc] initWithDictionary:message];
            
            [self.aryMessages addObject:messageInfo];
            isAnyData = YES;
        }
    }
    
    [self loadMessages:isAnyData];
    
    self.reqType = REQ_NONE;
    
    if(_sendingMsg != nil) {
        [self sendMessage];
    }
}

- (void) reqUpdateOffer:(NSString *)offerId state:(int)state
{
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    
    [connectionUtils updateOffer:offerId state:state];
}

- (NSString *)getLastMessageTime
{
    NSString *time = @"all";
    
    if(_lastGetMessageTime != nil) {
        time = _lastGetMessageTime;
    }
    
    return time;
}

#pragma mark -- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(self.txtMessage == textView) {
        
        if([self.txtMessage.text isEqualToString:PLACEHOLD_TYPE_MESSAGE]) {
            self.txtMessage.text = @"";
        }
        
        [self shownKeyboard:YES];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(self.txtMessage == textView) {
        
        if(self.txtMessage.text.length == 0) {
            self.txtMessage.text = PLACEHOLD_TYPE_MESSAGE;
        }
        
        [self shownKeyboard:NO];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(self.txtMessage == textView) {
        if(self.txtMessage.text.length == 255) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateUI];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self onViewProfile];
    } else if(buttonIndex == 1) {
        [self onSendEmail];
    } else if(buttonIndex == 2) {
        [self onDialPhone];
    } else if(buttonIndex == 3) {
         if([self.room isClient]) {
             [self onHireProvider];
         }
    }
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfo *message = [self.aryMessages objectAtIndex:indexPath.row];
    
    float height = 0.0f;
    if([message fromMe]) {
        height = [MyMessageTableViewCell getHeight:message width:self.tvMessages.frame.size.width];
        
    } else {
        height = [MessageTableViewCell getHeight:message width:self.tvMessages.frame.size.width];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    MessageInfo *message = [self.aryMessages objectAtIndex:indexPath.row];
    
    if([message fromMe]) {
        MyMessageTableViewCell *messageCell = (MyMessageTableViewCell *)cell;
        if (messageCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyMessageTableViewCell" owner:self options:nil];
            messageCell = [nib objectAtIndex:0];
        }
        
        [messageCell setMessage:message];
        
        cell = (UITableViewCell *)messageCell;
        
    } else {
        MessageTableViewCell *messageCell = (MessageTableViewCell *)cell;
        if (messageCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil];
            messageCell = [nib objectAtIndex:0];
        }
        
        [messageCell setMessage:message];
        
        if([message isPenddingOffer]) {
            messageCell.btnDecline.tag = indexPath.row;
            [messageCell.btnDecline addTarget:self action:@selector(onDecline:) forControlEvents:UIControlEventTouchUpInside];
            messageCell.btnAccept.tag = indexPath.row;
            [messageCell.btnAccept addTarget:self action:@selector(onAccept:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell = (UITableViewCell *)messageCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
                
                if(self.reqType == REQ_GET_MESSAGES) {
                    [self completedGetMessages:res];
                } else if(self.reqType == REQ_SEND_MESSAGE) {
                    [self completedSendMessage];
                }
            });
        });
        
    } else {
        
        self.reqType = REQ_NONE;
        
        if(self.reqType == REQ_GET_MESSAGES) {
            
        } else if(self.reqType == REQ_SEND_MESSAGE) {
            [self showAlert:APP_NAME withMsg:@"Failed to send messages."];
            [self runGetMessageTimer];
        }
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    self.reqType = REQ_NONE;
}

@end
