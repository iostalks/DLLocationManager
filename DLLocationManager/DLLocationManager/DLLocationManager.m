//
//  DLLocationManager.m
//  DLLocationManager
//
//  Created by Jone on 15/12/31.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import "DLLocationManager.h"
#import <CoreLocation/CoreLocation.h>

#define IS_OS8_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation DLLocation

- (instancetype)initLocationWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    self = [super init];
    if (self) {
        _province = province;
        _city     = city;
        _district = district;
    }
    return self;
}

@end


@interface DLLocationManager()<CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, copy) DLLocateSuccessBlock locateSuccessBlock;
@property (nonatomic, copy) DLLocateErrorBlock   locateErrorBlock;

@end

@implementation DLLocationManager

+ (DLLocationManager *)managerLocation
{
    static dispatch_once_t onceToken = 0;
    __strong static id managerLocation = nil;
    dispatch_once(&onceToken, ^{
        managerLocation = [[self alloc] init];
    });
    
    return managerLocation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if (IS_OS8_LATER) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (void)startUpdateLocation
{
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdateLocation
{
    [_locationManager stopUpdatingLocation];
}

- (void)locateSuccess:(DLLocateSuccessBlock)successBlock error:(DLLocateErrorBlock)errorBlock
{
    _locateSuccessBlock = successBlock;
    _locateErrorBlock   = errorBlock;
    [self startUpdateLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    if (locations.count > 0) {
        CLLocation *location = locations[0];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error != nil) {
                if (_locateErrorBlock) {
                    _locateErrorBlock(error);
                    _locateErrorBlock = nil;
                }
            }
            else if (placemarks.count > 0) {
                CLPlacemark *placemark = placemarks[0];
                NSString *province = placemark.addressDictionary[@"State"];
                NSString *city     = placemark.addressDictionary[@"City"];
                NSString *district = placemark.addressDictionary[@"SubLocality"];
                
                DLLocation *dlLocation = [[DLLocation alloc] initLocationWithProvince:province city:city district:district];
                
                if (_locateSuccessBlock) {
                    _locateSuccessBlock(dlLocation);
                    _locateSuccessBlock = nil;
                }
            }
        }];
        
    }
    
    [self stopUpdateLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_locateErrorBlock) {
        _locateErrorBlock(error);
        _locateErrorBlock = nil;
    }
    
    [self stopUpdateLocation];
}


@end
