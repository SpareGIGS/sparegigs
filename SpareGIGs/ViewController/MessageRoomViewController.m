//
//  MessageRoomViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MessageRoomViewController.h"

#import "MessageViewController.h"
#import "RoomTableViewCell.h"

#import "ConnectionUtils.h"
#import "DataManager.h"

@interface MessageRoomViewController ()<SDKProtocol>
{

}

@property (nonatomic, weak) IBOutlet UITableView *tvRooms;
@property (nonatomic, weak) IBOutlet UILabel *lblNoMessages;

@property (nonatomic, retain) NSMutableArray *aryRooms;

- (IBAction)onBack:(id)sender;

@end

@implementation MessageRoomViewController

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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getRooms];
}

- (void) loadRooms
{
    self.lblNoMessages.hidden = self.aryRooms.count != 0;
    [self.tvRooms reloadData];
}

- (IBAction)onBack:(id)sender
{
    [self back];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) gotoMessageScreen:(RoomInfo *) room
{
    MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.room = room;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) getRooms
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils getRooms:[DataManager shareDataManager].user.userid];
}

- (void) completedGetRoom:(NSObject *)res
{
    NSLog(@"%@", res);
    
    if(self.aryRooms == nil) {
        self.aryRooms = [[NSMutableArray alloc] init];
    }
    
    [self.aryRooms removeAllObjects];

    if([res isKindOfClass:[NSArray class]]) {
        NSArray *rooms = (NSArray *)res;
        for (int index = 0 ; index < rooms.count ; index ++) {
            NSDictionary *room = [rooms objectAtIndex:index];
            RoomInfo *roomInfo = [[RoomInfo alloc] initWithDictionary:room];
            [self.aryRooms addObject:roomInfo];
        }
    }
    
    [self loadRooms];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryRooms.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    RoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RoomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    RoomInfo *room = [self.aryRooms objectAtIndex:indexPath.row];
    
    if(room.isClient) {
        cell.lblName.text = [NSString stringWithFormat:@"%@", [room getOpportunityName]];
        cell.lblType.text = @"Service Provider";
        cell.lblServiceName.text = room.serviceName;
    } else {
        cell.lblName.text = [NSString stringWithFormat:@"%@", [room getOpportunityName]];
        cell.lblType.text = @"Service Seeker";
        cell.lblServiceName.text = room.serviceName;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomInfo *room = [self.aryRooms objectAtIndex:indexPath.row];
    
    [self gotoMessageScreen:room];
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
                [self completedGetRoom:data];
            });
        });
    } else {
        
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
}

@end
