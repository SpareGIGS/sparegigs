//
//  AddServiceViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "AddServiceViewController.h"

#import "ConnectionUtils.h"

#import "AddedServiceTableViewCell.h"

#import "DataManager.h"

@interface AddServiceViewController ()<SDKProtocol>
{
    NSMutableArray *_aryFilteredServices;
    NSMutableArray *_arySelectedServices;
    
    int _reqAddServiceIndex;
}

@property (nonatomic, weak) IBOutlet UITableView *tvServices;
@property (nonatomic, weak) IBOutlet UITableView *tvSelectedServices;

@property (nonatomic, weak) IBOutlet UIView *viewSelectedSection;
@property (nonatomic, weak) IBOutlet UIView *viewSelectSection;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;

@end

@implementation AddServiceViewController

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
    
    [self initializeServiceList];
}

- (void) initializeServiceList
{
    if([DataManager shareDataManager].aryServices == nil || [DataManager shareDataManager].aryServices.count == 0) {
        [self reqServiceList];
    } else {
        [self loadDatas];
    }
}

- (void) loadDatas
{
    [_aryFilteredServices removeAllObjects];
    
    if(_aryFilteredServices == nil) {
        _aryFilteredServices = [[NSMutableArray alloc] init];
    }
    
    NSArray *aryServices = [DataManager shareDataManager].aryServices;
    
    if(aryServices == nil) return;
    
    NSString *keyword = self.searchBar.text;
    for (int index = 0 ; index < aryServices.count ; index ++) {
        NSDictionary *service = [aryServices objectAtIndex:index];
        
        NSString *serviceId = [service objectForKey:@"service_id"];
        
        if(![[DataManager shareDataManager] checkMyServiceWithId:serviceId]) { // not my service
            if(keyword == nil || keyword.length == 0) { // not search
                [_aryFilteredServices addObject:service];
            } else {
                NSString *serviceName = [service objectForKey:@"service"];
                
                NSRange range = [serviceName rangeOfString:keyword];
                if(range.length > 0) {
                    [_aryFilteredServices addObject:service];
                }
            }
        }
    }
    
    [self.tvServices reloadData];
    [self.tvSelectedServices reloadData];
    
    float addedServiceSectionHeight = 0;
    
    NSInteger count = _arySelectedServices.count;
    if(count > 0) {
        if(count < 4) {
            addedServiceSectionHeight = CELL_ADDED_SERVICE_HEIGHT * count;
        } else {
            addedServiceSectionHeight = CELL_ADDED_SERVICE_HEIGHT * 3 + CELL_ADDED_SERVICE_HEIGHT / 2;
        }
    }
    
    self.viewSelectedSection.frame = CGRectMake(self.viewSelectedSection.frame.origin.x, self.viewSelectedSection.frame.origin.y,
                                                self.viewSelectedSection.frame.size.width, addedServiceSectionHeight);
    
    self.viewSelectSection.frame = CGRectMake(self.viewSelectSection.frame.origin.x, self.viewSelectedSection.frame.origin.y + addedServiceSectionHeight,
                                              self.viewSelectSection.frame.size.width, self.view.frame.size.height - self.viewSelectedSection.frame.origin.y + addedServiceSectionHeight);
}

- (IBAction)onBack:(id)sender
{
    [self back];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    if(_arySelectedServices == nil || _arySelectedServices.count == 0) {
        [self onBack:nil];
        return;
    }
    
    [self startActivityAnimation];
    
    _reqAddServiceIndex = 0;
    [self reqAddServiceToServer];
}

- (void) reqServiceList
{
    [self startActivityAnimation];
    
    self.reqType = REQ_SERVICE_LIST;
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils getServices];
}

- (void) completedGetServicesList:(NSArray *)aryServices
{
    if(aryServices == nil) return;
    
    [[DataManager shareDataManager] setServices:aryServices];
    
    [self runUIProcess:@selector(loadDatas)];
}

- (void) reqAddServiceToServer
{
    NSString *userid = [DataManager shareDataManager].user.userid;
    
    if (_reqAddServiceIndex < _arySelectedServices.count) {
        NSDictionary *service = [_arySelectedServices objectAtIndex:_reqAddServiceIndex];
        
        NSString *serviceId = [service objectForKey:@"service_id"];
        NSString *serviceName = [service objectForKey:@"service"];
        
        UserServiceInfo *userService = [[UserServiceInfo alloc] initWithUserId:userid serviceId:serviceId serviceName:serviceName];
        
        [self reqAddOneServiceToServer:userService];
    } else {
        [self stopActivityAnimation];
        
        [self runUIProcess:@selector(back)];
    }
}

- (void) reqAddOneServiceToServer:(UserServiceInfo *)service
{
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_ADD_SERVICE;
    
    [connectionUtils reqAddNewService:service];
}

- (void) completedReqAddOneServiceToServer
{
    _reqAddServiceIndex ++;
    
    [self reqAddServiceToServer];
}

- (void) removeAddedService:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    if(index < _arySelectedServices.count) {
        [_arySelectedServices removeObjectAtIndex:index];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        NSArray *aryIndexPaths = @[indexPath];
        [self.tvSelectedServices deleteRowsAtIndexPaths:aryIndexPaths withRowAnimation:UITableViewRowAnimationRight];
        
        [self performSelector:@selector(loadDatas) withObject:nil afterDelay:0.5f];
    }
}

- (BOOL) isAddedService:(NSDictionary *)service
{
    if(_arySelectedServices == nil) return NO;
    
    NSUInteger index = [_arySelectedServices indexOfObject:service];
    
    return index != NSNotFound;
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    if(self.tvServices == tableView) {
        count = _aryFilteredServices.count;
    } else if(self.tvSelectedServices == tableView) {
        count = _arySelectedServices.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_ADDED_SERVICE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(self.tvServices == tableView) {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        NSDictionary *service = [_aryFilteredServices objectAtIndex:indexPath.row];
        NSString *serviceName = [service objectForKey:@"service"];
        
        cell.textLabel.text = serviceName;
        
    } else {
        AddedServiceTableViewCell *addedServiceTableViewCell = (AddedServiceTableViewCell *)cell;
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddedServiceTableViewCell" owner:self options:nil];
            addedServiceTableViewCell = [nib objectAtIndex:0];
        }
        
        NSDictionary *service = [_arySelectedServices objectAtIndex:indexPath.row];
        NSString *serviceName = [service objectForKey:@"service"];
        
        addedServiceTableViewCell.lblTitle.text = serviceName;
        addedServiceTableViewCell.btnRemove.tag = indexPath.row;
        [addedServiceTableViewCell.btnRemove addTarget:self action:@selector(removeAddedService:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = addedServiceTableViewCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tvServices == tableView) {
        NSDictionary *service = [_aryFilteredServices objectAtIndex:indexPath.row];
        
        if(![self isAddedService:service]) {
            if(_arySelectedServices == nil ) {
                _arySelectedServices = [[NSMutableArray alloc] init];
            }
            
            [_arySelectedServices addObject:service];
            
            [self runUIProcess:@selector(loadDatas)];
        }
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self runUIProcess:@selector(loadDatas)];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    
    [self runUIProcess:@selector(loadDatas)];
}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    
    if(success) {
        
        if(self.reqType == REQ_SERVICE_LIST) {
            
            [self stopActivityAnimation];
            
            NSArray *aryServices = [res objectForKey:@"data"];
            [self completedGetServicesList:aryServices];
        } else if(self.reqType == REQ_ADD_SERVICE) {
            [self completedReqAddOneServiceToServer];
        }
        
    } else {
        
        [self stopActivityAnimation];
        
        if(self.reqType == REQ_SERVICE_LIST) {
            [self showAlert:APP_NAME withMsg:@"Failed to get services."];
        } else if(self.reqType == REQ_ADD_SERVICE) {
            [self showAlert:APP_NAME withMsg:@"Failed to add service."];
        }
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    [self showAlert:APP_NAME withMsg:@"Failed to get services. Please check your network."];
}

@end
