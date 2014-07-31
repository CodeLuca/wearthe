//
//  ViewController.m
//  wearThe
//
//  Created by Brendon on 29/07/2014.
//  Copyright (c) 2014 wearthe. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "ViewController.h" //import all variables
#import "Reachability.h" //import internet library

//initialize all variables
UIImage *suncream;
UIImage *sunglasses;
UIImage *Umbrella;

UIImage *formalSkirt;
UIImage *jeans;
UIImage *peachSkirt;
UIImage *shorts;
UIImage *trousers;

UIImage *blouse;
UIImage *dress;
UIImage *tankTop;
UIImage *tshirt;

UIImage *cardigan;
UIImage *coat;
UIImage *jacket;
UIImage *jumper;
UIImage *shirt;
UIImage *workCoat;


UIImage *clouds;
UIImage *rain;
UIImage *hail;
UIImage *partlyCloudyDay;
UIImage *clearDay;
UIImage *thunderstorm;
UIImage *snow;
UIImage *fog;
UIImage *tornado;
UIImage *wind;
UIImage *sleet;

NSURL *url;
NSString *urlSTRING;
NSURL *absURL;

@interface ViewController ()

@end

@implementation ViewController{
    CLLocationManager *manager; //sets up location finders
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    returnedFromSettings = false;
    
    suncream = [UIImage imageNamed:@"suncream copy.png"]; //sets the variables to images
    sunglasses = [UIImage imageNamed:@"SUnglasses copy.png"];
    Umbrella = [UIImage imageNamed:@"Umbrlla copy.png"];
    
    formalSkirt = [UIImage imageNamed:@"formal skirt.png"];
    jeans = [UIImage imageNamed:@"jeans copy.png"];
    peachSkirt = [UIImage imageNamed:@"peach skirt copy.png"];
    shorts = [UIImage imageNamed:@"shorts copy.png"];
    trousers = [UIImage imageNamed:@"trousers copy.png"];
    
    blouse = [UIImage imageNamed:@"blouse copy.png"];
    dress = [UIImage imageNamed:@"dress copy.png"];
    tankTop = [UIImage imageNamed:@"Tank Top copy.png"];
    tshirt = [UIImage imageNamed:@"tshirt copy.png"];
    
    cardigan = [UIImage imageNamed:@"Cardigan copy.png"];
    coat = [UIImage imageNamed:@"COat copy.png"];
    jacket = [UIImage imageNamed:@"jAcket copy.png"];
    jumper = [UIImage imageNamed:@"Jumper copy.png"];
    shirt = [UIImage imageNamed:@"Shirt copy.png"];
    workCoat = [UIImage imageNamed:@"work coat.png"];
    
    
    clouds = [UIImage imageNamed:@"clouds copy.png"];
    rain = [UIImage imageNamed:@"rain.png"];
    hail = [UIImage imageNamed:@"hail.png"];
    partlyCloudyDay = [UIImage imageNamed:@"partly clouds.png"];
    clearDay = [UIImage imageNamed:@"clear copy.png"];
    thunderstorm = [UIImage imageNamed:@"thunder copy.png"];
    snow = [UIImage imageNamed:@"snow copy.png"];
    fog = [UIImage imageNamed:@"fog.png"];
    tornado = [UIImage imageNamed:@"tornado.png"];
    wind = [UIImage imageNamed:@"wind.png"];
    sleet = [UIImage imageNamed:@"snow copy.png"];
    //partly cloudy night missing
    //cloudy night missing
    
    //[imageView setImage:image];
    
    firstTime = true;
    firstTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"firstTime"]; //looks for tutorial and if needed
    tutorialDone = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialDone"];
    
    manager = [[CLLocationManager alloc] init];
    
    geocoder = [[CLGeocoder alloc] init];
    
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //sets accuracy to 100 metres
    
    [manager startUpdatingLocation]; //updates location
    
}

#pragma mark CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//location services disabled in iOS
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location!");
    errorType = @"Location";
    [self errorShow];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", newLocation);
    CLLocation *currentLoc = newLocation;
    [manager stopUpdatingLocation]; //saves battery
    
    if (currentLoc != nil)
    {
        latitude =  currentLoc.coordinate.latitude;
        longitude = currentLoc.coordinate.longitude;
        
        NSLog(@"Latitude: %f", latitude);
        NSLog(@"Longitude: %f", longitude);
        
        [self buildURL]; //builds the URL to request the JSON from
        
    }
    
    [geocoder reverseGeocodeLocation:currentLoc completionHandler:^(NSArray *placeMarks, NSError *error){
    
        
        if (error == nil && [placeMarks count] > 0)
        {
            placemark = [placeMarks lastObject];
            userCity = [NSString stringWithFormat:@"Location: %@", placemark.locality];
            //gets city name from lat and long
        }
    }];
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    if (tutorialDone == true) //if the user has opened the app before
    {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus]; //checks for internet
        if (networkStatus == NotReachable)
        {
            NSLog(@"There IS NO internet connection");
            errorType = @"Internet";
            [self errorShow]; //shows error page if no internet
        }
        
        else
        {
            NSLog(@"There IS internet connection");
            
            if (returnedFromSettings == true)
            {
                returnedFromSettings = false;
                
                [self buildURL]; //builds the URL to request the JSON from
            }
        }
        

    }
    
    else if (tutorialDone == false)
    {
        //if its users first time, variables will need to be set to build URL
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"settingsController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)errorShow
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"errorController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)fetchedData:(NSData *)responseData
{
    //parse out the json data
    NSLog(@"Data Retrieved.");
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    NSLog(@"JSON: %@", json);
    
    NSArray* tops = [json objectForKey:@"tops"]; //2
    NSString *bottoms = (NSString *)[json objectForKey:@"bottoms"];
    NSArray* accessories = [json objectForKey:@"accessories"]; //2
    
    NSLog(@"Tops: %@", tops); //3
    NSLog(@"Bottoms %@", bottoms);
    NSLog(@"Accessories: %@", accessories);
    
    NSDictionary* weatherOverall = [json objectForKey:@"weather"];
    NSDictionary* timesOverall = [json objectForKey:@"times-overall"];
    NSDictionary* timesTemp = [json objectForKey:@"times-temp"];
    NSLog(@"Weather: %@", weatherOverall);
    NSLog(@"Times: %@", timesOverall);
    NSLog(@"Times Temp: %@", timesTemp);
    
    int count = [accessories count];
    NSLog(@"Count: %d", count);
    NSDictionary* forAccessoriesLoop;
    NSDictionary* forAccessoriesLoopTwo;
    NSMutableArray *accessoriesArray[count];
    
    NSLog(@"Past Accessory Initialization");
    
    for (int i = 0; i < count; i++)
    {
        accessoriesArray[i] = [NSMutableArray array];
        
        NSDictionary *theDictionary = [[NSDictionary alloc] init];
        
        [accessoriesArray[i] removeObject:theDictionary];
        
        if (accessoriesArray[i] == nil)
        {
             goto breakAccessory;    
        }
        
        theDictionary = [accessories objectAtIndex:i];
        
        [accessoriesArray[i] addObject:theDictionary];
            
        NSLog(@"Accessory %d: %@", i, accessoriesArray[i]);
    }
    
    breakAccessory:;
    NSLog(@"Broken Loop");

    
    int countTops = [tops count];
    NSLog(@"Count: %d", count);
    NSDictionary* forTopsLoop;
    NSDictionary* forTopsLoopTwo;
    NSMutableArray *topArray[count];
    
    NSLog(@"Past Top Initialization");
    
    for (int i = 0; i < countTops; i++)
    {
        topArray[i] = [NSMutableArray array];
        
        NSDictionary *topDictionary = [[NSDictionary alloc] init];
        
        [topArray[i] removeObject:topDictionary];
        
        if (topArray[i] == nil)
        {
            goto breakTops;
        }
        
        topDictionary = [tops objectAtIndex:i];
        
        [topArray[i] addObject:topDictionary];
        
        NSLog(@"Top %d: %@", i, topArray[i]);
    }
    
    breakTops:;
    NSLog(@"Broken Loop");


    //NSArray*highTemp = [weatherOverall valueForKey:@"High"];
    //NSArray*lowTemp = [weatherOverall valueForKey:@"Low"];
    
    NSArray*sixAM = [timesOverall valueForKey:@"6"];
    NSArray*eightAM = [timesOverall valueForKey:@"8"];
    NSArray*tenAM = [timesOverall valueForKey:@"10"];
    NSArray*twelveAM = [timesOverall valueForKey:@"12"];
    NSArray*twoPM = [timesOverall valueForKey:@"14"];
    NSArray*fourPM = [timesOverall valueForKey:@"16"];
    NSArray*sixPM = [timesOverall valueForKey:@"18"];
    NSArray*eightPM = [timesOverall valueForKey:@"20"];
    NSArray*tenPM = [timesOverall valueForKey:@"22"];
    
    NSArray*timeTemp6 = [timesTemp valueForKey:@"6"];
    NSArray*timeTemp8 = [timesTemp valueForKey:@"8"];
    NSArray*timeTemp10 = [timesTemp valueForKey:@"10"];
    NSArray*timeTemp12 = [timesTemp valueForKey:@"12"];
    NSArray*timeTemp14 = [timesTemp valueForKey:@"14"];
    NSArray*timeTemp16 = [timesTemp valueForKey:@"16"];
    NSArray*timeTemp18 = [timesTemp valueForKey:@"18"];
    NSArray*timeTemp20 = [timesTemp valueForKey:@"20"];
    NSArray*timeTemp22 = [timesTemp valueForKey:@"22"];
    
    // Set the labels appropriately
    self.sixAMLabel.text = [NSString stringWithFormat:@"%@", timeTemp6];
    self.eightAMLabel.text = [NSString stringWithFormat:@"%@", timeTemp8];
    self.tenAMLabel.text = [NSString stringWithFormat:@"%@", timeTemp10];
    self.twelveAMLabel.text = [NSString stringWithFormat:@"%@", timeTemp12];
    self.twoPMLabel.text = [NSString stringWithFormat:@"%@", timeTemp14];
    self.fourPMLabel.text = [NSString stringWithFormat:@"%@", timeTemp16];
    self.sixPMLabel.text = [NSString stringWithFormat:@"%@", timeTemp18];
    self.eightPMLabel.text = [NSString stringWithFormat:@"%@", timeTemp20];
    self.tenPMLabel.text = [NSString stringWithFormat:@"%@", timeTemp22];
    
    NSString * topPrimaryString = [NSString stringWithFormat:@"%@", topArray[0]];
    NSLog(@"Primary Top: %@", topPrimaryString);
    
    if ([topPrimaryString  isEqualToString: @"shirt"])
    {
        self.topPrimaryImage.image = shirt;
    }
    else if ([topPrimaryString  isEqualToString: @"blouse"])
    {
        self.topPrimaryImage.image = blouse;
    }
    else if ([topPrimaryString  isEqualToString: @"dress"])
    {
        self.topPrimaryImage.image = dress;
    }
    else if ([topPrimaryString  isEqualToString: @"tank-top"])
    {
        self.topPrimaryImage.image = tankTop;
    }
    else if ([topPrimaryString  isEqualToString: @"t-shirt"])
    {
        self.topPrimaryImage.image = tshirt;
    }
    
    
    NSString * topSecondaryString = [NSString stringWithFormat:@"%@", topArray[1]];
    NSLog(@"Secondary Top: %@", topSecondaryString);
    
    if ([topSecondaryString  isEqualToString: @"cardigan"])
    {
        self.topSecondaryImage.image = cardigan;
    }
    
    else if ([topSecondaryString  isEqualToString: @"coat"])
    {
        self.topSecondaryImage.image = coat;
    }
    else if ([topSecondaryString isEqualToString: @"jacket"])
    {
        self.topSecondaryImage.image = jacket;
    }
    else if ([topSecondaryString isEqualToString: @"shirt"])
    {
        self.topSecondaryImage.image = shirt;
    }
    else if ([topSecondaryString isEqualToString: @"jumper"])
    {
        self.topSecondaryImage.image = jumper;
    }
    else if ([topSecondaryString isEqualToString: @"work-coat"])
    {
        self.topSecondaryImage.image = workCoat;
    }
    
    NSString * bottomsString = [NSString stringWithFormat:@"%@", bottoms];
    NSLog(@"Bottoms: %@", bottomsString);
    
    if ([bottomsString isEqualToString:@"formal-skirt"])
    {
        self.bottomsImage.image = formalSkirt;
    }
    else if ([bottomsString isEqualToString:@"jeans"])
    {
        self.bottomsImage.image = jeans;
    }
    else if ([bottomsString isEqualToString:@"peach-skirt"])
    {
        self.bottomsImage.image = peachSkirt;
    }
    else if ([bottomsString isEqualToString:@"shorts"])
    {
        self.bottomsImage.image = shorts;
    }
    else if ([bottomsString isEqualToString:@"trousers"])
    {
        self.bottomsImage.image = trousers;
    }
    
    
    NSString * accessory1 = [NSString stringWithFormat:@"%@", accessoriesArray[0]];
    NSLog(@"Accessory 1: %@", accessory1);
    
    if ([accessory1 isEqualToString:@"sunglasses"])
    {
        self.accessoryImageOne.image = sunglasses;
    }
    else if ([accessory1 isEqual:@"umbrella"])
    {
        self.accessoryImageOne.image = Umbrella;
    }
    else if([accessory1 isEqualToString:@"suncream"] || [accessory1 isEqualToString:@"waterproof-suncream"])
    {
        self.accessoryImageOne.image = suncream;
    }
    else
    {
        self.accessoryImageOne.image = nil;
    }

    if (count == 2)
    {
        NSString * accessory2 = [NSString stringWithFormat:@"%@", accessoriesArray[1]];
        NSLog(@"Accessory 2: %@", accessory2);
        
        if ([accessory2 isEqualToString:@"sunglasses"])
        {
            self.accessoryImageTwo.image = sunglasses;
        }
        else if ([accessory2 isEqualToString:@"umbrella"])
        {
            self.accessoryImageTwo.image = Umbrella;
        }
        else if([accessory2 isEqualToString:@"suncream"] || [accessory2 isEqualToString:@"waterproof-suncream"])
        {
            self.accessoryImageTwo.image = suncream;
        }
        else
        {
            self.accessoryImageTwo.image = nil;
        }

    }
    
    if (count == 3)
    {
        NSString * accessory3 = [NSString stringWithFormat:@"%@", accessoriesArray[2]];
        NSLog(@"Accessory 3: %@", accessory3);
        
        if ([accessory3 isEqualToString:@"sunglasses"])
        {
            self.accessoryImageThree.image = sunglasses;
        }
        else if ([accessory3 isEqualToString:@"umbrella"])
        {
            self.accessoryImageThree.image = Umbrella;
        }
        else if([accessory3 isEqualToString:@"suncream"] || [accessory3 isEqualToString:@"waterproof-suncream"])
        {
            self.accessoryImageThree.image = suncream;
        }
        else
        {
            self.accessoryImageThree.image = nil;
        }

    }
    
    NSString *sixAMWeather = [NSString stringWithFormat:@"%@", sixAM];
    NSLog(@"6am weather: %@", sixAMWeather);
    
    if ([sixAMWeather isEqualToString:@"clear-day"] || [sixAMWeather isEqualToString:@"clear-night"])
    {
        self.sixAMImage.image = clearDay;
    }
    else if ([sixAMWeather isEqualToString:@"partly-cloudy-day"] || [sixAMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.sixAMImage.image = partlyCloudyDay;
    }
    else if ([sixAMWeather isEqualToString:@"hail"])
    {
        self.sixAMImage.image = hail;
    }
    else if ([sixAMWeather isEqualToString:@"thunderstorm"])
    {
        self.sixAMImage.image = thunderstorm;
    }
    else if ([sixAMWeather isEqualToString:@"tornado"])
    {
        self.sixAMImage.image = tornado;
    }
    else if ([sixAMWeather isEqualToString:@"rain"])
    {
        self.sixAMImage.image = rain;
    }
    else if ([sixAMWeather isEqualToString:@"sleet"])
    {
        self.sixAMImage.image = snow;
    }
    else if ([sixAMWeather isEqualToString:@"wind"])
    {
        self.sixAMImage.image = wind;
    }
    else if ([sixAMWeather isEqualToString:@"fog"])
    {
        self.sixAMImage.image = fog;
    }
    
    NSString *eightAMWeather = [NSString stringWithFormat:@"%@", eightAM];
    NSLog(@"8am weather: %@", eightAMWeather);
    
    if ([eightAMWeather isEqualToString:@"clear-day"])
    {
        self.eightAMImage.image = clearDay;
    }
    else if ([eightAMWeather isEqualToString:@"clear-night"])
    {
        self.eightAMImage.image = clearDay;
    }
    else if ([eightAMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.eightAMImage.image = partlyCloudyDay;
    }
    else if ([eightAMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.eightAMImage.image = partlyCloudyDay;
    }
    else if ([eightAMWeather isEqualToString:@"hail"])
    {
        self.eightAMImage.image = hail;
    }
    else if ([eightAMWeather isEqualToString:@"thunderstorm"])
    {
        self.eightAMImage.image = thunderstorm;
    }
    else if ([eightAMWeather isEqualToString:@"tornado"])
    {
        self.eightAMImage.image = tornado;
    }
    else if ([eightAMWeather isEqualToString:@"rain"])
    {
        self.eightAMImage.image = rain;
    }
    else if ([eightAMWeather isEqualToString:@"sleet"])
    {
        self.eightAMImage.image = sleet;
    }
    else if ([eightAMWeather isEqualToString:@"wind"])
    {
        self.eightAMImage.image = wind;
    }
    else if ([eightAMWeather isEqualToString:@"fog"])
    {
        self.eightAMImage.image = fog;
    }

    NSString *tenAMWeather = [NSString stringWithFormat:@"%@", tenAM];
    NSLog(@"10am weather: %@", tenAMWeather);
    if ([tenAMWeather isEqualToString:@"clear-day"])
    {
        self.tenAMImage.image = clearDay;
    }
    else if ([tenAMWeather isEqualToString:@"clear-night"])
    {
        self.tenAMImage.image = clearDay;
    }
    else if ([tenAMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.tenAMImage.image = clouds;
    }
    else if ([tenAMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.tenAMImage.image =clouds;
    }
    else if ([tenAMWeather isEqualToString:@"hail"])
    {
        self.tenAMImage.image = hail;
    }
    else if ([tenAMWeather isEqualToString:@"thunderstorm"])
    {
        self.tenAMImage.image = thunderstorm;
    }
    else if ([tenAMWeather isEqualToString:@"tornado"])
    {
        self.tenAMImage.image = tornado;
    }
    else if ([tenAMWeather isEqualToString:@"rain"])
    {
        self.tenAMImage.image = rain;
    }
    else if ([tenAMWeather isEqualToString:@"sleet"])
    {
        self.tenAMImage.image = sleet;
    }
    else if ([tenAMWeather isEqualToString:@"wind"])
    {
        self.tenAMImage.image = wind;
    }
    else if ([tenAMWeather isEqualToString:@"fog"])
    {
        self.tenAMImage.image = fog;
    }

    NSString *twelveAMWeather = [NSString stringWithFormat:@"%@", twelveAM];
    NSLog(@"12am weather: %@", twelveAMWeather);
    
    if ([twelveAMWeather isEqualToString:@"clear-day"])
    {
        self.twelveAMImage.image = clearDay;
    }
    else if ([twelveAMWeather isEqualToString:@"clear-night"])
    {
        self.twelveAMImage.image = clearDay;
    }
    else if ([twelveAMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.twelveAMImage.image = partlyCloudyDay;
    }
    else if ([twelveAMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.twelveAMImage.image = partlyCloudyDay;
    }
    else if ([twelveAMWeather isEqualToString:@"hail"])
    {
        self.twelveAMImage.image = hail;
    }
    else if ([twelveAMWeather isEqualToString:@"thunderstorm"])
    {
        self.twelveAMImage.image = thunderstorm;
    }
    else if ([twelveAMWeather isEqualToString:@"tornado"])
    {
        self.twelveAMImage.image = tornado;
    }
    else if ([twelveAMWeather isEqualToString:@"rain"])
    {
        self.twelveAMImage.image = rain;
    }
    else if ([twelveAMWeather isEqualToString:@"sleet"])
    {
        self.twelveAMImage.image = sleet;
    }
    else if ([twelveAMWeather isEqualToString:@"wind"])
    {
        self.twelveAMImage.image = wind;
    }
    else if ([twelveAMWeather isEqualToString:@"fog"])
    {
        self.twelveAMImage.image = fog;
    }

    NSString *twoPMWeather = [NSString stringWithFormat:@"%@", twoPM];
    NSLog(@"2pm weather: %@", twoPMWeather);
    if ([twoPMWeather isEqualToString:@"clear-day"])
    {
        self.twoPMImage.image = clouds;
    }
    else if ([twoPMWeather isEqualToString:@"clear-night"])
    {
        self.twoPMImage.image = clouds;
    }
    else if ([twoPMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.twoPMImage.image = partlyCloudyDay;
    }
    else if ([twoPMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.twoPMImage.image = partlyCloudyDay;
    }
    else if ([twoPMWeather isEqualToString:@"hail"])
    {
        self.twoPMImage.image = hail;
    }
    else if ([twoPMWeather isEqualToString:@"thunderstorm"])
    {
        self.twoPMImage.image = thunderstorm;
    }
    else if ([twoPMWeather isEqualToString:@"tornado"])
    {
        self.twoPMImage.image = tornado;
    }
    else if ([twoPMWeather isEqualToString:@"rain"])
    {
        self.twoPMImage.image = rain;
    }
    else if ([twoPMWeather isEqualToString:@"sleet"])
    {
        self.twoPMImage.image = sleet;
    }
    else if ([twoPMWeather isEqualToString:@"wind"])
    {
        self.twoPMImage.image = wind;
    }
    else if ([twoPMWeather isEqualToString:@"fog"])
    {
        self.twoPMImage.image = fog;
    }

    NSString *fourPMWeather = [NSString stringWithFormat:@"%@", fourPM];
    NSLog(@"4pm weather: %@", fourPMWeather);
    if ([fourPMWeather isEqualToString:@"clear-day"])
    {
        self.fourPMImage.image = clearDay;
    }
    else if ([fourPMWeather isEqualToString:@"clear-night"])
    {
        self.fourPMImage.image = clearDay;
    }
    else if ([fourPMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.fourPMImage.image = partlyCloudyDay;
    }
    else if ([fourPMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.fourPMImage.image = partlyCloudyDay;
    }
    else if ([fourPMWeather isEqualToString:@"hail"])
    {
        self.fourPMImage.image = hail;
    }
    else if ([fourPMWeather isEqualToString:@"thunderstorm"])
    {
        self.fourPMImage.image = thunderstorm;
    }
    else if ([fourPMWeather isEqualToString:@"tornado"])
    {
        self.fourPMImage.image = tornado;
    }
    else if ([fourPMWeather isEqualToString:@"rain"])
    {
        self.fourPMImage.image = rain;
    }
    else if ([fourPMWeather isEqualToString:@"sleet"])
    {
        self.fourPMImage.image = sleet;
    }
    else if ([fourPMWeather isEqualToString:@"wind"])
    {
        self.fourPMImage.image = wind;
    }
    else if ([fourPMWeather isEqualToString:@"fog"])
    {
        self.fourPMImage.image = fog;
    }

    NSString *sixPMWeather = [NSString stringWithFormat:@"%@", sixPM];
    NSLog(@"6pm weather: %@", sixPMWeather);
    if ([sixPMWeather isEqualToString:@"clear-day"])
    {
        self.sixPMImage.image = clearDay;
    }
    else if ([sixPMWeather isEqualToString:@"clear-night"])
    {
        self.sixPMImage.image = clearDay;
    }
    else if ([sixPMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.sixPMImage.image = partlyCloudyDay;
    }
    else if ([sixPMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.sixPMImage.image = partlyCloudyDay;
    }
    else if ([sixPMWeather isEqualToString:@"hail"])
    {
        self.sixPMImage.image = hail;
    }
    else if ([sixPMWeather isEqualToString:@"thunderstorm"])
    {
        self.sixPMImage.image = thunderstorm;
    }
    else if ([sixPMWeather isEqualToString:@"tornado"])
    {
        self.sixPMImage.image = tornado;
    }
    else if ([sixPMWeather isEqualToString:@"rain"])
    {
        self.sixPMImage.image = rain;
    }
    else if ([sixPMWeather isEqualToString:@"sleet"])
    {
        self.sixPMImage.image = sleet;
    }
    else if ([sixPMWeather isEqualToString:@"wind"])
    {
        self.sixPMImage.image = wind;
    }
    else if ([sixPMWeather isEqualToString:@"fog"])
    {
        self.sixPMImage.image = fog;
    }

    NSString *eightPMWeather = [NSString stringWithFormat:@"%@", eightPM];
    NSLog(@"8pm weather: %@", eightPMWeather);
    if ([eightPMWeather isEqualToString:@"clear-day"])
    {
        self.eightPMImage.image = clearDay;
    }
    else if ([eightPMWeather isEqualToString:@"clear-night"])
    {
        self.eightPMImage.image = clearDay;
    }
    else if ([eightPMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.eightPMImage.image = partlyCloudyDay;
    }
    else if ([eightPMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.eightPMImage.image = partlyCloudyDay;
    }
    else if ([eightPMWeather isEqualToString:@"hail"])
    {
        self.eightPMImage.image = hail;
    }
    else if ([eightPMWeather isEqualToString:@"thunderstorm"])
    {
        self.eightPMImage.image = thunderstorm;
    }
    else if ([eightPMWeather isEqualToString:@"tornado"])
    {
        self.eightPMImage.image = tornado;
    }
    else if ([eightPMWeather isEqualToString:@"rain"])
    {
        self.eightPMImage.image = rain;
    }
    else if ([eightPMWeather isEqualToString:@"sleet"])
    {
        self.eightPMImage.image = sleet;
    }
    else if ([eightPMWeather isEqualToString:@"wind"])
    {
        self.eightPMImage.image = wind;
    }
    else if ([eightPMWeather isEqualToString:@"fog"])
    {
        self.eightPMImage.image = fog;
    }

    NSString *tenPMWeather = [NSString stringWithFormat:@"%@", tenPM];
    NSLog(@"10pm weather: %@", tenPMWeather);
    if ([tenPMWeather isEqualToString:@"clear-day"])
    {
        self.tenPMImage.image = clearDay;
    }
    else if ([tenPMWeather isEqualToString:@"clear-night"])
    {
        self.tenPMImage.image = clearDay;
    }
    else if ([tenPMWeather isEqualToString:@"partly-cloudy-day"])
    {
        self.tenPMImage.image = partlyCloudyDay;
    }
    else if ([tenPMWeather isEqualToString:@"partly-cloudy-night"])
    {
        self.tenPMImage.image = partlyCloudyDay;
    }
    else if ([tenPMWeather isEqualToString:@"hail"])
    {
        self.tenPMImage.image = hail;
    }
    else if ([tenPMWeather isEqualToString:@"thunderstorm"])
    {
        self.tenPMImage.image = thunderstorm;
    }
    else if ([tenPMWeather isEqualToString:@"tornado"])
    {
        self.tenPMImage.image = tornado;
    }
    else if ([tenPMWeather isEqualToString:@"rain"])
    {
        self.tenPMImage.image = rain;
    }
    else if ([tenPMWeather isEqualToString:@"sleet"])
    {
        self.tenPMImage.image = sleet;
    }
    else if ([tenPMWeather isEqualToString:@"wind"])
    {
        self.tenPMImage.image = wind;
    }
    else if ([tenPMWeather isEqualToString:@"fog"])
    {
        self.tenPMImage.image = fog;
    }
}

-(void)buildURL
{
    locationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"locationType"];
    gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    formality = [[NSUserDefaults standardUserDefaults] objectForKey:@"formality"];
    
    NSString*genderForURL = [gender lowercaseString];
    NSString*formalityForURL = [formality lowercaseString];
    
    NSLog(@"Location Type: %d", locationType);
    NSLog(@"Gender: %@", gender);
    NSLog(@"Formality: %@", formality);
    
    //api/{locationType}/{location}/{gender}/{formality}/
    
    if (locationType == 1)
    {
        NSURL *relativeToURL = [NSURL URLWithString:@"http://michaelcullum.com/"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"/~wearthe/api/%d/%f,%f/%@/%@/", locationType, latitude, longitude, genderForURL, formalityForURL] relativeToURL:relativeToURL];
        absURL = [url absoluteURL];
    }
    else if (locationType == 2)
    {
        location = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationEntered"];
        NSString*locationForURL = [location lowercaseString];
        locationForURL = [locationForURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Location: %@", location);
        
        NSURL *relativeToURL = [NSURL URLWithString:@"http://michaelcullum.com/"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"/~wearthe/api/%d/%@/%@/%@/", locationType, locationForURL, genderForURL, formalityForURL] relativeToURL:relativeToURL];
        absURL = [url absoluteURL];
    }
    
        NSLog(@"URL: %@", absURL);
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:url]; //requests JSON from URL
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    NSLog(@"Requesting Data...");
}

@end
