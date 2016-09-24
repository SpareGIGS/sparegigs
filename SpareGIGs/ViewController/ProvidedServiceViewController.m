//
//  ProvidedServiceViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "ProvidedServiceViewController.h"

#import "AddServiceViewController.h"
#import "ServiceDetailViewController.h"
#import "MyServiceTableViewCell.h"
#import "MyServiceDetailTableViewCell.h"

#import "ConnectionUtils.h"

#import "DataManager.h"

@interface ProvidedServiceViewController ()<SDKProtocol>
{
    NSUInteger _selectedServiceIndex;
}

@property (nonatomic, weak) IBOutlet UILabel *lblNoServices;
@property (nonatomic, weak) IBOutlet UITableView *tvServices;

- (IBAction)onBack:(id)sender;
- (IBAction)onAdd:(id)sender;

@end

@implementation ProvidedServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _selectedServiceIndex = -1;
    
    self.lblNoServices.hidden = NO;
    self.tvServices.hidden = YES;
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
    
    [self reqUserServices];
}

- (void) loadData
{
    if(_selectedServiceIndex >= [DataManager shareDataManager].aryMyServices.count) {
        _selectedServiceIndex = [DataManager shareDataManager].aryMyServices.count - 1;
    }
    
    if([DataManager shareDataManager].aryMyServices.count == 0) {
        
        self.lblNoServices.hidden = NO;
        self.tvServices.hidden = YES;
        
    } else {
        
        self.lblNoServices.hidden = YES;
        self.tvServices.hidden = NO;
        
        if([DataManager shareDataManager].aryMyServices.count > 0 && _selectedServiceIndex == -1) {

            _selectedServiceIndex = 0;
        }
        
        [self.tvServices reloadData];
    }
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAdd:(id)sender
{
    [self gotoAddService];
}

- (void) gotoAddService
{
    AddServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddServiceViewController"];
    
    UINavigationController *nav = self.navigationController;
    
    [nav pushViewController:vc animated:YES];
}

- (void) openService:(UIButton *)sender
{
    UserServiceInfo *service = [[DataManager shareDataManager].aryMyServices objectAtIndex:sender.tag];
    
    [self gotoServiceDetailScreen:service];
}

- (void) gotoServiceDetailScreen:(UserServiceInfo *)userService
{
    ServiceDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceDetailViewController"];
    vc.userService = userService;
    
    UINavigationController *nav = self.navigationController;
    
    [nav pushViewController:vc animated:YES];
}

- (void) reqUserServices
{
    [self startActivityAnimation];
 
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils getUserServiceList:[DataManager shareDataManager].user.userid];
}

- (void) completedGetUserServices:(NSArray *)aryServices {
    
    [[DataManager shareDataManager].aryMyServices removeAllObjects];
    
    if(![aryServices isKindOfClass:[NSArray class]]) {
        
        [self runUIProcess:@selector(loadData)];
        return;
    }
    
    for (int index = 0 ; index < aryServices.count ; index ++) {
        
        NSDictionary *service = [aryServices objectAtIndex:index];

        UserServiceInfo *serviceInfo = [[UserServiceInfo alloc] init];
        [serviceInfo setDataWithDictionary:service];
        
        [[DataManager shareDataManager] addMyService:serviceInfo];
    }
    
    [self runUIProcess:@selector(loadData)];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataManager shareDataManager].aryMyServices.count + (_selectedServiceIndex == -1 ? 0 : 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _selectedServiceIndex + 1  && _selectedServiceIndex != -1) {
        UserServiceInfo *service = [[DataManager shareDataManager].aryMyServices objectAtIndex:_selectedServiceIndex];
        
        return [service getServiceCellHeight:self.tvServices.frame.size.width];
    }
    
    return CELL_MY_SERVICE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(indexPath.row == _selectedServiceIndex + 1  && _selectedServiceIndex != -1) {
        
        MyServiceDetailTableViewCell *serviceDetailCell = (MyServiceDetailTableViewCell *)cell;
        
        if (serviceDetailCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyServiceDetailTableViewCell" owner:self options:nil];
            serviceDetailCell = [nib objectAtIndex:0];
        }
        
        UserServiceInfo *service = [[DataManager shareDataManager].aryMyServices objectAtIndex:_selectedServiceIndex];
        
        [serviceDetailCell setSchedule:service.service_schedule];
        
        if(service.service_description.length == 0) {
            serviceDetailCell.lblDesc.text = @"There is no description.";
        } else {
            serviceDetailCell.lblDesc.text = service.service_description;
        }
        
        float descHeight = [service getServiceDescriptionHeight:self.tvServices.frame.size.width];
        float cellHeight = [service getServiceCellHeight:self.tvServices.frame.size.width];
        
        serviceDetailCell.lblDesc.frame = CGRectMake(16, 0, self.tvServices.frame.size.width - 32, descHeight);
        serviceDetailCell.tvSchedules.frame = CGRectMake(0, descHeight, self.tvServices.frame.size.width, cellHeight - descHeight);
        
        cell = (UITableViewCell *)serviceDetailCell;
        
    } else {
        MyServiceTableViewCell *serviceCell = (MyServiceTableViewCell *)cell;
        
        if (serviceCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyServiceTableViewCell" owner:self options:nil];
            serviceCell = [nib objectAtIndex:0];
        }
        
        NSUInteger realServiceIndex = indexPath.row;
        if(indexPath.row > _selectedServiceIndex  && _selectedServiceIndex != -1) {
            realServiceIndex --;
        }
        
        UserServiceInfo *service = [[DataManager shareDataManager].aryMyServices objectAtIndex:realServiceIndex];
        
        serviceCell.lblName.text = service.service_name;
        
        if(service.service_radius <= 0) {
            serviceCell.lblRadius.text = [NSString stringWithFormat:@"%d Mile", service.service_radius];
        } else {
            serviceCell.lblRadius.text = [NSString stringWithFormat:@"%d Miles", service.service_radius];
        }
        
        serviceCell.btnDetail.tag = realServiceIndex;
        [serviceCell.btnDetail addTarget:self action:@selector(openService:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = serviceCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectedServiceIndex == -1) {
        
        _selectedServiceIndex = indexPath.row;
        
    } else if (indexPath.row == _selectedServiceIndex + 1)  {
        return;
    } else if(indexPath.row != _selectedServiceIndex + 1) {
        
        NSUInteger realIndex = indexPath.row;
        if(indexPath.row > _selectedServiceIndex) {
            realIndex --;
        }
        
        _selectedServiceIndex = realIndex;
    }
    
    [self loadData];
}

#pragma mark -- SDKProtocal

- (void)unregisterSuccessful:(NSDictionary *)res
{
    [self stopActivityAnimation];
    
    NSLog(@"%@", res);
    
    BOOL success = [[res objectForKey:@"success"] boolValue];
    
    if(success) {
        
        NSArray *data = [res objectForKey:@"data"];
        
        [self completedGetUserServices:data];
        
    } else {
        [self showAlert:APP_NAME withMsg:@"Failed to get user services."];
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    [self showAlert:APP_NAME withMsg:@"Failed to get user services. Please check your network."];
}

@end
