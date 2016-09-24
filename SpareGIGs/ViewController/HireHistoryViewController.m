//
//  HireHistoryViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "HireHistoryViewController.h"

#import "HireProviderViewController.h"

#import "DataManager.h"
#import "HireInfo.h"

#import "HireTableViewCell.h"

#import "ConnectionUtils.h"

@interface HireHistoryViewController ()<UIActionSheetDelegate, SDKProtocol>
{

}

@property (nonatomic, retain) NSMutableArray *aryHires;

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblNoHires;
@property (nonatomic, weak) IBOutlet UITableView *tvHires;

- (IBAction)onBack:(id)sender;

@end

@implementation HireHistoryViewController

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
    
    [self reqHireHistory];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void) loadHires
{
    self.lblTitle.text = self.fromClient ? @"Hire History" : @"Services Offered";
    self.lblNoHires.hidden = (self.aryHires.count != 0);
    
    [self.tvHires reloadData];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Delete All", nil];
        
    [actionSheet showInView:self.view];
}

- (void) reqHireHistory
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_GET_HIRE_HISTORY;
    
    if(self.fromClient)
        [connectionUtils getHireHistory:[DataManager shareDataManager].user.userid];
    else
        [connectionUtils getOfferHistory:[DataManager shareDataManager].user.userid];
}

- (void) completeGetHireHistory:(NSObject *)res
{
    NSLog(@"%@", res);
    
    if(self.aryHires == nil) {
        self.aryHires = [[NSMutableArray alloc] init];
    }
    
    [self.aryHires removeAllObjects];
    
    if([res isKindOfClass:[NSArray class]]) {
        NSArray *aryHires = (NSArray *)res;
        for (int index = 0 ; index < aryHires.count ; index ++) {
            NSDictionary *hire = [aryHires objectAtIndex:index];
            HireInfo *hireInfo = [[HireInfo alloc] initWithDictionary:hire];
            [self.aryHires addObject:hireInfo];
        }
    }
    
    [self loadHires];
}

- (void) onClearAllHireHistory
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:@"Are you sure to clear all history?"
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
                             
                             [self reqClearHireHistory];
                         }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) reqClearHireHistory
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_CLEAR_HIRE_HISTORY;
    
    if(self.fromClient)
        [connectionUtils clearHireHistory:[DataManager shareDataManager].user.userid];
    else
        [connectionUtils clearOfferHistory:[DataManager shareDataManager].user.userid];
}

- (void) completeClearHireHistory
{
    [self.aryHires removeAllObjects];
    
    [self loadHires];
}

- (void) gotoHireScreen:(HireInfo *)hire
{
    HireProviderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HireProviderViewController"];
    vc.hireInfo = hire;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryHires.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HireInfo *hire = [self.aryHires objectAtIndex:indexPath.row];
    
    float height = 0;
    if(hire.rating > 0) {
        height = 120;
    } else {
        height = 90;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    HireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HireTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    HireInfo *hire = [self.aryHires objectAtIndex:indexPath.row];
    
    [cell setHireInfo:hire];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HireInfo *hire = [self.aryHires objectAtIndex:indexPath.row];
    
    [self gotoHireScreen:hire];
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
                
                if(self.reqType == REQ_GET_HIRE_HISTORY) {
                    [self completeGetHireHistory:data];
                } else if(self.reqType == REQ_CLEAR_HIRE_HISTORY) {
                    [self completeClearHireHistory];
                }
            });
        });
    } else {
        if(self.reqType == REQ_GET_HIRE_HISTORY) {
            [self showAlert:APP_NAME withMsg:@"Failed to get hire history."];
        } else if(self.reqType == REQ_CLEAR_HIRE_HISTORY) {
            [self showAlert:APP_NAME withMsg:@"Failed to clear hire history."];
        }
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
 
    if(self.reqType == REQ_GET_HIRE_HISTORY) {
        [self showAlert:APP_NAME withMsg:@"Failed to get hire history."];
    } else if(self.reqType == REQ_CLEAR_HIRE_HISTORY) {
        [self showAlert:APP_NAME withMsg:@"Failed to clear hire history."];
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self onClearAllHireHistory];
    }
}

@end
