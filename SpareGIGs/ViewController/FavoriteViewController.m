//
//  FavoriteViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "FavoriteViewController.h"

#import "ProviderProfileViewController.h"

#import "FavoriteTableViewCell.h"

#import "DataManager.h"
#import "HireInfo.h"

#import "ConnectionUtils.h"

@interface FavoriteViewController ()<SDKProtocol>
{

}

@property (nonatomic, retain) NSMutableArray *aryFavorites;

@property (nonatomic, weak) IBOutlet UILabel *lblNoFavorites;
@property (nonatomic, weak) IBOutlet UITableView *tvFavorites;

- (IBAction)onBack:(id)sender;

@end

@implementation FavoriteViewController

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
    
    [self reqFavorites];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void) loadFavorites
{
    self.lblNoFavorites.hidden = (self.aryFavorites.count > 0);
    
    [self.tvFavorites reloadData];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) reqFavorites
{
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    [connectionUtils getFavorUser:[DataManager shareDataManager].user.userid];
}

- (void) completeGetFavorite:(NSObject *)res
{
    NSLog(@"%@", res);
    
    if(self.aryFavorites == nil) {
        self.aryFavorites = [[NSMutableArray alloc] init];
    }
    
    [self.aryFavorites removeAllObjects];
    
    if([res isKindOfClass:[NSArray class]]) {
        NSArray *aryFavorites = (NSArray *)res;
        for (int index = 0 ; index < aryFavorites.count ; index ++) {
            NSDictionary *user = [aryFavorites objectAtIndex:index];
            UserInfo *userInfo = [[UserInfo alloc] initWithDictionary:user];
            [self.aryFavorites addObject:userInfo];
        }
    }
    
    [self loadFavorites];
}

- (void) gotoProfileScreen:(UserInfo *)user
{
    ProviderProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderProfileViewController"];
    vc.provider = user;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryFavorites.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoriteTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UserInfo *user = [self.aryFavorites objectAtIndex:indexPath.row];
    
    [cell setUserInfo:user];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *user = [self.aryFavorites objectAtIndex:indexPath.row];
    
    [self gotoProfileScreen:user];
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
                
                [self completeGetFavorite:data];
            });
        });
    } else {
        [self showAlert:APP_NAME withMsg:@"Failed to get favorites."];
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
 
    [self showAlert:APP_NAME withMsg:@"Failed to get favorites."];
}

@end
