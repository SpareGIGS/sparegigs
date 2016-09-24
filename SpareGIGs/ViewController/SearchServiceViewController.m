//
//  SearchServiceViewController.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "SearchServiceViewController.h"

#import "MessageViewController.h"
#import "ProviderProfileViewController.h"

#import "AppDelegate.h"

#import "ConnectionUtils.h"
#import "DataManager.h"

#import "MyAnnotation.h"

@interface SearchServiceViewController ()<SDKProtocol, UIActionSheetDelegate>
{
    NSArray *_aryProviders;
    
    NSDictionary *_currentProvider;
    NSDictionary *_currentService;
}

@property (nonatomic, weak) IBOutlet UITextField *txtSearch;
@property (nonatomic, weak) IBOutlet UILabel *lblLocation;
@property (nonatomic, weak) IBOutlet UILabel *lblDate;
@property (nonatomic, weak) IBOutlet UILabel *lblDistance;

@property (nonatomic, weak) IBOutlet UIView *viewPickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, weak) IBOutlet UIView *viewTimePickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *timePickerView;

@property (nonatomic, weak) IBOutlet UIView *viewSearchKeyword;
@property (nonatomic, weak) IBOutlet UIView *viewLocation;
@property (nonatomic, weak) IBOutlet UIView *viewDate;
@property (nonatomic, weak) IBOutlet UIView *viewDistance;

@property (nonatomic, weak) IBOutlet UIView *viewMap;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, weak) IBOutlet MKMapView *mainMapView;

///////////////////////// provider profile //////////////////////////////////

@property (nonatomic, weak) IBOutlet UIView *viewProvider;

@property (nonatomic, weak) IBOutlet UIView *viewProviderProfile;
@property (nonatomic, weak) IBOutlet UIImageView *ivProfile;
@property (nonatomic, weak) IBOutlet UILabel *lblProviderName;

@property (nonatomic, weak) IBOutlet UILabel *lblProviderRate;
@property (nonatomic, weak) IBOutlet UILabel *lblProviderAvailability;
@property (nonatomic, weak) IBOutlet UILabel *lblProviderMoreInfo;

@property (nonatomic, weak) IBOutlet UILabel *lblProviderOtherServices;

- (IBAction)onHideProviderView:(id)sender;
- (IBAction)onViewProviderProfile:(id)sender;
- (IBAction)onMessageProvider:(id)sender;
- (IBAction)onFavoriteProvider:(id)sender;

///////////////////////////////////////////////////////////


- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onSearch:(id)sender;
- (IBAction)onLocation:(id)sender;
- (IBAction)onDate:(id)sender;
- (IBAction)onDistance:(id)sender;

@end

@implementation SearchServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //////////////////////////////////////
    
    self.mainMapView.showsUserLocation = YES;
    self.mainMapView.mapType = MKMapTypeStandard;
    
    //////////////////////////////////////
    
    self.viewSearchKeyword.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewSearchKeyword.layer.borderWidth = 1.0f;
    
    self.viewLocation.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewLocation.layer.borderWidth = 1.0f;
    
    self.viewDate.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewDate.layer.borderWidth = 1.0f;
    
    self.viewDistance.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewDistance.layer.borderWidth = 1.0f;
    
    //////////////////////////////////////
    
    self.viewPickerView.hidden = YES;
    self.viewPickerView.alpha = 0.0f;
    
    self.viewTimePickerView.hidden = YES;
    self.viewTimePickerView.alpha = 0.0f;
    
    self.viewMap.hidden = YES;
    self.viewMap.alpha = 0.0f;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    //////////////////////////////////////
    
    [self.viewProvider setCenter:CGPointMake(self.view.frame.size.width / 2,
                                             self.view.frame.size.height + self.viewProvider.frame.size.height / 2 )];
    
    self.viewProviderProfile.layer.cornerRadius = self.viewProviderProfile.frame.size.height / 2; // this value vary as per your desire
    self.viewProviderProfile.clipsToBounds = YES;
    
    self.ivProfile.layer.cornerRadius = self.ivProfile.frame.size.height / 2; // this value vary as per your desire
    self.ivProfile.clipsToBounds = YES;
    
    //////////////////////////////////////
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)];
    [self.viewPickerView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePickerView)];
    [self.viewTimePickerView addGestureRecognizer:gesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLocationFromMap)];
    [self.viewMap addGestureRecognizer:tapGesture2];

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
    
    [self updateFilterData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[DataManager shareDataManager].searchFilterInfo save];
}

- (void) updateFilterData
{
    [self loadSearchFilterDatas];
    [self showAllProviders];
}

- (void) loadSearchFilterDatas
{
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
    self.txtSearch.text = filter.keyword;
    self.lblDistance.text = [NSString stringWithFormat:@"%d (Miles)", (int)filter.distance];
    self.lblDate.text = filter.date;
    self.lblLocation.text = filter.location;
}

- (void) showAllProviders
{
    NSMutableArray *aryLocations=[[NSMutableArray alloc]init];
    
    CLLocation *location = [self addMyPin:aryLocations];
    
    double minLat = 37.785834 , maxLat = 37.785834 , minLng = -122.406417 , maxLng = -122.406417;
    
    if(location) {
        minLat = location.coordinate.latitude;
        maxLat = location.coordinate.latitude;
        minLng = location.coordinate.longitude;
        maxLng = location.coordinate.longitude;
    }
    
    
    for (int i = 0 ; i < _aryProviders.count ; i ++) {
        
        NSDictionary *provider = [_aryProviders objectAtIndex:i];
        
        NSString *location = [provider objectForKey:@"zip_code"];
        NSArray *aryValues = [location componentsSeparatedByString:@","];
        
        if(aryValues.count != 2) {
            continue;
        }
        
        double lat = [[aryValues objectAtIndex:0] doubleValue];
        double lng = [[aryValues objectAtIndex:1] doubleValue];
        
        if(minLat > lat) {
            minLat = lat;
        }
        
        if(maxLat < lat) {
            maxLat = lat;
        }
        
        if(minLng > lng) {
            minLng = lng;
        }
        
        if(maxLng < lng) {
            maxLng = lng;
        }
        
        CLLocationCoordinate2D annotationCoord;
        
        MyAnnotation *annotationPoint = [[MyAnnotation alloc] init];
        annotationCoord.latitude = lat;
        annotationCoord.longitude = lng;
        
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = [provider objectForKey:@"user_name"];
        annotationPoint.information = provider;

        [aryLocations addObject:annotationPoint];
    }
    
    double latDelta = (maxLat - minLat) / 2;
    double lngDelta = (maxLng - minLng) / 2;
    
    if(latDelta < 0.05) latDelta = 0.05;
    if(lngDelta < 0.05) lngDelta = 0.05;
    
    MKCoordinateRegion myRegion;
    MKCoordinateSpan span;
    
    span.latitudeDelta = latDelta;
    span.longitudeDelta = lngDelta;
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:(maxLat + minLat) / 2 longitude:(maxLng + minLng) / 2] ;
    
    myRegion.center = center.coordinate;
    myRegion.span=span;
    
    [self.mainMapView setRegion:myRegion animated:YES];
    
    [self.mainMapView removeAnnotations:[self.mainMapView annotations]];
    [self.mainMapView addAnnotations:aryLocations];
}

- (CLLocation *) addMyPin:(NSMutableArray*)locations
{
    NSString *location = [[DataManager shareDataManager] getAvailableLocation];
    NSArray *aryValues = [location componentsSeparatedByString:@","];
    
    if(aryValues.count != 2) {
        return nil;
    }
    
    double lat = [[aryValues objectAtIndex:0] doubleValue];
    double lng = [[aryValues objectAtIndex:1] doubleValue];
    
    CLLocationCoordinate2D annotationCoord;
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationCoord.latitude = lat;
    annotationCoord.longitude = lng;
    
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"I'am";
    
    [locations addObject:annotationPoint];
    
    return [[CLLocation alloc] initWithLatitude:lat longitude:lng];
}

- (IBAction)onMenu:(id)sender
{

}

- (IBAction)onBack:(id)sender
{
    [self back];
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSearch:(id)sender
{
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
//    if(filter.keyword.length == 0) {
//        [self showAlert:APP_NAME withMsg:@"Please input a keyword."];
//        
//        return;
//    }
    
    NSString *location = filter.location;
    if(location.length == 0) {
        [self showAlert:APP_NAME withMsg:@"Please select a service location. or you can set your service location on your profile."];
        
        return;
    }
    
    NSArray *aryValues = [location componentsSeparatedByString:@","];
    if(aryValues.count != 2) {
        [self showAlert:APP_NAME withMsg:@"Please select a valid location."];
        return;
    }
    
    if(filter.distance == 0) {
        [self showAlert:APP_NAME withMsg:@"Please select a distance."];
        
        return;
    }
    
    NSString *day = filter.date;
    NSString *dateIndex = [self dateIndexStringWithDate:day];
    
    [self reqFindServices:dateIndex];
}

- (NSString *) dateIndexStringWithDate:(NSString *)day
{
    if(day.length == 0) {
        
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:SEARCH_DATE_FORMAT];
    
    NSDate *date = [dateFormatter dateFromString:day];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"EEEE"];
    
    NSString *weekday = [dateFormatter1 stringFromDate:date];
    
    NSString *dateIndex = @"";
    
    if([weekday isEqualToString:@"Monday"]) {
        dateIndex = @"1";
    } else if([weekday isEqualToString:@"Tuesday"]) {
        dateIndex = @"2";
    } else if([weekday isEqualToString:@"Wednesday"]) {
        dateIndex = @"3";
    } else if([weekday isEqualToString:@"Thursday"]) {
        dateIndex = @"4";
    } else if([weekday isEqualToString:@"Friday"]) {
        dateIndex = @"5";
    } else if([weekday isEqualToString:@"Saturday"]) {
        dateIndex = @"6";
    } else if([weekday isEqualToString:@"Sunday"]) {
        dateIndex = @"7";
    }
    return dateIndex;
}

- (IBAction)onLocation:(id)sender
{
    [self onSelectLocation];
}

- (IBAction)onDate:(id)sender
{
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
    NSDate *date = [NSDate date];
    if(filter.date.length > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:SEARCH_DATE_FORMAT];
        
        date = [dateFormatter dateFromString:filter.date];
    }
    
    [self showTimePickerViewWithType:date];
}

- (IBAction)onDistance:(id)sender
{
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
    [self showPickerView:filter.distance];
}

#pragma mark Search Services

- (void) reqFindServices:(NSString *)day
{
    [self startActivityAnimation];
    
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
    
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_FIND_SERVICES;
    
    [connectionUtils findServicesWith:[DataManager shareDataManager].user.userid
                             location:filter.location
                               radius:filter.distance
                                  day:day
                              keyword:filter.keyword];
}

- (void) completedFindService:(NSArray *)aryData
{
    NSLog(@"%@", aryData);
    
    _aryProviders = aryData;
    
    [self showAllProviders];
}

#pragma mark Provider Section

- (void) showProviderInfo:(NSDictionary *)providerInfo
{
    _currentProvider = providerInfo;
    
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    NSString *dateIndex = [self dateIndexStringWithDate:filter.date];
    
    self.lblProviderName.text = [providerInfo objectForKey:@"user_name"];
    
    NSArray *aryServices = [providerInfo objectForKey:@"services"];
    
    NSDictionary *fitService = nil;
    NSDictionary *fitSchedule = nil;
    NSString *otherServices = @"";
    for (int index = 0 ; index < aryServices.count; index ++) {
        NSDictionary *service = [aryServices objectAtIndex:index];
        
        NSString *serviceName = [service objectForKey:@"service_name"];
        
        NSRange range = [serviceName rangeOfString:filter.keyword];
        if(filter.keyword.length == 0 || range.length > 0) {
            
            NSArray *arySchedules = [service objectForKey:@"service_schedule"];
            BOOL isFitSchedule = false;
            for (int index = 0 ; index < arySchedules.count; index ++) {
                NSDictionary *schedule = [arySchedules objectAtIndex:index];
                
                NSString *days = [schedule objectForKey:@"days"];
                NSRange range = [days rangeOfString:dateIndex];
                
                if(range.length > 0 || dateIndex.length == 0) {
                    fitService = service;
                    fitSchedule = schedule;
                    
                    isFitSchedule = true;
                    break;
                }
            }
            
            if(!isFitSchedule) {
                if(otherServices.length == 0) {
                    otherServices = serviceName;
                } else {
                    otherServices = [NSString stringWithFormat:@"%@,%@", otherServices, serviceName];
                }
            }
            
        } else {
            if(otherServices.length == 0) {
                otherServices = serviceName;
            } else {
                otherServices = [NSString stringWithFormat:@"%@,%@", otherServices, serviceName];
            }
        }
    }
    
    self.lblProviderOtherServices.text = otherServices;
    
    if(fitService != nil) {
        self.lblProviderMoreInfo.text = [fitService objectForKey:@"more_info"];
    } else {
        self.lblProviderMoreInfo.text = @"";
    }
    
    if(fitSchedule != nil) {
        
        NSString *days = [fitSchedule objectForKey:@"days"];
        
        self.lblProviderAvailability.text = [self getRealWeekDates:days];
        self.lblProviderRate.text = [NSString stringWithFormat:@"$%@/hr", [fitSchedule objectForKey:@"price"]];
        
    } else {
        self.lblProviderAvailability.text = @" -- ";
        self.lblProviderRate.text = @" -- ";
    }
    
    _currentService = fitService;
    
    [self animationProviderView:YES];
}

- (NSString *) getRealWeekDates:(NSString *)dates
{
    dates = [dates stringByReplacingOccurrencesOfString:@"1" withString:@"Monday"];
    dates = [dates stringByReplacingOccurrencesOfString:@"2" withString:@"Tuesday"];
    dates = [dates stringByReplacingOccurrencesOfString:@"3" withString:@"Wednesday"];
    dates = [dates stringByReplacingOccurrencesOfString:@"4" withString:@"Thursday"];
    dates = [dates stringByReplacingOccurrencesOfString:@"5" withString:@"Friday"];
    dates = [dates stringByReplacingOccurrencesOfString:@"6" withString:@"Satday"];
    dates = [dates stringByReplacingOccurrencesOfString:@"7" withString:@"Sunday"];
    
    return dates;
}

- (IBAction)onHideProviderView:(id)sender
{
    [self animationProviderView:NO];
}

- (IBAction)onViewProviderProfile:(id)sender
{
    [self gotoProviderProfileView];
}

- (IBAction)onMessageProvider:(id)sender
{
    [self reqCreateRoom];
}

- (IBAction)onFavoriteProvider:(id)sender
{
    if(_currentProvider == nil) return;
    
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_ADD_FAVOR;
    
    [connectionUtils addFavorUser:[DataManager shareDataManager].user.userid opp:[_currentProvider objectForKey:@"user_id"]];
}

- (void) reqCreateRoom
{
    if(_currentProvider == nil) return;
    
    if(_currentService == nil) {
        [self showAlert:APP_NAME withMsg:@"There is no service."];
        
        return;
    }
    
    NSLog(@"%@", _currentProvider);
    NSLog(@"%@", _currentService);
    
    [self startActivityAnimation];
    
    ConnectionUtils *connectionUtils = [[ConnectionUtils alloc] init];
    connectionUtils.delegate = self;
    
    self.reqType = REQ_CREATE_ROOM;
    
    [connectionUtils createRoom:[DataManager shareDataManager].user.userid
                       provider:[_currentProvider objectForKey:@"user_id"]
                      serviceId:[_currentService objectForKey:@"service_id"]
                          title:[_currentService objectForKey:@"service_name"]];
}

- (void) completedCreateRoom:(NSObject *)res
{
    NSLog(@"%@", res);
    
    if([res isKindOfClass:[NSArray class]]) {
        NSArray *aryData = (NSArray *)res;
        if(aryData.count > 0) {
            NSDictionary *roomData = [aryData objectAtIndex:0];
            RoomInfo *room = [[RoomInfo alloc] initWithDictionary:roomData];
            
            [self gotoMessageScreen:room];
        }
    }
}

- (void) animationProviderView:(BOOL) show
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelegate:self];
    //position off screen
    [self.viewProvider setCenter:CGPointMake(self.view.frame.size.width / 2,
                                             self.view.frame.size.height - (show ?  self.viewProvider.frame.size.height / 2 : - self.viewProvider.frame.size.height / 2))];
    //[UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) gotoMessageScreen:(RoomInfo *)room
{
    MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.room = room;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) gotoProviderProfileView
{
    if(_currentProvider == nil) return;
    
    NSLog(@"%@", _currentProvider);
    
    ProviderProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderProfileViewController"];
    vc.provider = [[UserInfo alloc] initWithDictionary:_currentProvider];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Select Distance

- (void) showPickerView:(NSInteger) value
{
    [self.pickerView reloadAllComponents];
    
    NSInteger row = value - 1;
    
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
    
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    filter.distance = [self.pickerView selectedRowInComponent:0] + 1;
    
    [self updateFilterData];
}

#pragma mark Select Search Date

- (void) pickedTime:(UIDatePicker *)picker
{
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:SEARCH_DATE_FORMAT];
    
    NSDate *date = picker.date;
    filter.date = [formatter stringFromDate:date];
    
    [self updateFilterData];
}

- (void) showTimePickerViewWithType:(NSDate *) time
{
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

#pragma mark -Select Location

- (void) onSelectLocation
{
    [self.txtSearch resignFirstResponder];
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Select a location from"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Current Position"
                                                    otherButtonTitles:@"Map", nil];
    
    [actionsheet showInView:self.view];
}

- (void) selectCurrentPosition
{
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    filter.location = [delegate getCurrentPosition];
    
    [self updateFilterData];
}

- (void) selectFromMap
{
    [self showMapView];
}

- (void) showMapView
{
    self.viewMap.hidden = NO;
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewMap.alpha = 1.0f;
    [UIView setAnimationDidStopSelector:@selector(finishShowMapView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) finishShowMapView
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(delegate.currentLocation != nil) {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = delegate.currentLocation.coordinate;
        [self.mapView setRegion:region animated:YES];
    }
}

- (void) hideMapView
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    //position off screen
    self.viewMap.alpha = 0.0f;
    [UIView setAnimationDidStopSelector:@selector(finishHideMapView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) finishHideMapView
{
    self.viewMap.hidden = YES;
}

- (void) selectLocationFromMap
{
    [self hideMapView];
    
    SearchFilterInfo *filter = [DataManager shareDataManager].searchFilterInfo;
    
    NSString *location = [NSString stringWithFormat:@"%+.6f,%+.6f", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude];
    filter.location = location;
    
    [self updateFilterData];
}

#pragma mark --UITextFieldDelegate

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
    if(self.txtSearch == textField) {
        [textField resignFirstResponder];
        
        [DataManager shareDataManager].searchFilterInfo.keyword = textField.text;
        
        [self onSearch:nil];
    }

    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self selectCurrentPosition];
    } else if(buttonIndex == 1) {
        [self selectFromMap];
    }
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
    NSString *title = [NSString stringWithFormat:@"%d", (int)(row + 1)];
    
    return title;
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if(![annotation isKindOfClass:[MyAnnotation class]]) {
        return nil;
    }
    
    static NSString *reuseId = @"currentloc";
    
    MKAnnotationView *annView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (annView == nil)
    {
        annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        annView.image = [UIImage imageNamed:@"icon_pin"];
    }
    else
    {
        annView.annotation = annotation;
    }
    
    return annView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MyAnnotation *annotation = view.annotation;
    
    if([annotation isKindOfClass:[MyAnnotation class]]) {
        NSDictionary *provider = annotation.information;
        
        [self showProviderInfo:provider];
    }
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
                
                if(self.reqType == REQ_FIND_SERVICES) {
                    NSObject *aryData = [res objectForKey:@"data"];
                    if([aryData isKindOfClass:[NSArray class]]) {
                        [self completedFindService:(NSArray *)aryData];
                    }
                } else if(self.reqType == REQ_CREATE_ROOM) {
                    NSObject *room = [res objectForKey:@"data"];
                    [self completedCreateRoom:room];
                } else if(self.reqType == REQ_ADD_FAVOR) {
                    [self showAlert:APP_NAME withMsg:@"Added a provider as favorite."];
                }
            });
        });
        
    } else {
        
        if(self.reqType == REQ_FIND_SERVICES)
            [self showAlert:APP_NAME withMsg:@"Failed to find services."];
        else
            [self showAlert:APP_NAME withMsg:@"Failed to create room. Please check your network."];
    }
}

- (void)unregisterFailure:(NSError *)error
{
    [self stopActivityAnimation];
    
    if(self.reqType == REQ_FIND_SERVICES)
        [self showAlert:APP_NAME withMsg:@"Failed to get services. Please check your network."];
    else
        [self showAlert:APP_NAME withMsg:@"Failed to create room. Please check your network."];
}

@end
