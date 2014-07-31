//
//  SettingsViewController.m
//  wearThe
//
//  Created by Brendon on 29/07/2014.
//  Copyright (c) 2014 wearthe. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"

NSString *locationEntered;

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.blurredView.alpha = 0.0;
    self.blurredView.hidden = true;
    self.transparentView.alpha = 0.0;
    self.transparentView.hidden = true;
    self.locationEnteredLabel.hidden = true;
    [self performSelectorInBackground:@selector(captureBlur) withObject:nil];
    self.searchValidationLabel.hidden = true;
    self.searchLabel.hidden = true;
    self.locationSearch.hidden = true;
    [self.locationSearch setDelegate:self];
    
    [self.genderControl addTarget:self action:@selector(changedGenderControl:) forControlEvents:UIControlEventValueChanged];
    [self.formalityControl addTarget:self action:@selector(changedFormalityControl:) forControlEvents:UIControlEventValueChanged];
    [self.locationControl addTarget:self action:@selector(changedSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    if (tutorialDone == false)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Set Up wearThe"
                                                          message:@"Welcome to wearThe! You'll need to set up your settings."
                                                         delegate:nil
                                                cancelButtonTitle:@"Settings"
                                                otherButtonTitles:nil];
        
        [message show];
        
        firstTime = false;
        [[NSUserDefaults standardUserDefaults] setBool:firstTime forKey:@"firstTime"];
        
        if (self.locationControl.selectedSegmentIndex == 0)
        {
            self.locationEnteredLabel.text = userCity;
            locationType = 2;
        }
        
        if (self.genderControl.selectedSegmentIndex == 0)
        {
            gender = @"Male";
        }
        
        if (self.formalityControl.selectedSegmentIndex == 0)
        {
            formality = @"Informal";
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:locationType forKey:@"locationType"];
        [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"gender"];
        [[NSUserDefaults standardUserDefaults] setObject:formality forKey:@"formality"];

    }
    
    else if (tutorialDone == true)
    {
        locationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"locationType"];
        gender = [[NSUserDefaults standardUserDefaults] stringForKey:@"gender"];
        formality = [[NSUserDefaults standardUserDefaults] stringForKey:@"formality"];
        locationEntered = [[NSUserDefaults standardUserDefaults] stringForKey:@"locationEntered"];
        
        if (self.locationControl.selectedSegmentIndex == 0)
        {
            //location = CoreLocation
            locationType = 1;
        }
        else if (self.locationControl.selectedSegmentIndex == 1)
        {
            locationType = 2;
        }
        
        if ([gender  isEqual: @"Male"])
        {
            self.genderControl.selectedSegmentIndex = 0;
        }
        else if ([gender  isEqual: @"Female"])
        {
            self.genderControl.selectedSegmentIndex = 1;
        }
        
        if ([formality isEqual:@"Formal"])
        {
            self.formalityControl.selectedSegmentIndex = 1;
        }
        else if ([formality isEqual:@"Informal"])
        {
            self.formalityControl.selectedSegmentIndex = 0;
        }
    }
    
}

-(void)captureBlur
{
    NSLog(@"Blur Initialized");
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlur setValue:imageToBlur forKey:@"inputImage"];
    [gaussianBlur setValue:[NSNumber numberWithFloat:5] forKey:@"inputRadius"];
    CIImage *resultImage = [gaussianBlur valueForKey:@"outputImage"];
    
    UIImage *blurredImage = [[UIImage alloc] initWithCIImage:resultImage];
    
    UIImageView *newView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    newView.image = blurredImage;
    
    [self.blurredView insertSubview:newView belowSubview:self.transparentView];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)locationSearch
{

    [[NSUserDefaults standardUserDefaults] setInteger:locationType forKey:@"locationType"];
    [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setObject:formality forKey:@"formality"];
    tutorialDone = true;
    [[NSUserDefaults standardUserDefaults] setBool:tutorialDone forKey:@"tutorialDone"];
    [[NSUserDefaults standardUserDefaults] setObject:locationEntered forKey:@"locationEntered"];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredView.alpha = 0.0;
        self.transparentView.alpha = 0.0;
    }];
    
    self.transparentView.hidden = true;
    self.searchValidationLabel.hidden = true;
    self.searchLabel.hidden = true;
    self.locationSearch.hidden = true;
    self.locationEnteredLabel.hidden = false;
    self.blurredView.hidden = true;
    locationEntered = self.locationSearch.text;
    
    if ([locationEntered isEqual:@" "])
    {
        self.locationEnteredLabel.text = [NSString stringWithFormat:@"Please choose a city"];
    }
    
    else
    {
        self.locationEnteredLabel.text = [NSString stringWithFormat:@"Location: %@", locationEntered];
        [[NSUserDefaults standardUserDefaults] setObject:locationEntered forKey:@"locationEntered"];
    }
    
    [locationSearch resignFirstResponder];
    return YES;

}

- (void)changedSegmentedControl:(id)sender
{
    UISegmentedControl *ctl = sender;
    NSLog(@"Changed value of segmented control to %ld", (long)ctl.selectedSegmentIndex);
    // Code to change View Controller goes here
    
    if (ctl.selectedSegmentIndex == 0)
    {
        //location = CoreLocation
        self.locationEnteredLabel.text = userCity;
        locationType = 1;
    }
    else if (ctl.selectedSegmentIndex == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.blurredView.alpha = 1.0;
            self.blurredView.hidden = false;
            self.searchValidationLabel.hidden = false;
            self.searchLabel.hidden = false;
            self.locationSearch.hidden = false;
        }];
        
        locationEntered = self.locationSearch.text;
        location = locationEntered;
        self.locationEnteredLabel.text = [NSString stringWithFormat:@"Location: %@", locationEntered];
        locationType = 2;
        
    }
}

- (void)changedGenderControl:(id)sender
{
    UISegmentedControl *ctl = sender;
    NSLog(@"Changed value of segmented control to %ld", (long)ctl.selectedSegmentIndex);
    // Code to change View Controller goes here
    
    if (ctl.selectedSegmentIndex == 0)
    {
        gender = @"Male";
    }
    else if (ctl.selectedSegmentIndex == 1)
    {
        gender = @"Female";
    }
}

- (void)changedFormalityControl:(id)sender
{
    UISegmentedControl *ctl = sender;
    NSLog(@"Changed value of segmented control to %ld", (long)ctl.selectedSegmentIndex);
    // Code to change View Controller goes here
    
    if (ctl.selectedSegmentIndex == 0)
    {
        formality = @"Informal";
    }
    else if (ctl.selectedSegmentIndex == 1)
    {
        formality = @"Formal";
    }
}

- (IBAction)buttonBackClicked:(id)sender
{
    if (self.locationControl.selectedSegmentIndex == 0)
    {
        //location = CoreLocation
        locationType = 1;
    }
    else if (self.locationControl.selectedSegmentIndex == 1)
    {
        locationType = 2;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:locationType forKey:@"locationType"];
    [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setObject:formality forKey:@"formality"];
    tutorialDone = true;
    [[NSUserDefaults standardUserDefaults] setBool:tutorialDone forKey:@"tutorialDone"];
    [[NSUserDefaults standardUserDefaults] setObject:locationEntered forKey:@"locationEntered"];

    
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredView.alpha = 0.0;
        self.transparentView.alpha = 0.0;
    }];
    
    self.transparentView.hidden = true;
    self.searchValidationLabel.hidden = true;
    self.searchLabel.hidden = true;
    self.locationSearch.hidden = true;
    self.locationEnteredLabel.hidden = false;
    self.blurredView.hidden = true;
    locationEntered = self.locationSearch.text;
    
    if ([self.locationEnteredLabel.text  isEqualToString: @"Please choose a city"])
    {
        self.locationControl.selectedSegmentIndex = 0;
    }

    returnedFromSettings = true;
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
- (IBAction)removeBlurFunc:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredView.alpha = 0.0;
        self.transparentView.alpha = 0.0;
    }];
    
    self.transparentView.hidden = true;
    self.searchValidationLabel.hidden = true;
    self.searchLabel.hidden = true;
    self.locationSearch.hidden = true;
    self.locationEnteredLabel.hidden = false;
    self.blurredView.hidden = true;
    locationEntered = self.locationSearch.text;
    
    if ([locationEntered isEqual:@" "])
    {
        self.locationEnteredLabel.text = [NSString stringWithFormat:@"Please choose a city"];
    }
    
    else
    {
        self.locationEnteredLabel.text = [NSString stringWithFormat:@"Location: %@", locationEntered];
        [[NSUserDefaults standardUserDefaults] setObject:locationEntered forKey:@"locationEntered"];
    }
    
}

@end
