//
//  errorViewController.m
//  wearThe
//
//  Created by Brendon on 29/07/2014.
//  Copyright (c) 2014 wearthe. All rights reserved.
//

#import "errorViewController.h"
#import "Reachability.h"

@interface errorViewController ()

@end

@implementation errorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tryAgainClicked:(id)sender
{
    if ([errorType isEqualToString:@"Location"])
    {
        if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
        {
            NSLog(@"Location Services turned on.");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"Location Services turned off.");
        }
    }
    else if ([errorType isEqualToString:@"Internet"])
    {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            NSLog(@"There IS NO internet connection");
        }
        
        else
        {
            NSLog(@"There IS internet connection");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        

    }
    
}
@end
