//
//  ViewController.h
//  wearThe
//
//  Created by Brendon on 29/07/2014.
//  Copyright (c) 2014 wearthe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

bool firstTime;
bool tutorialDone;
int locationType;
NSString *location;
NSString *gender;
NSString *formality;
float latitude;
float longitude;
NSString *errorType;
NSString *userCity;
bool returnedFromSettings;

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageThree;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *bottomsImage;
@property (weak, nonatomic) IBOutlet UIImageView *topPrimaryImage;
@property (weak, nonatomic) IBOutlet UIImageView *topSecondaryImage;


@property (weak, nonatomic) IBOutlet UILabel *sixAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *eightAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *twelveAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *eightPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenPMLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sixAMImage;
@property (weak, nonatomic) IBOutlet UIImageView *eightAMImage;
@property (weak, nonatomic) IBOutlet UIImageView *tenAMImage;
@property (weak, nonatomic) IBOutlet UIImageView *twelveAMImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoPMImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourPMImage;
@property (weak, nonatomic) IBOutlet UIImageView *sixPMImage;
@property (weak, nonatomic) IBOutlet UIImageView *eightPMImage;
@property (weak, nonatomic) IBOutlet UIImageView *tenPMImage;

@end
