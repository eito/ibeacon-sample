//
//  ViewController.m
//  ibeacon-sample
//
//  Created by Eric Ito on 3/23/14.
//  Copyright (c) 2014 Esri. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;
@import CoreBluetooth;

@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLBeaconRegion        *beaconRegion;
//@property (nonatomic, strong) NSDictionary          *beaconPeripheralData;
//@property (nonatomic, strong) CBPeripheralManager   *peripheralManager;
@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *beaconAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconProximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconSignalLabel;


@property (weak, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setup];
    
    // test without walking away from beacon
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}

- (void)setup {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self setupRegion];
}

- (void)setupRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"D57092AC-DFAA-446C-8EF3-C81AA22815B5"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.esri.ibeacon-sample"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

#pragma mark CoreLocation stuff

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"No";
    NSLog(@"exited region");
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = nil;
    beacon = [beacons lastObject];
    
    NSString *accuracyText = @"- m";
    NSString *foundText = @"NO";
    NSString *proximityText = @"Unknown Proximity";
    NSString *signalText = @"- dB";
    
    if (beacon) {
        foundText = @"Yes";
        accuracyText = [NSString stringWithFormat:@"%f m", beacon.accuracy];
        signalText = [NSString stringWithFormat:@"%ld dB", beacon.rssi];
        
        if (beacon.proximity == CLProximityUnknown) {
            proximityText = @"Unknown Proximity";
        } else if (beacon.proximity == CLProximityImmediate) {
            proximityText = @"Immediate";
        } else if (beacon.proximity == CLProximityNear) {
            proximityText = @"Near";
        } else if (beacon.proximity == CLProximityFar) {
            proximityText = @"Far";
        }
    }
    
//    self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
//    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
//    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];

    self.beaconProximityLabel.text = proximityText;
    self.beaconSignalLabel.text = signalText;
    self.beaconAccuracyLabel.text = accuracyText;
    self.beaconFoundLabel.text = foundText;
}

-(void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"error: %@", error);
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

@end
