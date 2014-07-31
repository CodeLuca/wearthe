//
//  errorViewController.h
//  wearThe
//
//  Created by Brendon on 29/07/2014.
//  Copyright (c) 2014 wearthe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface errorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
- (IBAction)tryAgainClicked:(id)sender;

@end
