//
//  SettingsViewController.h
//  wearThe
//
//  Created by Brendon on 29/07/2014.
//  Copyright (c) 2014 wearthe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface SettingsViewController : UIViewController <UIAlertViewDelegate>

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *formalityControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationControl;
@property (weak, nonatomic) IBOutlet UITextField *locationSearch;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchValidationLabel;
@property (weak, nonatomic) IBOutlet UIView *blurredView;
@property (weak, nonatomic) IBOutlet UIView *transparentView;
- (IBAction)buttonBackClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationEnteredLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UIButton *removeBlur;
- (IBAction)removeBlurFunc:(id)sender;
@end
